--#CHECAR ID POR DATABASE
SELECT datname, age(datfrozenxid) AS idade
FROM pg_database
ORDER BY idade;



--#CHECAR ID POR TABELA
SELECT c.oid::regclass AS tabela,
greatest(age(c.relfrozenxid),age(t.relfrozenxid)) AS idade,
current_setting('autovacuum_freeze_max_age') AS autovacuum_freeze_max_age
FROM pg_class c
LEFT JOIN pg_class t
ON c.reltoastrelid = t.oid
WHERE c.relkind IN ('r', 'm')
AND greatest(age(c.relfrozenxid),age(t.relfrozenxid)) > 150000000
ORDER BY idade DESC;




--#REALIZAR VACUUM DAS TABELAS PRÓXIMAS AO LIMITE
SELECT 'vacuum verbose analyze '||c.oid::regclass||';' AS comando
FROM pg_class c
 LEFT JOIN pg_class t
ON c.reltoastrelid = t.oid
WHERE c.relkind IN ('r', 'm')
  AND greatest(age(c.relfrozenxid),age(t.relfrozenxid)) > 150000000
ORDER BY greatest(age(c.relfrozenxid),age(t.relfrozenxid));
