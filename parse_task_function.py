#!/usr/bin/env python
import os
import re
import glob
import json
import settings
import subprocess
from os.path import isfile, join
import json as j


files_list = []
for path in settings.PATHS:
    print(path)
    files_list.append(glob.glob(os.environ[settings.VIPPATH] + path+"/*.sv"))
    files_list.append(glob.glob(os.environ[settings.VIPPATH] + path+"/*.svh"))

#global
vtask = 'task'
vfuntion = 'function'
vec_struc_json = {} #dictionary top

# remove various combinations of parentheses in the arguments
def delete_parenthesis(string):
    string = string.replace('[', '   [   ')
    string = string.replace(']', '   ]   ')
    string = string + '    '
    while (('[' in string) and (']' in string)):
        init = string.find('[')
        end = string.find(']')
        temp = string[init + 2:end - 2]
        if '[' in temp:
            init2 = temp.find('[')
            temp2 = string[:init2 - 2 + init] + '   ' + string[end + 2:]
            string = temp2
        else:
            temp2 = string[:init - 2] + '   ' + string[end + 2:]
            string = temp2
    return string

# to parse strings as vectors using special characters and words
def separate(string):
    string = string.replace('=', '  =  ')
    string = string.replace(',', '   ,   ')
    string = string.replace('(', '   (   ')
    string = string.replace(')', '   )   ')
    string = re.sub("[;]", " ", string)  # for process function parentesis
    end = string.find(')')
    string = string[:end]
    return string.split()

# We extract information from tasks and functions
def data_task(sv, line, line_list, i, type_class):
    #get file name
    cut2 = sv[::-1].find('/')
    name_file = sv[(len(sv) - cut2):]
    # we extract name and type of function and the arguments
    remove_equal = []
    name = line_list[line_list.index('(') - 1]
    # line_list at the end only contains the arguments, this part may be easier
    if line_list[0] == vfuntion:
        if (len(line_list) >= 4) and (line_list[3] == '('):
            line_list.pop(3)
            line_list = line_list[3:]
        else:
            line_list.pop(2)
            line_list = line_list[2:]
        type_ = vfuntion
    else:
        if line_list[0] != vtask:
            line_list = line_list[4:]
        else:
            line_list = line_list[3:]
        type_ = vtask

    if '()' in line:
        print('Name: ', name, 'File: ', name_file, 'Line: ', i)
        struc_i = make_json(name, fix_argvs(remove_equal), type_, line, type_class)
    else:
        print('Name: ', name, 'File: ', name_file, 'Line: ', i)
        # delete part "= value"
        while('=' in line_list):
            limit = line_list.index('=')
            line_list.pop(limit)
            a = line_list[:limit]
            b = line_list[limit + 1:]
            line_list = a + b
            print(line_list)
        remove_equal = line_list
        struc_i = [0, 0]
        struc_i[0], struc_i[1] = make_json( name, fix_argvs(remove_equal), type_, line, type_class) #key end argument for top dictionary
    print(struc_i)
    return struc_i


# we create the function that fixes the arguments, extrct only names of arguments
def fix_argvs(vec_arg):
    vec_arg_temp = []
    args_name = []
    if vec_arg != []:
        for arg in vec_arg:
            if arg == ',':
                arg_name = vec_arg_temp[len(vec_arg_temp) - 1] #extract name
                vec_arg_temp = []
                args_name.append(arg_name)
            else:
                vec_arg_temp.append(arg) #temp vector for save information for a argument
        #last argument
        arg_name = vec_arg_temp[len(vec_arg_temp) - 1]
        vec_arg_temp = []
        args_name.append(arg_name)
        # we prepare the arguments for the json format
        cont = 1
        for name in args_name:
            vec_arg_temp.append('${' + str(cont) + ':' + name + '}')
            cont = cont + 1
    else:
        vec_arg_temp.append('${' + str(0) + ':' + '' + '}')
    return vec_arg_temp

# we prepare key and argument for the top dictionary
def make_json(name, arguments, type_, function, type_class):
    # delete and accommodate line breaks \n
    function = function.replace('\n', '')
    function = function.replace('\t', '')
    function = function.replace(',', ',\n')
    #function = function.replace('(', '(\n')
    # we join the processed arguments with ${n:argv} for the body
    temp = ", ".join(arguments)
    body = [name + '(' + temp + ');']
    if type_class != '':
        name_t = type_class + ' :: ' + name
        name_ = [name, type_ + ':' + name + ' -> ' + type_class]
        dates = {"prefix": name_, "body": body, "description": '[Class:' + type_class + ']\n ' + function}
    else:               #if the function has no class
        name_t = name
        name_ = [name, type_ + ':' + name]
        dates = {"prefix": name_, "body": body, "description": function}
    return name_t, dates #key and argument for top dictionary

