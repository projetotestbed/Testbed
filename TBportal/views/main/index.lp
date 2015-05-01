<% if tabela == nil then %>
	<script> document.location.href = "?r=main/index" </script>
<% end %>

<% if tabela.alert then %>
	<script> popup('alert','Aviso',"<%= tabela.alert %>");</script>
<% end %>
<div class="row" id="mainPage" style="padding-top: 3px; padding-left: 5px;padding-right: 5px;">

	<div class="row">
		<div class="panel panel-default">
			<div class="panel-heading">
				<div class="row">
					<div class="col" style="float: left; padding-left: 10px;"><h4>Visão Geral</h4></div>
					<div class="col" style="float: right;">
					<div class="btn-group" role="group" >
			            <% for k,coluna in ipairs(tabela) do %>
			            <% if string.sub(activetab,k,k)=='0' then %>
								<a class="btn btn-default" href="?r=main&col=<%=k%>&action=up&id=0&activetab=<%= activetab%>"><?= coluna.icon ?>&nbsp<%= coluna.nome %>&nbsp<i class="fa fa-plus-square" style="color:#428bca"></i></a>
					    <% end %>
					    <% end %>
					</div>
					</div>
				</div>
			</div>
			<a href="?r=main&action=oldtest" id="a_oldtest"><%= (session and (session.oldtest == "true") and '<i class="fa fa-check-square-o"></i>') or '<i class="fa fa-square-o"></i>' %></a>&nbsp Exibir testes antigos.
		</div>		
	</div>
		<div class="row">
            <% 
            local activeCols = 0
            for i=1, string.len(activetab) do
            	if string.sub(activetab,i,i)=='1' then
					activeCols = activeCols + 1
				end
            end 
            colWidth = 100 / activeCols %>
            <% for k,coluna in ipairs(tabela) do %>
            <% if string.sub(activetab,k,k)=='1' then %>
                <div class="panel panel-default" style="float: left; width: <%= colWidth%>%;" > 
					<div class="panel-heading">
						<?= coluna.icon ?>&nbsp<?= coluna.nome ?>
						<td><a href="?r=main&col=<%=k%>&action=down&id=0&activetab=<%= activetab%>" title="Minimizar coluna"><span class="fa fa-minus-square pull-right" ></span></a> </td>
				  	</div>
					<div class="panel-body" style="padding-top: 1px;">					
						<table class="table">
					    <% for j,linha in ipairs(coluna) do  %>
	                	<tr> 
							<td> 
								<a  href="<?=coluna.url ..'&id='.. linha.id ?>" title="<?= linha.created:sub(1,19)..'\n'..(linha.description or '--')..'\n'.. (linha.itens or '') ?>"><?= linha.nome ?></a>
								<td <%= (linha.actions and 'width="'..(#linha.actions * 40)+20 ..'px"') or ''	 %>>
									<a href="#" onclick="return popup('confirm','Apagar item?','Apagar  ``<%= linha.nome %>´´ de <%= coluna.nome%>?','?r=main&col=<%=k%>&action=del&id=<%= linha.id%>')" title="Apagar"><span class="fa fa-trash-o pull-right"></span></a>
									<% if linha.actions then 
											for a,act in ipairs(linha.actions) do %>
												<a href="<%=act.href%>" <%= (act.onclick and ('onclick="'..act.onclick ..'"')) or ''%> title="<%=act.title%>"><span class="<%=act.icon%>">&nbsp</span></a>
									<%		end
										end %>
								</td>
							</td> 
						</tr>
	                    <% end %>
						</table>
				  	</div>
					<div class="panel-footer">
						<td>Novo</td><td><a href="<?=coluna.url ?>" title="Criar novo"><span class="fa fa-plus pull-right"></span></a></td>
				  	</div>
				</div>
		    <% end %>
		    <% end %>
        </div>
<!--
		<div class="row">
			<div class="col-md-6">
				<a type="button" class="btn btn-default btn-lg btn-block" href="?r=main/monitoramento">
  					Monitoramento 
				</a>
			</div>
			<div class="col-md-6">
				<a type="button" class="btn btn-default btn-lg btn-block" href="?r=main/agenda">
  				Agenda 
				</a>
			</div>
		</div>
-->
</div>

<script>
function viewDep(obj,idx,objId){
	$.post("?r=main/createTable",
			{consType: 2,
			ObjId: idx,
			ItemId: objId},
			function (data,status){procCreateTable(data, status)}
			);
}

function procCreateTable(data,status) {
	//alert(data);
	var info = JSON.parse(data);
	$('#hdName').html(info[0][0]);
	$('#hdDate').html(info[0][1]);

	var textHTML = '';
	textHTML = textHTML+garfield_js(info,"col",1);
	popup('alert','Dependências',textHTML);

}

function createTable(){
}

function garfield_js(field,prevLevel,prevDeph){
	var str = "";
	var i;
	var level=''
	var deph=prevDeph+1
	
	if (prevLevel == "row"){
		level = "col";
	} else {
		level = "row";
	}

	if(typeof field == "string"){
		if (level == "row"){
			str = str +'<tr><td style="padding-left: 3px; padding-right: 10px;">'+ field + '</td></tr>';
		} else {
			str = str + "<td>" + field + "</td>";
		}
	} else {
		if (level == "row"){
			str = str + '<tr ><td style="border: 1px solid lightgray;"><table><tr>';
			for(i=0;(field).length > i;i++){
					str = str + garfield_js(field[i],level,deph);
			}
			str = str + "</tr></table></td></tr>";
		} else {
			str = str + '<td ><table>';
			for(i=0;(field).length > i;i++){
					str = str + garfield_js(field[i],level,deph);
			}
			str = str + "</table></td>";		
		}
	}
	return str;
}
</script>
		