#!/usr/bin/env python
import os
import re
import glob
import json
import settings
import subprocess
from os.path import isfile, join
import json as j
from xml.etree.ElementTree import Element, tostring, SubElement
import xml.etree.cElementTree as ET
from lxml import etree

files_list = []
for path in settings.PATHS:
    print(path)
    files_list.append(glob.glob(os.environ[settings.VIPPATH] + path+"/*.sv"))
    files_list.append(glob.glob(os.environ[settings.VIPPATH] + path+"/*.svh"))

#global
vtask = 'task'
vfuntion = 'function'

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
        vec_info_function_i = [[type_class, name, type_, line], []]
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
        vec_info_function_i = [[type_class, name, type_, line], fix_argvs(remove_equal)]
    return vec_info_function_i


# we create the function that fixes the arguments, extrct only names of arguments
def fix_argvs(vec_words_arv):
    if ('(' in vec_words_arv):
        vec_words_arv.remove('(')
    vec_arg_i = []
    vec_arg = []
    #we create a vector of arguments
    for word in vec_words_arv:
        if (word != ','):
             vec_arg_i.append(word)
        else:
            vec_arg.append(vec_arg_i)
            vec_arg_i = []
    #last arv
    vec_arg.append(vec_arg_i)
    vec_arg_i = []
    #we fix the arguments
    vec_arg_i_fix = []
    vec_arg_fix = []
    #we define initial reference to autocomplete
    if (len(vec_arg[0]) == 3):
        reference = [vec_arg[0][0], vec_arg[0][1]]
    else:
        vec_arg[0].insert(0, 'input')
        reference = [vec_arg[0][0], vec_arg[0][1]]
    AUX = ['input']
    #we fill in the fields of the arguments
    for arg in vec_arg:
        if (len(arg) >= 3):
            if ((arg[0] != 'input') or  (arg[0] != 'output') or (arg[0] != 'inout')):   
                reference[0] = AUX[0]
            else:
                reference[0] = [arg[0][0], arg[0][1]]
        else:
            if (len(arg) == 2):
                vec_arg_fix = arg
                vec_arg_fix.insert(0, reference[0])
                reference = [vec_arg_fix[0], vec_arg_fix[1]]
            else:
                if (len(arg) == 1):
                    vec_arg_fix = arg
                    print(reference)
                    vec_arg_fix.insert(0, reference[1])
                    vec_arg_fix.insert(0, reference[0])
        #last argument
        vec_arg_i_fix.append(vec_arg_fix)
        vec_arg_fix = []
    #print(vec_arg)
    return vec_arg


