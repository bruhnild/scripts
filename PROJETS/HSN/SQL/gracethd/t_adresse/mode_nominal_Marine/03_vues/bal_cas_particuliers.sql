

CREATE OR REPLACE VIEW rbal.v_bal_cas_particuliers AS
SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM

(
---------------------------------------------------
-- TOUT CE QUI N'A PAS DE CAS PARTICULIERS
SELECT 
hp.ad_code,
NULL::varchar as cas_particuliers
FROM
rbal.bal_hsn_point_2154 as hp
WHERE
hp.ad_code NOT IN

(SELECT DISTINCT ON (ad_code) ad_code FROM 
(WITH liste_cas_particuliers_agg AS  
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT ad_code, array_to_string(array_agg(cas_particuliers),';') AS cas_particuliers FROM 
(WITH liste_cas_particuliers AS
(
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier1 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_numero IS NULL OR ad_nomvoie IS NULL THEN 'Adresse a fiabiliser (Mairie)'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier1
WHERE cas_particuliers IS NOT NULL )a
 
UNION ALL 
 
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier2 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_ban_id IS NULL THEN 'Adresse a creer (manque BAN)'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier2
WHERE cas_particuliers IS NOT NULL )a
 
UNION ALL
 
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier3 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_distinf>=150 THEN 'Site isolé'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier3
WHERE cas_particuliers IS NOT NULL )a 
)
SELECT * FROM liste_cas_particuliers)a
GROUP BY ad_code)a
)
SELECT * FROM liste_cas_particuliers_agg)a)
 
 
---------------------------------------------------
-- TOUT CE QUI A UN OU PLUSIEURS CAS PARTICULIERS

UNION ALL 

(SELECT DISTINCT ON (ad_code) ad_code, cas_particuliers FROM 
(WITH liste_cas_particuliers_agg AS  
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT ad_code, array_to_string(array_agg(cas_particuliers),';') AS cas_particuliers FROM 
(WITH liste_cas_particuliers AS
(
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier1 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_numero IS NULL OR ad_nomvoie IS NULL THEN 'Adresse a fiabiliser (Mairie)'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier1
WHERE cas_particuliers IS NOT NULL )a
 
UNION ALL 
 
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier2 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_ban_id IS NULL THEN 'Adresse a creer (manque BAN)'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier2
WHERE cas_particuliers IS NOT NULL )a
 
UNION ALL
 
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier3 AS
(SELECT DISTINCT ON (ad_code) ad_code, (CASE WHEN ad_distinf>=150 THEN 'Site isolé'END)::varchar as cas_particuliers
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier3
WHERE cas_particuliers IS NOT NULL )a 
)
SELECT * FROM liste_cas_particuliers)a
GROUP BY ad_code)a
)
SELECT * FROM liste_cas_particuliers_agg)a))a;
 

--- Schema : rbal
--- Vue : vm_bal_columns_gracethdview
--- Traitement : Crée la fonction qui permet de sauvegarder les dépendances d'une vue lorsqu'elle est supprimée
--- Crédits : http://pretius.com/postgresql-stop-worrying-about-table-and-view-dependencies/

