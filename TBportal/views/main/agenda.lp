<% if agenda.alert then %>
	<script> popup('alert','Aviso',"<%= agenda.alert %>");</script> 
<% end %>

<div class="row">
<div class="col" style="float: left; padding-top: 2px;">
<table>
<tr><td>
	<form method="post">
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
	    		<h4>Dados da agenda</h4>
	  		</div>
			<div class="panel-body">
				<table>
					<tr><td>Nome: (max 20 caracteres)</td></tr>
					<tr><td style="padding-left: 20px;"><input type="text" name="name" id="name" placeholder="Nome da agenda." required="true" maxlength="20" size="28" value="<%= (agenda and agenda.name) or '' %>"></td></tr>
					<tr><td>Descrição:</td></tr>
					<tr><td style="padding-left: 20px; padding-bottom: 20px;"><input type="text" name="description" id="description" placeholder="Descrição da agenda." size="28" value="<%= (agenda and agenda.description) or '' %>"></td></tr>	
					<tr><td>
						<table>					
							<tr>
								<td>Slot inicial:</td>
								<td><input type="text"   name="startslot_str" id="startslot_str"  readonly="value" title="O valor do slot inicial é selecionado com o primeiro click na agenda. Selecione <Limpar> para poder selecionar um novo valor." placeholder="Slot inicial da agenda." required maxlength="16" size="20" value="<%= (agenda and agenda.startslot_str) or '' %>">
									<input type="hidden" name="startslot"     id="startslot" value="<%= (agenda and agenda.startslot) or '' %>">
									<input type="hidden" name="startslot_dt"  id = "startslot_dt" value="<%= (agenda and agenda.startslot_dt and agenda.startslot_dt ..'Z') or '' %>">
								</td>
							</tr>
							<tr>
								<td>Slot final:</td>
								<td><input type="text" 	 name="endslot_str" id = "endslot_str"  readonly="value" title="O valor do slot final é selecionado com qualqer click na agenda após o primeiro click." placeholder="Slot final da agenda." required maxlength="16" size="20" value="<%= (agenda and agenda.endslot_str) or '' %>">
									<input type="hidden" name="endslot"     id = "endslot"   value="<%= (agenda and agenda.endslot) or '' %>">
									<input type="hidden" name="endslot_dt"  id = "endslot_dt" value="<%= (agenda and agenda.endslot_dt and agenda.endslot_dt ..'Z') or '' %>" >
								</td>
							</tr>
							<tr>
								<td>Duração:</td>
								<td><input type="text" name="duration" id ="duration" readonly size=20 style="border: 0px; background: transparent; color:<%= (agenda and agenda.duration_color) or 'black'%>" value="<%= (agenda and agenda.duration) or '--' %>" >
								</td>
							</tr>
						</table>					
					</table>
				</div>
				<div class="panel-footer">
					<div class="col" style="float: right;">
						<input type="submit" class="btn btn-default" name="btnSave" id="btnSave" value="<%= (agenda and agenda.idagenda and 'Atualizar') or 'Salvar' %>" <%= (agenda and agenda.btnSave and agenda.btnSave=='false' and 'enabled') or 'disabled' %>/>
					</div>
					<div class="col" >
						<input type="button" class="btn btn-default" value="Limpar slots" onclick="clearSlot()">&nbsp&nbsp
						<input type="hidden" name="idagenda" id="idagenda" value="<%= (agenda and agenda.idagenda) or '' %>" />
				    	<input type="hidden" name="action" id="action" value="<%= (agenda and agenda.idagenda and 'update') or 'save' %>" />
					</div>
				</div>
		</div>
	</form>
