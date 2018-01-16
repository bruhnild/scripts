# V1.0
# 27/10/2017
# g.bruel@metis-reseaux.fr
import csv, os

# Description : open csv and clean row were id is not the same of folder

# function use to find one expression (string) in a given word (string)
def matchStr (f,s):
    try:
        res=f.index(s)
        return True
    except ValueError:
        return False

# remove useless line (where id is not the same as folder name) in csv files
# call by external file as lib : csvparse.py 
def cleanFiles (listDir, path):        
    for fname in listDir:
        fpath=path+"/"+fname
        # control that file is csv
        isCsv = matchStr(fname,".csv");
        if isCsv :
            arr=[]
            # open csv    
            with open(fpath, 'r') as f :
                # read file
                #writer = csv.writer(out)
                reader=csv.reader(f, delimiter=';')
                c=0
                for row in reader:
                    # if id match with file name
                    if c != 0:
                        match = matchStr(path, row[1])
                        if match == True:
                            arr.append(row);
                            #writer.writerow(row)
                    else:
                        arr.append(row)                            
                    c=c+1
            # remove old file
            os.remove(fpath)
            # write to new file with same name
            with open(fpath, 'w', newline='') as out:                
                writer = csv.writer(out,delimiter=';')
                writer.writerows(arr)
                out.close()
                
        
