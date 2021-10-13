from os.path import isfile, join
import os
import re
import glob
import json
#from yattag import Doc
#import xlwt

sv_files = glob.glob(os.environ['AVERY_PCIE']+"/src/*.sv")
svh_files = glob.glob(os.environ['AVERY_PCIE']+"/src.VCS/*.svh")

matrix = [sv_files, svh_files]


vtask = 'task'
vfuntion = 'function'


def delete_parenthesis(string):
	string = string.replace('[', '   [   ')
        string = string.replace(']', '   ]   ')
	#string = string.replace(',', '   ,   ')
	string = string + '    '
	#print(string)
	#flag2 = 0
	#flag3 = 0
	while (('[' in string) and (']' in string)):
		init = string.find('[')
		end = string.find(']')
		temp = string[init+2:end-2]
		#flag = 0
		if '[' in temp:
			init2 = temp.find('[')
			temp2 = string[:init2-2+init] + '   ' +  string[end+2:]
			string = temp2
			#print(string)
			#flag2 = flag2 + 1
		else:
			temp2 = string[:init-2] + '   ' +  string[end+2:]
			string = temp2
			#print(string)
			#if flag3 == 1:
			#	exit()
			#if flag2 != flag:
			#	flag3 = 1
	return string

def separate(string):	
	string = string.replace('=', '  =  ')
	string = string.replace(',', '   ,   ')
	string = string.replace('(', '   (   ')
	string = string.replace(')', '   )   ')
	string = re.sub("[;]", " ", string) #for process function parentesis
	end = string.find(')')
        string = string[:end]  
        return string.split()

def data_task(sv, line, line_list, i):
	cut2 = sv[::-1].find('/')
        name_file = sv[(len(sv)-cut2):]
	#print(line_list)
	remove_equal = []
	#we extract name and type of function and the arguments
	if line_list[0] == vfuntion:
		if (len(line_list)>=4) and (line_list[3] == '('):
			name = line_list[2]
                	#type_ = line_list[1]
			line_list.pop(3)
                	line_list = line_list[3:]
		else:
			name = line_list[1]
                        #type_ = 'unknown'
			line_list.pop(2)
                        line_list = line_list[2:]
		type_ = 'function'
	else:
		if line_list[0] != vtask: # + f
			name = line_list[2]
			#type_ = line_list[0]
			line_list = line_list[4:]	
		else:
			name = line_list[1]
			#type_ = 'unknown'
			line_list = line_list[3:]
		type_ = 'task'

	if '()' in line:
        	print('Name: ', name, 'File: ', name_file,'Line: ', i)
        	#print('paremeters: NONE')
		print(make_json(name, fix_argvs(remove_equal), type_, line))
		struc_i = make_json(name, fix_argvs(remove_equal), type_, line)
	else:
		print('Name: ', name, 'File: ', name_file,'Line: ', i)
		cont = 0
		for word in line_list:
                	if word == '=':
                        	cont = 3 #with 2 when there was no "," 3 to incorporate it
                        if cont == 0:
                        	#print(word)
				remove_equal.append(word)
                                cont = 1
                        cont = cont - 1
		#print(fix_argvs(remove_equal))
		struc_i = make_json(name, fix_argvs(remove_equal), type_, line)
	print(struc_i)
	return struc_i


#we create the function that fixes the arguments
'''def fix_argvs(vec_string):
	print('=================================================>', vec_string)
	description_i = []
	description = []
	flag = 0
	temp = []
	vec_str_jsom = []
	for word in vec_string:
		if word != ',':					#we use "," to separate
			#We guarantee that the first argument has input
			if (vec_string[0]!='input') and (vec_string[0]!='inout') and (vec_string[0]!='output') and (flag==0):
				description_i.append('input')
				description_i.append(word)
			else:
				description_i.append(word)
		else:						#we fill in the missing spaces of the argument
			if len(description_i) == 2:
				description_i.insert(0, temp[0])
				temp = description_i
                                description = description + description_i
                                description_i = []
			else:
				if len(description_i) == 1:
					description_i.insert(0, temp[1])
					description_i.insert(0, temp[0])
					temp = description_i
					description = description + description_i
					description_i = []
				else:
					temp = description_i
                                        description = description + description_i
                                        description_i = []
		flag = 1
	#last argument
	if len(description_i) == 2:
         	description_i.insert(0, temp[0])
                description = description + description_i
        else:
                if len(description_i) == 1:
                	description_i.insert(0, temp[1])
                        description_i.insert(0, temp[0])
			description = description + description_i
		else:
			description = description + description_i
	return description'''

