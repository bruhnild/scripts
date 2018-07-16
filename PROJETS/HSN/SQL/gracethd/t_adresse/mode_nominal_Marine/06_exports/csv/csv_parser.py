#-*- coding: utf-8 -*-

##########################################################
#                    ATTENTION:                          #
#  Ce script se base sur le principe que le fichier      #
#  csv contient des entetes de colonnes.                 #
#  Si ce n'est pas le cas, commenter la ligne indiquee   #
#  dans le code                                          #
##########################################################

import csv

FILENAME = "export_v_adresse.csv"
COLUMN_NUMBER = 1

def get_unique_value():
    """
        Retourne un tableau contenant chaque occurence unique d'une colonne du csv
    """
    unique_value = []
    with open(FILENAME, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=";")
        for row in reader:
            if (row[COLUMN_NUMBER] not in unique_value):
                unique_value.append((row[COLUMN_NUMBER]))
    return unique_value


def split_csv():
    """
        Lecture de chaque ligne du csv source puis l'eclate en plusieurs
        fichiers selon le nombre d'occurence unique trouves
    """
    unique_value = get_unique_value()
    for i in range(0, len(unique_value)):
        with open(FILENAME, 'r') as csvfile:
            reader = csv.reader(csvfile, delimiter=";")
            next(reader) #Commenter cette ligne s'il n'y a pas d'entetes de colonnes dans le csv
            for row in reader:
                if (row[COLUMN_NUMBER] == unique_value[i]):
                    file = open(unique_value[i] + ".csv", "a")
                    
                    temp_line = ""

                    for y in range (0, len(row)):
                        temp_line += row[y] + ";"

                    file.write(str(temp_line) + "\n")

if __name__ == "__main__":
    split_csv()