# We don't need libraries
lines = open("alifs_20_raw.txt", "r")

flag_struct = 0
members = ''

with open('prueba.sv', 'w') as f:
    for line in lines:
        line = line.replace('[', '   [   ')
        line = line.replace(']', '   ]   ')
        # we extract and build the members
        if (('[' in line) and (']' in line)) == True:
            flag_struct = 1
            bits_of_member = line[line.index('['):line.index(']')+1]

            line_list = line.split()
            line_list = line_list[line_list.index(']') + 1:]
            # we join the words of the name
            name_member =  '_'.join(line_list)
            # concatenamos los miembros
            members = '\t' + 'bit ' + bits_of_member + ' ' + name_member + ';' + '\n' + members
        # we arrange the members when the structure is finished
        if ((('[' in line) and (']' in line)) == False) and (flag_struct == 1):
            members = members.replace('[   ', '[')
            members = members.replace('   ]', ']')
            
            struct_i = 'typedef struct packed { \n' + members + '}' + name_strct + ';' + '\n' + '\n'
            f.write(struct_i)
            members = ''
        # a new structure begins
        if ((('[' in line) and (']' in line)) == False):
            flag_struct = 0
            name_strct = line
            name_strct = ' ' + name_strct.replace('\n', ' ')
            
    #Last struct
    members = members.replace('[   ', '[')
    members = members.replace('   ]', ']')  
    struct_i = 'typedef struct packed { \n' + members + '}' + name_strct + ';' + '\n' + '\n'
    f.write(struct_i)
    members = ''
            

            