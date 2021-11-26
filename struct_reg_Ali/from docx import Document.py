from docx import Document
import csv
import codecs
 
docFile = 'C: \\ Users \\ hgvgh \\ Desktop \\ Computer.docx'
 document = Document (docFile) #Read in file
 tables = document.tables #Obtén la tabla establecida en el archivo
 
data = []
for table in tables[:]:
         para i, fila en enumerate (table.rows [:]): # lee cada fila
        row_content = []
                 para celda en row.cells [:]: # lee todas las celdas en una fila
            c = cell.text
            row_content.append(c.strip("\n"))
        data.append(row_content)
 
print(data)
 def data_write_csv (nombre_archivo, datos): # nombre_archivo es la ruta para escribir el archivo CSV, y datas es la lista de datos a escribir
         file_csv = codecs.open (nombre_archivo, 'w +') # Agregar
    writer = csv.writer(file_csv) #, delimiter=' ', quotechar=' ', quoting=csv.QUOTE_MINIMAL)
    for data in datas:
        writer.writerow(data)
         print ("Guardar archivo correctamente, el procesamiento ha terminado")
data_write_csv("C:\\Users\\hgvgh\\Desktop\\result.csv", data)