/*
drop table if exists deps_saved_ddl;
create table deps_saved_ddl
(
  deps_id serial primary key, 
  deps_view_schema varchar(255), 
  deps_view_name varchar(255), 
  deps_ddl_to_run text
) ;

create or replace function deps_save_and_drop_dependencies(p_view_schema varchar, p_view_name varchar) returns void as
$$
declare
  v_curr record;
begin
for v_curr in 
(
  select obj_schema, obj_name, obj_type from
  (
  with recursive recursive_deps(obj_schema, obj_name, obj_type, depth) as 
  (
    select p_view_schema, p_view_name, null::varchar, 0
    union
    select dep_schema::varchar, dep_name::varchar, dep_type::varchar, recursive_deps.depth + 1 from 
    (
      select ref_nsp.nspname ref_schema, ref_cl.relname ref_name, 
    rwr_cl.relkind dep_type,
      rwr_nsp.nspname dep_schema,
      rwr_cl.relname dep_name
      from pg_depend dep
      join pg_class ref_cl on dep.refobjid = ref_cl.oid
      join pg_namespace ref_nsp on ref_cl.relnamespace = ref_nsp.oid
      join pg_rewrite rwr on dep.objid = rwr.oid
      join pg_class rwr_cl on rwr.ev_class = rwr_cl.oid
      join pg_namespace rwr_nsp on rwr_cl.relnamespace = rwr_nsp.oid
      where dep.deptype = 'n'
      and dep.classid = 'pg_rewrite'::regclass
    ) deps
    join recursive_deps on deps.ref_schema = recursive_deps.obj_schema and deps.ref_name = recursive_deps.obj_name
    where (deps.ref_schema != deps.dep_schema or deps.ref_name != deps.dep_name)
  )
  select obj_schema, obj_name, obj_type, depth
  from recursive_deps 
  where depth > 0
  ) t
  group by obj_schema, obj_name, obj_type
  order by max(depth) desc
) loop

  insert into deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
  select p_view_schema, p_view_name, 'COMMENT ON ' ||
  case
  when c.relkind = 'v' then 'VIEW'
  when c.relkind = 'm' then 'MATERIALIZED VIEW'
  else ''
  end
  || ' ' || n.nspname || '.' || c.relname || ' IS ''' || replace(d.description, '''', '''''') || ''';'
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  join pg_description d on d.objoid = c.oid and d.objsubid = 0
  where n.nspname = v_curr.obj_schema and c.relname = v_curr.obj_name and d.description is not null;

  insert into deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
  select p_view_schema, p_view_name, 'COMMENT ON COLUMN ' || n.nspname || '.' || c.relname || '.' || a.attname || ' IS ''' || replace(d.description, '''', '''''') || ''';'
  from pg_class c
  join pg_attribute a on c.oid = a.attrelid
  join pg_namespace n on n.oid = c.relnamespace
  join pg_description d on d.objoid = c.oid and d.objsubid = a.attnum
  where n.nspname = v_curr.obj_schema and c.relname = v_curr.obj_name and d.description is not null;
  
  insert into deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
  select p_view_schema, p_view_name, 'GRANT ' || privilege_type || ' ON ' || table_schema || '.' || table_name || ' TO ' || grantee
  from information_schema.role_table_grants
  where table_schema = v_curr.obj_schema and table_name = v_curr.obj_name;
  
  if v_curr.obj_type = 'v' then
    insert into deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select p_view_schema, p_view_name, 'CREATE VIEW ' || v_curr.obj_schema || '.' || v_curr.obj_name || ' AS ' || view_definition
    from information_schema.views
    where table_schema = v_curr.obj_schema and table_name = v_curr.obj_name;
  elsif v_curr.obj_type = 'm' then
    insert into deps_saved_ddl(deps_view_schema, deps_view_name, deps_ddl_to_run)
    select p_view_schema, p_view_name, 'CREATE MATERIALIZED VIEW ' || v_curr.obj_schema || '.' || v_curr.obj_name || ' AS ' || definition
    from pg_matviews
    where schemaname = v_curr.obj_schema and matviewname = v_curr.obj_name;
  end if;
  
  execute 'DROP ' ||
  case 
    when v_curr.obj_type = 'v' then 'VIEW'
    when v_curr.obj_type = 'm' then 'MATERIALIZED VIEW'
  end
  || ' ' || v_curr.obj_schema || '.' || v_curr.obj_name;
  
end loop;
end;
$$
LANGUAGE plpgsql ;

create or replace function deps_restore_dependencies(p_view_schema varchar, p_view_name varchar) returns void as
$$
declare
  v_curr record;
begin
for v_curr in 
(
  select deps_ddl_to_run 
  from deps_saved_ddl
  where deps_view_schema = p_view_schema and deps_view_name = p_view_name
  order by deps_id desc
) loop
  execute v_curr.deps_ddl_to_run;
end loop;
delete from deps_saved_ddl
where deps_view_schema = p_view_schema and deps_view_name = p_view_name;
end;
$$
LANGUAGE plpgsql ;

--drop all views and materialized views dependent on p_schema_name.p_object_name 
--and save DDL which restores them in a helper table.
select deps_save_and_drop_dependencies('rbal', 'vm_bal_columns_gracethdview');
select * from deps_saved_ddl;
--restore those dropped objects
select deps_restore_dependencies('rbal', 'vm_bal_columns_gracethdview');

--These functions take care of:

--dependencies hierarchy
--proper order of dropping and creating views/materialized views across hierarchy
--restoring comments and grants on views/materialized views
*/

