
<div style="padding-top: 10px;">
<form method="post">
	<div class="panel panel-default" style="float: left; <%= (plan and plan.name and 'border-color: blue;') or '' %>">
		<div class="panel-heading">
	    	<h4><%= (plan and plan.name and 'Atualizar Plano') or 'Novo Plano' %></h4>
			<%= (plan and plan.name and '(obs.: As alterações sobre-escrevem o plano original.)') or '' %>
	  	</div>
		<div class="panel-body">
			<table>
				<tr><td>Nome: (max 20 caracteres)</td></tr>
				<tr><td style="padding-left: 20px;"><input type="text" name="planname"  placeholder="Nome do plano." required="true" maxlength="20" size="20" value="<%= (plan and plan.name) or '' %>"></td></tr>
				<tr><td>Descrição:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description" placeholder="Descrição do plano." size="40" value="<%= (plan and plan.description) or '' %>"></td></tr>
				<tr><td>Configuração:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;">
						<select name="netconfigid" required >
					        <?lua for i=1,#netconfigs do ?>
					            <option value="<%= netconfigs[i].netconfigid %>" <%= ((netconfigs[i].netconfigid) == (plan and plan.netconfigid) and 'selected') or '' %> ><%= netconfigs[i].nome %>
					        <?lua end ?>
					    </select>
				</td></tr>
				<tr><td>Script:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="scriptid" required >
					        <?lua for i=1,#scripts do ?>
					            <option value="<%= scripts[i].scriptid %>" <%= ((scripts[i].scriptid) == (plan and plan.scriptid) and 'selected') or '' %> ><%= scripts[i].nome %>
					        <?lua end ?>
					    </select>
				</td></tr>
			</table>
		</div>
		<div class="panel-footer">
			<div align='right'>
				<input type="hidden" name="planid" value="<%= (plan and plan.planid) or '0' %>" />
			    <input type="hidden" name="action" value="<%= (plan and plan.name and 'update') or 'save' %>" />
				<input type="submit" class="btn btn-default" value="<%= (plan and plan.name and 'Atualizar') or 'Salvar' %>" />
			</div>
			<div class="col" >
			</div>
		</div>
	</div>
</form>
</div>