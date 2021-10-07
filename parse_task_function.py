from os.path import isfile, join
import os
import re
import glob
#from yattag import Doc
#import xlwt

sv_files = glob.glob(os.environ['AVERY_PCIE']+"/src/*.sv")
svh_files = glob.glob(os.environ['AVERY_PCIE']+"/src.VCS/*.svh")

matrix = [sv_files, svh_files]

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
	string = re.sub("[;()]", " ", string)
	#No quitar las comas, y dejarlas como elemento del arreglo para luego utilizarlas para separar si es entrada o salida, los tipos de variables y nombres  
        return string.split()

def data_task(sv, line, line_list, i):
	cut2 = sv[::-1].find('/')
        name_file = sv[(len(sv)-cut2):]
	#print(line_list)
	remove_equal = []
	if line_list[0] != 'task':
		name = line_list[2]
		line_list = line_list[3:]	
	else:
		name = line_list[1]
		line_list = line_list[1:]
	if '()' in line:
        	print('Name: ', name, 'File: ', name_file,'Line: ', i)
        	print('paremeters: NONE')
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
		print(fix_argvs(remove_equal))


#we create the function that fixes the arguments
def fix_argvs(vec_string):
	description_i = []
	description = []
	flag = 0
	temp = []
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
	return description


			
	
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
				if ('task' in line_temp) and ('(' in line_temp):
					flag = 1
				if (('task' in fix_line) and ('(' in fix_line) and ((')' in fix_line) == False)) or flag:
					fix_line = fix_line + line_temp
                                if ('task' in fix_line) and ((('(' in fix_line) and ( ')' in fix_line)) or ('()' in fix_line)):
                                        print('\n\n')
					print(fix_line)
					#we invoke functions
					fix_line = delete_parenthesis(fix_line) 
					temp_list = separate(fix_line )
					data_task(sv, fix_line, temp_list, i)
					fix_line = ''
					flag = 0
                        	i = i + 1











