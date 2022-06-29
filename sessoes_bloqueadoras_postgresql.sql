--# ENCERRAR UMA SESSAO - deve retornar t
SELECT pg_terminate_backend(40946) FROM pg_stat_activity ;



--# VER TODAS AS SESSOES DO BANCO
---------------------------------
\pset format wrapped
SELECT a.datname as DATABASE, a.pid, a.state, a.usename AS USUARIO, a.application_name AS APLICACAO, a.client_addr AS ENDERECO_IP____
    , a.backend_start AS DATA_HORA_LOGON, to_char(a.query_start, 'YYYY-MM-DD HH24:MI') AS INICIO_COMANDO
    , SUBSTRING(a.query,1,100) AS COMANDO_SQL_EM_EXECUCAO
FROM  pg_stat_activity A
ORDER BY DATA_HORA_LOGON ;



--# VER SESSOES AGRUPADAS POR IP E APLICACAO
--------------------------------------------
\pset format wrapped
SELECT a.datname as DATABASE, a.state, a.usename AS USUARIO, a.client_addr as ENDERECO_IP____, SUBSTRING(a.application_name,1,11) AS APLICACAO, COUNT(*)
FROM  pg_stat_activity A
GROUP BY a.datname, a.state, a.usename, a.client_addr, SUBSTRING(a.application_name,1,11)
ORDER BY COUNT(*) DESC ;



--# VER QUANTIDADE SESSOES EXECUTANDO MESMO COMANDO
---------------------------------------------------
\pset format wrapped
SELECT a.query, COUNT(*)
FROM  pg_stat_activity A
GROUP BY a.query
ORDER BY COUNT(*) DESC ;



--# VER SESSOES ATIVAS COM TEMPO
--------------------------------
\pset format wrapped
SELECT a.pid, a.state, a.usename                   AS USUARIO
    , a.application_name                           AS APLICACAO
    , a.client_addr                                AS ENDERECO_IP___
    , to_char(a.backend_start, 'DD/MM HH24:MI')    AS LOGON
    , to_char(a.query_start, 'DD/MM HH24:MI')      AS INICIO_CMD
    , to_char(now() - a.query_start, 'HH24:MI:SS') AS ATIVA
    , SUBSTRING(a.query,1,130)                     AS COMANDO_SQL_EM_EXECUCAO
FROM  pg_stat_activity A
WHERE a.state = 'active'
  AND to_char(now() - a.query_start, 'MI') > '01' -- > 1min
--  AND a.client_addr = 'ENDERECO_IP'
ORDER BY ATIVA DESC ;



--# VER SESSOES BLOQUEADORAS - SIMPLES
--------------------------------------
\pset format wrapped
SELECT a.pid, a.usename       AS USUARIO
    , a.application_name      AS APLICACAO
    , a.client_addr           AS ENDERECO_IP___
    , pg_blocking_pids(a.pid) AS BLOQUEADO_POR
FROM  pg_stat_activity A
WHERE cardinality(pg_blocking_pids(a.pid)) > 0
ORDER BY A.PID ;



--# VER SESSOES BLOQUEADORAS - SIMPLES
--------------------------------------
\pset format wrapped
SELECT  pg_blocking_pids(a.pid) AS BLOCK
    , a.pid as WAIT, a.usename  AS USUARIO
    , a.application_name        AS APLICACAO
    , a.client_addr             AS ENDERECO_IP___
FROM  pg_stat_activity A
WHERE cardinality(pg_blocking_pids(a.pid)) > 0
ORDER BY A.PID ;



--# VER SESSOES BLOQUEADORAS - COMPLETO
---------------------------------------
\pset format wrapped
SELECT BLK.pid AS PID_BLOQ, BLK_A.usename AS USUARIO_BLOQ
    , BLK_A.application_name AS APLICACAO_BLOQ, BLK_A.client_addr AS IP_BLOQUEANDO__
    , substring(BLK_A.query,1,1000) AS COMANDO_BLOQ
    , now() - WAIT_A.query_start AS TEMPO_WAIT
    , WAIT.pid AS PID_WAIT, WAIT_A.usename AS USUARIO_WAIT
    , WAIT_A.application_name AS APLICACAO_WAIT, WAIT_A.client_addr AS IP_ESPERANDO__
    , substring(WAIT_A.query,1,1000) AS COMANDO_WAIT
