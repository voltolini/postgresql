SELECT SUBSTRING(s.relname,1,20) AS tabela, s.n_live_tup AS linhas,
 s.n_dead_tup AS mortas, round(s.n_dead_tup * 100 / s.n_live_tup::NUMERIC,2) AS perc,
 to_char(s.last_autoanalyze, 'DD/MM/YY HH24:MI') AS l_analyz_a,
 --to_char(s.last_analyze, 'DD/MM/YY HH24:MI') as l_analyz_m,
 s.autoanalyze_count AS analyz_a,
 --s.analyze_count as analyz_m,
 to_char(s.last_autovacuum, 'DD/MM/YY HH24:MI') AS l_vacuum_a,
 --to_char(s.last_vacuum, 'DD/MM/YY HH24:MI') as l_vacuum_m,
 s.autovacuum_count AS vaccum_a
 --s.vacuum_count as vaccum_m
FROM pg_stat_all_tables s
WHERE NOT s.relname IS NULL
  AND NOT s.relname LIKE 'pg%'
  AND NOT s.relname LIKE 'sql%'
  --and s.n_live_tup > 1000
  --and not s.last_autoanalyze is null
  --and s.n_dead_tup > 0
  --and s.relname in ('history_uint','hosts')
ORDER BY linhas DESC;