</td></tr>
<tr><td>
	<form  method="post">
		<div class="panel panel-default" style="float: left;">
			<div class="panel-heading">
	    		<h4>Buscar novo período</h4>
	  		</div>
			<div class="panel-body">
				<table>
					<tr><td>Dia:</td><td>Mês:</td><td>Ano:</td></tr>
					<tr>
						<td><input type="number" maxlength="2" style="width:40px;" name="nd_day" id="nd_day" min="1" max="31" step="1" value="<%= slots.refDate.day %>">&nbsp</td>
						<td><input type="number" maxlength="2" style="width:40px;" name="nd_month" id="nd_month" min="1" max="12" step="1" value="<%= slots.refDate.month %>">&nbsp</td>
						<td><input type="number" maxlength="4" style="width:60px;" name="nd_year" id="nd_year" min="<%= os.date("*t").year%>" max="<%= os.date("*t").year + 1%>" step="1" value="<%= slots.refDate.year %>"></td>
					</tr>
				</table>
				<table>
					<tr><td style="padding-top: 10px;">Relógio do Servidor: </td></tr>
			      	<tr><td><input type="text" id="servTime" readonly value="0" size="20" style="border: 0px; background: transparent;" > </td></tr>
				</table>
				<input type="hidden" name="nd_idagenda" id="nd_idagenda" />
			    <input type="hidden" name="nd_action" id="nd_action" />
			    <input type="hidden" name="nd_name" id="nd_name" />
			    <input type="hidden" name="nd_description" id="nd_description" />
		
			    <input type="hidden" name="nd_startslot_str" id="nd_startslot_str" />
			    <input type="hidden" name="nd_startslot" id="nd_startslot" />
			    <input type="hidden" name="nd_startslot_dt" id="nd_startslot_dt" />
			    <input type="hidden" name="nd_endslot_str" id="nd_endslot_str" />
			    <input type="hidden" name="nd_endslot" id="nd_endslot" />
			    <input type="hidden" name="nd_endslot_dt" id="nd_endslot_dt" />
			    <input type="hidden" name="nd_duration" id="nd_duration" />
			    <input type="hidden" name="nd_duration_color" id="nd_duration_color" />
			</div>
			<div class="panel-footer">
				<div class="col" style="float: right;">
					<input type="submit" class="btn btn-default" value="Buscar" name="nd_newdate" id="btnNewDate" onclick="copyValues()">
				</div>
				<div class="col" >
					<input type="button" class="btn btn-default" value="Hoje" onclick="setToday()">&nbsp&nbsp
				    <input type="hidden" name="nd_btnSave" id="nd_btnSave" />
				</div>
			</div>
		</div>
	</form>
</td></tr>
</table>
</div>
<div class="col" style="float: left; width:20px;" >
	&nbsp
</div>
<div class="col" style="float: left; padding-top: 3px;">
			<div>
				<table cellpadding = "0"  border="1" style=" background-color: #f5f5f5; border: 1px solid #dddddd">
					<tr>
						<th style=" border: 1px solid #dddddd"></th>
						<% for i=slots.offset,slots.offset+(6*48),48 do %>
			          		<th style=" border: 1px solid #dddddd"> &nbsp<%=slots[i].day .."/".. slots[i].monthstr .."/".. slots[i].year:sub(3,4) %>&nbsp</th>
			    		<%end%>
					</tr>
			  		<tr style=" border: 1px solid #dddddd">
			  			<td width="50" style=" border: 1px solid #dddddd"><font size="2">&nbsp</font></td>
			    		<% for i=slots.offset,slots.offset+(6*48),48 do %>
			          		<td width="83" align="center" style=" border: 1px solid #dddddd"><font size="2" > &nbsp<%=slots[i].wdaystr %>&nbsp</font></td>
			    		<%end%>  
					</tr>
			    </table>
			</div>
			<div id="agendaData"  style="float: left; overflow-y: scroll; overflow-x: hidden; display: block;">
				<table cellpadding = "0"  border="1" style=" border: 1px solid #dddddd">
					<% for i=1,48 do %>
						<tr>
							<%if (i%2 == 1) then %>
			                	<td width="50px" rowspan="2" style=" border: 1px solid #dddddd"><font size="3">&nbsp<%= slots[i].hour..":"..slots[i].min %>&nbsp</font></td>
			                <%end%>
			        		<% for j=slots.offset,slots.offset+(6*48),48 do
			        			 local click=false
			                  	 cell_color =  "#8DD1A4" -- Verde 
			                     if slots[j+i-1].enabled == "f" then
			                        	cell_color = "#a0a0a0" -- Cinza
			                     end
			                	 if slots[j+i-1].used == "t" then
			                    	if slots[i+j-1].isowner=="t" then
			                        	cell_color = "#66A3FF" -- Azul
			                        else
			                        	cell_color = "#a0a0a0" -- Cinza
			                        end
			                     end
			                     if (slots[j+i-1].enabled == "t" and (slots[j+i-1].used == "f" or (agenda and agenda.name and slots[i+j-1].isowner=="t") )) then
									click=true
			                     end
			                   %>
			                 	<td  id="<%='slot_'..slots[i+j-1].slot%>" width='83px'  bgcolor='<%= cell_color%>' style=" border: 1px solid #dddddd">
			                 		<a 	id="<%='slot_a_'..slots[i+j-1].slot%>"
			                 			title="<%= slots[i+j-1].day..' '..slots[i+j-1].hour.."h"..slots[i+j-1].min%>" 
			                 			style="display: block; height:<%=(agenda.size or '14')%>px;" 
			                 			<% if click then %>
			                 				onclick="setSlot('<%= slots[i+j-1].day..'/'..slots[i+j-1].month..'/'..slots[i+j-1].year..' '..slots[i+j-1].hour.."h"..slots[i+j-1].min%>','<%= slots[i+j-1].slot%>','<%= slots[i+j-1].year..'-'..slots[i+j-1].month..'-'..slots[i+j-1].day..'T'..slots[i+j-1].hour..":"..slots[i+j-1].min%>');"
										<% end %>
			                 			>
			        				</a>
			                 	</td>
			          		<% end %>
			          	</tr>
					<% end %>   
				</table>
			</div>
