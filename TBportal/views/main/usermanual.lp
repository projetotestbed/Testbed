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
              	  <li><a href="#navega">Menu geral</a></li>
              	  <li><a href="#upload">Arquivos</a></li>
	              <li><a href="#confnet">Configurando a rede</a></li>
	              <li><a href="#script">Passos de execução</a></li>
	              <li><a href="#planos">Plano de teste</a></li>
	              <li><a href="#agenda">Agendamento</a></li>             
	              <li><a href="#teste">Teste</a></li>             
	              <li><a href="#log">Monitoramento</a></li>             
	            </ul>
			  </li>
              <li><a href="#consultas">Consultas</a>
                <ul >
              	  <li><a href="#hierarquia">Hierarquia</a></li>
              	  <li><a href="#dependencias">Dependências</a></li>
	            </ul>
			  </li>
              <li><a href="#personalizacao">Personalização</a>
                <ul >
              	  <li><a href="#senha">Alterar Senha</a></li>
              	  <li><a href="#attrdefaults">Configuração padrão</a></li>
              	  <li><a href="#perfil">Alterar perfil</a></li>
	            </ul>
			  </li>
            </ul>
           </div>
        </div>
        <!-- main area -->
        <div class="col-xs-12 col-sm-9" data-spy="scroll" data-target="#sidebar-nav">
          <h2 id="introducao">Introdução</h2>
			<p>
				Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
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
          <h2 id="operacao">Operação</h2>
	          <h3 id="navega">Navegação no menu geral</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>

	          <h3 id="upload">Carregando seus arquivos binários</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_exec.png" alt="Error: Picture missing." style="width: 40%; height: 50%">
            	 </div>
          		</div>
          		<br></br>
				<p>
					Localização: Configurações ><a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/arquivo"> Novo Executável</a>
				</p>
				<p>
					Esse formulário permite que você faça upload dos arquivos executáveis que você deseja usar no testbed para a nossa base da dados. Clique em "browse" para procurar o arquivo e não esqueça de checar o tipo do nó!
					A descrição não é obrigatória, mas pode ajudar a distinguir arquivos de nomes iguais. 
				</p>
	          <h3 id="confnet">Configurando a rede de teste</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_config_rede.png" alt="Error: Picture missing." style="width: 125%; height: 125%">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/netconfig">Nova Configuração de Rede</a> 
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="script">Configurando um roteiro de execução</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_script.png" alt="Error: Picture missing." style="width: 115%; height: 115%">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/script">Novo Script</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="planos">Configurando um plano de teste</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_plano.png" alt="Error: Picture missing." style="width: 50%; height: 50%">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/teste">Novo Plano</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="agenda">Agendando um horário para o teste</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/agenda.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/agenda">Agenda</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="teste">Definindo a execução do teste</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/novo_teste.png" alt="Error: Picture missing." style="width: 50%; height: 50%">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Configurações > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/teste">Novo Teste</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="log">Monitoramento</h3>
	          	<p>
					Localização: <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/test_monitor">Monitoramento</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
          <hr>
          <h2 id="consultas">Consultas</h2>
	          <h3 id="hierarquia">Hierarquia</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/hierarquia.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Consultas > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/cons_hierq_dep">Hierarquia/Dependência</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="dependencias">Dependências</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/dependencia.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Consultas > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/cons_hierq_dep">Hierarquia/Dependência</a>
				</p>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
          <hr>
          <h2 id="personalizacao">Personalização</h2>
	          <h3 id="senha">Alterar Senha</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/alterar_senha.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Username > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/userconfig">Configurações</a>
				</p>
				<p>
					Formulário para alteração de senha. 
				</p>
	          <h3 id="attrdefaults">Configuração padrão</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/config_default.png" alt="Error: Picture missing." style="width: 35%; height: 35%">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Username > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/userconfig">Configurações</a>
				</p>
				<p>
					Esse formulário permite "personalizar" a tela inicial da sua sessão(visão geral). Qual perfil você quer que seja o default e como a sua visão geral deve ser.
					Todos esses parâmetros podem ser alterados durante a sessão, mas essa configuração indica a default.
				</p>
	          <h3 id="perfil">Alterar perfil da sessão atual</h3>
	          	<div class="row">
           		 <div class="col-md-10" align="center">
                  	<img src="img/alterar_perfil.png" alt="Error: Picture missing.">
            	 </div>
          		</div>
          		<br></br>
          		<p>
					Localização: Username > <a href="http://testbed.inf.puc-rio.br/TBportal/?r=main/userconfig">Configurações</a>
				</p>
				<p>
					Esse formulário permite com que você mude o seu perfil ATUAL da sessão. Essa mudança não será persistente para outra sessão.
					(Apenas disponível para usuários com mais de um perfil cadastrado)
				</p>
          <hr>
        </div><!-- /.col-xs-12 main -->
      </div><!--/.row-->
 	</div><!--/.container-->