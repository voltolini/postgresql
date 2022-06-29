--# select pra matar varias sessoes:
-----------------------------------
select 'select pg_terminate_backend('||pid||');'
from pg_stat_activity
where state in ('active','idle in transaction')
  and pid <> pg_backend_pid()
  and client_addr = '172.31.36.223'
  and lower(query) like 'select rem.sco01_cep%';



--# SESSÕES ATIVASp
SELECT pid, state, datname, usename, application_name, client_addr, backend_start AS dt_logon,
 to_char(query_start, 'HH:MI:SS') AS query_start, SUBSTRING(query,1,45) AS query
FROM pg_stat_activity
ORDER BY query_start;



--# SESSÕES IDLE (INATIVAS COM TRANSAÇÃO ABERTA)
\pset pager off
\pset format wrapped
SELECT pid, to_char(query_start, 'HH24:MI:SS') AS inicio_query,
 trunc(EXTRACT(epoch FROM (now()::TIMESTAMP - query_start::TIMESTAMP))) AS seg,
 state, datname AS db, usename AS usuario, application_name AS aplicacao,
 client_addr AS endereco, concat(wait_event_type,'/',wait_event) AS eventos,
 REPLACE(SUBSTRING(ltrim(TRIM(query)),1,1024),'  ',' ') AS comando
FROM pg_stat_activity
WHERE state IN ('idle in transaction')
  AND pid <> pg_backend_pid()
  --and client_addr = '172.31.36.223'
  --and trunc(extract(epoch from (now()::timestamp - query_start::timestamp))) > 10
  --and usename = 'zabbix'
  --and pid in (37063)
  --and query like '%vacuum%'
ORDER BY inicio_query desc;




--# SESSÕES ATIVAS COM TEMPO
\pset pager off
\pset format wrapped
SELECT pid, state as status, datname as database, usename as usuário, application_name as aplicacao, client_addr as ip, to_char(backend_start, 'YYYY/DD/MM HH24:MI:SS') AS dt_logon,
 to_char(query_start, 'YYYY-MM-DD HH24:MI') AS query_start,
EXTRACT( epoch FROM (now() - query_start)::INTERVAL /3600) AS tempo , SUBSTRING(query,1,45) AS query    /*divisao por 3600 para resultado em Hrs*/
FROM pg_stat_activity WHERE state in ('active','idle in transaction')
ORDER BY query_start;




--# SESSÕES ATIVAS AGRUPADAS
\pset pager off
\pset format wrapped
SELECT usename, state,
application_name as aplicacao,
client_addr,
datname as database,
count(*) as sessoes
FROM pg_stat_activity
--WHERE usename=''           --#usuário
--AND application_name=''    --#aplicação
--AND client_addr=            --#ip
--AND state=''                --#status
GROUP BY usename, state, application_name, client_addr, datname
having count(*) >5
order by sessoes desc;




--# SESSÕES ATIVAS AGRUPADAS SIMPLES
\pset pager off
\pset format wrapped
SELECT datname AS db, state, COUNT(*) AS qtde
FROM pg_stat_activity
GROUP BY datname, state
ORDER BY qtde DESC;




--# DETALHES DA SESSÃO
SELECT pid, state, /*datname as db, */usename AS usuario, application_name AS aplicacao,
 client_addr AS endereco, to_char(query_start, 'HH:MI:SS') AS horario, SUBSTRING(query,1,5000) AS comando
FROM pg_stat_activity
WHERE pid IN (34277)
ORDER BY query_start;





--# SESSÕES ATIVAS ++
\pset pager off
\pset format wrapped
\x off
select pid, to_char(query_start, 'HH24:MI:SS') as inicio_query,
 trunc(extract(epoch from (now()::timestamp - query_start::timestamp))) as seg,
 state, datname as db, usename as usuario, application_name as aplicacao,
 client_addr as endereco, concat(wait_event_type,'/',wait_event) as eventos,
 replace(substring(ltrim(trim(query)),1,1024),'  ',' ') as comando
from pg_stat_activity
where state in ('active','idle in transaction')
  and pid <> pg_backend_pid()
  --and trunc(extract(epoch from (now()::timestamp - query_start::timestamp))) > 10
  --and usename = 'zabbix'
  --and pid in (37063)
  --and (lower(query) like '%truncate%' or lower(query) like '%drop%')
order by inicio_query;
