# V1.0
# 27/10/2017
# g.bruel@metis-reseaux.fr

# call  lib
import csv, os, shutil, time, sys

# call externals files as lib
import csvparser, csvcleaner

opp=[]
#path=os.getcwd()
path=sys.argv[1]
print(path)
d=os.listdir(path)

# change this name to find template file
templateName = "template.xlsx"
if os.path.exists(path+"/"+templateName):	
    csvparser.createFolder(d,opp,path, templateName)
else:
    print("No " + templateName + " exist in the working directory: "+path)

