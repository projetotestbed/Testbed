<%
local fontStyle={
	['0']='color:black;',
	['1']='color:gray;',
	['2']='color:gray;text-decoration:line-through;'
}
%>
            <% if motes then 
              	for moteIdx,mote in pairs(motes) do %>

                  <tr style="border-bottom: 1px solid #CCCCCC;" <%= (mote.statusid=='2' and 'hidden') or ''%>>
                    <td style="text-align:center; width:53px; <%= fontStyle[mote.statusid] or '' %>">
	                  <%= mote.nodeid %>
                      <input type="hidden"  name="nodeid" value ="<%= mote.nodeid%>" />
                      <input type="hidden"  id="<%='statusid'..moteIdx%>" value ="<%= mote.statusid%>" />
                    </td>
                    <td style="text-align:center; width:66px;" >
                      <input type="text" name="logicid" <%= ((mote.statusid == '2') and 'readonly') or ''%> placeholder ="<%= mote.nodeid%>" value ="<%= (netconfig and netconfig.nodes and netconfig.nodes[mote.nodeid] and netconfig.nodes[mote.nodeid].logicid) or mote.nodeid %>" required maxlength="5" size="5"  pattern="[0-9]{1,5}" title="Digite um número: (1..65533) "/>
                    </td>
                    <td style="text-align:left; width:100px; <%= fontStyle[mote.statusid] or '' %>">
                    	<%= mote.typeshort%>
                      	<input type="hidden"  name="nodetype" value ="<%= mote.nodetype%>" >
                    </td>
                    <td style="text-align:left; width:45px; <%= fontStyle[mote.statusid] or '' %>">
                    	<%= mote.srvport%>
                      	<input type="hidden"  name="srvport" value ="<%= mote.srvport%>" >
                    </td>
					<td style="text-align:center; width:70px">
					<% 
						local sval = '1'
						local stext = 'checked'
						local sbool = ''
						local sbool2 = 'disabled'
						if netconfig.nodes then
							if netconfig.nodes and netconfig.nodes[mote.nodeid] then
								if netconfig.nodes[mote.nodeid].selected and (netconfig.nodes[mote.nodeid].selected == '0') then
									sval = '0'
									stext = ''
								end
							else
								sval = '0'
								stext = ''
							end
						end
						-- Mote state is OUT
						if mote.statusid == '2' then
							sbool = 'disabled'
							sbool2 = ''
							sval = '0'
							stext = ''
						else
							sbool = ''
							sbool2 = 'disabled'
						end
					%>
					<input type="hidden" name="selected" id="<%= 'sbx_selected'.. moteIdx %>" value="<%= sval %>"><input type="checkbox" <%= stext %> id="<%= 'sb_selected'.. moteIdx %>"
																					onclick="this.previousSibling.value=1-this.previousSibling.value" 
																					onchange="checkSelected('<%=moteIdx%>')"
																					<%=sbool%>>
					</td>
					<td style="text-align:center; width:70px">
					<% 
						local dval = '1'
						local dtext = 'checked'
						local dbool = 'disabled'
						local dbool2 = ''
						if netconfig.nodes then
							if (netconfig.nodes and netconfig.nodes[mote.nodeid]) and sval == '1' then
								if (netconfig.nodes[mote.nodeid].default) and netconfig.nodes[mote.nodeid].default == '0' then
									dval = '0'
									dtext = ''
									dbool = ''
									dbool2='disabled'
								end
							else
								dval = '1'
								dtext = 'checked'
								dbool = 'disabled'
								dbool2= ''
							end
						end
						if sval=='0' then sbool='disabled' end
					%>
					<input type="hidden" name="default" id="<%= 'sbx_default'.. moteIdx %>" value="<%= dval %>"><input type="checkbox" <%= dtext %> <%= sbool %> id="<%= 'sb_default'.. moteIdx %>"
																												  onclick="this.previousSibling.value=1-this.previousSibling.value" 
																												  onchange="checkDefault('<%=moteIdx%>')">
					</td>
                    <td style="text-align:left;">
						<input type="hidden" name='fileid' id="<%= 'sbx_fileid'.. moteIdx %>" value='-' <%= dbool2 %>>
                    	<select name='fileid' id="<%= 'sb_fileid'.. moteIdx %>" required <%= dbool %> style="width: 200px">
                          <% if arquivos then 
                            	for j,arq in pairs(arquivos) do 
                                	if arq.nodetype == mote.nodetype then 
										local selection = (((netconfig and netconfig.default and netconfig.nodes[mote.nodeid] and netconfig.nodes[mote.nodeid].fileid)==arq.fileid) and "selected") or ''
                                	%>
		                            <option value=<%= arq.fileid %> <%= selection%> ><%= arq.filename %></option>
                          <% 		end
                             	end 
                             end %>
						</select>
                    </td>
                  </tr>

          <% end 
              end %>

<script>
function checkDefault(nodeid){
	document.getElementById('sb_fileid'+nodeid).disabled=document.getElementById('sb_default'+nodeid).checked;
	document.getElementById('sbx_fileid'+nodeid).disabled=document.getElementById('sb_default'+nodeid).checked==false;
}
function checkSelected(nodeid){
	//alert(document.getElementById('sb_selected'+nodeid).checked)

	if (document.getElementById('sb_selected'+nodeid).checked) {
		document.getElementById('sb_default'+nodeid).disabled=false;
		document.getElementById('sb_fileid'+nodeid).disabled=document.getElementById('sb_default'+nodeid).checked;
		document.getElementById('sbx_fileid'+nodeid).disabled=document.getElementById('sb_default'+nodeid).checked==false;
	} else {
		document.getElementById('sb_default'+nodeid).disabled=true;
		document.getElementById('sb_fileid'+nodeid).disabled=true;
		document.getElementById('sbx_fileid'+nodeid).disabled=false;
	}
}


</script>
