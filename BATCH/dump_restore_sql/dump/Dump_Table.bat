cd C:\Program Files\PostgreSQL\9.4\bin\
pg_dump.exe -h localhost -p 5432 -U postgres -v -f C:\batch\dump_restore_sql\dump\dump_table.sql -t avp_ms2.chb_ms2 optimisation_diag

PAUSE
