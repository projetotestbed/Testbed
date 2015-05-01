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
		return colors[((nodetype-1)%10)+1]	
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

	function eraseAll(){
		var canvas = document.getElementById('netCanvas');
  		if (canvas.getContext) {
			canvas.getContext('2d').clearRect(0,0,canvas.width,canvas.height );
		}	
	}
	
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
				ctx.lineWidth = "1";
				ctx.setLineDash([1,4]);
				ctx.fillStyle = 'LightGray';
			}
    		ctx.strokeRect(x,y,width,15);
			ctx.font = "12px sans-serif";
			ctx.textAlign = "center";
  			ctx.fillText(id, x+(width/2), y+13);
   		}
	}

</script>
<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>

<div class="row">
	<form method="post">
		<div class="row" style="float: left; padding-top: 3px; padding-right: 10px;">
			<table>
				<tr>
				<td style="vertical-align:top; padding-right: 10px;"><a id='minimize' onclick="hideTable()" title="Esconder tabelas superiores"><span class="fa fa-minus-square pull-right" ></span></a></td>
				<td id="panelA" style="vertical-align:top; padding-right: 10px;">
				<div class="panel panel-default" style="float: left;">
					<div class="panel-heading">
			    		<h4><%= (network and network.netid and 'Nova Versão de Rede') or 'Rede não selecionada' %></h4>
			  		</div>
					<div class="panel-body">
						<table  style="width:400px;">
							<tr><td><%= 'NetId='..((network and network.netid) or '--')..' -- <font color="blue" >Novo NetVersion='..((network and (network.netversion + 1)) or '--') ..'</font>' %> </td></tr>
							<tr><td>Nome:</td></tr>
							<tr><td style="padding-left: 20px;"><input type="text" readonly name="name"  placeholder="Nome da rede." required="true" maxlength="20" size="25" value="<%= (network and network.nname) or '' %>"></td></tr>
							<tr><td>Descrição da Rede:</td></tr>
							<tr><td style="padding-left: 20px;"><input type="text" readonly name="description" placeholder="Descrição da rede." size="40" value="<%= (network and network.description) or '' %>"></td></tr>
							<tr><td>Descrição da Versão:</td></tr>
							<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" required name="vdescription" placeholder="Descrição da versão." title="Digite uma descrição para nova versão." size="40" value=""></td></tr>
						</table>
					</div>
					<div class="panel-footer">
						<div align='right'>
							<input type="hidden" name="netid" value="<%= (network and network.netid) or '0' %>" />
							<input type="hidden" name="netversion" value="<%= (network and (network.netversion + 1)) or '0' %>" />
						    <input type="hidden" name="action" value="update" />
							<input type="submit" class="btn btn-default" <%= (network and network.netid and 'enabled') or 'disabled' %> value="Atualizar"/>
						</div>
						<div class="col" >
						</div>
					</div>
				</div>
				</td>
				<td id="panelB" style="vertical-align:top; padding-right: 10px;">
					<div class="panel panel-default" style="float: left;">
						<div class="panel-heading">
			    			Diagrama da rede: 400x250 -- node: 20x15
				  		</div>
						<div class="panel-body" >
							<canvas id="netCanvas" width="400" height="250"></canvas>
								<script>
				    				var c=document.getElementById("netCanvas");
									var ctx=c.getContext("2d");
								</script>
					            <% if (network and network.nodes) then 
					              for i,mote in pairs(network.nodes) do %>
					    			<script>drawNode(<%=mote.nodeid%>,<%=mote.posx%>,<%=mote.posy%>,"<%=mote.nodetype%>",<%=mote.statusid%>);</script>
					    		<% end 
					    		end %>
						</div>
						<div class="panel-footer">
							<table cellpadding = "0">
								<% if nodestype then 
									 for x,target in pairs(nodestype) do %>
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
		<div class="row" style="padding-top: 3px;">
			<div class="panel panel-default" style="float: left;">
				<div class="panel-heading" style="padding-left: 0px;">
							<table cellpadding = "5" >
								<tr>
					              <th style="text-align:left; width:20px"></th>
					              <th style="text-align:center; width:53px">ID</th>
					              <th hidden>motetype</th>
					              <th style="text-align:left; width:100px">Tipo do mote</th>
					              <th style="text-align:left; width:80px">Status</th>
					              <th style="text-align:left; width:150px">Descrição local</th>
					              <th style="text-align:left; width:46px">posX</th>
					              <th style="text-align:left; width:46px">posY</th>
					              <th style="text-align:left; width:46px">posZ</th>
					              <th style="text-align:left; width:280px">Canal de Controle</th>
					              <th style="text-align:left; width:200px">Canal de Dados</th>
								</tr>
							</table>
				</div>
				<div class="panel-body" style="padding-top: 1px;">
					<div class="row" id="topoData" style="float: left; overflow-y: scroll; overflow-x: hidden; display: block;">
						<table  cellpadding = "1" id='nodesTable'>
	
				            <% if (network and network.nodes) then 
				              for i,mote in pairs(network.nodes) do %>
					              <tr id="<%='reg'..mote.nodeid%>" style="border-bottom: 1px solid #CCCCCC;">
					              	<td align="center" style="width:20px">
										<a href="#" onclick="return removeNode(<%=mote.nodeid%>);" title="Apagar mote."><span class="fa fa-trash-o pull-right"></span></a>
					              	</td>
					              	<td align="center" style="width:53px">
					              		<%= mote.nodeid %> 
					              	</td>
				                    <td hidden>
				                    	<%= mote.nodetype%>
				                    	<input type="hidden"  name="nodeid" value ="<%= mote.nodeid%>" />
				                    	<input type="hidden"  name="typeshort" value ="<%= mote.typeshort%>" />
				                    </td>
				                    <td style="text-align:left; width:100px">
										<select name="nodetype" id="<%= 'sb_nodetype'.. mote.nodeid %>" required style="width: 100px" onchange="setTpShort(<%=mote.nodeid %>);">
											<% if nodestype then for j,type in ipairs(nodestype) do %>
												<option value=<%= type.nodetype %> <%= (type.nodetype == mote.nodetype and 'selected') or ''%> ><%= type.short %></option>
											<% end end %>
										</select>
				                    </td>
					              	<td style="text-align:left; width:80px">
				                    	<select name='statusid' id="<%= 'sb_statusid'.. mote.nodeid %>" required style="width: 80px" onchange="redraw();">
				                          <% if nodestatus then 
				                            	for j,stat in ipairs(nodestatus) do 
				                                	%>
						                            <option value=<%= stat.statusid %> <%= (stat.statusid == mote.statusid and 'selected') or ''%> ><%= stat.code %></option>
				                          <%
				                             	end 
				                             end %>
										</select>
					              	</td>
					              	<td style="text-align:left; width:150px">
										<input type="text" name="location"  required placeholder="Descrição do local" size="15" value="<%= (mote.location) or '' %>">
					              	</td>
					         
					              	<td style="text-align:left; width:46px">
										<input type="text" name="posx" id="posx" required placeholder="pos X" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="<%= (mote.posx) or '' %>" onblur="redraw()">
					              	</td>
					              	<td style="text-align:left; width:46px">
										<input type="text" name="posy" id="posy" required placeholder="pos Y" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="<%= (mote.posy) or '' %>" onblur="redraw()">
					              	</td>
					              	<td style="text-align:left; width:46px">
										<input type="text" name="posz" id="posz" required placeholder="pos Z" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="<%= (mote.posz) or '' %>" onblur="redraw()">
					              	</td>
					              	<td style="text-align:left; width:280px">
										<input type="text" name="ctlchannel"  required placeholder="Canal de controle" size="32" value="<%= (mote.ctlchannel) or '' %>">
					              	</td>
					              	<td style="text-align:left; width:200px">
										<input type="text" name="datachannel"  required placeholder="Canal de dados" size="24" value="<%= (mote.datachannel) or '' %>">
					              	</td>
					              </tr>
				    		<% end  %>
				    		<%end %>
				    			  <tr id="addReg">
				    			  	<td>
										<a href="#" onclick="return insertNewNode();" title="Inserir novo mote."><span class="fa fa-plus pull-right"></span></a>				    			  	</td>
				    			  	<td>&nbsp</td><td></td><td></td><td></td><td></td>
				    			  	<td></td><td></td><td></td><td></td><td></td>
					              </tr>

						</table>
					</div>
				</div>
			</div>
		</div>
	</form>
