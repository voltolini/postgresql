'--------------------------------
--# Local dos logs do postgres
--------------------------------'

--> Cliente Tozetto:

os logs ficam no diretório: /sysmo/sysmovs/dados/pgsql/data/log/

Há um log para cada dia.


--> Em algumas versões os logs ficam armazenados no local abaixo... versão 9.5 por exemplo.
/var/log/postgresql/postgresql-9.5-main.log



--# Configurações do log

Podemos configurar o log do Postgres da forma que desejarmos, ou a melhor que nos atendermos... podemos colocar as querys dentro do log,
querys que levam +30seg por exemplo. o log é totalmente configurável.


------------------------------------
--# Logging parameters in postgres
------------------------------------

1. logging_collector (boolean): Esse parametro ativa o logging collector, que é um processo em segundo plano que captura mensagens de log
enviadas para stderr e as redireciona para os arquivos de log. Essa abordagem geralmente é mais útil do que registrar em syslog, pois
alguns tipos de mensagens podem não aparecer na saída do syslog.

postgres=# show logging_collector;


2. log_directory (string): Quando o collector está habilitado, este parâmetro determina o diretório no qual os arquivos de log serão criados.
Ele pode ser especificado como um caminho absoluto ou relativo ao diretório de dados do cluster. Este parametro só pode ser definido no
"postgres.conf" ou na linha de comando do servidor. O padrão é log.

postgres=# show log_directory;


3. log_filename (string): Define os nomes dos arquivos de log criados, o valor é tratado como 'strftime', portanto %-escapes pode ser usado
para especificar nomes de arquivos que variam no tempo. (o calculo será feito no timezone especificado por log_timezone). O padrão postgres é
postgresql-%Y-%m-%d_%H%M%S.log

postgres=# show log_filename;


4. log_file_mode (integer): Define as permissões do arquivo, quem pode gravar e ler os dados do arquivo.

postgres=# show log_file_mode;

5. log_rotation_age (integer): determina o tempo máximo para usar um arquivo de log, após o qual um novo arquivo de log será criado. Sem
unidades é considerado minutos, o padrão é 24horas. este parametro pode ser definido em postgresql.conf

postgres=# show log_rotation_age;

6. log_rotation_size (integer): tamanho máximo de um arquivo de log, depois do valor X será criado um novo arquivo. unidade usada é Kilobytes
o padrão é 10 MB cada arquivo. pode ser alterado em postgresql.conf.

postgres=# show log_rotation_size;


--# Configurações de quando registrar no log


1. log_min_messsages (enum): controla quais niveis de mensagens são gravados no log do servidor. Os valores válidos são DEBUG5, DEBUG4, DEBUG3, DEBUG2, DEBUG1, INFO, NOTICE, WARNING, ERROR, LOG, FATAL e PANIC
cada nível inclui todos os níveis que os seguem.
Quanto maior o valor, menos mensagens são enviadas para o log. O padrão é warning.

postgres=# show log_min_messages;


2. log_min_error_statement (enum): Controla quais instrucoes SQL que causam uma condição de erro serão registradas no log do servidor. O padrão é ERROR, significa que as instruções que causam erros,
mnesagens de log, erros fatais ou panicos serão registradas.

postgres=# show log_min_error_statement;


3. log_min_duration_statement (integer): Faz com que cada instrução concluída seja registrada se a instrução for executada por pelo menos o período de tempo especificado. Exemplo, se defini-lo para 250ms,
todas as instruções SQL que executam em 250ms ou mais serão registradas, este parametro pode ser útil para rastrear consultas não otimizadas em seus aplicativos. será considerado milesgundos.

postgres=# show log_min_duration_statement;

4. log_recovery_conflict_waits: verifica os waits ref. ao WAL(archives) do postgres
5. log_statement: Controla as instruçoes que vão ser registradas no log, os modos são, none (off), ddl, mode all (tudo), o padrão é none.
6. log_replication_commands: com este podemos registrar os comandos de replicação no log.
7. log_temp_files: nomes e tamanhos dos arquivos temporários.