</div>
</div>

<script>
window.onresize = function() {
	$('#agendaData').css('max-height', (window.innerHeight-146)+'px');
}
window.onload = function() {
	$('#agendaData').css('max-height', (window.innerHeight-146)+'px');
	getServerTime();
	markSlot();
};

//******************
// Server time control
//******************

	var servClockDelta = 0;

	function calcClockDelta(data,status){
		var serverDate_x = new Date(data+"Z");
		var serverDate = new Date(serverDate_x.getTime() + serverDate_x.getTimezoneOffset()*60*1000);
		var clientDate = new Date();
		servClockDelta = clientDate.getTime() - serverDate.getTime();
		servClock();
		setInterval(servClock, 1000);
	}
	
	function getServerTime(){
		$.post("?r=main/getServerTime",
			{id: '1'},
			function(data, status){calcClockDelta(data,status)}
			);		
	}

	function servClock(){
		var localDate = new Date();
		var servDate = new Date(localDate.getTime()-servClockDelta);
		$('#servTime').val(date2str(servDate));	
	}	

	function date2str(d){
		return ((d.getDate()+100)+'').substring(1,3)+'/'+((d.getMonth()+101)+'').substring(1,3)+'/'+d.getFullYear()+' '+ 
					((d.getHours()+100)+'').substring(1,3)+':'+((d.getMinutes()+100)+'').substring(1,3)+':'+((d.getSeconds()+100)+'').substring(1,3);
	}

