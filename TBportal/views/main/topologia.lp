<%
	function typeColor(nodetype)
		local colors={
		    "#000000", -- black
		    "#0000FF", -- blue
		    "#006600", -- green
		    "#FF0000", -- red
		    "#CCCC00", -- yelow
		    "#666666", -- gray
		    "#663300", -- brown
		    "#CC00FF", -- pink
		    "#00FFCC", -- sky
		    "#660066", -- purple
			}
		return colors[(nodetype%10)]	
	end
%>
<script>
	var colors=[
		    "#000000", // black
		    "#0000FF", // blue
		    "#006600", // green
		    "#FF0000", // red
		    "#CCCC00", // yelow
		    "#666666", // gray
		    "#663300", // brown
		    "#CC00FF", // pink
		    "#00FFCC", // sky
		    "#660066", // purple	
	];

	function drawNode(id,x,y,type,status){
		var width = 20;
		var color = colors[(type-1)%10];
		if (id > 100) { width = 26;}
		var canvas = document.getElementById('netCanvas');
  		if (canvas.getContext) {
    		var ctx = canvas.getContext("2d");
			ctx.strokeStyle=color;
			if (status == 0) {
				ctx.lineWidth = "2";
				ctx.setLineDash([1,0]);
				ctx.fillStyle = 'black';
			} else if (status == 1) {
				ctx.lineWidth = "1";
				ctx.setLineDash([1,1]);
				ctx.fillStyle = 'gray';
			} else {
				return;
				//ctx.lineWidth = "1";
				//ctx.setLineDash([1,4]);
				//ctx.fillStyle = 'LightGray';
			}
    		ctx.strokeRect(x,y,width,15);
			ctx.font = "12px sans-serif";
			ctx.textAlign = "center";
  			ctx.fillText(id, x+(width/2), y+13);
   		}
	}

// Define a global maxNodes var

var maxNodes = <%= #motes%>;
</script>
<% if netconfig.alert then %>
	<script> popup('alert','Aviso',"<%= netconfig.alert %>");</script> 
<% end %>

