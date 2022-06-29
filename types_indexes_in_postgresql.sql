'-------------------------
--# Indices no Postgres
-------------------------'

--> What is an index?

Um indice ajuda o banco a encontrar dados dentro de uma tabela, porque sem um indice. teriamos que escanear a tabela
do inicio ao fim para procurar os valores que que estamos procurando, um indice apenas o torna mais rapido.

Pode ser usado também na ordenação de dados.

Indices ocupam um espaço adicional, em termo gerais isso é muito insignificante, eles não ocupam muito, mas você só precisa estar
ciente de que você não pode simplesmente criar um indice "gratuitamente", pois há alguma sobrecarga adicional tanto na
manutenção da criação quanto no armazenamento para ele, mas o banco não irá utilizar um indice se a tabela for pequena,
porque se não a busca pelo dado irá demorar mais, pois primeiro ele irá ler o indice e depois a tabela.


--> Why do we need indexes?
Para evitar que o banco de dados faça leituras em disco, pois leituras em disco são mais lentas.


--> Index types in Postgres

 -> B-tree: É o padrão, é o mais utilizado.
 -
 > GIN: Especialmente particionado. (uteis quando deve-se mapear vários valores para uma linha)
 Good for data that contains multiple values, such as (arrays, jsonb, hstore, tsvector e range types) preferido para search text

 -> GIST: gerencia o layout das próprias páginas

 -> SP-GIST: Particionado por espaço, suporta buscas particionadas. (numero de telefone ou endereço ip)

 -> BRIN (block range index): Projetado para manipular tabelas muito grandes, nas quais certas colunas tem coorelação.
  Indice de intervalo de blocos (é considerado um bom indice)

 -> HASH: Úteis para comparações de igualdade, não é um tipo que oferece transações seguras, precisam ser reconstruidos apos acidentes


