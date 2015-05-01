
<div class="col" style="padding-top: 3px;">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading" style="min-width:800px">
			<table ><tr>
				<td style="padding-right: 80px;">
					<input type="button" id="btnStop" class="btn btn-default" disabled value="Parar" onclick="sendTBControl(<%=session.netid%>,1);">
					<input type="button" id="btnStart" class="btn btn-default" disabled value="Reiniciar" onclick="sendTBControl(<%=session.netid%>,0);">
					Teste atual: <input type="text" id="testid" readonly value="--" size="20" style="border: 0px; background: transparent;" >
				</td>
				<td>
			      	Relógio do Servidor: <input type="text" id="servTime" readonly value="0" size="20" style="border: 0px; background: transparent;" >
					<i id="waitChar" class="fa fa-refresh fa-spin"></i>
				</td>
			</tr></table>
		</div>
		<div class="panel-body">
			<%
			local wdt1='50px'
			local wdt2='150px'
			local wdt3='30px'
			local wdt4='60px'
			%>
			<div>
				<div class="col">
			      <table>
				      	<th hidden width='<%= wdt1 %>'>seq</th>
				      	<th width='<%= wdt2 %>'>Data/Hora</th>
				      	<th width='<%= wdt3 %>'>Nó</th>
				      	<th width='<%= wdt4 %>'>Tipo</th>
				      	<th >Mensagem</th>
			      </table>
				</div>
				<div id="dataArea"class="col" style="overflow-y: scroll; overflow-x: hidden; display: block;">
			      <table id='logTable'>
			      </table>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
window.onload = function() {
	$('#dataArea').css('height', (window.innerHeight-200)+'px');
	getServerTime();
	getTestLog();
};
window.onresize = function() {
	$('#dataArea').css('height', (window.innerHeight-200)+'px');
}

	var servClockDelta = 0;
	var getTestLogPeriod=1000;
	var testid = 0

	function getTestLog(){
		//document.getElementById('waitChar').style.visibility="visible";
		var last_logseq=$('#logTable tr:first td:eq(0)').text();
		if (!last_logseq) {last_logseq="0";}
		$.post("?r=main/getTestLog",
			{last_logseq: last_logseq, cmd: 'TEST'},
			function(data, status){appendData(data,status)}
			);		
	}

	function appendData(data,status){
		//document.getElementById('waitChar').style.visibility="hidden";
		// get testid, line count, and test name from 1st line of data: "<!-- xx yy *** name -->"
		if (data.length > 5) {
			setTimeout(getTestLog, 1000);
			var params = (data.substring(4, data.indexOf("***"))).trim(); 
			var testname = (data.substring(data.indexOf("***")+3, data.indexOf("-->"))).trim(); 
			//$('#testid').val(params);
			var values = params.split(" "); // [0]=testid, [1]=lines
			if (Number(values[0]) == 0) {
				$('#testid').css('color', 'red');
				$('#testid').val("nenhum teste.");
				$('#btnStop').attr("disabled", "disabled");
				$('#btnStart').attr("disabled", "disabled");
			} else {
				if (Number(values[0]) > testid) {
					testid = Number(values[0]); 
					$('#testid').val(testname);
					$('#btnStop').removeAttr("disabled");
					$('#btnStart').removeAttr("disabled");
					}
			}
			$('#logTable').prepend(data);
		} else {
			// Exit from current page to main index (login)
		    window.open ('?r=main','_self',false);
		}
	}

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

	function sendTBControlDone(data,status){
		var values = data.split("@$");
		var stat = Number((values[0]).trim());
		var errmsg= values[1];
		if (stat>0){popup('alert','Aviso',errmsg);}
	}
	
	function sendTBControl(netid,action){
		$.post("?r=main/sendTBControl",
			{action: action, testid: testid, netid: netid},
			function(data, status){sendTBControlDone(data,status)}
			);		
	}

	function date2str(d){
		return ((d.getDate()+100)+'').substring(1,3)+'/'+((d.getMonth()+101)+'').substring(1,3)+'/'+d.getFullYear()+' '+ 
					((d.getHours()+100)+'').substring(1,3)+':'+((d.getMinutes()+100)+'').substring(1,3)+':'+((d.getSeconds()+100)+'').substring(1,3);
	}

</script>