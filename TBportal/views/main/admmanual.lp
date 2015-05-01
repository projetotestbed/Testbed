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
              	  <li><a href="#navega">Menu geral</a></li>
              	  <li><a href="#configuser">Config.Usuário</a></li>
	              <li><a href="#manutrede">Atualizar rede</a></li>
	              <li><a href="#versao">Criar versão de rede</a></li>
	              <li><a href="#rede">Criar nova rede</a></li>
	              <li><a href="#tipos">Atualizar tipos de motes</a></li>             
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
          <h2 id="admin">Administração</h2>
	          <h3 id="navega">Navegação no menu geral</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="configuser">Configurando usuários</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="manutrede">Atualizar parâmetros da rede</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="versao">Criar nova versão de rede</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="rede">Criar nova rede</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
	          <h3 id="tipos">Atualizar tipos de motes</h3>
				<p>
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
					Akhds  asljkd ljad lkjadslkj asdljkasdd al. Akhds  asljkd ljad lkjadslkj asdljkasdd al. 
				</p>
          <hr>
          <h2 id="consultas">Consultas</h2>
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