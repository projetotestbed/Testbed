
<% if (log and log.alert) then %>
	<script> popup('alert','Aviso',"<%= log.alert %>");</script> 
<% end %>

<div class="col" style="padding-top: 3px;">
	<div class="panel panel-default" style="float: left;">
		<div class="panel-heading" style="min-width:800px">
			<table ><tr>
				<td style="padding-right: 150px;">
					<h4>Visualização do log do teste:</h4>
					<h4><%= log.testname %></h4>
				</td>
				<td style="padding-right: 30px;">
					<table>
						<tr><td>Início:</td><td ><%= log.starttime %></td></tr>
						<tr><td>Fim:</td><td><%= log.endtime %></td></tr>
						<tr><td>Duração:</td><td><%= log.duration %></td></tr>
					</table>
					<progress id="loadbar" style="width: 170px; height: 5px;" value="0" max="<%=log.total%>"></progress>
				</td>
				<td>
			    	<form  method="post">
			    		<input type="hidden" id="testid" name="testid" value="<%= log.testid%>" >
			    		<input type="submit" class="btn btn-default" value="Download" >
			    	</form>
				</td>
				<td style="padding-left: 10px;">
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
	$('#dataArea').css('height', (window.innerHeight-240)+'px');
	getTestLog();
};
window.onresize = function() {
	$('#dataArea').css('height', (window.innerHeight-240)+'px');
}

	var servClockDelta = 0;
	var testid = 0
	var offset = 0
	var current_logseq=0
	var loadedLines=0;

	function getTestLog(){
		//document.getElementById('waitChar').style.visibility="visible";
		var last_logseq=current_logseq;
		if (offset == 0) {last_logseq = $('#logTable tr:last td:eq(0)').text();}
		current_logseq = last_logseq;
		if (!last_logseq) {last_logseq="0";}
		testid = $('#testid').val();
		$.post("?r=main/getTestLog",
			{last_logseq: last_logseq, cmd: 'TEST', offset: offset, testid: testid},
			function(data, status){appendData(data,status)}
			);		
	}

	function appendData(data,status){
		//document.getElementById('waitChar').style.visibility="hidden";
		// get testid, line count, offset, and test name from 1st line of data: "<!-- xx yy zz *** name -->"
		if (data.length > 5) {
			var params = (data.substring(4, data.indexOf("***"))).trim(); 
			var testname = (data.substring(data.indexOf("***")+3, data.indexOf("-->"))).trim(); 
			//$('#testid').val(params);
			var values = params.split(" "); // [0]=testid, [1]=lines, [2]=offset			
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
			if (Number(values[1])>0) {
				$('#logTable').append(data);
				//$('#dataArea').scrollTop($('#dataArea')[0].scrollHeight);
				loadedLines = loadedLines + Number(values[1]);
				$('#loadbar').val(loadedLines);
			}
			offset = Number(values[2]);
 			if (offset > 0) {
				getTestLog();
			} else {
				//setTimeout(getTestLog, 1000);
			}
		} else {
			// Exit from current page to main index (login)
		    window.open ('?r=main','_self',false);
		}
	}


</script>