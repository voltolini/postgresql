--------------------------------
--# PG_STAT_STATEMENTS Postgres
--------------------------------

Pelo que parece, se assemelha com o plano de execução do Oracle.

-> Versão: disponível a partir da 8.4

É uma extensão do Postgres, fornece um modo para rastrear as estatísticas de execução de todas as intruções SQL. são úteis para
identificar que consultas têm consumido mais tempo, retornam mais dados e quais são executadas com maior frequência.

Para monitorar o que ocorre, é necessário manter em memória uma rotina que realize essa atividade. deve ser alterado o arquivo
de configuração "postgres.conf", mais precisamente a variável "shared_preload_libraries", e reiniciar o servidor.

Exemplo: shared_preload_libraries='$libdir/pg_stat_statements'

Para confirmar a alteração podemos executar o comando abaixo no banco:
show shared_preload_libraries


O próximo passo é executar o script do arquivo "contrib/pg_stat_statements/pg_stat_statements.sql" que se
encontra na pasta de contribs para criar uma visão que mostrará os dados monitorados chamada pg_stat_statements

Podemos habilitar com CREATE EXTENSION pg_stat_statements.


--# Consulta padrão
select *from pg_stat_statements;


--# Consultas ordenadas pelo numero de chamadas
select * from pg_stat_statements order by calls desc;


--# Ordenada pelo tempo total utilizado
select * from pg_stat_statements order by total_time desc;

--# Ordenada pelo numero de linhas retornado
select * from pg_stat_statements order by rows desc;


--# Limpar a coleta de dados
select pg_stat_statements_reset();


--# Tempo gasto na query
select substring(query, 1, 50) as short_query,
round(total_time::numeric,2) as total_time,
calls, round(mean_time::numeric,2) as mean,
round ((100 * total_time / sum(total_time::numeric)
over ())::numeric,2) as percent_overall
from pg_stat_statement
order by total_time desc
limit 20;



select userid, dbid,
substr(query, 1, 50) as short_query,
calls, rows,
round ((100 * total_time / sum(total_time::numeric) over ())::numeric,2) as percent_overall,
local_blks_dirtied as blk_sujos,
blk_read_time as leitura_blk,
blk_wirte_time as tempo_escrita
from pg_stat_statement
--where dbid in (999)
--and userid in (123)
--and rows >=100000 --milhao
order by total_time;



--# A query magica (missing index)
select schemaname, relname, seq_scan, seq_tup_read,
idx_scan, seq_tup_read, / seq_scan as avg
from pg_stat_user_tables
where seq_scan >0
order by seq_tup_read desc;





---------------------
--# Exemplo
---------------------

create table t_gender (id int, name text);

	insert into t_gender values (1,'male'), (2,'female');


create table t_person (id serial, gender int, data char(40));

	insert into t_person (gender, data)
		select x%2+1,'data'
		from generate_series(1,50000000) as X;
		insert 0 5000000



--# Simples analysis
select name, count(*)
from t_gender as a, t_person as b
where a.id=b.gender
group by 1;


-> result:

name   | count
-------+--------
female | 250000
male   | 250000
(2 rows)
Time: 9661.034 ms


-> Tentativa 2

with x as
(
	select gender, count(*) as res
	from t_person as a
	group by 1
	)
select name, res
from x, t_gender as y
where x.gender=y.id;
...<same result>...
Time: 526.472 ms

--# Plano de execução
explain select name, count(*)
from t_gender as a, t_person as b
where a.id=b.gender
group by 1;


--# Exemplo classico

> suppose we have 20 years worth of data
> 1 billion rows per year

select sensor, count(temp)
from t_sensor
where t between '2014-01-01'
and '2014-12-31'
group by sensor;


--# Cria indices
create index idx_btree on t_person (id);

Time: 1542.177 ms


create index idx_brin on t_person using brin(id);

Time: 721.838 ms


postgres=#\di+

Name	 | Type	 | Table	 | Size
---------+-------+-----------+------
idx_brin  index   t_person     48 KB
idx_btree index   t_person    107 MB


alter table t_person
add column age int default random()*100;

select * from t_person limit 4;

id       gender  data  age
--------+------+------+-------
5000001 | 2    | data | 78
5000002 | 1    | data | 26
5000003 | 2    | data | 33
5000004 | 1    | data | 55


select name,
count(*) as everybody,
count(*) filter (where age <50) as young,
count(*) filter (where age >=50) as censored
from t_gender as a, t_person as b
where a.id=b.gender
group by rollup(1)
order by 1;

name   |everybody |young     | censored
-------+----------+----------+------------
female | 2500000  | 1238156  | 1261844
male   | 2500000  | 1238403  | 1261597
       | 2500000  | 2476559  | 2523441
