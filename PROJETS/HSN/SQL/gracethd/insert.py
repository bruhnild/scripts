import psycopg2

path = "/mnt/metis/FTTH RIP/20-MOE70-HSN/07-Scripts/SQL/gracethd"

sql1 = "/t_noeud/01_gracethd_t_noeud_insert.sql"
sql2 = "/t_noeud/02_gracethd_t_noeud_trigger_bt.sql"
sql3 = "/t_noeud/02_gracethd_t_noeud_trigger_ch.sql"
sql4 = "/t_znro/01_gracethd_t_znro_insert.sql"
sql5 = "/t_zsro/01_gracethd_t_zsro_insert.sql"
# t_ptech
# t_ebp
# t_cable_patch201
sql6 = "/t_sitetech/01_gracethd_t_sitetech_insert.sql"

sqlx = "/t_cable/01_gracethd_t_cable_insert.sql"
sqlx = "/t_cableline/01_gracethd_t_cableline_insert.sql"
sqlx = "/t_conduite/01_gracethd_t_conduite_insert.sql"
sqlx = "/t_cab_cond/01_gracethd_t_cab_cond_insert.sql"
sqlx = "/t_cheminement/01_gracethd_t_cheminement_insert.sql"
sqlx = "/t_cond_chem/01_gracethd_t_cond_chem_insert.sql"

################# POINTS
# t_noeud (nro, sro, chambre, boite)
## ptech (chambre/appui/boite)
## epb (boite)
## site_tech
### ltech
#### baie
#### boite
##### gracethd_metis.t_cable_patch201
#### sro
#### nro

################# LIGNES

conn = psycopg2.connect("""
    dbname=hsn_test
    user=postgres
    host='192.168.101.254'
    port='5432'
    password='l0cA!L8:'""")

cur = conn.cursor()
print("Connection sur 192.168.101.254 OK")

cur.execute(open(path + sql1, "r").read())
print("Execution de " + sql1 + " OK")
cur.execute(open(path + sql2, "r").read())
print("Execution de " + sql2 + " OK")
cur.execute(open(path + sql3, "r").read())
print("Execution de " + sql3 + " OK")
cur.execute(open(path + sql4, "r").read())
print("Execution de " + sql4 + " OK")
cur.execute(open(path + sql5, "r").read())
print("Execution de " + sql5 + " OK")
cur.execute(open(path + sql6, "r").read())
print("Execution de " + sql6 + " OK")
cur.execute(open(path + sqlx, "r").read())
print("Execution de " + sqlx + " OK")

conn.commit()
cur.close()
conn.close()

# BEGIN;
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_reference/01_gracethd_t_reference_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_organisme/01_gracethd_t_organisme_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_noeud/01_gracethd_t_noeud_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_znro/01_gracethd_t_znro_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_zsro/01_gracethd_t_zsro_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_ptech/01_gracethd_t_ptech_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_sitetech/01_gracethd_t_sitetech_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_ltech/01_gracethd_t_ltech_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_ltech_patch201/01_gracethd_t_ltech_patch201_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_ebp/01_gracethd_t_ebp_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cable/01_gracethd_t_cable_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cableline/01_gracethd_t_cableline_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_baie/01_gracethd_t_baie_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cable_patch201/01_gracethd_t_cable_patch201_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_conduite/01_gracethd_t_conduite_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cab_cond/01_gracethd_t_cab_cond_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cheminement/01_gracethd_t_cheminement_insert.sql
# \i /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/t_cond_chem/01_gracethd_t_cond_chem_insert.sql
# COMMIT;
