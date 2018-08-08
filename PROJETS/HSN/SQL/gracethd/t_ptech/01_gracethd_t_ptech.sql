CREATE OR REPLACE VIEW gracethd_metis.v_ptech AS
SELECT 
	-- code unique pour la donnée ptech (pour les unions de tables)
	concat('PT700', sro, to_char(row_number() over (partition by sro ) +13, 'FM00000')) as pt_code
	,pt_code_metier
	,pt_codeext	
	,pt_nd_code
	,pt_ad_code
	,pt_prop
	,pt_gest
	,pt_avct
	,pt_typephy				   			   
	,pt_typelog				   
	,pt_rf_code				   
	,pt_nature				   
	,pt_secu		
	,pt_rotatio
	,pt_comment		
	,pt_creadat	
	,geom	
FROM 								
(WITH vue_ptech AS
(SELECT
	concat(b.digt_6, b.digt_7, '00') as sro
 	-- code métier (propre à la donnée)
	,concat('PT700', b.digt_6, b.digt_7, '00', to_char(a.gid, 'FM00000')) as pt_code_metier 
	,pt_codeext AS pt_codeext
	--,pt_nd_code --  REFERENCES t_noeud (nd_code)
	--,pt_ad_code --  REFERENCES t_adresse(ad_code)
	,UPPER(pt_prop) AS pt_prop -- REFERENCES t_organisme (or_code)
	--or_code AS pt_gest -- REFERENCES t_organisme (or_code)
	,pt_avct -- REFERENCES l_avancement(code)
	,pt_typephy AS pt_typephy -- REFERENCES l_ptech_type_phy (code)
	,'I'::VARCHAR AS pt_typelog -- REFERENCES l_ptech_type_log (code)
	,(CASE WHEN pt_avct LIKE 'C' THEN 'RF700010100001' ELSE null END )AS pt_rf_code -- REFERENCES t_reference (rf_code)
	,pt_nat::VARCHAR AS pt_nature --  REFERENCES l_ptech_nature (code)
	,0::BOOLEAN AS pt_secu 
	,pt_rotatio AS pt_rotatio
	,CASE WHEN pt_nat LIKE 'IND' THEN 'PRECISER NATURE' END AS pt_comment
	,now() AS pt_creadat 
	,a.geom
FROM avp_n070gay.ft_chambre a,  psd_orange.zanro_hsn_polygon_2154 b 
WHERE ST_CONTAINS (b.geom, a.geom))
SELECT 
a.sro
,a.pt_code_metier
,pt_codeext	
,c.nd_code AS pt_nd_code
,d.pt_ad_code
,b.or_code AS pt_prop
,b.or_code AS  pt_gest
,pt_avct
,pt_typephy				   			   
,pt_typelog				   
,pt_rf_code				   
,pt_nature				   
,pt_secu		
,pt_rotatio
,pt_comment		
,pt_creadat	
,a.geom
FROM vue_ptech a	
-- récupère or_code de t_organisme				   
LEFT JOIN gracethd_metis.t_organisme b ON a.pt_prop=b.or_nom	
-- récupère nd_code de v_noeud				   
LEFT JOIN gracethd_metis.v_noeud c ON a.pt_code_metier=c.pt_code	
-- récupère pt_ad_code de t_adresse					   
LEFT JOIN 
(SELECT 
pt_code
,pt_ad_code		
FROM				   
(WITH chambre_dist AS
(SELECT 
concat('PT700', b.digt_6, b.digt_7, '00', to_char(a.gid, 'FM00000')) as pt_code 
,a.pt_nat
,a.geom
,a.pt_nat														  
 FROM avp_n070gay.ft_chambre as a, psd_orange.zasro_hsn_polygon_2154 as b
WHERE ST_CONTAINS(b.geom, a.geom))
SELECT a.pt_code, a.geom, b.pt_ad_code
FROM chambre_dist a
LEFT JOIN 		   
(SELECT 
		 pt_code
		 ,pt_ad_code
		 ,dist
		 ,geom
		 ,pt_nat
		 FROM
		(WITH tmp AS
		-- requête qui permet de prendre le premier point chambre le plus proche de chaque adresse
		(
						WITH chambre_dist AS
						(SELECT 
						   concat('PT700', b.digt_6, b.digt_7, '00', to_char(a.gid, 'FM00000')) as pt_code 
						    ,a.pt_nat
							,a.geom
					    FROM avp_n070gay.ft_chambre as a, psd_orange.zasro_hsn_polygon_2154 as b
					    WHERE ST_CONTAINS(b.geom, a.geom))
					    SELECT pt_code, pt_nat, geom , t.ad_code, t.dist FROM chambre_dist as pt
						CROSS JOIN LATERAL
						-- requête qui permet de récupérer la distance la plus proche entre adresse et chambre
							(
								SELECT adresse.ad_code AS ad_code, st_distance(adresse.geom, pt.geom) AS dist
								FROM gracethd_metis.t_adresse as adresse 
								ORDER BY pt.geom <-> adresse.geom
								--LIMIT 1
							) AS t
						)

		SELECT 
		-- classifie les pt_code en fonction de la distance au ad_code																		 
		ROW_NUMBER() OVER(PARTITION BY pt_code ORDER BY dist) as id
		,pt_code, ad_code as pt_ad_code , dist , geom, pt_nat
		FROM tmp b
		WHERE dist <= 100)a
		-- Ne prend que la première ligne par pt_code (distance minimale)	
		WHERE id = 1) b ON a.pt_code = b.pt_code)a)d ON d.pt_code = a.pt_code_metier)a