FROM  pg_catalog.pg_locks BLK;





--# VER SESSOES BLOQUEADORAS - COMPLETO
---------------------------------------
\pset format wrapped
SELECT BLK.pid AS PID_BLOQ, BLK_A.usename AS USUARIO_BLOQ
    , BLK_A.application_name AS APLICACAO_BLOQ, BLK_A.client_addr AS IP_BLOQUEANDO__
    , substring(BLK_A.query,1,1000) AS COMANDO_BLOQ
    , now() - WAIT_A.query_start AS TEMPO_WAIT
    , WAIT.pid AS PID_WAIT, WAIT_A.usename AS USUARIO_WAIT
    , WAIT_A.application_name AS APLICACAO_WAIT, WAIT_A.client_addr AS IP_ESPERANDO__
    , substring(WAIT_A.query,1,1000) AS COMANDO_WAIT
FROM  pg_catalog.pg_locks BLK
JOIN  pg_catalog.pg_stat_activity BLK_A
  ON  BLK_A.pid = blk.pid
JOIN  pg_catalog.pg_locks WAIT
  ON  WAIT.locktype = blk.locktype
 AND  WAIT.database      IS NOT DISTINCT FROM blk.database
 AND  WAIT.relation      IS NOT DISTINCT FROM blk.relation
 AND  WAIT.page          IS NOT DISTINCT FROM blk.page
 AND  WAIT.tuple         IS NOT DISTINCT FROM blk.tuple
 AND  WAIT.virtualxid    IS NOT DISTINCT FROM blk.virtualxid
 AND  WAIT.transactionid IS NOT DISTINCT FROM blk.transactionid
 AND  WAIT.classid       IS NOT DISTINCT FROM blk.classid
 AND  WAIT.objid         IS NOT DISTINCT FROM blk.objid
 AND  WAIT.objsubid      IS NOT DISTINCT FROM blk.objsubid
 AND  WAIT.pid != blk.pid
JOIN  pg_catalog.pg_stat_activity WAIT_A
  ON  WAIT_A.pid = blk.pid
WHERE NOT blk.granted
ORDER BY TEMPO_WAIT DESC ;




--# VER SESSOES BLOQUEADORAS - COMPLETO NOVO
\pset format wrapped
select
 blocking_locks.pid as pid_lock,
 to_char(blocking_activity.query_start, 'hh24:mi:ss') as horario_lock,
 blocking_activity.datname as database_lock,
 blocking_activity.usename as usuario_lock,
 substring(blocking_activity.query,1,255) as comando_lock,
 blocking_activity.application_name as aplicacao_lock,
 blocking_activity.client_addr as estacao_lock,
 blocked_locks.pid as pid_wait,
 to_char(blocked_activity.query_start, 'hh24:mi:ss') as horario_wait,
 --blocked_activity.usename as usuario_wait,
 --blocked_activity.wait_event_type as wait_type,
 --blocked_activity.wait_event,
 blocked_activity.application_name as aplicacao_wait,
 blocked_activity.client_addr as estacao_wait,
 substring(blocked_activity.query,1,255) as comando_wait
from pg_catalog.pg_locks blocked_locks
 join pg_catalog.pg_stat_activity blocked_activity
  on blocked_activity.pid = blocked_locks.pid
 join pg_catalog.pg_locks blocking_locks
   on blocking_locks.locktype = blocked_locks.locktype
  and blocking_locks.database is not distinct from blocked_locks.database
  and blocking_locks.relation is not distinct from blocked_locks.relation
  and blocking_locks.page is not distinct from blocked_locks.page
  and blocking_locks.tuple is not distinct from blocked_locks.tuple
  and blocking_locks.virtualxid is not distinct from blocked_locks.virtualxid
  and blocking_locks.transactionid is not distinct from blocked_locks.transactionid
  and blocking_locks.classid is not distinct from blocked_locks.classid
  and blocking_locks.objid is not distinct from blocked_locks.objid
  and blocking_locks.objsubid is not distinct from blocked_locks.objsubid
  and blocking_locks.pid != blocked_locks.pid
 join pg_catalog.pg_stat_activity blocking_activity
  on blocking_activity.pid = blocking_locks.pid
where not blocked_locks.granted
order by horario_lock;