<div class="row">
	<form method="post">
		<div class="col" style="float: left; padding-top: 3px; padding-right: 10px;">
			<table>
				<tr><td>
				<div class="panel panel-default" style="float: left;">
					<div class="panel-heading">
			    		<h4><%= (netconfig and netconfig.netconfigid and 'Atualizar Configuração da Rede') or 'Nova Configuração da Rede' %></h4>
						<%= (netconfig and netconfig.netconfigid and '(obs.: As alterações sobre-escrevem a configuração original.)') or '' %>
			  		</div>
					<div class="panel-body">
						<table  style="width:400px;">
							<tr><td>Nome: (max 20 caracteres)</td></tr>
							<tr><td style="padding-left: 20px;"><input type="text" name="name"  placeholder="Nome da configuração da rede." required="true" maxlength="20" size="25" value="<%= (netconfig and netconfig.name) or '' %>"></td></tr>
							<tr><td>Descrição:</td></tr>
							<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description" placeholder="Descrição da configuração da rede." size="40" value="<%= (netconfig and netconfig.description) or '' %>"></td></tr>
							<tr><td>Arquivos default:</td></tr>
							<tr><td style="padding-left: 20px;">
							<table border="0">
								<% if targets then 
									for x,target in pairs(targets) do %>
										<tr>
											<td  width=130>
												<%= target.short %>
												<input type="hidden"  name="deftype" value ="<%= target.nodetype%>" />
											</td>
											<td width=200>
												<select name='deffileid' id="SelectedFile" >
												<% if arquivos then 
														local count=0
													for j,arq in pairs(arquivos) do 
														if arq.nodetype == target.nodetype then 
															count=count+1
															local selection = (((netconfig and netconfig.default and netconfig.default[target.nodetype].fileid)==arq.fileid) and "selected") or ''
														%>
															<option value=<%= arq.fileid %> <%= selection %> ><%= arq.filename %> </option>
			  											<% end
													end 
													if count==0 then %>
														<option value='-' selected >&nbsp </option>
													<% end
												   end %>
											</td>
										</tr>
									<% end
								end %>
							</table>
							</td></tr>
						</table>
					</div>
					<div class="panel-footer">
						<div class="col" style="float: right;">
							<input type="hidden" name="netconfigid" value="<%= (netconfig and netconfig.netconfigid) or '0' %>" />
						    <input type="hidden" name="action" value="<%= (netconfig and netconfig.netconfigid and 'update') or 'save' %>" />
							<input type="submit" class="btn btn-default" value="<%= (netconfig and netconfig.netconfigid and 'Atualizar') or 'Salvar' %>"/>
						</div>
						<div class="col" >
							<a href="?r=main/netconfig"><input type="button" class="btn btn-default" value="Limpar" ></a>
						</div>
					</div>
				</div>
				</td></tr>
				<tr><td>
					<div class="panel panel-default" style="float: left;">
						<div class="panel-heading">
				    		Diagrama da rede <%= session.netid .. ': '.. session.netname %>
				  		</div>
						<div class="panel-body">
							<canvas id="netCanvas" width="400" height="250"></canvas>
								<script>
				    				var c=document.getElementById("netCanvas");
									var ctx=c.getContext("2d");
									//ctx.strokeRect(0,0,400,250);
								</script>
					            <% if motes then 
					              for i,mote in pairs(motes) do %>
					    			<script>drawNode(<%=mote.nodeid%>,<%=mote.posx%>,<%=mote.posy%>,"<%=mote.nodetype%>",<%=mote.statusid%>);</script>
					    		<% end 
					    		end %>
						</div>
						<div class="panel-footer">
							<table cellpadding = "0">
								<% if targets then 
									 for x,target in pairs(targets) do %>
									 	 <td><font size="2" color="<%=typeColor(target.nodetype)%>">&nbsp<%= target.short%>&nbsp</font></td>
									 	 <% if (target.nodetype%4) == 0 then %> <tr> <% end %>
								<%   end
								   end %>
							</table>
						</div>
					</div>
				</td></tr>
			</table>
		</div>
		<div style="padding-top: 3px;">
			<div class="panel panel-default" style="float: left;">
				<div class="panel-heading" style="padding-left: 0px;">
							<table cellpadding = "5" >
								<tr>
					              <th style="text-align:left; width:53px">ID Físico</th>
					              <th style="text-align:left; width:66px">ID &nbsp Lógico</th>
					              <th style="text-align:left; width:100px">Tipo do &nbsp &nbsp mote</th>
					              <th style="text-align:left; width:45px">Porta TCP</th>
					              <th style="text-align:center; width:70px">Usar mote?</th>
					              <th style="text-align:center; width:70px">Arquivo default?</th>
					              <th style="text-align:left;" >Arquivo Binário </th>
								</tr>
							</table>
				</div>
				<div class="panel-body" style="padding-top: 1px;">
					<div class="row" id="topoData" style="float: left; overflow-y: scroll; overflow-x: hidden; display: block;">
						<table  cellpadding = "1" >
								<tr style="border-bottom: 1px solid #CCCCCC;">
									<td></td>
									<td></td>
									<td></td>
									<td></td>
									<td align="center">
										<a href="#" onclick="cbSelectAll()"><input type="checkbox" id="cbSelectAll"></a>
									</td>
									<td align="center">
										<a href="#" onclick="cbDefaultAll()"><input type="checkbox" id="cbDefaultAll"></a>
									</td>
									<td align="left" ><i class="fa fa-arrow-left"></i><font face="Roman"> marcar todos:</font></td>
								</tr>
				                <?lua page:include('/views/main/topologia_motes',{motes = motes, arquivos = arquivos, netconfig = netconfig}) ?>
						</table>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<script>
var headerOffsetDefault=180;

window.onresize = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault)+'px');
}
window.onload = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault)+'px');
};

function cbSelectAll(){
	var set = $('#cbSelectAll').prop('checked');
	var setx = (set)?1:0;
	for (moteIdx=1; moteIdx<=maxNodes; moteIdx++){
		if 	($("#statusid"+moteIdx).val() != 2){
			$( "#sb_selected"+moteIdx ).prop( "checked", set );
			$( "#sbx_selected"+moteIdx ).val( setx );
			$( "#sb_selected"+moteIdx ).trigger("change");
		}
	}
}
function cbDefaultAll(){
	var set = $('#cbDefaultAll').prop('checked');
	var setx = (set)?1:0;
	for (moteIdx=1; moteIdx<=maxNodes; moteIdx++){	
		if 	($("#statusid"+moteIdx).val() != 2){
			$( "#sb_default"+moteIdx ).prop( "checked", set );
			$( "#sbx_default"+moteIdx ).val( setx );
			if ($("#sb_selected"+moteIdx ).prop( "checked")){
				$( "#sb_default"+moteIdx ).trigger("change");
			}
		}
	}
}

</script>