//******************
// Agenda control
//******************
	
	function setSlot(slotText,slot, slotdate){
		slotdate = slotdate+'Z'
		if (document.getElementById('startslot_str').value==="") {
			document.getElementById('startslot_str').value=slotText;
			document.getElementById('startslot').value=slot;
			document.getElementById('startslot_dt').value=slotdate;
			changeColor(slot,1);
		} 
		
			if (document.getElementById('endslot').value != ''){
				var start_dt = new Date(document.getElementById('startslot_dt').value);
				var end_dt   = new Date(document.getElementById('endslot_dt').value);
				var startx = start_dt.getTime() + (start_dt.getTimezoneOffset()*60*1000) + (30*1000*60);
				var endx = end_dt.getTime() + (end_dt.getTimezoneOffset()*60*1000);
				for (t=startx;t<=endx;t=t+(30*1000*60)){
					var slotx = date2slot(t);
					changeColor(slotx,-1);
				}
			}
			document.getElementById('endslot_str').value=slotText;
			document.getElementById('endslot').value=slot;
			document.getElementById('endslot_dt').value=slotdate;

			var start_dt = new Date(document.getElementById('startslot_dt').value);
			var end_dt   = new Date(document.getElementById('endslot_dt').value);
			var minutos = 30 + ((end_dt - start_dt)/1000/60)
			if (minutos > 0){
				document.getElementById('duration').value =  Math.floor(minutos/60/24) + 'd '+ Math.floor(minutos/60)%24 + 'h '+ minutos%60+'min';
				document.getElementById('duration').style.color='';
				var startx = start_dt.getTime() + (start_dt.getTimezoneOffset()*60*1000) + (30*1000*60);
				var endx = end_dt.getTime() + (end_dt.getTimezoneOffset()*60*1000);
				var allFree=0;
				for (t=startx;t<=endx;t=t+(30*1000*60)){
					var slotx = date2slot(t);
					changeColor(slotx,1);
					if ($('#'+'slot_a_'+slotx).attr("onClick") == undefined) allFree=allFree+1;
				}
				if (allFree==0)
					document.getElementById('btnSave').disabled='';
				else {
					beep();
					document.getElementById('duration').value =  "Seleção inválida.";
					document.getElementById('duration').style.color='red'
					document.getElementById('btnSave').disabled='disabled'
				}

			} else {
				beep();
				document.getElementById('duration').value =  "Slot final antes do inicial";
				document.getElementById('duration').style.color='red'
				document.getElementById('btnSave').disabled='disabled'
			}
	}
	
	function markSlot(){
		if (document.getElementById('startslot').value != ''){
			var start_dt = new Date(document.getElementById('startslot_dt').value);
			var slotx = date2slot(start_dt.getTime()+(start_dt.getTimezoneOffset()*60*1000));
			changeColor(slotx,1);
		}
		if (document.getElementById('endslot').value != ''){
			var start_dt = new Date(document.getElementById('startslot_dt').value);
			var end_dt   = new Date(document.getElementById('endslot_dt').value);
			var startx = start_dt.getTime() + (start_dt.getTimezoneOffset()*60*1000) + (30*1000*60);
			var endx = end_dt.getTime() + (end_dt.getTimezoneOffset()*60*1000);
			for (t=startx;t<=endx;t=t+(30*1000*60)){
				var slotx = date2slot(t);
				changeColor(slotx,1);
			}
		}
	}
	
	function clearSlot(){
		if (document.getElementById('startslot').value != ''){
			var start_dt = new Date(document.getElementById('startslot_dt').value);
			var slotx = date2slot(start_dt.getTime()+(start_dt.getTimezoneOffset()*60*1000));
			changeColor(slotx,-1);
		}
		if (document.getElementById('endslot').value != ''){
			var start_dt = new Date(document.getElementById('startslot_dt').value);
			var end_dt   = new Date(document.getElementById('endslot_dt').value);
			var startx = start_dt.getTime() + (start_dt.getTimezoneOffset()*60*1000) + (30*1000*60);
			var endx = end_dt.getTime() + (end_dt.getTimezoneOffset()*60*1000);
			for (t=startx;t<=endx;t=t+(30*1000*60)){
				var slotx = date2slot(t);
				changeColor(slotx,-1);
			}
		}
		$( '#startslot_str' ).val('');
		//document.getElementById('startslot_str').value='';
		document.getElementById('startslot').value='';
		document.getElementById('startslot_dt').value='';

		document.getElementById('endslot_str').value='';
		document.getElementById('endslot').value='';	
		document.getElementById('endslot_dt').value='';
		document.getElementById('duration').value='--';
			
		document.getElementById('btnSave').disabled='disabled'
	}
	
	function copyValues(){
		clearSlot()
		document.getElementById('nd_idagenda').value = document.getElementById('idagenda').value;
		document.getElementById('nd_action').value = document.getElementById('action').value;
		document.getElementById('nd_name').value = document.getElementById('name').value;
		document.getElementById('nd_description').value = document.getElementById('description').value;

		document.getElementById('nd_startslot_str').value=document.getElementById('startslot_str').value;
		document.getElementById('nd_startslot').value=document.getElementById('startslot').value;
		document.getElementById('nd_startslot_dt').value=document.getElementById('startslot_dt').value;

		document.getElementById('nd_endslot_str').value=document.getElementById('endslot_str').value;
		document.getElementById('nd_endslot').value=document.getElementById('endslot').value;
		document.getElementById('nd_endslot_dt').value=document.getElementById('endslot_dt').value;

		document.getElementById('nd_duration').value =  document.getElementById('duration').value;
		document.getElementById('nd_duration_color').value =  document.getElementById('duration').style.color;
		document.getElementById('nd_btnSave').value=document.getElementById('btnSave').disabled;
	
	}
	function setToday(){
		var d = new Date();
		document.getElementById('nd_day').value=d.getDate();
		document.getElementById('nd_month').value=d.getMonth()+1;
		document.getElementById('nd_year').value=d.getFullYear();
	}

	function changeColor(slot,flag){
		var rgb = $('#'+'slot_'+slot).css("background-color");
		rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
		var newColor='rgb('+(Number(rgb[1])+(100*flag))+','+rgb[2]+','+rgb[3]+')'; 
		$('#'+'slot_'+slot).css("background-color",newColor);
	}

	function date2slot(ms){
		var d = new Date(ms);
		var slot = d.getFullYear()+((d.getMonth()+101)+'').substring(1,3)+((d.getDate()+100)+'').substring(1,3)+ 
					((d.getHours()+100)+'').substring(1,3) + ((d.getMinutes()+100)+'').substring(1,3); 
		return slot;
	}

function beep() {
  (new
	Audio(
	"data:audio/wav;base64,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 /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VEFHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU291bmRib3kuZGUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMjAwNGh0dHA6Ly93d3cuc291bmRib3kuZGUAAAAAAAAAACU="
	)).play();
}
</script>	