</div>

<script>
var hideOffsetDefault=390;
var headerOffsetDefault=155;
var hideOffset=hideOffsetDefault;
window.onresize = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault-hideOffset)+'px');
}
window.onload = function() {
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault-hideOffset)+'px');
};

function hideTable(){
	if ($('#panelA').is(':hidden')){
		$('#panelA').show();
		$('#panelB').show();
		$('#minimize').html('<span class="fa fa-minus-square pull-right" ></span>');
		$('#minimize').prop('title', 'Esconder tabelas superiores');
		hideOffset = hideOffsetDefault;
	} else {
		$('#panelA').hide();
		$('#panelB').hide();
		$('#minimize').html('<span class="fa fa-plus-square pull-right" ></span>');
		$('#minimize').prop('title', 'Exibir tabelas superiores');
		hideOffset = 0;
	}
	$('#topoData').css('max-height', (window.innerHeight-headerOffsetDefault-hideOffset)+'px');
}

function redraw(){
	eraseAll()
	$('#nodesTable tr').each(function() {
    	var id = 	$(this).find(':nth-child(2)').html();
    	var type = 	$(this).find(':nth-child(4) option:selected').val();
    	var status= $(this).find(':nth-child(5) option:selected').val();
    	var posx = 	$(this).find(':nth-child(7)').find('input').val();
    	var posy = 	$(this).find(':nth-child(8)').find('input').val();
    	var posz = 	$(this).find(':nth-child(9)').find('input').val();
    	//alert(Number(id)+' '+type+' '+status+' '+posx+' '+posy+' '+posz);
    	drawNode(id,Number(posx),Number(posy),type,status);
	});
}

