


inputFile = open('acpu_FECreg.txt', 'r')

outputFile1 = open("stringConcatenate.txt", "a")
outputFile2 = open("scriptStructure.txt", "a")

Orderlist = []
Lines = inputFile.readlines()

for line in Lines:

    #vector of the line elements
    linev = line.split()

    name = ""

    if len(linev)==0: #empty line are skiped

        continue

    if str(linev[0])=='}':  #end of the struct

        Orderlist = Orderlist[::-1] #reverse the bits data

        for order in Orderlist: #record data to the file

            outputFile1.writelines(order)
            outputFile1.writelines("\n")


        Orderlist.clear()

        #ending for every structure created, for both files

        outputFile1.writelines("end //"+ linev[1].replace(";", ""))
        outputFile1.writelines("\n")
        outputFile1.writelines("\n")

        outputFile2.writelines("end")
        outputFile2.writelines("\n")
        outputFile2.writelines("\n")

    #look for comment line, and create-save title for every structure for the file1
    elif str(linev[0])=='//': 


        outputFile1.writelines("NULL: begin")
        outputFile1.writelines("\n")

        outputFile2.writelines('NO_NAME: Begin')
        outputFile2.writelines("\n")

        title = ""

        for i in range (2, len(linev)):

            if (list(linev[i])[0]=='('): #if a ( is found, ends adding new 
                break

            title = title + " " + linev[i]

        outputFile1.writelines('s2 = $sformatf("'+ title +'\\n");')
        outputFile1.writelines("\n")


    #look for lines with bits, and save data according to the bit type.
    elif str(linev[0])!='typedef' and str(linev[0])!='}': 

            #check where is located the name of the bit
            name = linev[1]
            if list(linev[1])[0]=='[':
                name = linev[2]

            listName = list(name) #get chars if the string

            if (listName[0]=='r' and listName[1]=='s'): #this is the only part where data from struct is added to the file2.

                #save bits data, as a string, in the file
                outputFile2.writelines('if (msg.NULL.'+name.replace(";", "")+'!=0) begin\nif (report2) begin \n end else if (fixed2) msg.NULL.'+name.replace(";", "")+' =0; \n end')
                outputFile2.writelines("\n")

                
            else:

                #this data is saved on the array to be reversed later.
                Orderlist.append('s2 = $sformatf("%0s'+ name.replace(";", "") +'= h%0h\\n", s2, msg.NULL.'+ name.replace(";", "") +');')

#close files
outputFile1.close()
outputFile2.close()




