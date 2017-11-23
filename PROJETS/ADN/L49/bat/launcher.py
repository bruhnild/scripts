# V1.0
# 27/10/2017
# g.bruel@metis-reseaux.fr

# call  lib
import csv, os, shutil, time

# call externals files as lib
import csvparser, csvcleaner

d=os.listdir()
opp=[]
#path=os.getcwd()
path="I:/14-ADN/04-Scripts/rapport_bi_mensuel/bat/"

# change this name to find template file
#templateName = "V:/ADN/04-Scripts/rapport_bi_mensuel/bat/template.xlsx"
templateName = "template.xlsx"
if os.path.exists(path+templateName):	
    csvparser.createFolder(d,opp,path, templateName)
else:
    print("No " + templateName + " exist in the working directory")
