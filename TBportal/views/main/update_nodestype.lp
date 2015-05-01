<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>

<div class="row" style="float:left; padding-top: 3px; padding-right: 50px;">
	<form method="post">	
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
				<h4>Atualizar Tipos de Motes</h4>
			</div>
			<div class="panel-body">
				<div>
					<table cellpadding = "5" >
						<tr>
			              <th style="text-align:left; width:20px"></th>
			              <th style="text-align:left; width:53px">ID</th>
			              <th style="text-align:left; width:200px">Tipo do mote</th>
			              <th style="text-align:left;">Descrição</th>
						</tr>
					</table>
				</div>
				<div class="row" id="topoData" style="float: left; overflow-y: scroll; overflow-x: hidden; display: block;">
					<table  cellpadding = "1" id='nodesTable'>
			            <% if (nodestype) then 
			              for i,reg in pairs(nodestype) do %>
				              <tr style="border-bottom: 1px solid #CCCCCC;">
				              	<td align="center" style="width:20px">
									<a href="#" onclick="return popup('confirm','Apagar item?','Apagar  id:<%= reg.nodetype %>, Type:<%= reg.short %> ?','?r=main/update_nodestype&action=del&nodetype=<%= reg.nodetype%>')" title="Apagar tipo."><span class="fa fa-trash-o pull-right"></span></a>
				              	</td>

				              	<td align="center" style="width:53px">
				              		<%= reg.nodetype %> 
			                    	<input type="hidden"  name="nodetype" value ="<%= reg.nodetype%>" />
				              	</td>
				              	<td style="text-align:left; ">
									<input type="text" name="short"  required placeholder="Descrição curta" maxlength="20" size="20" value="<%= (reg.short) or '' %>" title="Nome curto para o tipo.">
				              	</td>
				              	<td style="text-align:left; ">
									<input type="text" name="description"  placeholder="Descrição" size="40" value="<%= (reg.description) or '' %>" title="Descrição do tipo.">
				              	</td>
				             </tr>
			    		<% end 
			    		end %>
					</table>
				</div>
			</div>
			<div class="panel-footer">
				<div align='right'>
					<input type="submit" class="btn btn-default" value="Atualizar"/>
				    <input type="hidden" name="action" value="update" />
				</div>
				<div class="col" >
				</div>
			</div>
		</div>
	</form>
</div>
<div class="row" style="float:left; padding-top: 3px; ">
	<form method="post">	
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
				<h4>Criar novo Tipo de Motes</h4>
			</div>
			<div class="panel-body">
				<table>
					<tr><td>Id:</td>
	            		<td><input type="text"  name="nodetype" required placeholder="Núm." maxlength="3" size="3" pattern="[0-9]{1,3}" title="Digite um número: (1..999)" value ="<%= (nodestype[#nodestype] and (nodestype[#nodestype].nodetype + 1)) or 1%>" /></td></tr>
					<tr><td>Tipo do mote:</td>
						<td><input type="text" name="short"  required placeholder="Descrição curta" maxlength="20" size="20" value="" title="Nome curto para o tipo."></td></tr>
					<tr><td>Descrição:</td>
						<td><input type="text" name="description"  placeholder="Descrição" size="40" value="" title="Descrição do tipo."></td></tr>
				</table>
			</div>
			<div class="panel-footer">
				<div align='right'>
					<input type="submit" class="btn btn-default" value="Criar novo tipo"/>
				    <input type="hidden" name="action" value="create" />
				</div>
				<div class="col" >
				</div>
			</div>
		</div>
</div>
<script>
var headerOffsetDefault=280;
window.onresize = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault)+'px');
}
window.onload = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault)+'px');
};
</script>