function insertReg(nodeid){
	var nodetype=1;
	var typeshort='micaz300';
	var statusid=1;
	var statusidtxt='ACTIVE';
	var tpshort_field='tpshort'+nodeid
	var canvas = document.getElementById('netCanvas');
	var posx = (((nodeid-1) * 40)+10) % canvas.width;
	var posy = ((Math.floor((((nodeid-1) * 40)+10)/canvas.width) * 40)+10)%canvas.height;
	
	var Htext =
      '<tr id="reg'+nodeid+'" style="border-bottom: 1px solid #CCCCCC;"> \
      	<td align="center" style="width:20px"> \
			<a href="#" onclick="return removeNode('+nodeid+');" title="Apagar mote."><span class="fa fa-trash-o pull-right"></span></a> \
      	</td> \
      	<td align="center" style="width:53px"> \
      		'+nodeid+'  \
      	</td> \
        <td hidden> \
        	'+nodetype+' \
        	<input type="hidden"  name="nodeid" value ="'+nodeid+'" /> \
        	<input type="hidden"  id="tpshort'+nodeid+'" name="typeshort" value="'+typeshort+'" /> \
        </td> \
        <td style="text-align:left; width:100px"> \
			<select name="nodetype" id="sb_nodetype'+nodeid+'" required style="width: 100px" onchange="setTpShort('+nodeid+');"> \
				<% if nodestype then for j,type in ipairs(nodestype) do %> \
					<option value=<%= type.nodetype %>  ><%= type.short %></option> \
				<% end end %> \
			</select> \
        </td> \
      	<td style="text-align:left; width:80px"> \
			<select name="statusid" id="sb_statusid'+nodeid+'" required style="width: 80px" onchange="redraw();"> \
				<% if nodestatus then for j,stat in ipairs(nodestatus) do %> \
					<option value=<%= stat.statusid %>  ><%= stat.code %></option> \
				<% end end %> \
			</select> \
      	</td> \
      	<td style="text-align:left; width:150px"> \
			<input type="text" name="location"  required placeholder="Descrição do local" size="15" value=""> \
      	</td> \
      	<td style="text-align:left; width:46px"> \
			<input type="text" name="posx" id="posx" required placeholder="pos X" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="'+posx+ '" onblur="redraw()"> \
      	</td> \
      	<td style="text-align:left; width:46px"> \
			<input type="text" name="posy" id="posy" required placeholder="pos Y" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="'+posy+ '" onblur="redraw()"> \
      	</td> \
      	<td style="text-align:left; width:46px"> \
			<input type="text" name="posz" id="posz" required placeholder="pos Z" title="Digite um valor numérico." pattern="[0-9]{1,3}" maxlength="3" size="3" value="0" onblur="redraw()"> \
      	</td> \
      	<td style="text-align:left; width:280px"> \
			<input type="text" name="ctlchannel" required placeholder="Canal de controle" size="32" value=""> \
      	</td> \
      	<td style="text-align:left; width:200px"> \
			<input type="text" name="datachannel" required placeholder="Canal de dados" size="24" value="10000 192.168.0.1 10002"> \
      	</td> \
      </tr>';




	$('#addReg').before(Htext);

}

function setTpShort(nodeid){
	$('#tpshort'+nodeid).val($('#sb_nodetype'+nodeid+ ' option:selected').text());
	redraw();
}

function getNextNodeid(){
	var nextId=0;
	$('#nodesTable tr').each(function() {
		var id = Number($(this).find(':nth-child(2)').html());
		if (nextId < id) nextId=id;
	});
	return nextId+1;
}

function isNewId(nodeid){
	var ret = true;
	$('#nodesTable tr').each(function() {
		var id = Number($(this).find(':nth-child(2)').html());
		if (nodeid == id) ret = false;
	});
	return ret;
}

function insertNewNode(){
	var nextId = getNextNodeid();
	var nodeidTxt = prompt("Digite o número do novo mote",nextId);
	if (nodeidTxt){
		var nodeId = Number(nodeidTxt);
		if (isNaN(nodeId) || ((nodeId < 1)  || (nodeId > 65535))) {
			popup('alert','Aviso','O valor ['+nodeidTxt+'] é inválido! (valor deve ser de 1 até 65535)');
		} else {
			if (isNewId(nodeId)) {
				insertReg(nodeId);
				redraw();
			} else {
				popup('alert','Aviso','O nodeid ['+nodeidTxt+'] já está em uso!');
			}
		}
	}
}
function removeNode(nodeid){
	if (confirm("Deseja remover node "+nodeid)) {
		$('#reg'+nodeid).remove();
		redraw();
	}
}

</script>