#we obtain a vector with the names of the classes
def vec_class_names():
    vec_class_name = []
    for files in files_list:
        for filex in files:
            #initial values and flags
            i, line_class, flag_comment, flag_protected = 0, '', 0, 0
            with open(filex, 'r') as fp:
                flag_ext_d_class, flag_one_time = 0, 0
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
                    line_temp = line
                    line_temp = line.replace('//', '  //  ')
                    if "//" in line_temp:
                        line_temp = line_temp.split('//')
                        line_temp = line_temp[0]
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
                        flag_one_time = 0
                        line_class = ''
                        vec_class_name.append(name_class) # to create the XML file
                    if (';' in line_temp_c) and (flag_ext_d_class == 1):
                        flag_ext_d_class = 0
                        flag_one_time = 1
                    i = i + 1
    return vec_class_name


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
struct_i = []
vec_class_names_loop = vec_class_names()
vec_info_function_final = []
vec_data_type_sv = ['reg', 'wire', 'integer', 'real', 'time', 'realtime', 'logic', 'bit', 'byte', 'shortint', 'int', 'longint', 'shotreal', 'string']
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
               string_extr_class = string_extr_class.replace('}', '  }  ')
               string_extr_class = string_extr_class.replace('#', '  #  ')
               list_extr_class = separate(string_extr_class) #to ignore when extract members
               if ('class' in list_extr_class) and (('typedef' in list_extr_class) == False):
                   flag_class = 1
               if ('endclass' in list_extr_class):
                   flag_class = 0
                   #==================== remove repeating members ======================
                   type_class_without_repead = []
                   for r in vec_class_i_members:
                      if r not in type_class_without_repead:        
                          type_class_without_repead.append(r)
                   vec_class_i_members = type_class_without_repead
                   #====================================================================
                   vec_class_i_members.insert(0, type_class) # add name class to vec members
                   #print(vec_class_i_members)
                   vec_class_members.append(vec_class_i_members) # add strc class to top vec 
                   vec_class_i_members = []
                   flag_members = 1
               if flag_class == 1:
                   try:             #try to delete this try
                       type_class = list_extr_class[list_extr_class.index('class') + 1] #extract class name
                   except:
                       type_class = type_class
                    #we extract the members
                   if ((vtask in list_extr_class)==True) or ((vfuntion in list_extr_class)==True): #stop scanning
                       flag_members = 0
                   if flag_members == 1:
                       # We detected the structs and members
                       if ('struct' in list_extr_class):
                           flag_struct = 1
                       if (flag_struct == 0):
                           #members
                           for data_t in vec_data_type_sv:
                               if (data_t in list_extr_class) and (('#' in list_extr_class)==False) and ((('(' in list_extr_class)==False) 
                               or (((')' in list_extr_class)==False))):
                                  data_type_i = list_extr_class[list_extr_class.index(data_t) + 1]
                                  vec_class_i_members.append([data_t, data_type_i]) #type end data
                           # we get member class
                           for class_namex in vec_class_names_loop:
                               if (class_namex in list_extr_class) and (('#' in list_extr_class)==False) and ((('(' in list_extr_class)==False) 
                                  and (((')' in list_extr_class)==False))) and (len(list_extr_class)>1) and (('class' in list_extr_class)==False) and (('extends' in list_extr_class)==False): # before->  and ((list_extr_class.index(class_namex)==0))
                                  if (list_extr_class[list_extr_class.index(class_namex) - 1] != '='):
                                    data_type_i = list_extr_class[list_extr_class.index(class_namex) + 1]
                                    vec_class_i_members.append([class_namex, data_type_i])
                       else:        #structs
                           for data_t in vec_data_type_sv:
                               if (data_t in list_extr_class):
                                  data_type_i = list_extr_class[list_extr_class.index(data_t) + 1]
                                  struct_i.append([data_t, data_type_i]) #type end data
                            # we get member class
                           for class_namex in vec_class_names_loop:
                               if (class_namex in list_extr_class) and (('#' in list_extr_class)==False) and ((('(' in list_extr_class)==False) 
                                  and (((')' in list_extr_class)==False))) and (len(list_extr_class)>1) and ((list_extr_class.index(class_namex)==0)):
                                  data_type_i = list_extr_class[list_extr_class.index(class_namex) + 1]
                                  struct_i.append([class_namex, data_type_i])
                       if (('}' in list_extr_class) and (flag_struct == 1)): #end struct
                           flag_struct = 0
                           struct_i.append(list_extr_class[list_extr_class.index('}')+1])
                   #after the structure there may be a function and therefore it may not enter
                   if (struct_i != [] and (flag_struct == 0)):
                       vec_class_i_members.append(struct_i)
                       struct_i = []
                               # HAY QUE RESOLVER EL CASO DE INT VARIABLE = NEW()
               else:
                   type_class = ''
                   vec_class_i_members = []
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
                   print('========>', temp_list)
                   if (temp_list[0] == vtask) or (len(temp_list) >= 2 and temp_list[1] == vtask) or (temp_list[0] == vfuntion):
                        #We add each function and task to a long dictionary with json format
                       if ('automatic' in temp_list):
                           temp_list.remove('automatic')
                       #vector of all functions and task
                       vec_info_function_final.append(data_task(filex, fix_line, temp_list, i, type_class))

                   fix_line = ''
                   flag = 0
               i = i + 1

