	<style type="text/css" media="screen">

		.tree ul {
			margin: 0; padding: 0;
			padding-top: 20px; position: relative;
	
			-webkit-transition: all 0.5s;
			-moz-transition: all 0.5s;
			transition: all 0.5s;
		}

		.tree li {
			float: left; text-align: center;
			list-style-type: none;
			position: relative;
			padding: 20px 5px 0 5px;
	
			-webkit-transition: all 0.5s;
			-moz-transition: all 0.5s;
			transition: all 0.5s;
		}

		/*We will use ::before and ::after to draw the connectors*/

		.tree li::before, .tree li::after{
			content: '';
			position: absolute; top: 0; right: 50%;
			border-top: 1px solid #ccc;
			width: 50%; height: 45px;
			z-index: -1;
		}
		.tree li::after{
			right: auto; left: 50%;
			border-left: 1px solid #ccc;
		}

		/*We need to remove left-right connectors from elements without 
		any siblings*/
		.tree li:only-child::after, .tree li:only-child::before {
			display: none;
		}

		/*Remove space from the top of single children*/
		.tree li:only-child{ padding-top: 0;}

		/*Remove left connector from first child and 
		right connector from last child*/
		.tree li:first-child::before, .tree li:last-child::after{
			border: 0 none;
		}
		/*Adding back the vertical connector to the last nodes*/
		.tree li:last-child::before{
			border-right: 1px solid #ccc;
			border-radius: 0 5px 0 0;
			
			-webkit-transform: translateX(1px);
			-moz-transform: translateX(1px);
			transform: translateX(1px);
			
			-webkit-border-radius: 0 5px 0 0;
			-moz-border-radius: 0 5px 0 0;
			border-radius: 0 5px 0 0;
		}
		.tree li:first-child::after{
			border-radius: 5px 0 0 0;
			-webkit-border-radius: 5px 0 0 0;
			-moz-border-radius: 5px 0 0 0;
		}

		/*Time to add downward connectors from parents*/
		.tree ul ul::before{
			content: '';
			position: absolute; top: -12px; left: 50%;
			border-left: 1px solid #ccc;
			width: 0; height: 32px;
			z-index: -1;
		}

		.tree li a{
			border: 1px solid #ccc;
			padding: 5px 10px;
			text-decoration: none;
			color: #666;
			font-family: arial, verdana, tahoma;
			font-size: 12px;
			display: inline-block;
			background: white;
	
			-webkit-border-radius: 5px;
			-moz-border-radius: 5px;
			border-radius: 5px;
	
			-webkit-transition: all 0.5s;
			-moz-transition: all 0.5s;
			transition: all 0.5s;
		}
		.tree li a+a {
			margin-left: 20px;
			position: relative;
		}
		.tree li a+a::before {
			content: '';
			position: absolute;
			border-top: 1px solid #ccc;
			top: 50%; left: -21px; 
			width: 20px;
		}

		/*Time for some hover effects*/
		/*We will apply the hover effect the the lineage of the element also*/
		.tree li a:hover, .tree li a:hover~ul li a {
			background: #ccc; color: #000; border: 1px solid #94a0b4;
		}
		/*Connector styles on hover*/
		.tree li a:hover~ul li::after, 
		.tree li a:hover~ul li::before, 
		.tree li a:hover~ul::before, 
		.tree li a:hover~ul ul::before
		{
			border-color: #94a0b4;
		}
	</style>
	
	


    <div id="masthead">  
      <div class="container">
        <div class="row">
          <div class="col-md-7">
            <h1><b>Céu na Terra Testbed</b>
              <p class="lead">Manual do usuário</p>
            </h1>
          </div>
        </div> 
      </div><!--/container-->
    </div><!--/masthead-->  
    <div class="container">
      <div class="row row-offcanvas row-offcanvas-left">          
        <!-- sidebar -->
        <div class="col-xs-6 col-sm-3 sidebar-offcanvas" id="sidebar" role="navigation">
          <div data-spy="affix" data-offset-top="45" data-offset-bottom="90">
            <ul class="nav" id="sidebar-nav">
              <li><a href="#introducao">Introdução</a></li>
              <li><a href="#operacao">Operação</a>
                <ul>
              	  <li><a href="#upload">Arquivos</a></li>
	              <li><a href="#confnet">Configurando a rede</a></li>
	              <li><a href="#script">Script de execução</a></li>
	              <li><a href="#planos">Plano de teste</a></li>
	              <li><a href="#agenda">Agendamento</a></li>             
	              <li><a href="#teste">Teste</a></li>             
	              <li><a href="#log">Monitoramento</a></li>             
	            </ul>
			  </li>
            </ul>
           </div>
        </div>
        <!-- main area -->
        <div class="col-xs-12 col-sm-9" data-spy="scroll" data-target="#sidebar-nav">
          <h2 style="padding-top: 50px; margin-top: -50px;" id="introducao">Introdução</h2>
			<p>
				O Testbed Céu na Terra disponibiliza, para acesso remoto, uma ou mais redes de
				sensores sem fio para execução de aplicações de usuários cadastrados.
				Uma Rede de Sensores Sem Fio (RSSF) contém um conjunto de dispositivos 
				compostos por um microcontrolador, um rádio para comunicação de dados e 
				alguns sensores e/ou atuadores.				
			</p>      
			<p>
				O principio de operação básico do Testbed assume que o usuário desenvolva toda
				a aplicação em ambiente local, utilizando as ferramentas de desenvolvimento 
				preferidas, e somente carregue no testbed (<em>upload</em>) os arquivos 
				previamente compilados (<em>arquivos binários/executáveis</em>) para 
				cada tipo de dispositivo (<em>tipo de mote</em>) da rede.     
			</p>      
			<p>
				A tabela a seguir mostra a configuração de cada rede disponível neste Testbed.      
			</p>      
			<table class="table" style="table-layout: auto; width:auto;">
				<tr><th>Rede</th><th >Quant.</th><th>Tipo de mote</th></tr>
				<% for netid,net in pairs(netsinfo) do %>
					<tr><td><%=net.name%></td>
					<td><table>
						<% for nodetype, type in pairs(net.type) do %>
							<tr><td><%=type.qtt%></td></tr>
						<% end %>
					</table></td>
					<td><table>
						<% for nodetype, type in pairs(net.type) do %>
							<tr><td><%=type.short%></td></tr>
						<% end %>
					</table></td>
				<% end %>
			</table>

			<p>
				Para executar um <b>Teste</b> no testbed, o usuário deve seguir um roteiro onde se define a execução
				de um teste em vários itens de configurações.
			</p>

			<div style="float: right; padding-left: 10px;">
			<div style="float: right; padding-top: 10px; padding-left: 10px; padding-right: 10px; border: 1px solid #ccc; border-radius: 5px;">
				<div class="tree"  >
					Hierarquia da Configuração de um Teste
					<ul>
						<li>
							<a href="#" title="Define a execução de um teste."><i class='fa fa-rocket' style='color:DarkBlue'></i> Teste</a>
							<ul>
								<li>
									<a href="#" title="Reserva de uma janela de execução."><i class='fa fa-calendar'  style='color:Green'></i> Agenda</a>
								</li>
								<li>
									<a href="#" title="Define a configuração do teste."><i class='fa fa-cogs'  style='color:SaddleBrown '></i> Plano</a>
									<ul>
										<li>
											<a href="#" title="Define os passos de execução."><i class='fa fa-list'  style='color:Purple '></i> Script</a>
										</li>
										<li>
											<a href="#" title="Configuração dos Nós da Rede x Arquivos Executáveis."><i class='fa fa-star-o'  style='color:GoldenRod '></i> Config.Rede</a>
											<ul>
												<li>
													<a href="#" title="Repositório dos arquivos executáveis."><i class='fa fa-files-o'  style='color:red'></i> Executáveis</a>
												</li>
											</ul>
										</li>
									
									</ul>
								</li>
							</ul>
						</li>
					</ul>
				</div>
			</div> 
			</div> 
			<p>
				A imagem ao lado mostra a hierarquia dos componentes de um teste.
				A principal regra do Testbed é que dois testes não podem ser executados ao mesmo tempo na mesma 
				rede. Essa regra exige que cada rede tenha uma agenda própria onde os usuários devem reservar
				o horário que deseja executar o seu teste.
			</p>      
			<p>
				Então um Teste só será executado se tiver uma <b>Agenda</b> e um <b>Plano</b> de teste associados.
			</p>
			<p>
				Um <b>Plano</b> de teste é composto por uma <b>Configuração de Rede</b> e um <b>Script de Teste</b>.
				No Script de Teste o usuário deve definir a sequência em que os nós da rede devem ser ativados 
				e/ou desativados. Na Configuração de Rede o usuário seleciona quais nós participarão do seu teste
				e qual arquivo executável cada nó utilizará. 
			</p>
			<p>
				A configuração dos <b>Executáveis</b> permite a transferência (upload) dos arquivos binário/executáveis
				da máquina local do usuáro para a área do usuário no Testbed.
			</p>      
			<p>
				Com exceção das Agendas vencidas e dos Testes, qualquer outro item de configuração pode ser 
				reutilizado em novas configurações.
				Qualquer atualização efetuada em um item de configuração será refletida na execução do Teste que 
				tenha o respectivo item na sua hieraquia.
				Um Teste será reiniciado imediatamente se o mesmo estiver em execução no momento da atualização de um item. 
			</p>
			<p>
				Durante a execução de um teste, o sistema permite acesso remoto, via portas TCP/IP, 
				às portas seriais (USB) dos nós. 
				Dessa forma, se o teste do usuário necessitar, é possível se comunicar com cada nó da rede durante 
				a execução do teste.
				Para controlar quem pode acessar essas portas durante um teste, o sistema permite que o usuário 
				identifique o IP da sua máquina cliente (ou uma faixa de IPs) que terá permissão de acesso.
			</p>
			<p>
				Um tutorial de uso com exemplos básicos pode ser encontrado logo no início da página
				<a href="../Site/tutoriais.html" target="_blank">Tutoriais</a> do portal do projeto. 
			</p>


          <hr style="clear: both;">
          <h2  style="padding-top: 50px; margin-top: -50px;" id="operacao">Operação</h2>
	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="upload">Carregando os arquivos binários</h3>
	          	<div >
           		 <div  style="float: right;">
                  	<img src="img/novo_exec.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Localização: Configurações ><a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/arquivo"> Novo Executável</a>
				</p>
				<p>
					Este formulário permite que o usuário faça upload dos arquivos executáveis que deseja 
					usar no testbed. Esses arquivos são armazenados na área do usuário e podem ser utilizados
					em qualquer nó rede do Testbed.
					Clique em "browse" para procurar um arquivo na máquina local e não esqueça de selecionar o 
					tipo correto de mote. Após o upload não é mais possível alterar o tipo de mote de um arquivo.
					A descrição não é obrigatória. 
				</p>
	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="confnet">Configurando a rede de teste</h3>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/netconfig">Nova Configuração de Rede</a> 
				</p>
				<p>
					É nessa tela que o usuário deve configurar os nós que serão utilizados em um teste.
					Para cada nó da rede o usuário deverá indicar o identificador numérico do nó (ID lógico),
					indicar se o nó será selecionado para o teste ("Usar mote?") e também indicar qual executável 
					(arquivo binário) o nó utilizará.
					Para seleção do arquivo executável, pode-se optar por um arquivo default ou selecionar 
					um arquivo específico.
					No caso da seleção de arquivo default, o nó será carregado com o arquivo default configurado 
					para o seu respectivo tipo no formulário da esquerda.
					No topo da lista de nós existem dois chekbox ("<i class="fa fa-arrow-left" style="color:Gray"></i> marcar todos") 
					que servem para marcar ou desmarcar todos os itens da lista, tanto para a seleção dos nós como para arquivo default.
				</p>

	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_config_rede.png" alt="Error: Picture missing." style="width: 125%; height: 125%">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Na lista de nós também é exibido o respectivo tipo de mote e a porta TCP/IP para conexão ao 
					canal de dados (interface USB) do nó. 
				</p>
				<p>
					Essa tela também informa na janela inferior esquerda a organização dos nós na rede, indicando, 
					quando for o caso, se o nó está temporariamente inativo.
 
				</p>
	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="script">Configurando um Script de execução</h3>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/script">Novo Script</a>
				</p>
				<p>
					O Script de execução define a sequência que os nós de uma rede serão ativados e desativados 
					durante o teste do usuário.
					Um script é composto por uma lista de comandos do tipo <em>A</em>, <em>D</em> ou <em>W</em>.
					Os comandos <em>A</em> de ativação e <em>D</em> desativação recebem um parâmetro que pode identificar
					um nó, uma lista de nós ou uma faixa de nós. Esses comandos somentem atuam sobre os nós selecionados
					na Configuração da Rede do respectivo Plano de Teste. Esses dois comandos consideram como 
					identificador de nó o ID Físico do nó na rede.
					O comando <em>W</em> de wait, suspende a execução do script por uma quantidade de segundos passada
					como parâmetro.
					Um script muito comum é composto somente pela comando "A ALL" que ativa, no início do Teste, 
					todos os nós selecionados na respectiva Configuração da Rede.
				</p>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_script.png" alt="Error: Picture missing." style="width: 125%; height: 125%">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Um script sempre é iniciado a partir da sua primeira linha de comando. Quando um Teste é interrompido 
					e reiniciado, o script também vai reiniciar da sua primeira linha.  
					Um script é interrompido automaticamente ao final da agenda do respectivo Teste, independente da duração
					do script. Por exemplo, considerando que o usuário configurou um script para executar durante 30 minutos 
					em uma agenda de 30 minutos. Se o usuário reinciar o teste aos 15 minutos de execução, o script será 
					re-executado somente até a metade do tempo original.    
				</p>
	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="planos">Configurando um plano de teste</h3>
	          	<div >
           		 <div  style="float: right;">
                  	<img src="img/novo_plano.png" alt="Error: Picture missing." >
            	 </div>
          		</div>
          		<br></br>
				<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/teste">Novo Plano</a>
				</p>
				<p>
					Este formulário permite que o usuário crie um Plano associando uma Configuração de Rede com 
					um Script de Execução.
				</p>

	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="agenda">Agendando um horário para o teste</h3>
          		<p>
					Localização: <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/agenda">Agenda</a>
				</p>
				<p>
					A tela de Agendamento permite que o usuário reserve uma janela de tempo para execução do seu teste.
					Cada Rede de Teste tem a sua própria agenda para evitar que mais de um usuário tente executar 
					seus testes ao mesmo tempo.
					Uma janela de execução tem duração mínima de 30 minutos e sempre tem seu valor multiplo de 30 minutos.
					O primeiro click na agenda seleciona o slot inicial e os clicks subsequentes redefine o slot final.
					O botão "Limpar slots" permite uma nova seleção para o slot inicial.
					O formulário "Buscar novo período" permite alterar a faixa de datas da agenda.
				</p>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/agenda.png" alt="Error: Picture missing."style="width: 125%; height: 125%">
            	 </div>
          		</div>

	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="teste">Definindo a execução do teste</h3>
	          	<div >
           		 <div  style="float: right;">
                  	<img src="img/novo_teste.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/teste">Novo Teste</a>
				</p>
				<p>
					A configuração de um Teste é a etapa final para confirmar a execução do mesmo.
					Nessa tela o usuário associa um Plano de Teste à uma Agenda.
					O Sistema de Controle do Testbed vai iniciar a execução do Teste na hora agendada.
					Se a agenda for corrente, o Sistema de Controle inicia a execução imediatamente. 
				</p>
				<p>
					É neste formulário que o usuário deve confirmar o endereço IP da sua máquina cliente ou definir
					uma máscara IP para filtrar o acesso.
					Para evitar dúvidas qual é o IP da máquina cliente, principalmente nas redes que utilizam 
					servidores NAT, este formulário exibe qual é o IP real da máquina cliente.
					A configuração do endereço IP também permite o uso de uma máscara 255 para facilitar o acesso de 
					faixas de IPs de sub-redes. 
					Por exemplo, a configuração hipotética 129.130.10.255 permite o acesso de todos computadores da
					rede 129.130.10.xxx.
					A configuração 255.255.255.255 libera o acesso de qualquer computador ao teste do usuário.
				</p>


	          <h3  style="clear: both; padding-top: 50px; margin-top: -50px;" id="log">Monitoramento</h3>
	          	<p>
					Localização: <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/test_monitor">Monitoramento</a>
				</p>
				<p>
					A tela de monitoramento permite que o usuário acompanhe a execução do seu teste com os 
					seguintes tipos de logs:
				</p>
				<ul>
					<li>Execução dos comandos do Script de Teste, indicando o momento de cada comando 
					e o tempo de carga do código executável em cada nó.
					<li>Mensagens de dados, no formato hexadecimal, trocadas entre os nós da rede e o computador 
					cliente do usuário.
					<li>Mensagens das conexões/desconexões TCP/IP, incluindo as tentativas com IP inválido.
				</ul>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/monitoracao.png" alt="Error: Picture missing." style="width: 125%; height: 125%">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Os dados da tela são atualizados automaticamente a cada segundo e só são exibidos para 
					o teste do usuário que estiver em execução.
				</p>
          <hr>
        </div><!-- /.col-xs-12 main -->
      </div><!--/.row-->
 	</div><!--/.container-->