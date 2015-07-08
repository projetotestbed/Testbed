<div class="container">
	<div class="navbar navbar-default navbar-fixed-top" role="navigation" >
		<div class="navbar-header">
	        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
	            <span class="sr-only">Toggle navigation</span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	        </button>
	    </div>
    		<div class="navbar-collapse collapse">
			<% if  (session and session.uid)  then %>
				<ul class="nav navbar-nav">
					<li><img class="visible-md visible-lg" src="./layouts/default/CeuNaTerra_logo2.png" alt="Ceu na Terra Logo" style="padding-left: 5px;width:50px;height:50px"></li>
					<% if (session.role ~= 'administrador') then %>
						<li><a href="?r=main/">Visão Geral</a></li>
						<li class="visible-lg <%= ((#session.roles == 1) and 'visible-md') or ''%>"><a href="?r=main/agenda">Agenda</a></li>
						<li class="dropdown visible-md visible-lg"><a href="#" data-toggle="dropdown" class="dropdown-toggle">Configurações <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="?r=main/teste">Novo Teste</a></li>
								<li><a href="?r=main/plano">Novo Plano</a></li>
								<li><a href="?r=main/script">Novo Script</a></li>
								<li><a href="?r=main/netconfig">Nova Configuração de rede</a></li>
								<li><a href="?r=main/arquivo">Novo Executável</a></li>
							</ul>
						</li>
						<li><a href="?r=main/test_monitor">Monitoramento</a></li>
						
						<li class="dropdown" >
							<a href="#" data-toggle="dropdown" class="dropdown-toggle">
								<span class="<%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>">Outros <b class="caret"></span></b>
								<span class="<%= ((#session.roles > 1) and 'visible-lg') or ''%>">Consultas <b class="caret"></span></b>
							</a>
							<ul class="dropdown-menu">
								<li role="presentation" class="dropdown-header <%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>">Consultas</li>
								<li><a href="?r=main/cons_hierq_dep">Hierarquia/Dependência</a></li>
								<li><a href="?r=main/sys_monitor">System Monitor</a></li>
								<li role="presentation" class="divider <%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>"></li>
								<li role="presentation" class="dropdown-header <%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>">Ajuda</li>
								<li class="<%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>"><a href="?r=main/usermanual">Manual de Utilização</a></li>
								<li class="<%= ((#session.roles > 1) and 'hidden-lg') or 'hidden'%>"><a href="/Site">Projeto GT-TeI</a></li>
								</li>
							</ul>
						</li>
						
						<li class="dropdown <%= ((#session.roles > 1) and 'visible-lg') or ''%>"><a href="#" data-toggle="dropdown" class="dropdown-toggle">Ajuda <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="?r=main/usermanual">Manual de Utilização</a></li>
								<li><a href="/Site">Projeto GT-TeI</a></li>
							</ul>
						</li>
					<% else %>
						<li><a href="?r=main/useradmin">Administração</a>
						</li>
						<li class="dropdown">
							<a href="#" data-toggle="dropdown" class="dropdown-toggle">
								<span class="hidden-lg  hidden-md">Outros <b class="caret"></span></b>
								<span class="visible-lg  visible-md">Manutenção de Rede <b class="caret"></span></b>
							</a>
							<ul class="dropdown-menu">
								<li role="presentation" class="dropdown-header hidden-lg hidden-md">Manutenção de Rede</li>
								<li><a href="?r=main/update_net">Atualizar dados Rede</a></li>
								<li><a href="?r=main/new_version">Criar nova Versão</a></li>
								<li><a href="?r=main/new_net">Criar nova Rede</a></li>
								<li><a href="?r=main/update_nodestype">Atualizar tipos de motes</a></li>
								<li role="presentation" class="divider hidden-lg hidden-md"></li>
								<li role="presentation" class="dropdown-header hidden-lg hidden-md">Consultas</li>
								<li class="hidden-lg hidden-md"><a href="?r=main/sys_monitor">System Monitor</a></li>
								<li role="presentation" class="divider hidden-lg hidden-md"></li>
								<li role="presentation" class="dropdown-header hidden-lg hidden-md">Ajuda</li>
								<li class="hidden-lg hidden-md"><a href="?r=main/admmanual">Manual de Administração</a></li>
								<li class="hidden-lg hidden-md"><a href="/Site">Projeto GT-TeI</a></li>
							</ul>
						</li>
						<li class="dropdown <%= ((#session.roles > 1) and 'visible-md visible-lg') or 'visible-md visible-lg'%>" >
							<a href="#" data-toggle="dropdown" class="dropdown-toggle">
								<span class="hidden-lg">Outros <b class="caret"></span></b>
								<span class="visible-lg">Consultas <b class="caret"></span></b>
							</a>
							<ul class="dropdown-menu">
								<li role="presentation" class="dropdown-header hidden-lg">Consultas</li>
								<li><a href="?r=main/sys_monitor">System Monitor</a></li>
								<li role="presentation" class="divider hidden-lg"></li>
								<li role="presentation" class="dropdown-header hidden-lg">Ajuda</li>
								<li class="hidden-lg"><a href="?r=main/admmanual">Manual de Administração</a></li>
								<li class="hidden-lg"><a href="/Site">Projeto GT-TeI</a></li>
							</ul>
						</li>
						<li class="dropdown <%= ((#session.roles > 1) and 'visible-lg') or 'visible-lg'%>"><a href="#" data-toggle="dropdown" class="dropdown-toggle">Ajuda <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<li><a href="?r=main/admmanual">Manual de Administração</a></li>
								<li><a href="/Site">Projeto GT-TeI</a></li>
							</ul>
						</li>
					<% end %>
				</ul>
				<ul class="nav navbar-nav navbar-right">
				
					<% if #session.roles > 1 then %>
					<li class="navbar-text visible-sm visible-md visible-lg">Perfil: <%= session.role %></li>
					<% end %>
				
					<li class="dropdown"><a href="#" data-toggle="dropdown" class="dropdown-toggle"><i class="fa fa-user"></i> <%=  session.username %> <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<li><a href="?r=main/userconfig"><i class="fa fa-cog fa-fw"></i>Configurações</a></li>
							<li role="presentation" class="divider"></li>
							<li><a href="?r=main/logout"><i class="fa fa-sign-out fa-fw"></i>Sair</a></li>
						</ul>
					</li>
					
					<li class="dropdown"><a href="#" data-toggle="dropdown" class="dropdown-toggle"><i class="fa fa-star-o"></i> Rede <%=  session.netid ..'.'..session.netversion .. ': '.. session.netname %> <b class="caret"></b>&nbsp&nbsp</a>
						<ul class="dropdown-menu">
							<% for k,v in pairs(session.networks) do %>
								<li><a href="?r=main/newnetid&netid=<%=v.netid%>"><%= v.netid ..'-'.. v.name%> </a></li>
							<%end%>            
						</ul>
					</li>
				</ul>
			<% else %>
				<h4>&nbsp Portal Testbed - Autenticação de usuário cadastrado</h4>
			<% end %>
		</div>
	</div>
