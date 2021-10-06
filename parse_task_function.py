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
	string = re.sub("[,;()]", " ", string)
	#No quitar las comas, y dejarlas como elemento del arreglo para luego utilizarlas para separar si es entrada o salida, los tipos de variables y nombres  
        return string.split()

def data_task(sv, line, line_list, i):
	cut2 = sv[::-1].find('/')
        name_file = sv[(len(sv)-cut2):]
	print(line_list)
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
                        	cont = 2
                        if cont == 0:
                        	print(word)
				#Aquí va a generar arreglos con los datos de los parametros HACER UNA FUNCIÍN QUE TRATE LAS COMAS Y PONERLA AQUÍ
                                cont = 1
                        cont = cont - 1
			
	
for directory in matrix:
	for sv in directory:
	        i = 0
		fix_line = ''
		flag = 0
	        with open(sv, 'r') as fp:
        	        for line in fp:
				if ('task' in line) and ('(' in line):
					flag = 1
				if (('task' in fix_line) and ('(' in fix_line) and ((')' in fix_line) == False)) or flag:
                			fix_line = fix_line + line
                                if ('task' in fix_line) and ((('(' in fix_line) and ( ')' in fix_line)) or ('()' in fix_line)):
                                        print('\n\n')
					print(fix_line)
					fix_line = delete_parenthesis(fix_line) 
					temp_list = separate(fix_line )
					data_task(sv, fix_line, temp_list, i)
					fix_line = ''
					flag = 0
                        	i = i + 1











