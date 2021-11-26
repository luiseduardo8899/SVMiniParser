import xlsxwriter  # build excel,   sudo apt-get install python3-xlsxwriter
import docx


file_exc = xlsxwriter.Workbook('prueba.xlsx')
sheet = file_exc.add_worksheet()


doc = docx.Document('MFR_register_description_example.docx')
print(len(doc.tables))
tablas = doc.tables

line_tex = []
#print(len(doc.paragraphs))
for i in range(len(doc.paragraphs)):
    #print(doc.paragraphs[i].text)
    line = doc.paragraphs[i].text
    line = line.split()
    if (len(line) == 3):
        print(line)
        line = [line[0], line[1]]
        line_tex.append(line)
#print(line_tex)
#print(len(line_tex))
i = 0
j = 0
k = 0

for table in tablas:
    if (len(table.rows) > 1):
        k = k + 1
        print('======================>', k)
        sheet.write(i, 0, line_tex[k-1][0])
        sheet.write(i, 1, line_tex[k-1][1])
        for row in table.rows:
            j = 0
            for cell in row.cells:
                #print(cell.text)
                
                sheet.write(i, j+2, str(cell.text))
                j = j + 1
            i = i + 1
file_exc.close()








#print(doc.paragraphs[1].text)

#print(len(doc.paragraphs[1].runs))

#print(doc.paragraphs[0].runs[0].text)
