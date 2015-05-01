<% if config == nil then %>
	<script> document.location.href = "?r=main/userconfig" </script>
<% end %>

<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>
<div style="padding-top: 10px;">
<form method="post">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading">
	    	<h4>Alterar Senha</h4>
	  	</div>
		<div class="panel-body">
		<table>
			<tr><td>Senha atual:</td></tr>
	    	<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="password" required="true" size='15' name="old_password"  id="old_password"  placeholder="Digite senha atual" onkeyup="enableSave();" onchange="enableSave();"></td></tr>
			<tr><td>Nova senha:</td></tr>
	    	<tr><td style="padding-left: 20px;"><input type="password" required="true" size='15' name="new_password1" id="new_password1" placeholder="Digite a nova senha" onkeyup="enableSave();" onchange="enableSave();"></td></tr>
	    	<tr><td>Confirmar nova senha:</td></tr>
	    	<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="password" required="true" size='15' name="new_password2" id="new_password2" placeholder="Repita a nova senha" onkeyup="enableSave();" onchange="enableSave();"></td></tr>
		</table>
		</div>
		<div class="panel-footer">
			<div align='right'>
		   		<input type="submit" class="btn btn-default" name='newPassword' id='btnSave' value="Atualizar" disabled/>
				</div>
			<div class="col" >
			</div>
		</div>
	</div>
</form>
<div class="col" style="float: left; width:20px;" >
	&nbsp
</div>
<form method="post">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading">
	    	<h4>Definir configuração padrão</h4>
	  	</div>
		<div class="panel-body">
		<table>
			<tr><td>Escolha sua rede padrão:</td></tr>
		    <tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="netdefault" onchange="enableSaveConfig()">
				    <% for i=1,#session.networks do %>
				    <option value="<%= (session.networks[i].netid) %>" <% if (session.networks[i].name) == config.netdefault then %> selected <% end %>> <%= (session.networks[i].name) %> </option>
				    <% end %>
				    </select>
				 </td></tr>		    
			<tr><td>Escolha seu perfil padrão:</td></tr>
			<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="roledefault" onchange="enableSaveConfig()">
				    <% for i=1,#session.roles do %>
				    <option value="<%= (session.roles[i]) %>" <% if (session.roles[i]) == config.roledefault then %> selected <% end %>> <%=(session.roles[i])%> </option>
				    <% end %>
				    </select>
			    </td></tr>
		    
			<tr><td>Exibir testes antigos? </td></tr>
			<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="radio" name="showoldtests" value="true" onchange="enableSaveConfig()" <% if config.showoldtests == "true" then %>checked<% end %>> Sim
			    	<input type="radio" name="showoldtests" value="false" onchange="enableSaveConfig()" <% if config.showoldtests == "false" then %>checked <% end %>> Não
				</td></tr>
			<tr><td>Selecione o padrão de colunas ativas: </td></tr>
			<tr><td style="padding-left: 20px; padding-bottom: 20px;"><table>
			    	<% for i=1, string.len(config.activetab) do %>
			        	<% local cbValue= string.sub(config.activetab,i,i); local cbChecked = (cbValue=='1' and 'checked') or '';%>
						<tr><td><input type="checkbox" id="<%= 'tab'..tostring(i) %>" value="<%=cbValue%>" onchange="changeTabs(id,<%= i %>,<%= #indexData %>)" <%=cbChecked%> > <%= (indexData[i].title) %></td></tr>
			    	<% end %>
			    </table></td></tr>
		</table>
		</div>
		<div class="panel-footer">
			<div class="col" style="float: right;">
			    <input type="submit" class="btn btn-default" name='newUserconfig' id='btnNewconfig' value="Atualizar" disabled >
			</div>
			<div class="col" >
			    <input type="password" required="true" size='15' name="cfg_password"  id="cfg_password" placeholder="Digite senha atual" >
			    <input type="hidden" name="activetabs" id="actTabs" value="<%= config.activetab  %>" ></br>
			</div>
		</div>
	</div>
</form>
<div class="col" style="float: left; width:20px;" >
	&nbsp
</div>
  	<form method="post">
	<div class="panel panel-default" style="float: left;" <%= (#session.roles == 1 and 'hidden') or ''%> >
		<div class="panel-heading">
	    	<h4>Alterar perfil da sessão atual</h4>
	  	</div>
		<div class="panel-body">
		<table>
			<tr><td>Escolha o novo perfil:</td></tr>
			<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="roledefault" onchange="enableSaveSessionRole()">
			    <% for i=1,#session.roles do %>
			    <option value="<%=session.roles[i]%>" <%= (session.roles[i] == session.role and 'selected') or '' %>> <%=session.roles[i]%> </option>
			    <% end %>
			    </select>
			 </td></tr>
		</table>
		</div>
		<div class="panel-footer">
			<div class="col" style="float: right;">
		    	<input type="submit" class="btn btn-default" name='newSessionRole' id='btnNewRole' value="Atualizar" disabled >
			</div>
			<div >
		    	<input type="password" required="true" size='15' name="role_password"  id="role_password" placeholder="Digite senha atual" >
			</div>
		</div>
	</div>
</form>


</div>

<script>
function enableSave(){
	if ($('#old_password').val().length > 0 && $('#new_password1').val().length > 0 && $('#new_password2').val().length > 0) {
		$('#btnSave').removeAttr("disabled");
	} else {
		$('#btnSave').attr("disabled", true);
	}
}
 window.onload=function(){                                              
    setTimeout(function(){  
        document.getElementById('old_password').value = '';
        document.getElementById('cfg_password').value = '';
        document.getElementById('role_password').value = '';
    },100);
  } 

function enableSaveConfig(){
	$('#btnNewconfig').removeAttr("disabled");
}

function changeTabs(id,pos,numTabs){
	enableSaveConfig();
	
	var activetabs = document.getElementById("actTabs").value;
	
	var subStr1 = activetabs.substring(0,pos-1);
	var subStr2 = activetabs.substring((pos),(numTabs));
	
	if (document.getElementById(id).value == "1") {
		document.getElementById(id).value = "0";
	}
	else {
		document.getElementById(id).value = "1"
	}
	
	var v =  document.getElementById(id).value;
	
	activetabs = subStr1.concat(v);
	activetabs = activetabs.concat(subStr2);
	
	document.getElementById("actTabs").value = activetabs;
	
}
</script>
<script>
function enableSaveSessionRole() {
	$('#btnNewRole').removeAttr("disabled");
}
</script>



















