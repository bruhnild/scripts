import psycopg2

path = "/home/public/20-MOE70-HSN/07-Scripts/SQL/gracethd"
sql1 = "/t_noeud/01_gracethd_t_noeud_insert.sql"
sql2 = "/t_znro/01_gracethd_t_znro_insert.sql"
sql3 = "/t_zsro/01_gracethd_t_zsro_insert.sql"
sql4 = "/t_sitetech/01_gracethd_t_sitetech_insert.sql"

conn = psycopg2.connect("""
    dbname=hsn
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

conn.commit()
cur.close()
conn.close()