def make_json_class(name, function):
    body = [name + '  ${0:' + 'name_class' + '};']
    dates = {"prefix": name, "body": body, "description": function}
    return name, dates


# Filter out uneeded files
for files in files_list:
    #print(files)
    for filex in files:
        #print(filex)
        for filterx in settings.FILTER:
            if filterx in filex:
                print("REMOVE FILE: ", filex)
                files.remove(filex)
vec_class = []
vec_class_i_members = []
vec_class_members = []
for files in files_list:
   for filex in files:
       #initial values and flags
       i, fix_line, line_class, flag, flag_comment, flag_protected , flag_members, flag_struct = 0, '', '', 0, 0, 0, 1, 0
       with open(filex, 'r') as fp:
           flag_class, flag_ext_d_class, flag_one_time = 0, 0, 0
           for line in fp:
               # We ignore long comments /* ... */
               if '/*' in line:
                   flag_comment = 1
               if '*/' in line:
                   flag_comment = 0
               if flag_comment == 1:
                   continue
               # We ignore protected lines  `protected ... `endprotected
               if '`protected' in line:
                   flag_protected = 1
               if '`endprotected' in line:
                   flag_protected = 0
               if flag_protected == 1:
                   continue
               # delete comment //
               vec_temp = []
               line_temp = line
               line_temp = line.replace('//', '  //  ')
               if "//" in line_temp:
                   line_temp = line_temp.split('//')
                   line_temp = line_temp[0]
               #we detect a class and extract its type
               string_extr_class = delete_parenthesis(line_temp)
               list_extr_class = separate(string_extr_class) #to ignore when extract members
               if ('class' in list_extr_class) and (('typedef' in list_extr_class) == False):
                   flag_class = 1
               if 'endclass' in list_extr_class:
                   flag_class = 0
               if flag_class == 1:
                   try:
                       type_class = list_extr_class[list_extr_class.index('class') + 1] #extract class name
                   except:
                       type_class = type_class
               else:
                   type_class = ''
                #====================================================================
               # We build a single row for the class and build json for class
               line_temp_c = line_temp.replace(';', '  ;  ')
               line_temp_c = line_temp_c.split()
               if ('class' in line_temp_c) and (('typedef' in line_temp_c) == False):
                   flag_ext_d_class = 1
                   name_class = line_temp_c[line_temp_c.index('class') + 1]
               if flag_ext_d_class == 1:
                   line_class = line_class + line_temp
               # add class to json
               if flag_one_time == 1:
                   name, body = make_json_class(name_class, line_class)
                   vec_struc_json[name] = body
                   flag_one_time = 0
                   line_class = ''
                   vec_class.append(name_class) # to create the XML file
               if (';' in line_temp_c) and (flag_ext_d_class == 1):
                   flag_ext_d_class = 0
                   flag_one_time = 1
                #=====================================================================
               # We build a single row for the task and function
               if ((vtask in line_temp) or (vfuntion in line_temp)) and ('(' in line_temp):
                   flag = 1
               if (((vtask in fix_line) or (vfuntion in fix_line)) and ('(' in fix_line) and ((')' in fix_line) == False)) or flag:
                   fix_line = fix_line + line_temp
               if ((vtask in fix_line) or (vfuntion in fix_line)) and ((('(' in fix_line) and (')' in fix_line)) or ('()' in fix_line)):
                   print('\n\n')
                   print(fix_line)
                   # we invoke functions
                   fix_line = delete_parenthesis(fix_line)
                   temp_list = separate(fix_line)
                   # we eliminate the fields before the word -function or task-
                   if (len(temp_list) >= 2) and ((temp_list[1] == vfuntion) or (temp_list[1] == vtask)):
                       temp_list.pop(0)
                   else:
                       if (len(temp_list) >= 3) and ((temp_list[2] == vfuntion) or (temp_list[2] == vtask)): #before (temp_list[1] == vtask)
                           temp_list.pop(0)
                           temp_list.pop(0)

                   print(temp_list)
                   if (temp_list[0] == vtask) or (len(temp_list) >= 2 and temp_list[1] == vtask) or (temp_list[0] == vfuntion):
                        #We add each function and task to a long dictionary with json format
                       if ('automatic' in temp_list):
                           temp_list.remove('automatic')
                       struc_json = data_task(filex, fix_line, temp_list, i, type_class)
                       vec_struc_json[struc_json[0]] = struc_json[1] #key ang argument
                   fix_line = ''
                   flag = 0
               i = i + 1

# we write in the file
with open(settings.FILENAME, 'w') as f:
    json.dump(vec_struc_json, f, indent=4)

#we write the snippets in the visual snippet file
subprocess.call('cp ' + settings.FILENAME + ' ~/.config/Code/User/snippets/systemverilog.json', shell=True)



