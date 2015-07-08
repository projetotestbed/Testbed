    <div id="masthead">  
      <div class="container">
        <div class="row">
          <div class="col-md-7">
            <h1><b>Céu na Terra Testbed</b>
              <p class="lead">Manual do administrador</p>
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
              <li><a href="#admin">Administração</a>
                <ul >
              	  <li><a href="#configuser">Config.Usuário</a></li>
	              <li><a href="#manutrede">Atualizar rede</a></li>
	              <li><a href="#versao">Criar versão de rede</a></li>
	              <li><a href="#rede">Criar nova rede</a></li>
	              <li><a href="#tipos">Atualizar tipos de motes</a></li> 
		      <li><a href="#confno">Configurar o nó</a></li>            
	            </ul>
			  </li>
              <li><a href="#consultas">Consultas</a>
                <ul >
              	  <li><a href="#xxxx">xxxxx</a></li>
              	  <li><a href="#yyyy">yyyyy</a></li>
	            </ul>
			  </li>
            </ul>
           </div>
        </div>
        <!-- main area -->
        <div class="col-xs-12 col-sm-9" data-spy="scroll" data-target="#sidebar-nav">
          <h2 id="introducao">Introdução</h2>
			<p>
				O Testbed Céu na Terra disponibiliza, para acesso remoto, uma ou mais redes de sensores sem fio para execução 					de aplicações de usuários cadastrados. Uma Rede de Sensores Sem Fio (RSSF) contém um conjunto de dispositivos 					compostos por um microcontrolador, um rádio para comunicação de dados e alguns sensores e/ou atuadores.
			</p>
			<p>
				O principio de operação básico do Testbed assume que o usuário desenvolva toda a aplicação em ambiente local, 					utilizando as ferramentas de desenvolvimento preferidas, e somente carregue no testbed (upload) os arquivos 					previamente compilados (arquivos binários/executáveis) para cada tipo de dispositivo (tipo de mote) da rede.
			</p>
			<p>
				O usuário Admin fica responsável pelo gerenciamento do Testbed. Suas funções são desde o gerenciamento de 					usuários até o gerenciamento da Rede(configuração da topologia da rede).
			</p>
			<p>
				A tabela a seguir mostra a configuração de cada rede disponível neste Testbed. 
			</p>
			<table class="table" style="table-layout: auto; width:auto">
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
			
          <hr>
          <h2 id="admin">Administração</h2>
	          
	          <h3 id="configuser">Configurando usuários</h3>
				</br>				
				<p>
					Localização: <a href="http://ceunaterra.voip.ufrj.br/TBportal/?r=main/useradmin"> Administração</a>
				</p>
				<h4  style="padding-top: 50px; margin-top: -50px;"><u>Criando um novo usuário</u></h4>
	          	 	<div  style="float: right;" >
                  			<img src="img/criar_usuario.png" width="80%" alt="Error: Picture missing.">
            	 		</div>
          			
				
				<p>
					Este formulário permite que a criação de um usuário. Preencha os campos conforme os dados abaixo:
					<ul>
						<li><b>Email: </b> e-mail do usuário.</li>
						<li><b>Nome: </b>nome do usuário.</li>
						<li><b>Senha e Confirmar senha: </b>Senha do novo usuário, se preferir utilize o
										   botão “Gerar Senha” para criar uma senha aleatória.</li>
						<li><b>Marque o campo “Enviar e­mail?”</b> caso queira notificar o novo usuário do
											  login/senha.</li>
						<ul><li type="square"><b>*Obs.</b>Obrigatório caso tenha escolhido <i>Gerar Senha.</i>.
							                          </li></ul>
						<li> Defina o(s) <b>Perfil(s) do usuário:</b></li>
							<ul>
								<li><b>Obs.:</b> Os perfis ainda não foram todos implementados, por enquanto 										defina o usuário como:</li>
									<ul>
										<li><b>Básico: </b> usuários que apenas realizarão testes no ambiente.</li>
							    			<li><b>Administrador: </b>usuários que terão acesso a parte de
											gerenciamento de rede e de usuários.
										</li>
									</ul>
							</ul>
					</ul> 
				</p>
				</br>				
				<h4  style="padding-top: 50px; margin-top: -50px;" id="operacao"><u>Alterando o perfil de um usuário</u></h4>
				<div  style="float: right;" >
                  			<img src="img/alterar_usuario.png" width="80%" alt="Error: Picture missing.">
            	 		</div>	          	 	
				<p>
					Este formulário permite alterar o tipo de perfil do usuário. Siga os seguintes passos:
					<ul>
						<li>1. Digite o <b>e-mail</b> do usuário.</li>
						<li>2. Clique em <b>Validar</b>.</li>
						<li>3. Altere o perfil do usuário em <i>Perfil(s)</i>.</li>
						<li>Obs. Caso apareça <i>Inválido</i> no campo <b>User</b> significa:</li>
						<ul>
							<li type="square">E­mail digitado errado ou; </li>
							<li type="square">Não existe cadastro desse usuário no testbed.</li>
						</ul>					
					</ul>
				</p>
				</br>

	          <h3 style="clear: both; padding-top: 50px; margin-top: -50px;" id="manutrede">Atualizar dados da rede</h3>
				</br>				
				<p>
					Localização: Manutenção de Rede > <a href="http://ceunaterra.voip.ufrj.br/TBportal/?r=main/update_net"> Atualizar dados Rede</a>
				</p>
				<div  style="float: right;" >
                  			<img src="img/atualizar_rede_2.png" width="80%" alt="Error: Picture missing.">
            	 		</div>				
				<p>
					Para alterar os dados de uma rede que já existe execute os seguintes passos:
					<ul>
						<li>Atualize as informações no quadro dos nós.</li>
					       <li>Preencha o formulário <b>Atualizar Configuração da Rede</b> e clique em <i>Atualizar</i></li>
					</ul>
				</p>
				<div  style="float: right;" >
                  			<img src="img/atualizar_rede_1.png" width="80%" alt="Error: Picture missing.">
            	 		</div>

	          <h3 style="clear: both; padding-top: 50px; margin-top: -50px;" id="versao">Criar nova versão de rede</h3>
				</br>				
				<p>
					Localização: Manutenção de Rede > 
					<a href="http://ceunaterra.voip.ufrj.br/TBportal/?r=main/new_version">Criar nova Versão</a>
				</p>				
				<p>
					Siga os passos abaixo para adicionar ou remover um nó de uma rede existente: 
				</p>
				
				<h4  style="padding-top: 50px; margin-top: -50px;"><u>Excluir um nó</u></h4>
				<p>	
					<ul>			
						<li><b>Para excluir um nó: </b>clique no ícone da lixeira do nó que deseja excluir.</li>
					</ul>				
				</p>          	 		
				<div  style="float: right;" >
          				<img src="img/delete_nova_versao.png" width="80%" alt="Error: Picture missing.">
    	 			</div>
				
				<h4><u>Adicionar um nó</u></h4>
				<li><b>Para adicionar um nó: </b>Clique no sinal de <i>+</i> e preencha os campos.</li>
					<ul><li><b>Obs. :</b>Veja o tópico <i>Configurar o nó</i> para mais informações</li></ul>
          	 		<div  style="float: right;" >
          				<img src="img/adicionar_nova_versao.png" width="80%" alt="Error: Picture missing.">
    	 			</div>
				</br>
				
				<h4><u>Salvando as alterações</u></h4>
					<div  style="float: right;" >
                  				<img src="img/salvando_nova_versao.png" width="80%" alt="Error: Picture missing.">
            	 			</div>					
					<p>
						Após Adicionar/Excluir um nó preencha os campos do formulário <i>Nova Versão de Rede</i> e 							clique em <i>Atualizar</i>.
					</p>
					
				
          	<h3 style="clear: both; padding-top: 50px; margin-top: -30px;" id="rede">Criar nova rede</h3>
				</br>				
				<p>
					Localização: Manutenção de Rede > 
					<a href="http://ceunaterra.voip.ufrj.br/TBportal/?r=main/new_net">Criar nova Rede</a>
				</p>
				<div  style="float: right;" >
                  			<img src="img/criar_nova_rede.png" width="80%" alt="Error: Picture missing.">
            	 		</div>
				<p>
					Siga os passos abaixos para criar uma nova rede de nós
					<ul>
						<li>Preencha os campos em <b>Criação de uma nova Rede</b></li>
						<li>Adicione os nós desejados clicando no sinal de <i>+</i></li>
						     <ul><li><b>Obs. :</b>Veja o tópico <i>Configurar o nó</i> para mais informações</li></ul>
						<li>Clique em <i>Salvar</i> em <b>Criação de uma nova Rede</b> para criar a nova Rede</li>
					</ul>
				</p>
				<div  style="float: right;" >
                  			<img src="img/adicionar_nova_rede.png" width="80%" alt="Error: Picture missing.">
            	 		</div>
	          <h3 style="clear: both; padding-top: 50px; margin-top: -50px;" id="tipos">Atualizar tipos de motes</h3>
				</br>				
				<p>
					Localização: Manutenção de Rede > 
					<a href="http://ceunaterra.voip.ufrj.br/TBportal/?r=main/update_nodestype">Atualizar tipos de motes</a>
				</p>
				
				
				<p>
					<ul><li>Preencha os campos em <b>Criar novo Tipo de Motes</b> para adicionar um novo tipo de nó ou 
					atualize/delete um tipo de nó existente em <b>Atualizar Tipos de Motes</b>.</li></ul>
				</p>
				<div  style="float: right;" >
                  			<img src="img/atualizar_node.png" width="80%" alt="Error: Picture missing.">
            	 		</div>
		<h3 style="clear: both; padding-top: 50px; margin-top: -50px;" id="confno">Configurar o nó</h3>
				<p>Para configurar um nó preencha os campos da seguinte forma:
					<ul>
						<li><b>Tipo de mote: </b>Escolha o tipo do nó que deseja adicionar: </li>
							<ul>
								<li><b>micaz100:</b> MICAz+MIB600+MDA100.</li>
								<li><b>telosb:</b></li>
									<ul>
										<li>TelosB+Silex.</li>
										<li>TelosB+Raspberry Pi(Rpi).</li>
									</ul>
								<li><b>Arduino Mega:</b> Raspberry Pi+Arduino Mega+Sensor MTH11+Sensor 													LDR.</li>
							</ul>
						<li><b>Status: </b>Condição do nó</li>
							<ul>
								<li><b>ACTIVE: </b>Nó configurado e online. </li>
								<li><b>OFF: </b>Nó configurado e offline.</li>
								<li><b>OUT: </b>Nó removido.</li>
							</ul>
						<li><b>Descrição Local: </b>Breve descrição do local do nó.</li>
						<li><b>posX/posY/posZ: </b>posições <i>x</i>,<i>y</i>,<i>z</i> do nó em relação a apresentação da tela. Os limites são 400x250 e cado nó ocupa um espaço de 20x15.</li>
						<li><b>Canal de Controle</b> e <b>Canal de Dados: </b>Canal de entrada de dados e Canal de 								saída de dados, respectivamente.</li>
							<ul>
								<li>Para o <b>MICAz</b> configure como: 
								<ul>
								<li><b>Canal de Controle: 
											</b>"-dprog=stk500 -dhost=IP"</li></li>
								<li><b>Canal de Dados: </b>"X IP 10002"</li>
								<li><b>Obs.: </b>
									<ul>
									<li>
										X é a porta TCP do nó, com formato 1000x, crescente e único 											entre todas as redes.
									</li>
									<li>
										IP= IP da MIB600.
									</li>									
									</ul>									
								</li>
								</ul>									

								<li>Para o <b>TelosB+silex</b> configure como:</li>
								<ul>
									<li><b>Canal de Controle: </b>"IP porta_do_telosb"</li>
									<li><b>Canal de Dados: </b>"X IP porta"</li>
									<li><b>Obs.: </b>
									<ul>
									<li>
										IP= IP da Silex.
									</li>
									<li>
										X é a porta TCP do nó, com formato 1000x, crescente e único 											entre todas as redes.
									</li>
									<li>
										porta_do_telosb é a porta configurada no arquivo tb_mote(no 											Windos: ~/TBControl/files)
									</li>
									<li>
										porta é a porta_do_telosb+1.
									</li>
									</ul>									
								</li>
									
								</ul>	
								<li>Para o <b>TelosB+Rpi</b> configure como:</li>
								<ul>
									<li><b>Canal de Controle: </b>"IP 10001"</li>
									<li><b>Canal de Dados: </b>"X IP 10002"</li>
									<li><b>Obs.: </b>
									<ul>
									<li>
										X é a porta TCP do nó, com formato 1000x, crescente e único 											entre todas as redes.
									</li>
									<li>
										IP: IP do Raspberry Pi.
									</li>									
									</ul>									
								</li>
								</ul>
								<li>Para o <b>Arduino+Rpi</b> configure como:</li>
								<ul>
									<li><b>Canal de Controle: </b>"IP 10001"</li>
									<li><b>Canal de Dados: </b>"X IP 10002"</li>
									<li><b>Obs.: </b>
									<ul>
									<li>
										X é a porta TCP do nó, com formato 1000x, crescente e único 											entre todas as redes.
									</li>
									<li>
										IP: IP do Raspberry Pi.
									</li>									
									</ul>									
								</li>
								</ul>
							</ul>
					</ul>
				</p>
          <hr>
          <h2 style="clear: both; padding-top: 50px; margin-top: -50px;" id="consultas">Consultas</h2>
	          <h3 id="xxxx">xxxxx</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="yyyy">yyyyy</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
          <hr>
        </div><!-- /.col-xs-12 main -->
      </div><!--/.row-->
 	</div><!--/.container-->