def fix_argvs(vec_arg):
	vec_arg_temp = []
        args_name = []
	if vec_arg != []:
		for arg in vec_arg:
			if arg == ',':
				arg_name = vec_arg_temp[len(vec_arg_temp)-1]
				vec_arg_temp = []
				args_name.append(arg_name)
			else:
				vec_arg_temp.append(arg)
		arg_name = vec_arg_temp[len(vec_arg_temp)-1]
		vec_arg_temp = []
       		args_name.append(arg_name)
		#preparamos los argumentos para el formato json
		cont = 0
		for name in args_name:
			vec_arg_temp.append('${' + str(len(args_name)-1-cont) + ':' + name + '}') 
			cont = cont + 1
	else:
		vec_arg_temp.append('${' + str(0) + ':' + '' + '}')
	return vec_arg_temp
		





def make_json(name, arguments, type_, function):

	name_ = [name, type_ + ':' + name ]
	final_arguments = name + "("
	#we construct the string of arguments
	'''cont = 0
	for arv in arguments:
		if cont == 3:
			final_arguments = final_arguments + ", "
			final_arguments = final_arguments + " " + arv
			cont = 1
		else:
			final_arguments = final_arguments + " " + arv
			cont = cont + 1
	final_arguments = final_arguments + " )"'''

	temp = ", ".join(arguments)	
	body = [name +'(' + temp + ')']	

	dates = {"prefix": name_, "body": body, "description": function}
	task_i = {name: dates}
	return json.dumps(task_i)


vec_struc_json = []
	
for directory in matrix:
	for sv in directory:
	        i = 0
		fix_line = ''
		flag = 0
	        with open(sv, 'r') as fp:
        	        for line in fp:
				#delete comment
				vec_temp = []
				line_temp = line
				line_temp = line.replace('//', '  //  ')
				if "//" in line_temp:
					line_temp = line_temp.split('//')
					line_temp = line_temp[0]
				#We build a single row
				if ((vtask in line_temp) or (vfuntion in line_temp)) and ('(' in line_temp): # + f
					flag = 1
				if (((vtask in fix_line) or (vfuntion in fix_line)) and ('(' in fix_line) and ((')' in fix_line) == False)) or flag: # + f
					fix_line = fix_line + line_temp
                                if ((vtask in fix_line) or (vfuntion in fix_line)) and ((('(' in fix_line) and ( ')' in fix_line)) or ('()' in fix_line)): # + f
                                        print('\n\n')
					print(fix_line)
					#we invoke functions
					fix_line = delete_parenthesis(fix_line) 
					temp_list = separate(fix_line )
					#we eliminate the fields before the word -function or task-
        				if (len(temp_list) >= 2) and ((temp_list[1] == vfuntion) or (temp_list[1] == vtask)):
                				temp_list.pop(0)
        				else:
                				if (len(temp_list) >= 3) and ((temp_list[2] == vfuntion) or (temp_list[1] == vtask)):
                        				temp_list.pop(0)
                       					temp_list.pop(0)
					if (temp_list[0] == vtask) or (len(temp_list) >= 2 and temp_list[1] == vtask) or (temp_list[0] == vfuntion):
						struc_json = data_task(sv, fix_line, temp_list, i)
						vec_struc_json.append(struc_json)
					fix_line = ''
					flag = 0
                        	i = i + 1

#we write in the file
with open('datos.json', 'w') as f:
	for struc_json_i in vec_struc_json:
		f.write(struc_json_i)
		f.write('\n')










