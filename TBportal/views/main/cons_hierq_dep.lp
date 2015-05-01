<% if alert then %>
	<script> popup('alert','Aviso',"<%= alert %>");</script> 
<% end %>


<div style="padding-top: 10px;">
<table><tr><td>
	<form method="post">
		<div class="panel panel-default" style="float: left;">
			<div class="panel-body">
				<table>
					<tr><td>
						<input type="radio" name="consType" onclick="objectLoad()" value="1" checked> Hierarquia
						<br>
							<input type="radio" name="consType" onclick="objectLoad()" value="2"> Dependência
						</br>
					</td>
					<td>
						<select name="objType" id="objType" style="width: 150px" onchange="itemsLoad()" >
						</select>
					</td>
					<td>
						<select name="itemsList" id="itemsList" style="width: 200px">
						</select>
					</td>
					<td>
						<input type="button" class="btn btn-default" name='btnConsultDep' id="btnConsultDep" onclick="test()" value="Consultar">
					</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</td></tr><tr><td>
	<div class="panel panel-default" id="panel" hidden style="float: left;">
		<div class="panel-heading">
			<table>
				<tr><td id="hdType"> </td></tr> 
				<tr style="font-size: 20px;"><td id="hdName" style="width: 200px"></td></tr>
				<tr><td id="hdDate"> </td></tr> 
			</table>
		</div>
		<div class="panel-body" id="data">
		
		</div>
	</div>
</td></tr>
</table>
</div>

<script>
function test(){
	createTable();
}

window.onload=function(){               
	objectLoad();
  } 
  
  
function procObjectLoad (data, status) {
	var info = JSON.parse(data);
	
	var i;
	$('#objType').html("");
	
	for(i=0;i<(info.data).length;i++) {
		$('#objType').append("<option value='"+info.data[i].id+"'> "+info.data[i].name+"</option>")
	}
	$("#objType option:selected");
	itemsLoad();
}

function objectLoad() {
	$.post("?r=main/objectLoad",
			{consType: $('input[name=consType]:checked').val()},
			function (data,status){procObjectLoad(data, status)}
			);
}

function procItemsLoad(data,status) {
	var info = JSON.parse(data);
	var i;
	$('#itemsList').html("");
	for(i=0;i<(info.data).length;i++) {
		$('#itemsList').append("<option value='"+info.data[i].id+"'> "+info.data[i].name+"</option>")
	}
	$("#itemsList option:selected");
}

function itemsLoad(){
	$.post("?r=main/itemsLoad",
			{id: $('#objType').val()},
			function (data,status){procItemsLoad(data, status)}
			);
}

function procCreateTable(data,status) {
	//alert(data);
	var info = JSON.parse(data);
	var hdType="Dependência:";
	if ($('input[name=consType]:checked').val()==1)  hdType="Hierarquia:";
	$('#hdType').html(hdType);
	$('#hdName').html(info[0][0]);
	$('#hdDate').html(info[0][1]);

	var str1 = '';
	str1 = str1+garfield_js(info[1],"row",1);
	$('#data').html(str1);
	$('#panel').show();
}

function createTable(){
	$.post("?r=main/createTable",
			{consType: $('input[name=consType]:checked').val(),
			ObjId: $('#objType').val(),
			ItemId:$('#itemsList').val()},
			function (data,status){procCreateTable(data, status)}
			);
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