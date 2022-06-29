'--------------------------------'
'--#POSTGRES - RESTAURAR BACKUP'
'-------------------------------'


--# CRIAR DATABASE ANTES DE RESTAURAR

create database nome_db;


--# OU CRIAR O DATABASE NO MOMENTO DA RESTAURAÇÃO

pg_restore -U postgres -C -d nome_db /backup/arquivo.bak


--# RESTAURAÇÃO COMPLETA EM DATABASE VAZIO.

pg_restore -U postgres -d nome_db /backup/arquivo.bak



'----------------------------------------------'
'--# RESTORE SOMENTE DA ESTRUTURA (SEM DADOS)'
'----------------------------------------------'


--# BACKUP SOMENTE DOS OBJETOS VAZIOS

pg_dump -U postgres --schema-only -d nome_db /backup/arquivo.bak



--# RESTAURAÇÃO SOMENTE DOS OBJETOS VAZIOS

pg_restore -U postgres --schema-only -d nome_db /backup/arquivo.bak



'---------------------------------'
'--# RESTORE DE TABELA ESPECÍFICA'
'---------------------------------'


--# BACKUP SOMENTE UMA TABELA DO BACKUP

pg_restore -U postgres -d nome_db /backup/arquivo.bak -t nome_tabela


--# RESTAURAÇÃO DE SOMENTE UMA TABELA DO BACKUP

pg_restore -U postgres -d nome_db /backup/arquivo.bak -t nome_tabela



' -- Obs: Pode ser usado o asterisco(*) como coringa para os nomes de tabelas --'
