--# TAMANHO DAS TABELAS
SELECT nspname || '.' || relname AS "tabela",
 pg_size_pretty(pg_relation_size(c.oid)) AS "tamanho"
FROM pg_class c
 LEFT JOIN pg_namespace n
  ON (n.oid = c.relnamespace)
WHERE nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_relation_size(c.oid) DESC
LIMIT 20;
