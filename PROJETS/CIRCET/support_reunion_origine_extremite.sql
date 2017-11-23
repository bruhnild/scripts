
------================================================================================------
------= ETAPE 1 : CREATION DES START POINTS/END POINTS DANS LA TABLE cb_cilaos_d1-d2 =------
------================================================================================------

--- base de données: temporaire (localhost)
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: création des start point/end points dans la table cb
SELECT AddGeometryColumn ('temp','cb_cilaos_d1-d2','start_point',2975,'POINT',2);
UPDATE temp."cb_cilaos_d1-d2" SET start_point = ST_StartPoint(geom);
SELECT AddGeometryColumn ('temp','cb_cilaos_d1-d2','end_point',2975,'POINT',2);
UPDATE temp."cb_cilaos_d1-d2" SET end_point = ST_EndPoint(geom);

------=======================================================================================================================------
------= ETAPE 2 : MISE A JOUR DES CHAMPS cb_nd1 ET cb_nd2 DE LA TABLE cb_cilaos_d1-d2 A PARTIR DES pt_code DES TABLES NOEUDS=------
------=======================================================================================================================------

--- base de données: temporaire (localhost)
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd1 (origine) avec la valeur pt_code de pa_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd1=b.pt_code
   FROM temp.pa_cilaos as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;

--- base de données: temporaire (localhost)  
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd2 (extremite) avec la valeur pt_code de pa_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd2=b.pt_code
   FROM temp.pa_cilaos as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;

--- base de données: temporaire (localhost)
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd1 (origine) avec la valeur pt_code de pep_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd1=b.pt_code
   FROM temp.pep_cilaos as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;

--- base de données: temporaire (localhost)   
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd2 (extremite) avec la valeur pt_code de pep_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd2=b.pt_code
   FROM temp.pep_cilaos as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;
   
--- base de données: temporaire (localhost)
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd1 (origine) avec la valeur pt_code de pb_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd1=b.pt_code
   FROM temp.pb_cilaos as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;
   
--- base de données: temporaire (localhost)   
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd2 (extremite) avec la valeur pt_code de pb_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd2=b.pt_code
   FROM temp.pb_cilaos as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;

--- base de données: temporaire (localhost)
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd1 (origine) avec la valeur pt_code de pm_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd1=b.pt_code
   FROM temp.pm_cilaos as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;
   
--- base de données: temporaire (localhost)  
--- schema: temp
--- table : "cb_cilaos_d1-d2" (renommée en cb)
--- action: mise à jour du champ cb_nd2 (extremite) avec la valeur pt_code de pm_cilaos
UPDATE temp."cb_cilaos_d1-d2" as a
   SET cb_nd2=b.pt_code
   FROM temp.pm_cilaos as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))-- parametre mofifiable (buffer de 2m)
   ;

------==========================================================================================------
------= ETAPE 3 : SUPPRESSION DES CHAMPS start_point ET end_point DANS LA TABLE cb_cilaos_d1-d2=------
------==========================================================================================------

ALTER TABLE temp."cb_cilaos_d1-d2" DROP COLUMN start_point RESTRICT;
ALTER TABLE temp."cb_cilaos_d1-d2" DROP COLUMN end_point RESTRICT;

