# Projeto RNP GT-TeI: Testbed para Espaços Inteligentes 
## 'Céu na Terra' Testbed

### Procedimento de instalação - parte Web e Banco de Dados

* instalar Ubuntu 14.04 Server 64bits (obs: para ambiente de desenvolvimento com IDE instalar versão Desktop 64bits) *[O upload de arquivos derruba o apache na versão 32bits]*
    ```    
    http://www.ubuntu.com/download/server
    ```    

* instalar Lua
    ```    
    sudo apt-get install lua5.1
    sudo apt-get install lua-md5
    ```

* instalar o Apache(2.4.12)
  * adicionar o repositório PPA para versão mais recente do Apache. 
  
    ```
    sudo apt-add-repository ppa:ondrej/apache2
    sudo apt-get update
    ```
  * instalar o  Apache
    
      ```
      sudo apt-get install apache2
      ```

* habilitar Lua no Apache (enable mod_lua)
    
      ```
      sudo a2enmod lua
      ```

* reiniciar o serviço do Apache

  ```
  sudo service apache2 restart
  ```
* instalar luarocks
  
  ```
  sudo apt-get install luarocks
  ```
* instalar Git
 
  ```
  sudo apt-get install git
  ```
* instalar Sailor
 
  ```
  sudo luarocks install cgilua 5.1.4-2
  sudo luarocks install sailor
  ```
* instalar postgresql(9.3)--

    ```
    sudo apt-get install postgresql libpq-dev
    ```
* instalar suporte Postgres para Lua (luasql-postgres)
 
  ```
  sudo luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql/
  ```  
* criar senha do postgres

 ```
    sudo -u postgres psql
    \password
    <defina uma senha do postgres>
    \q
 ```
* baixar aplicação Testbed

  ```
   cd ~
   git clone https://github.com/afbranco/Testbed
   <entre com o seu usuário e senha do Github>
  ```
* criar o banco de dados

    ```
    cd ~/Testbed/BD
    psql -h localhost -U postgres < TBDB.bck 
    <digitar senha do postgres definida no item acima>
    ```
* copiar aplicação web para dentro de /var/www/html

    ```
    sudo cp ~/Testbed/TBportal /var/www/html/TBportal -r
    ```
* configurar o apache2.conf - mudar *allow overwrite* para *all* dentro da sessão */var/www* em /etc/apache2/apache2.conf

    ```
    como super user(sudo) abra o arquivo /etc/apache2/apache2.conf em seu editor de preferência
    
    em <Directory /var/www/> substitua
    AllowOverride None por AllowOverride all
    ```
* dar permissão de escrita para o Apache escrever arquivo de sessão 
 
    `sudo chown www-data:www-data /var/www/html/TBportal/runtime/tmp` 

* Carregar no banco de dados a configuração do Testbed
    * Edidar o arquivo *ResetAllData.lua* no diretório *~/Testbed/DB* e alterar os dados conforme a configuração do seu Testbed.
    * Carregar os dados com o comando abaixo: (obs: este comando apaga todos os dados existentes e cria novos dados.)

        ```
        lua ResetAllData.lua
        ```

* reiniciar o serviço do Apache

  ```
  sudo service apache2 restart
  ```

### Procedimento de instalação - TestbedControl (TBControl)

* Uisp Tools 
	* 1) Adicione os seguintes repositorios: 
        ```
sudo gedit /etc/apt/sources.list 
        ```

		* Adicione no final arquivo: 
		```
		deb http://tinyos.stanford.edu/tinyos/dists/ubuntu lucid main 
		deb http://tinyos.stanford.edu/tinyos/dists/ubuntu maverick main 
		deb http://tinyos.stanford.edu/tinyos/dists/ubuntu natty main 
		```

	* 2) Execute:
        ```
	sudo apt-get update 
        ```

	* 3) Execute:
        ```
	sudo apt-get install tinyos-tools 
        ```

* Complementos
	* 1) Executar os comandos:
	```
	sudo apt-get install binutils-avr 
	sudo apt-get install binutils-msp430 
	sudo apt-get install python-psycopg2
	```
       
