# import packages to copy files system and navigate
import shutil, os, time
# import package to work with csv
import csv
# import recommended package for reading and writing Excel 2010 files (ie: .xlsx)
import openpyxl

# general var
dateStr = time.strftime("%d%m%Y");
os.chdir("C://scripts/"); # change work directory


nameTemplate = "template.xlsx"; # xls template location and name
locTemplate = "C://scripts";

folderLoc = "";
folderName = "";
xlName = "";

# functions
def changeType(h): # change str to int if possible    
    try :        
        l = int(h);
        return l;
    except ValueError:        
        return False;

def callChange(word):
    n = "";
    if(changeType(word)):
        return changeType(word);
    else :
        for i in word :
            res = changeType(i);
            if (res):
                n = n + str(res);
                return int(n);

def createName (i, date):
    try :        
        name = str(i)+"_" + date;        
        return name;
    except ValueError:
        return False;

# ---------------------------------------------------------------------- XLSX
#
# CREATE FOLDER
# COPY TEMPLATE TO THIS FOLDER
#
# get excel file template and copy to new folder
os.chdir(locTemplate); # template location path
fTime = time.strftime("%d%m%y%H%M%S");
fId = "1";
if os.path.exists(nameTemplate):  # if template exist, create folder and copy template    
    n = 1;
    folderName = createName(n,dateStr);    
    # create folder if not name already exist    
    if not os.path.exists(folderName) :
        os.makedirs(folderName);        
    # else if exist
    else :        
        listNumbers = [];
        # start loop
        for fName in os.listdir():
            if(dateStr in fName): # just control common names
                #-------------------------- here is bug !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                a = fName[0:2]; # position of id
                a = callChange(a);
                #--------------------------
                if a != False :
                    listNumbers.append(a); # add new id to list
        # end loop
        # from list create new logical id
        listNumbers.sort();
        size = len(listNumbers);        
        
        fId = listNumbers[size-1]+1;
        folderName = createName(fId, dateStr);
        # create folder
        if folderName != False:
            os.makedirs(folderName);
    # copy template to new folder
    folderLoc = os.getcwd() + "/" + folderName + "/"
    xlName = str(fId) +"_rapport_" + fTime + ".xlsx"    
    shutil.copy(locTemplate + "/" + nameTemplate, folderLoc + str(fId) +"_rapport_" + fTime + ".xlsx");
else :
    print("not exist");
   
# ---------------------------------------------------------------------- CSV
#
# COPY EACH CSV
# COPY CSV TO FOLDER
csvList = [["opportunites_synthese.csv","Feuil1","data_synthese"],["opportunites_typegc.csv","Feuil2","data_gc"]];
data_synthese=[]
data_gc=[]


# start loop to copy csv only
for c in csvList:
    fileStr = c[0]
    if (os.path.exists(fileStr)):
        shutil.copy(fileStr,folderLoc + "/" + fileStr);        
    else :
        print(c + " - CSV does not exist");        
# end loop

# loop to get csv and copy  csv contain to excel
os.chdir(folderLoc);

for d in csvList :
    fileStr=d[0] # fileStr is string file name
    with open(fileStr,"r") as f:        
        reader=csv.reader(f, delimiter=';')
        for row in reader:
            print(d[2])
