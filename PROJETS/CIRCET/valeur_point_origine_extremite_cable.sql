/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 01/05/2017
Objet : Permet de rapatrier les identifiants de chambres aux origines/
extrémités des cables
Modification : Nom : Faucher Marine - Date :  - Motif/nature : 

-------------------------------------------------------------------------------------
*/



SELECT AddGeometryColumn ('covage','cb','start_point',2154,'POINT',2);
UPDATE covage.cb SET start_point = ST_StartPoint(geom);
SELECT AddGeometryColumn ('covage','cb','end_point',2154,'POINT',2);
UPDATE covage.cb SET end_point = ST_EndPoint(geom);

UPDATE covage.cb as a
   SET origine=b.code_bpe
   FROM covage.bpe as b 
   where st_intersects (a.start_point, st_buffer(b.geom, 2))
   ;

UPDATE covage.cb as a
   SET extremite=b.code_bpe
   FROM covage.bpe as b 
   where st_intersects (a.end_point, st_buffer(b.geom, 2))
;