</div>
<!-- *************************************************** -->
<!-- ********  Imlementação do 'alert' customizado ***** -->
<!-- *************************************************** -->
<style>
#blanket {
	background-color:#111;
	opacity: 0.65;
	*background:none;
	position:absolute;
	z-index: 9001;
	top:0px;
	left:0px;
	width:100%;
}

#alert {
	position:absolute;
	max-width:600px;
	min-width:300px;
	min-height:100px;
	z-index: 9002;
}
#confirm {
	position:absolute;
	max-width:500px;
	min-width:300px;
	min-height:100px;
	z-index: 9002;
}
</style>
<script>
function toggle(div_id) {
	var el = document.getElementById(div_id);
	if ( el.style.display == 'none' ) {	el.style.display = 'block';}
	else {el.style.display = 'none';}
}
function blanket_size(popUpDivVar) {
	if (typeof window.innerWidth != 'undefined') {
		viewportheight = window.innerHeight;
	} else {
		viewportheight = document.documentElement.clientHeight;
	}
	if ((viewportheight > document.body.parentNode.scrollHeight) && (viewportheight > document.body.parentNode.clientHeight)) {
		blanket_height = viewportheight;
	} else {
		if (document.body.parentNode.clientHeight > document.body.parentNode.scrollHeight) {
			blanket_height = document.body.parentNode.clientHeight;
		} else {
			blanket_height = document.body.parentNode.scrollHeight;
		}
	}
	var blanket = document.getElementById('blanket');
	blanket.style.height = blanket_height + 'px';
	var popUpDiv = document.getElementById(popUpDivVar);
	popUpDiv_height=blanket_height/2-150;//150 is half popup's height
	popUpDiv.style.top = popUpDiv_height + 'px';
}
function window_pos(popUpDivVar) {
	if (typeof window.innerWidth != 'undefined') {
		viewportwidth = window.innerHeight;
	} else {
		viewportwidth = document.documentElement.clientHeight;
	}
	if ((viewportwidth > document.body.parentNode.scrollWidth) && (viewportwidth > document.body.parentNode.clientWidth)) {
		window_width = viewportwidth;
	} else {
		if (document.body.parentNode.clientWidth > document.body.parentNode.scrollWidth) {
			window_width = document.body.parentNode.clientWidth;
		} else {
			window_width = document.body.parentNode.scrollWidth;
		}
	}
	var popUpDiv = document.getElementById(popUpDivVar);
	window_width=window_width/2-150;//150 is half popup's width
	popUpDiv.style.left = window_width + 'px';
}

function popup(windowname,title,text,href) {
	document.getElementById(windowname+"Title").innerHTML = title;
	document.getElementById(windowname+"Text").innerHTML = text;
	if (href) {
		document.getElementById(windowname+"Href").href = href;
	}
	blanket_size(windowname);
	window_pos(windowname);
	toggle('blanket');
	toggle(windowname);		
}
</script>
<div id="blanket" style="display:none;"></div>
<div class="panel panel-default" id="alert" style="display:none;">
	<div class="panel-heading">
		<h4 id="alertTitle"></h4>
	</div>
	<div class="panel-body" id="alertText">
	</div>
	<div class="panel-footer">
		<div align='right'>
			<input type="button" class="btn btn-default" value="Fechar" onclick="popup('alert')">
		</div>
		<div class="col" >
		</div>
	</div>
</div>
<div class="panel panel-default" id="confirm" style="display:none;">
	<div class="panel-heading">
		<h4 id="confirmTitle"></h4>
	</div>
	<div class="panel-body" id="confirmText">
	</div>
	<div class="panel-footer">
		<div class="col" style="float: right;">
			<a href="#" id="confirmHref" class="btn btn-default" onclick="popup('confirm');">&nbsp OK &nbsp</a>
		</div>
		<div class="col">
			<a href="#" class="btn btn-default" onclick="popup('confirm'); ">Cancelar</a>
		</div>
	</div>
</div>