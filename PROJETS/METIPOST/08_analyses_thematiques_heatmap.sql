/*
-------------------------------------------------------------------------------------
Auteur : Marine FAUCHER (METIS)
Date de création : 16/03/2018
Objet : MAJ données METIPOST
Modification : Nom : // - Date : // - Motif/nature : //
-------------------------------------------------------------------------------------
*/	
/*
-------------------------------------------------------------------------------------
ETAPE 1 : ANALYSES THEMATIQUES : HEATMAP
-------------------------------------------------------------------------------------
*/

--- Schema : analyses
--- Vue : heatmap_batiments_nb_pop_tot
--- Traitement : Heatmap

ALTER TABLE analyses.heatmap_batiments_nb_pop_tot
ADD range_id_rupture integer ;

update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 1 where dn <= 31;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 2 where dn between 32 and 69;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 3 where dn between 70 and 105;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 4 where dn between 106 and 135;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 5 where dn between 136 and 163;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 6 where dn between 164 and 191;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 7 where dn between 192 and 219;
update analyses.heatmap_batiments_nb_pop_tot  set range_id_rupture = 8 where dn >=220;

drop table if exists analyses.heatmap_batiments_nb_pop_tot_merge;
create table analyses.heatmap_batiments_nb_pop_tot_merge as 
SELECT
    (ST_Dump(St_multi(ST_Union(geom)))).geom AS geom, range_id_rupture
FROM 
   analyses.heatmap_batiments_nb_pop_tot
    group by range_id_rupture
;

update analyses.heatmap_batiments_nb_pop_tot_merge  set geom = ST_Buffer (ST_Buffer (geom, 15), -10) ;

drop table if exists analyses.heatmap_batiments_nb_pop_tot;
ALTER TABLE analyses.heatmap_batiments_nb_pop_tot_merge RENAME TO heatmap_batiments_nb_pop_tot;


