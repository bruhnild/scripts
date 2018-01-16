#!/usr/bin/env python
#-*- coding: utf-8 -*-
from tkinter import *
import tkinter.ttk
from tkinter import ttk
import os
import re
import psycopg2
import sys
import pprint
from subprocess import Popen


def ListeChoix():
        
    #Define our connection string
    conn_string = "host='www.metis-reseaux.fr' dbname='l49' user='postgres' password='UhtS.1Hd2' port=5678"
    # print the connection string we will use to connect
    print ("Connecting to database")

    # get a connection, if a connect cannot be made an exception will be raised here
    conn = psycopg2.connect(conn_string)   
    # conn.cursor will return a cursor object, you can use this cursor to perform queries
    cursor = conn.cursor()


    
    # executer la requete pour obtenir la liste des statuts
    cursor.execute("SELECT  statut FROM coordination.opportunite group by statut")
    # Récupérer les résultats depuis la bdd
    records_statut = cursor.fetchall()
    # Enlever les accolades
    records_statut=[x for xs in records_statut for x in xs]

    # executer la requete pour obtenir la liste des opportunités
    #cursor.execute("SELECT  id_opp FROM coordination.opportunite group by id_opp")
    # Récupérer les résultats depuis la bdd
    #records_id_opp = cursor.fetchall()
    # enelever les accolades
    #records_id_opp=[x for xs in records_id_opp for x in xs]

    def updateSQLView(event):
        # executer la requete pour copier les csv depuis le serveur postgres de metis
        val = CategoryCombo.get()
        cursor.execute(
                """
                        SELECT ROW_NUMBER() OVER(ORDER BY id_opp) id, * 
                        FROM(
                        SELECT 
                           a.id_opp,
                           a.nom,
                           a.com_dep,
                           a.emprise,
                           a.travaux,
                           a.prev_starr,
                           a.cables,
                           a.typ_cable,
                           a.prog_dsp,
                           CASE WHEN a.debut_trvx IS NULL THEN 'Inconnue'::character varying ELSE a.debut_trvx END AS debut_trvx,
                           a.moa,
                           d.nb_suf,
                           (WITH sum AS (SELECT sum(longueur) as longueur FROM coordination.opportunite where statut like 'A présenter')
                           SELECT sum.longueur
                           FROM coordination.opportunite o, sum
                           limit 1) longueur,
                           b.nb_chb_exists,
                           count(DISTINCT c.id) AS nb_chb_a_creer,
                           count(CASE WHEN fonction = 'Desserte' THEN 1 ELSE NULL END) nb_chb_desserte,
                           count(CASE WHEN fonction = 'Transport' THEN 1 ELSE NULL END) nb_chb_transport,
                           count(CASE WHEN fonction = 'Indefinie' THEN 1 ELSE NULL END) nb_chb_indef
                        FROM coordination.opportunite a
                        LEFT JOIN rip1.vue_chambres_adn b ON a.id_opp::text = b.id_opp::text
                        JOIN coordination.chambres c ON st_dwithin(a.geom, c.geom, 30::double precision)
                        LEFT JOIN administratif.vue_nb_suf_opp d ON a.id_opp::text = d.id_opp::text
                        WHERE statut like '""" +val+
                        """' GROUP BY a.id_opp,a.nom, a.com_dep,a.emprise, a.travaux,prev_starr, a.cables, a.typ_cable, a.prog_dsp, a.debut_trvx, a.moa, d.nb_suf, b.nb_chb_exists
                        order by id_opp, longueur DESC
                        )vue;
                """
                """
                SELECT                  
                        row_number() over () AS id,
                        a.id_opp, 
                        prev_starr,
                        lg_prev_st,
                        gc_typ_mut,
                        sum(CASE WHEN a.gc_typ_mut IS null THEN null ELSE longueur END) as lg_typ_mut,
                        gc_typ_int,
                        sum(CASE WHEN a.gc_typ_int IS null THEN null ELSE longueur END) as lg_typ_int,
                        sum(longueur) as longueur,
                        a.com_dep
                FROM coordination.opportunite as a
                LEFT JOIN  rip1.vue_chambres_adn as b on a.id_opp=b.id_opp 
                LEFT JOIN  administratif.vue_nb_suf_opp as d on a.id_opp=d.id_opp
                where statut like '""" +val+
                """' group by a.id_opp, com_dep, prev_starr,lg_prev_st, gc_typ_mut, gc_typ_int
                order by id_opp;
                """
        )
        
        p = Popen("script.bat", cwd=os.getcwd())
        stdout, stderr = p.communicate()
        


    def getUpdateData(event):
        cursor.execute("SELECT  id_opp FROM coordination.opportunite where statut LIKE '"+CategoryCombo.get()+"' group by id_opp")
        res=cursor.fetchall()
        res = [x for xs in res for x in xs]        
        AccountCombo['values'] = res        
        
        
    top=Toplevel(root) # créer la fenêtre (instancier)
    # Creation labels pour les combobox
    message = "Selectionner un statut"  #définir le texte de l'étiquette
    lab=Label(top, text=message).grid(row = 2,column = 1,padx = 2, pady=0) # définir l'étiquette
    message = "Selectionner une opportunité"  #définir le texte de l'étiquette
    labo=Label(top, text=message).grid(row = 4,column = 1,padx = 2, pady=0) # définir l'étiquette
    # Creation des combobox
    AccountCombo = tkinter.ttk.Combobox( top, width = 15)
    sqlData = ListeChoix    
    CategoryCombo = tkinter.ttk.Combobox(top,  values = records_statut)


    # Ajouter les combobox
    CategoryCombo.bind('<<ComboboxSelected>>', updateSQLView)
    #AccountCombo.bind('<<ComboboxSelected>>', updateSQLView)
    CategoryCombo.grid(row = 3,column = 1,padx = 10,pady = 25)
    AccountCombo.grid(row = 5,column = 1,pady = 25,padx = 10)

   
    

class App:
    def __init__(self, master):
        fm = Frame(master)
    
        Button(fm, text="Choisir dans la liste des opportunités à l\'étude",command=ListeChoix).pack(side=TOP, anchor=W, fill=X, expand=YES)
        fm.pack(fill=BOTH, expand=YES)

  
        
        
root = Tk()
root.option_add('*font', ('verdana', 12, 'bold'))
root.title("Générateur de rapports - GUI")
display = App(root)
root.mainloop()