* Java 1.7 (Oracle/Sun): 
	* No terminal execute os seguintes passos: 
		* 1) Adicione o seguinte repositório:

	        ```
		sudo add-apt-repository ppa:webupd8team/java 
		sudo apt-get update 
	        ```
  
		* 2) Instale o Java: 

	        ```
		sudo apt-get install oracle-jdk7-installer 
	        ```
  
		* 3) Execute no terminal o comando: “java –version” e verfique se a versão do Java é 1.7.0_xx 
			* 3.1) Caso não seja a versão 1.7 faça: 

		        ```
			sudo apt-get install oracle-java7-set-default 
		        ```

* Testbed Control 
	* 1) Na pasta TestbedControl/files 
		* 1.1 ­ Defina o caminho correto do arquivo startTBrelay.sh 
		* 1.2 ­ Configure o arquivo TBDB.cfg conforme as configurações do banco de dados 
	* 2) Edite o arquivo "TestbedControl.properties"  para corrigir os parâmetros do banco de dados e o caminho do programa 
 	* 3) Copie "TestbedControl.properties" para o diretório root do usuário como .TestbedControl.properties" (note o ponto incluído antes do nome) 
    * 4) Na Pasta TestbedControl/ crie uma pasta com o nome de "logs"  
  

* Configurar o start/stop/restart do TBControl como serviço no linux
	* 1) Vá para o diretório TBControl e crie a pasta logs
        ```
        cd ~/Testbed/TBControl
        mkdir logs
        ```

	* 2) Vá para o diretório TBControl/files
        ```
        cd ~/Testbed/TBControl/files
        ```

	* 3) Edite o arquivo tbcontrol no diretório files e coloque os valores corretos para:
        ```
	TBCUSER=tbdev
	TBCPATH=/home/tbdev/Testbed/TBControl
	DATABASE=portal2
	DBUSER=postgres
	PGPWD=postgres
        ```
        Sendo:
		* TBCUSER - Usuário linux
		* TBCPATH - Caminho do diretório onde encontra-se o TBControl.jar
		* DATABASE - Nome do banco de dados no postgres
		* DBUSER - usuário do banco de dados
		* PGPWD - senha do banco de dados (criado no item acima: "criar senha do postgres")
        
        

	* 4) Copie o arquivo para a pasta de serviços do linux
        ```
	sudo cp tbcontrol /etc/init.d/.
        ```

	* 5) Configurar o serviço para iniciar no boot da máquina
        ```
	sudo update-rc.d tbcontrol defaults 95
        ```
		
	* 6) Reiniciar semanalmente o tbcontrol
		* No terminal execute
			```
			crontab -e
			```
		* Adicione a seguinte linha
			```
			10 02 * * sun /etc/init.d/tbcontrol restart
			```
		* No terminal execute
			```
			sudo /etc/init.d/cron restart
			```

### Iniciar VMs do VirtualBox no boot do host
* Configurar o start/stop das VMs como serviço no linux
	* 1) Vá para o diretório TBControl/files
        ```
        cd ~/Testbed/TBControl/files
        ```

	* 2) Edite o arquivo vmboot no diretório files e coloque o valor correto para:
        ```
	VBOXUSER=tbdev
        ```
        Sendo:
		* VBOXUSER - Usuário linux

	* 3) Copie o arquivo para a pasta de serviços do linux
        ```
	sudo cp vmboot /etc/init.d/.
        ```

	* 4) Configurar o serviço para iniciar no boot da máquina
        ```
	sudo update-rc.d vmboot defaults 95
        ```

	* obs) No shutdown o script salva os estados das VMs que estiverem ligadas. No boot o script só inicializa as VMs que tiverem seus estados salvos. Se alguma VM não inicializar no boot, tente salvar o estado dela manualmente antes do shutdown. 


### Dicas para configurações adicionais. (Somente se forem necessárias)

* Configuração da placa de rede no Linux: 
	* Nas configurações de rede faça os seguintes ajustes: 
		* eth0(placa ligada no Switch): 
			* IP:192.168.0.100 
			* Netmask: 255.255.255.0 
		* eth1(conexão externa): 
			* Configuração padrão: com IP fixo ou dinâmico  



* Python e pyserial - Somente se não estiver instalado na sua versão do Ubuntu.
	* 1) Confirmar se o Python 2.7 já está instalado:
        ```
	python --version
        ```

	 * Se necessário, instalar o Python 2.7 com o comando:
	
        ```
	sudo apt-get install python 
        ```
  
	* 2) Instale o pyserial: 
        ```
	sudo apt-get install python-serial 
        ```
  