--drop all views and materialized views dependent on p_schema_name.p_object_name 
--and save DDL which restores them in a helper table.
--select deps_save_and_drop_dependencies('rbal', 'vm_bal_columns_gracethdview');
--select * from deps_saved_ddl;
--restore those dropped objects
--select deps_restore_dependencies('rbal', 'vm_bal_columns_gracethdview');

/*
-------------------------------------------------------------------------------------
OLD



SELECT ad_code, cas_particuliers::varchar FROM 
(WITH liste_cas_particuliers_agg AS  
(SELECT ROW_NUMBER() OVER(ORDER BY ad_code) gid, *
FROM
(
SELECT ad_code, array_to_string(array_agg(cas_particuliers),';') AS cas_particuliers FROM 
(WITH liste_cas_particuliers AS
(SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier1 AS
(SELECT (CASE WHEN ad_ban_id IS NULL AND nom_id IS NULL THEN 'Adresse à créer'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier1
WHERE cas_particuliers IS NOT NULL )a
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier2 AS
(SELECT (CASE WHEN ad_ban_id IS NULL AND nom_id IS NOT NULL THEN 'Adresse BAN inexistante mais locaux présents'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier2
WHERE cas_particuliers IS NOT NULL)b
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier3 AS
(SELECT (CASE WHEN nom_pro LIKE '%Transformateurs Electriques%' THEN 'Transformateur électrique'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier3
WHERE cas_particuliers IS NOT NULL)c
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier4 AS
(SELECT (CASE WHEN ad_isole IS TRUE THEN 'Site à prendre en compte (isolé)?' END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier4
WHERE cas_particuliers IS NOT NULL)d
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier5 AS
(SELECT (CASE WHEN nom_pro LIKE 'Antenne telecom' THEN 'Telecom (Antenne) à prendre en compte?'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier5
WHERE cas_particuliers IS NOT NULL)e
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier6 AS
(SELECT (CASE WHEN nom_pro LIKE 'Poste de refoulement' THEN 'Poste de refoulement à prendre en compte?'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier6
WHERE cas_particuliers IS NOT NULL)f
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier7 AS
(SELECT (CASE WHEN nom_pro LIKE 'Poste de gaz' THEN 'Poste gaz à prendre en compte?'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier7
WHERE cas_particuliers IS NOT NULL)g
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier8 AS
(SELECT (CASE WHEN nom_pro LIKE 'Château d’eau avec antenne telecom' THEN 'Château d''eau à prendre en compte?'END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier8
WHERE cas_particuliers IS NOT NULL)h
UNION ALL
SELECT cas_particuliers, ad_code FROM
(WITH cas_particulier7 AS
(SELECT (CASE WHEN nb_prises_totale = 0 OR statut = 'S' THEN 'Site à supprimer (pas de prise)' END)::varchar as cas_particuliers, ad_code
FROM rbal.vm_bal_columns_gracethdview)
SELECT * FROM cas_particulier7)i)
SELECT * FROM liste_cas_particuliers
WHERE cas_particuliers IS NOT NULL) a
WHERE cas_particuliers IS NOT NULL 
GROUP BY ad_code)a)
SELECT * FROM liste_cas_particuliers_agg)a)a;
-------------------------------------------------------------------------------------
*/
