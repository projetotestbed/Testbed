<% if (test and test.alert) then %>
	<script> popup('alert','Aviso',"<%= test.alert %>");</script> 
<% end %>

<div style="padding-top: 10px;">
<form method="post">
	<div class="panel panel-default" style="float: left; <%= (test and test.name and 'border-color: blue;') or '' %>">
		<div class="panel-heading">
	    	<h4><%= (test and test.name and 'Atualizar Teste') or 'Novo Teste' %></h4>
			<%= (test and test.name and '(obs.: As alterações sobre-escrevem o teste original.)') or '' %>
	  	</div>
		<div class="panel-body">
			<table>
				<tr><td>Nome: (max 20 caracteres)</td></tr>
				<tr><td style="padding-left: 20px;"><input type="text" name="testname"  placeholder="Nome do teste." required="true" maxlength="20" size="20" value="<%= (test and test.name) or '' %>"></td></tr>
				<tr><td>Descrição:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description" placeholder="Descrição do teste." size="40" value="<%= (test and test.description) or '' %>"></td></tr>
				<tr><td>Endereço IPv4:</td></tr>
				<tr><td style="padding-left: 20px;"><input type="text" name="remote_addr" id="remote_addr" pattern="\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}" title="Endereço IPv4 para conexão com o canal de dados durante a execução do seu teste. Formato: xxx.xxx.xxx.xxx" placeholder="Endereço cliente." size="20" value="<%= (test and test.remote_addr) or (session and session.remote_addr) or '' %>">
				</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;">Endereço atual: <%= session.remote_addr %> 
				</td></tr>
				<tr><td>Agenda:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="idagenda" required >
					        <?lua for i=1,#agendas do 
					        	if agendas[i].testid == (test and test.testid) or agendas[i].testid == 0  then ?>
					            	<option value="<%= agendas[i].idagenda %>" <%= (agendas[i].idagenda == (test and test.idagenda) and 'selected') or '' %> ><%= agendas[i].nome %>
					        <?lua end
					          end ?>
					    </select>
				</td></tr>
				<tr><td>Plano:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="planid" required >
					        <?lua for i=1,#planos do ?>
					            <option value="<%= planos[i].configid %>" <%= (planos[i].configid == (test and test.planid) and 'selected') or '' %> ><%= planos[i].nome %>
					        <?lua end ?>
					    </select>
				</td></tr>
			</table>
		</div>
		<div class="panel-footer">
			<div class="col" style="float: right;">
				<input type="hidden" name="testid" value="<%= (test and test.testid) or '0' %>" />
			    <input type="hidden" name="action" value="<%= (test and test.name and 'update') or 'save' %>" />
				<input type="submit" class="btn btn-default" value="<%= (test and test.name and 'Atualizar') or 'Salvar' %>"/>
			</div>
			<div class="col" >
				<input type="button" class="btn btn-default" onclick="$('#remote_addr').val('<%= session.remote_addr %>');" value="Copiar Endereço" /> &nbsp&nbsp
			</div>
		</div>
	</div>
</form>
</div>
