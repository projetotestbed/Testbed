<% if (alert) then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>

<div style="padding-top: 10px;">
<form method="post" enctype="multipart/form-data">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading">
	    	<h4><%= (userfile and userfile.filename and 'Atualizar Arquivo Executável') or 'Novo Arquivo Executável' %></h4>
			<p align="left"><%= (userfile and userfile.filename and '(Somente nome e descrição)') or '' %></p>
	  	</div>
		<div class="panel-body">
			<table>
				<tr><td>Nome: (max 20 caracteres)</td></tr>
				<tr><td style="padding-left: 20px;"><input type="text" name="filename"  placeholder="Nome do arquivo." required="true" maxlength="20" size="20" value="<%= (userfile and userfile.filename) or '' %>"></td></tr>
				<tr><td>Descrição:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description"  placeholder="Descrição do arquivo." size="30" value="<%= (userfile and userfile.description) or '' %>"></td></tr>
				<tr><td>Arquivo binário:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="file" name='bindata' multiple="false" required = "yes" <%=  (userfile and userfile.filename and 'disabled') or '' %>></input></td></tr>
				<tr><td>Tipo de nó:</td></tr>
				<tr><td style="padding-left: 20px; padding-bottom: 20px;"><select name="nodetype" <%= (userfile and userfile.filename and 'disabled') or '' %> >
					        <?lua for i=1,#targets do ?>
					            <option value="<%= targets[i].nodetype %>" <%= ((targets[i].nodetype) == (userfile and userfile.nodetype) and 'selected') or '' %> ><%= targets[i].description %>
					        <?lua end ?>
					    </select>
			    </td></tr>
			</table>
		</div>
		<div class="panel-footer">
			<div align='right'>
			    <input type="hidden" name="fileid" value="<%= (userfile and userfile.fileid) or '0' %>" />
			    <input type="hidden" name="action" value="<%= (userfile and userfile.filename and 'update') or 'save' %>" />
				<input type="submit"  class="btn btn-default" value="<%= (userfile and userfile.filename and 'Atualizar') or 'Salvar' %>"/>
			</div>
			<div class="col" >
			</div>
		</div>
	</div>
</form>
</div>
