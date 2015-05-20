<% if roles == nil then %>
	<script> document.location.href = "?r=main/useradmin" </script>
<% end %>

<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>

<div style="padding-top: 10px;">
<form method="post" style="padding-top: 10px;">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading">
	    	<h4>Criar Usuário</h4>
	  	</div>
		<div class="panel-body">
			<div class="row" style="padding-left: 10px;">
				<div class="col" style="float: left;">
					<table>
						<tr><td>E-mail:</td></tr>
				    	<tr><td style="padding-left: 20px;"><input type="text" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" required="true" name="ulogin" id="ulogin" placeholder="Digite o e-mail"></td></tr>
				    	<tr><td>Nome:</td></tr>
				    	<tr><td style="padding-left: 20px;"><input type="text" required="true" id="uname" name="unameCreate" placeholder="Digite o nome"> </td></tr>
				    	<tr><td>Senha:</td></tr>
				    	<tr><td style="padding-left: 20px;"><input type="password" required="true" size='15' name="password1" id="password1" placeholder="Digite a senha"</td></tr>
				    	<tr><td>Confirmar Senha:</td></tr>
				    	<tr><td style="padding-left: 20px;"><input type="password" required="true" size='15' name="password2" id="password2" placeholder="Confirme a senha"</td></tr>
						<tr><td style="padding-left: 20px; padding-top: 10px;">
							<input type="button" class="btn btn-default" name='newPass' id='btnNewPass' value="Gerar Senha" onclick="newRandomPass()"/> 
						</td></tr>
						<tr><td style="padding-left: 20px; padding-top: 10px;">
							<input type="checkbox" name="enviarEmail" value="email" checked > Enviar e-mail?
						</td></tr>
					</table>
				 </div>
				 <div class="col" style="float: left; padding-left: 25px;">
				 	<table>
				    	<tr><td>Perfil(s):</td></tr>
				    	<tr><td style="padding-left: 20px;"><table>
						    	<% for roleid,rolename in pairs(roles.byid) do %>
									<tr><td><input type="checkbox" name="create_roles" value="<%= roleid %>" onchange="checkRolesCreate()" > <%= rolename %></td></tr>
						    	<% end %>
						    </table></td></tr>
					</table>
				</div>
			</div>
		</div>
		<div class="panel-footer">
			<div align='right'>
		   		<input type="submit" class="btn btn-default" name='newUser' id='btnCreate' value="Criar" disabled/>   		
				</div>
			<div class="col" >
			</div>
		</div>
	</div>
</form>
<div class="col" style="float: left; width:20px;" >
	&nbsp
</div>
<form method="post" disabled>
	<div style="padding-left: 20px;">
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
		    	<h4>Alterar Perfil de Usuário</h4>
		  	</div>
			<div class="panel-body">
				<table>
					<tr><td>E-mail:</td></tr>
					<tr><td style="padding-left: 20px;"><input type="text" pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$" required="true" id="ulogin2" placeholder="Digite o e-mail"><input type="button" class="btn btn-default"  onclick="validateUser()" value="Validar"></td></tr>
					<tr><td><p id="validation"></p></td></tr>
					<tr><td>User: <input type="text" name="uloginUpt" id="ulogin2Out" style="border: 0px; background: transparent;" readonly></td></tr>
					<tr><td>Nome: <input type="text" id="unameUpdate" style="border: 0px; background: transparent;" readonly></td></tr>
					<tr><td>Perfil(s):</td></tr>
					    	<tr><td style="padding-left: 20px;"><table>
							    	<% for roleid,rolename in pairs(roles.byid) do %>
										<tr><td><input type="checkbox" name="update_roles" id="cbRoleUpd<%= roleid %>" value="<%= roleid %>" onchange="checkRolesUpdate()" disabled> <%= rolename %></td></tr>
							    	<% end %>
							    </table></td></tr>
					<tr><td><input type="hidden" name="uidUpdate" id="uidUpdate"></td></tr>
				</table>
			</div>
			<div class="panel-footer">
				<div align='right'>
			   		<input type="submit" class="btn btn-default" name='editRoles' id='btnEditRoles' value="Atualizar" disabled/>		   		
				</div>
				<div class="col" >
				</div>
			</div>
		</div>	
	</div>
</form>
</div>
<script>

function checkRolesCreate() {
	var checkboxes = document.getElementsByName("create_roles");
	var i;
	var length = checkboxes.length;
	for (i=0; i < length; i++) {
		if (checkboxes[i].checked){
			$("#btnCreate").removeAttr("disabled");
			return ;
		}
	}
	$("#btnCreate").attr("disabled", "disabled");
}
window.onload=function(){                                        
    setTimeout(function(){  
        document.getElementById('password1').value = '';
        document.getElementById('password2').value = '';
        document.getElementById('uname').value = '';
    },100);
  }
</script>
<script>
function validateEmail() {
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    var status = re.test($("#ulogin").val());
   	return status;
}


function checkRolesUpdate() {
	var checkboxes = document.getElementsByName("update_roles");
	var i;
	var length = checkboxes.length;
	for (i=0; i < length; i++) {
		if (checkboxes[i].checked){
			$("#btnEditRoles").removeAttr("disabled");
			return ;
		}
	}
	$("#btnEditRoles").attr("disabled", "disabled");
}
function procValidateUser (data, status) {
	var info = JSON.parse(data);
	if (info.data == "true") {
		document.getElementById("ulogin2Out").style.color = "black";
		$("#ulogin2Out").val($("#ulogin2").val());
		$("#unameUpdate").val(info.uname);
		$("#uidUpdate").val(info.uid);
		disableBoxes(false);
		for (i=0; i < $(info.roles).size() ; i++) {
			$("#cbRoleUpd" + info.roles[i].id).prop("checked", true);
		}
	}
	else {
		document.getElementById("ulogin2Out").style.color = "red";
		$("#ulogin2Out").val("Inválido");
		disableBoxes(true);
		$("#btnEditRoles").attr("disabled", "disabled");
	}
}

function validateUser() {
	$.post("?r=main/validateUser",
			{ulogin: $("#ulogin2").val()},
			function (data,status){procValidateUser(data, status)}
			);
}

function disableBoxes(valid) {
	var checkboxes = document.getElementsByName("update_roles");
	var i;
	var length = checkboxes.length;
	for (i=0; i < length; i++) {
			checkboxes[i].disabled = valid;
			checkboxes[i].checked = false;
	}
}


function newRandomPass(){
	var keys="abcdefghijklmnopqrstuvwxyz123456789"
	var pass=''
	for (i=0;i<6;i++)
		pass+=keys.charAt(Math.floor(Math.random()*keys.length))
	$('#password1').val(pass);
	$('#password2').val(pass);
}
</script>


