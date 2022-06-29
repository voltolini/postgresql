--------------------------------------
--# Criar um certificado autoassinado
--------------------------------------

Criar o dominio

psql -U postgres -d database -h 192.168.0.105



--------------------- postgres.conf
ssl = on
ssl_ca_file = 'root.crt'
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL' #ALLOWED SSL CIPHERS


--------------------- pg_hga.conf
hostssl database  postgres  192.168.0.108/32  trust clientcert=1

------------------------------------------------- ANOTHER
rm server.8 root.* client.*

cd /var/lib/postgres/13/main


# Create a self-signed certificate
openssl req -new -nodes -text -out server.csr \
-keyout server.key -subj "/CN=postgres.lucasgrana.com.br"

openssl x509 -req -in server.csr -text -days 3650 \
-extfile /etc/ssl/openssl.conf -extensions v3_ca \
-signkey server.key -out server.crt


# Use it as the root (only for self-signed certificates)
cp server.crt root.crt


# Create the client certificate and sign it with root (no servidor postgres)
openssl req -new -nodes -text -out client.csr \
-keyout client.key -subj "/CN=hostname"

openssl x509 -req -in client.csr -text -days 365 \
-CA root.crt -CAkey server.key -CAcreaetserial \
-out client.crt


# Fix permissions
chown postgres:postgres root.* server.* client.*
chmod 600 root.* server.* client.*

# Fix for dbeaver
openssl pkcs8 -topk8 -inform PEM -outform DER -in client.key -out client.pk8 -nocrypt

/var/lib/postgres/13/main


----------------- Editar o postgres.conf /etc/postgres/13/main/postgresql.conf

Ir até ssl


ssl_cert_file = '/var/lib/postgres/13/main/server.crt'
ssl_key_file =  '/var/lib/postgres/13/main/server.key'
ssl_ca_file = '/var/lib/postgres/13/main/root.crt'


> Reiniciar o serviço
systemctl restart postgresql




------------------------- Forçar os clientes a enviarem uma chave ssh para eu checar no servidor essa chave ssh

# Editar o arquivo de conf
vi /etc/postgres/13/main/pg_hba.conf

ao invés de utilizar a opção host no tipo de conexão

utilizar "hostssl"

e no final após o md5 utilizar a opção 'clientcert=1'


------------------- Mover o certificado do client.

mv client.crt client.csr client.key /home/usuario

cp root.crt /home/usuario


-------------------------- Mover para a máquina que vou me conectar ao banco


--> Diretorio certificados
mkdir certificados

--> Entrar no diretorio criado
cd certificados

--> Conectar no servidor do banco
sftp ipservidor

--> Baixar o certificado para a máquina que vou me conectar ao banco
get client.*
get root.

--> Apagar os arquivos no servidor do banco



------------------------- Configurar o pgadmin

"liberar permissão especifica nos arquivos 660"

chmod 600 *.*

> Aba ssl

  #ssl mode: verify-full

> client certificate
  # client.crt

> client certificate key
  # client.key

> root certificate
  # root.crt
