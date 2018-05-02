# V1.0
# 27/10/2017
# g.bruel@metis-reseaux.fr

# call  lib
import csv, os, shutil, time

# call externals files as lib
import csvparser, csvcleaner

d=os.listdir()
opp=[]
path=os.getcwd()

# change this name to find template file
xFile = "template.xlsx"
if os.path.exists(xFile):	
    csvparser.createFolder(d,opp,path, xFile)
else:
    print("No " + xFile + " exist in the working directory")
