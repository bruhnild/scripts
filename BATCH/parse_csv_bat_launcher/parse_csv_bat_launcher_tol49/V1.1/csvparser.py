# V1.0
# 27/10/2017
# g.bruel@metis-reseaux.fr

import csv, os, shutil, time,csvcleaner as cc

# Description :  to create folder and associate csv files in the same script directory
# Control if expression exist in string
def controlIndex (v,string):    
    try :        
        idx=v.index(string)
        return idx
    except ValueError:
        return False

# main function to create folder and paste files
def createFolder(listDir, array, path, template):
    os.chdir(path)
    count=0    
    for fname in os.listdir():
        
        # push all csv in names list
        xlFile= path+"/"+template
        xlFileTarget = ""
        file=controlIndex(fname,".csv") # True tu return file Value value
        if file != False:
            with open(fname, 'r') as f:                
                # read file
                reader=csv.reader(f, delimiter=';')
                # parse and append row to array
                c=0
                for row in reader:                    
                    # get opportunity number
                    numOpp = row[1]                    
                    if c != 0 : # dont get the first line                    
                        # create opportunity folder
                        folderTime = time.strftime("%m%H%M");                        
                        folderName = numOpp +"_"+ folderTime;
                        # control if folder exist
                        if os.path.exists(folderName):
                            print(folderName+" folder already exist. He will be remove before new creation.")
                            shutil.rmtree(folderName)
                            os.makedirs(folderName)                                                                                   
                        else:
                            os.makedirs(folderName)                                                       
                        # copy file to opportunity folder                                                                        
                        newpath=path+"/"+folderName # opportunity folder                                            
                        filePath=newpath+"/"+fname                                                
                        shutil.copy(fname,filePath)
                        
                        # in file path, clean csv files paste
                        cc.cleanFiles(os.listdir(newpath),newpath)

                        # paste template if not exist
                        xlFileTarget = newpath+"/"+template;                    
                        if not os.path.exists(xlFileTarget):                            
                            shutil.copy(xlFile, xlFileTarget)
                            
                        
                    c=c+1
            count=count+1
    if count < 1:
        print('No CSV in working directory !')
