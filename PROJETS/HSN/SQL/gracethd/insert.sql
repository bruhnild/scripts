BEGIN;


\! echo "Répertoire des scripts (/!\chemin à adapter si besoin) : " pwd

\cd /mnt/'FTTH RIP'/20-MOE70-HSN/07-Scripts/SQL/gracethd/sro_batch/

-- \cd I:/20-MOE70-HSN/07-Scripts/Backups/GRACE/gracethd/

-- Variable SRO parmi les codes suivants :
-- SELECT DISTINCT 'avp_' || lower(code_nro_definitif) FROM psd_orange.ref_code_zasro;
-- SELECT DISTINCT code_nro_definitif FROM psd_orange.ref_code_zasro;

-- \set iter_sro 9
-- \set sro (SELECT 'avp_' || lower(code_nro_definitif) sro FROM psd_orange.ref_code_zanro WHERE id = :iter_sro)

\set sro avp_n070gay
\set code_sro '\'' N070GAY '\''

\! echo "Inclusion des scripts TRANSPORT dans l'ordre des contraintes du MCD GR@CE-THD"

\include_relative 01_gracethd_t_organisme_insert.sql
\include_relative 01_gracethd_t_reference_insert.sql
\include_relative 01_gracethd_t_noeud_insert.sql
\include_relative 01_gracethd_t_znro_insert.sql
\include_relative 01_gracethd_t_zsro_insert.sql
\include_relative 01_gracethd_t_ptech_insert.sql
\include_relative 01_gracethd_t_sitetech_insert.sql
\include_relative 01_gracethd_t_ltech_insert.sql
\include_relative 01_gracethd_t_ltech_patch201_insert.sql
\include_relative 01_gracethd_t_ebp_insert.sql
\include_relative 01_gracethd_t_cable_insert.sql
\include_relative 01_gracethd_t_cableline_insert.sql
\include_relative 01_gracethd_t_baie_insert.sql
\include_relative 01_gracethd_t_cablepatch201_insert.sql
\include_relative 01_gracethd_t_conduite_insert.sql
\include_relative 01_gracethd_t_cab_cond_insert.sql
\include_relative 01_gracethd_t_cheminement_insert.sql
\include_relative 01_gracethd_t_cond_chem_insert.sql
COMMIT;