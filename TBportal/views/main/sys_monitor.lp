
<div class="col" style="padding-top: 3px;">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading" style="min-width:800px">
		      	Relógio do Servidor: <input type="text" id="servTime" readonly value="0" size="20" style="border: 0px; background: transparent;" >
				<i id="waitChar" class="fa fa-refresh fa-spin"></i>
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
};
window.onresize = function() {
	$('#dataArea').css('height', (window.innerHeight-200)+'px');
}

	var servClockDelta = 0;
	var getTestLogPeriod=1000;
	var testid = 0
	var offset = 0
	var current_logseq=0

	function getTestLog(){
		//document.getElementById('waitChar').style.visibility="visible";
		var last_logseq=current_logseq;
		if (offset == 0) {last_logseq = $('#logTable tr:last td:eq(0)').text();}
		current_logseq = last_logseq;
		if (!last_logseq) {last_logseq="0";}
		$.post("?r=main/getTestLog",
			{last_logseq: last_logseq, cmd: 'SYS', offset: offset},
			function(data, status){appendData(data,status)}
			);		
	}

	function appendData(data,status){
		//document.getElementById('waitChar').style.visibility="hidden";
		// get line count, and offset from 1st line of data: "<!-- xx yy -->"
		if (data.length > 5) {
			var params = (data.substring(4, data.indexOf("-->"))).trim(); 
			var values = params.split(" "); // [0]=lines, [1]=offset
			if (Number(values[0])>0) {
				$('#logTable').append(data);
				$('#dataArea').scrollTop($('#dataArea')[0].scrollHeight);
			}
			offset = Number(values[1]);
 			if (offset > 0) {
				getTestLog();
			} else {
				setTimeout(getTestLog, 1000);
			}
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
		// now can get log data
		getTestLog();
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

</script>