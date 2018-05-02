cd C:\Program Files\PostgreSQL\9.4\bin\
psql.exe -h localhost -p 5432 -U postgres -d thd_isere --schema="route" -f C:\batch\dump_restore_sql\restore\01_TR01_PRO_DUMP_V2_20170303.sql

PAUSE
