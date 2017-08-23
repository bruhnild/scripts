INSERT INTO public.t_ltech (
   id,
   nom,
   insee,
   commune,
   geom
)
SELECT
   gid,
   nom_msro,
   codinsee,
   commune,
   wkb_geometry
FROM avp_ms2.nro_ms2
;

INSERT INTO public.t_ptech (
   id,
   nature,
   avct,
   geom
)
SELECT
   gid,
   ref_chambr,
   statut,
   wkb_geometry
FROM avp_ms2.chb_ms2
;


INSERT INTO public.t_cheminement (
   id,
   avct,
   compo,
   typ_imp,
   "long",
   lgreel,
   geom
)
SELECT
   gid,
   statut,
   compositio,
   mode_pose,
   shape_len,
   longueur,
   wkb_geometry
FROM avp_ms2.inf_ms2
;

fo_util



UPDATE avp_ms2.inf_ms2_test
SET compo_2 = substr(compositio,0 ,(strpos(compositio,'Ø')));
UPDATE avp_ms2.inf_ms2_test
SET compo_2 = null where compositio like '%Ciment%' or compositio like '%PEHD%';
UPDATE avp_ms2.inf_ms2_test
SET compo_2 = substr(compositio,8 ,(strpos(compositio,'Ciment:'))) where compo_2 is null;
UPDATE avp_ms2.inf_ms2_test
SET compo_2 = null where compositio like '%PEHD%';
UPDATE avp_ms2.inf_ms2_test
SET compo_2 = substr(compositio,6 ,(strpos(compositio,'PEHD:'))) where compo_2 is null;