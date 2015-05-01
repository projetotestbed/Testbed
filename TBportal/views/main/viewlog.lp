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
				</td>
				<td>
			    	<form  method="post">
			    		<input type="hidden" name="testid" value="<%= log.testid%>" >
			    		<input type="submit" class="btn btn-default" value="Download" >
			    	</form>
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
			      	<%= log.data %>
			      </table>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
window.onload = function() {
	$('#dataArea').css('height', (window.innerHeight-240)+'px');
};
window.onresize = function() {
	$('#dataArea').css('height', (window.innerHeight-240)+'px');
}
</script>