with open('prueba.txt', 'w') as f:
    for struc in vec_class_members:
        f.write(str(struc))
        f.write('\n')

#File XML
def dic_to_xml(root, vec_class, vec_class_members, vec_info_function_final):
    vec_class = list(set(vec_class))
    element = Element(root)
    for class_i in vec_class:
        nodo = Element('class')
        son_of_class_name = Element('name')
        son_of_class_name.text = class_i
        nodo.append(son_of_class_name)
        son_of_class_d = Element('description')
        son_of_class_d.text = 'class ' + class_i
        nodo.append(son_of_class_d)
        #we add the members
        #we traverse a vector that has a vector of members and structures. Structures are a vector.
        for members_class_i in vec_class_members:
            if (members_class_i[0] == class_i):
                members_class_ix = members_class_i[1:]
                for member in members_class_ix:
                    #is not struct
                    if (len(member) == 2) and (type(member[0]) == str) and (type(member[1]) == str):
                        son_of_class_member = Element('member')
                        son_of_member_name = Element('name')
                        #print(member[1])
                        son_of_member_name.text = member[1]
                        son_of_member_type = Element('type')
                        #print(member[0], '\n')
                        son_of_member_type.text = str(member[0])
                        son_of_class_member.append(son_of_member_name)
                        son_of_class_member.append(son_of_member_type)
                        nodo.append(son_of_class_member)
                    #it is struct!
                    else:
                        son_of_class_struct = Element('struct')
                        son_of_struct_name = Element('name')
                        son_of_struct_name.text = str(member[len(member)-1])
                        son_of_class_struct.append(son_of_struct_name)
                        vec_args_of_strs = member[:len(member)-1]
                        for arv in vec_args_of_strs:
                            son_of_struct_arg = Element('arv')
                            son_of_struct_arg_name = Element('name')
                            son_of_struct_arg_name.text = str(arv[1])
                            son_of_struct_arg_type = Element('type')
                            son_of_struct_arg_type.text = str(arv[0])
                            son_of_struct_arg.append(son_of_struct_arg_name)
                            son_of_struct_arg.append(son_of_struct_arg_type)
                            son_of_class_struct.append(son_of_struct_arg)
                        nodo.append(son_of_class_struct)

        for data_function in vec_info_function_final:
            if (data_function[0][0] == class_i):
                #data_function[0].pop(0)
                son_of_class_function = Element(data_function[0][2])
                body_of_function = Element('body')
                name_of_function = Element('name')
                name_of_function.text = str(data_function[0][1])
                body_of_function.append(name_of_function)
                description = data_function[0][3]
                data_function = data_function[1]
                #we add the arguments
                for arg_f in data_function:
                    if (arg_f[0] == 'input'):
                        i_o_arg = Element('input_arg')
                    else:
                        if (arg_f[0] == 'output'):
                            i_o_arg = Element('output_arg')
                        else:
                            if (arg_f[0] == 'inout'):
                                i_o_arg = Element('inout_arg')
                            else:
                                if (arg_f[0] == 'ref'):
                                    i_o_arg = Element('ref_arg')
                                else:
                                    i_o_arg = Element('parameter')
                    type_arg = Element('type')
                    type_arg.text = str(arg_f[1])
                    i_o_arg.append(type_arg)
                    name_arg = Element('name')
                    name_arg.text = str(arg_f[2])
                    i_o_arg.append(name_arg)
                    body_of_function.append(i_o_arg)
                son_of_class_function.append(body_of_function)
                description_function = Element('description')
                description_function.text = str(description)
                son_of_class_function.append(description_function)
                nodo.append(son_of_class_function)

        element.append(nodo)

    arbol = ET.ElementTree(element)
    arbol.write("GFG.xml")
    parser = etree.XMLParser(remove_blank_text=True)
    arbolXML = etree.parse("GFG.xml", parser=parser)
    arbolXML.write("GFG.xml", pretty_print=True)


dic_to_xml("information" , vec_class, vec_class_members, vec_info_function_final)

