--- Schema : psd_orange
--- Vue : v_locaux_hsn_sian_zanro_point_2154_duplicate
--- Traitement : Vue qui contient tous les doublons de locaux (superposition) par liaison

CREATE OR REPLACE VIEW psd_orange.v_locaux_hsn_sian_zanro_point_2154_duplicate AS
SELECT ROW_NUMBER() OVER(ORDER BY liaison_id) gid, * 
FROM(	
WITH locaux_liaison AS
(SELECT a.id, a.geom, a.objectid, b.liaison_id
FROM psd_orange.locaux_hsn_sian_zanro_point_2154 AS a, rbal.liaison_hsn_linestring_2154 b
WHERE ST_DWithin(a.geom, b.geom, 0.1))
SELECT   COUNT(liaison_id) AS nbr_doublon, liaison_id, geom
FROM     locaux_liaison
GROUP BY liaison_id, geom
HAVING   COUNT(*) > 1)a
;