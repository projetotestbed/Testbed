	<style type="text/css" media="screen">
		* {margin: 0; padding: 0; }

		.tree ul {
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

<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>
<div class="row" style="float: left; padding-top: 10px;">
	<div class="col" style="float: left; padding-top: 10px; padding-left: 20px;">
		<img src="./layouts/default/CeuNaTerra_logo.png" alt="Ceu na Terra Logo" style="width:110px;height:120px">
	</div>
	<div class="col" style="float: left; padding-left: 40px; padding-right: 40px;">
		<form method="post" >
			<div class="panel panel-default">
				<div class="panel-heading">
	    			<h4>Autenticação</h4>
  				</div>
				<div class="panel-body">
						<p></p>
					    <b>Usuario:</b>
					    <br>
					    <input type="text" name="ulogin" >
					    <br/>
					    <b>Senha:</b>
					    <br><input type="password" name="password"></br>
					    <p></p>
				</div>
				<div class="panel-footer">
					<div align='right'>
					    <input class="btn btn-default" type="submit" name="btnLogin" value="Entrar"/>
					</div>
					<div >
					</div>
				</div>
			</div>
		</form>
	</div>
	<div class="col" style="float: left; padding-top: 10px; padding-left: 10px; border: 1px solid #ccc; border-radius: 5px;">

	<div class="tree" style="padding-right: 10px;" >
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