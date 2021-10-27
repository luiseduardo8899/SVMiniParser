from os.path import isfile, join
import os
import re
import glob
import json
#from yattag import Doc
#import xlwt

sv_files_src = glob.glob(os.environ['AVERY_PCIE'] + "/src/*.sv")
svh_files_src = glob.glob(os.environ['AVERY_PCIE'] + "/src/*.svh")
sv_files_srcVCS = glob.glob(os.environ['AVERY_PCIE'] + "/src.VCS/*.sv")
svh_files_srcVCS = glob.glob(os.environ['AVERY_PCIE'] + "/src.VCS/*.svh")

matrix = [sv_files_src, svh_files_src, sv_files_srcVCS, svh_files_srcVCS]


vtask = 'task'
vfuntion = 'function'


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


def separate(string):
    string = string.replace('=', '  =  ')
    string = string.replace(',', '   ,   ')
    string = string.replace('(', '   (   ')
    string = string.replace(')', '   )   ')
    string = re.sub("[;]", " ", string)  # for process function parentesis
    end = string.find(')')
    string = string[:end]
    return string.split()


def data_task(sv, line, line_list, i, type_class):
    cut2 = sv[::-1].find('/')
    name_file = sv[(len(sv) - cut2):]
    remove_equal = []
    # we extract name and type of function and the arguments
    name = line_list[line_list.index('(') - 1]
    if line_list[0] == vfuntion:
        if (len(line_list) >= 4) and (line_list[3] == '('):
            line_list.pop(3)
            line_list = line_list[3:]
        else:
            line_list.pop(2)
            line_list = line_list[2:]
        type_ = vfuntion
    else:
        if line_list[0] != vtask:  # + f
            line_list = line_list[4:]
        else:
            line_list = line_list[3:]
        type_ = vtask

    if '()' in line:
        print('Name: ', name, 'File: ', name_file, 'Line: ', i)
        #print('paremeters: NONE')
        struc_i = make_json(name, fix_argvs(remove_equal), type_, line, type_class)
    else:
        print('Name: ', name, 'File: ', name_file, 'Line: ', i)

        while('=' in line_list):
            limit = line_list.index('=')
            line_list.pop(limit)
            a = line_list[:limit]
            b = line_list[limit + 1:]
            line_list = a + b
            print(line_list)
        remove_equal = line_list

        struc_i = [0, 0]
        struc_i[0], struc_i[1] = make_json(name, fix_argvs(remove_equal), type_, line, type_class)
    print(struc_i)
    '''if name == 'wait_d2h_rsp_msg':
        print('\n\n')
        exit()'''
    return struc_i


# we create the function that fixes the arguments
def fix_argvs(vec_arg):
    vec_arg_temp = []
    args_name = []
    if vec_arg != []:
        for arg in vec_arg:
            if arg == ',':
                arg_name = vec_arg_temp[len(vec_arg_temp) - 1]
                vec_arg_temp = []
                args_name.append(arg_name)
            else:
                vec_arg_temp.append(arg)
        arg_name = vec_arg_temp[len(vec_arg_temp) - 1]
        vec_arg_temp = []
        args_name.append(arg_name)
        # we prepare the arguments for the json format
        cont = 1
        for name in args_name:
            vec_arg_temp.append('${' + str(cont) + ':' + name +  '}')
            cont = cont + 1
    else:
        vec_arg_temp.append('${' + str(0) + ':' + '' + '}')
    return vec_arg_temp

# we prepare the top dictionary arguments
def make_json(name, arguments, type_, function, type_class):
    name_t = type_class + ' :: ' + name #mod
    name_ = [name, type_ + ':' + name + ' -> ' + type_class]
    temp = ", ".join(arguments)
    body = [name + '(' + temp + ');']
    dates = {"prefix": name_, "body": body, "description": '[Class:' + type_class + ']\n' + function}
    return name_t, dates


vec_struc_json = {}

for directory in matrix:
    for sv in directory:
        i = 0
        fix_line = ''
        flag = 0
        with open(sv, 'r') as fp:
            flag_class = 0 # indicates when it passes through a class
            for line in fp:
                # delete comment
                vec_temp = []
                line_temp = line
                line_temp = line.replace('//', '  //  ')
                if "//" in line_temp:
                    line_temp = line_temp.split('//')
                    line_temp = line_temp[0]

                #we detect a class and extract its type
                list_extr_class = separate(line_temp)
                
                if 'class' in list_extr_class:
                    flag_class = 1
                if 'endclass' in list_extr_class:
                    flag_class = 0
                if flag_class == 1:
                    try:
                        type_class = list_extr_class[list_extr_class.index('class') + 1]
                    except:
                        type_class = type_class
                else:
                    type_class = ''
            
                # We build a single row
                if ((vtask in line_temp) or (vfuntion in line_temp)) and ('(' in line_temp):  # + f
                    flag = 1
                if (((vtask in fix_line) or (vfuntion in fix_line)) and ('(' in fix_line) and ((')' in fix_line) == False)) or flag:  # + f
                    fix_line = fix_line + line_temp
                if ((vtask in fix_line) or (vfuntion in fix_line)) and ((('(' in fix_line) and (')' in fix_line)) or ('()' in fix_line)):  # + f
                    print('\n\n')
                    print(fix_line)
                    # we invoke functions
                    fix_line = delete_parenthesis(fix_line)
                    temp_list = separate(fix_line)

                    # we eliminate the fields before the word -function or task-
                    if (len(temp_list) >= 2) and ((temp_list[1] == vfuntion) or (temp_list[1] == vtask)):
                        temp_list.pop(0)
                    else:
                        if (len(temp_list) >= 3) and ((temp_list[2] == vfuntion) or (temp_list[1] == vtask)):
                            temp_list.pop(0)
                            temp_list.pop(0)
                    if (temp_list[0] == vtask) or (
                            len(temp_list) >= 2 and temp_list[1] == vtask) or (temp_list[0] == vfuntion):
                        
                        struc_json = data_task(sv, fix_line, temp_list, i, type_class)
                        vec_struc_json[struc_json[0]] = struc_json[1]
                    fix_line = ''
                    flag = 0
                i = i + 1

# we write in the file
with open('datos.json', 'w') as f:
    '''for struc_json_i in vec_struc_json:
            f.write(struc_json_i)
            f.write('\n')'''
    json.dump(vec_struc_json, f)








'''Linea 167 del archivo acxl_seq_library: No aparece este task!
task automatic read_full_line(bit[63:0] cline_addr, acxl_d2h_req_opcode_e code);'''