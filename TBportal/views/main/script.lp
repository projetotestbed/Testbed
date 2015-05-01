<% if script.alert then %>
	<script> popup('alert','Aviso',"<%= script.alert %>");</script> 
<% end %>

<div class="col" style="padding-top: 10px;">
	<form method="post">
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
		    	<h4><%= (script and script.name and 'Atualizar Script') or 'Novo Script' %></h4>
				<%= (script and script.name and '(obs.: As alterações sobre-escrevem o script original.)') or '' %>
		  	</div>
			<div class="panel-body">
			<table>
				<tr><td>Nome: (max 20 caracteres)</td></tr>
				<tr><td style="padding-left: 20px;"><input type="text" name="scriptname"  placeholder="Nome do script." required="true" maxlength="20" size="20" value="<%= (script and script.name) or '' %>"></td></tr>
				<tr><td>Descrição:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description" placeholder="Descrição do script." size="40" value="<%= (script and script.description) or '' %>"></td></tr>
				<tr><td>Comandos do script:</td></tr>
				<tr><td><textarea name="scriptsteps"  placeholder="Comandos do script." required="true" rows="10" cols="40"><%= (script and script.text) or '' %></textarea></td></tr>
			</table>
			</div>
			<div class="panel-footer">
				<div align='right'>
		    		<input type="hidden" name="scriptid" value="<%= (script and script.scriptid) or '0' %>" />
				    <input type="hidden" name="action" value="<%= (script and script.name and 'update') or 'save' %>" />
					<input type="submit" class="btn btn-default" value="<%= (script and script.name and 'Atualizar') or 'Salvar' %>"/>
				</div>
				<div class="col" >
				</div>
			</div>
		</div>
	</form>
	<div class="col" style="float: left; width:20px;" >
		&nbsp
	</div>
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading">
	    	<h4>Descrição da sintaxe:</h4>
	  	</div>
		<div class="panel-body">

			<p style="text-align:top;">
				• Ativar nó: <br>
				– Comando: A ALL| &lt; id &gt; | &lt; idList &gt; | &lt; idRange &gt; <br><br>
				• Desativar nó:<br>
				– Comando: D ALL| &lt; id &gt; | &lt; idList &gt; | &lt; idRange &gt;<br><br>
				• Esperar execução:<br>
				– Comando: W &lt; time &gt;<br><br>
				• Definição dos parâmetros:<br>
				ALL: Constante que define todos os nós selecionados na configuração.<br>
				&lt; id &gt;: número inteiro.<br>
				&lt; idList &gt;: Sequência de &lt; id &gt; separados por vírgula.<br>
				&lt; idRange &gt;: &lt; idA &gt; .. &lt; idB &gt;, onde seleciona todos os ids de idA até idB.<br>
				&lt; time &gt;: quantidade de segundos.<br>
			</p>
		</div>
		<div class="panel-footer">
		</div>
	</div>
</div>
