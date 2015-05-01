
tables:
----

nodestype = types of nodes on a network, provided by the admin
network = a network, with nodes in a certain topology, provided by the admin
nodestatus = a status of a certain node on a network
userfiles = the files of a user in relation to a nodestype
netconfignodes =  

session
----

table with

session.uid = id of the user of the session (from get_users)
session.netid = the id of the chosen network (from )
session.netversion = the version of the chosen network

utilidades.lua:
----

```lua
function get_all(cursor,dest) --> table of rows
function slot2date(slot) --> year,month,day,hour,minute
function date2slot(year,month,day,hour,minute) --> slot

function connect() --> env,con 
function close_connect(env,con)



function insert_users(con,login,name,accesslevel,password)
function get_users(con,login,password)
function delete_users(con,uid)

function get_targets(con,session)
function insert_targets(con,description)
function delete_targets(con,nodetype)
--[[
    network node = {nodeid, nodetype, statusid, location, posx, posy, posz}
--]]
function get_network(con,session)
function insert_network(con,session)
function delete_network(con,session)


function get_netconfig(con,session)
--[[
    cname: string
    description: string
    netconfignodes: table of netconfignode
        
    netconfignode: table
    with 
        netconfignode.nodeid: int
        netconfignode.default: bool
        netconfignode.fileid: int
        netconfignode.logicid: int
        netconfignode.selected: bool
--]]
function insert_netconfig(con,session,cname,description,netconfignodes)
function update_netconfig_node(con,nodeid,netconfignode)
function delete_netconfig(con,netconfigid)

function get_userfiles(con,session)
function get_userfiles_target(con,session,target)
function insert_userfiles(con,session,nodetype,filename,bindata)
function update_userfiles_filename(con,fileid,filename)
function delete_userfiles(con,fileid)

function get_config(con,session)
function insert_config(con,session,netconfigid,scrptid,cname,description)
function delete_config(con,configid)

function get_tests(con,session)
function insert_tests(con,session,configid,idagenda,cname,description)
function delete_tests(con,testeid)

--
function get_planos(con,session)
function get_agendas(con,session)
--[[
    startslot is a slot given by date to slot
    duration is an int representing the amount of cells after startslot
        e.g. to insert reserve from 14:00 to 15:00 
                (14:00-14:30 and 14:30-15:00)
             startslot = date2slot(year,month,day,14,00)
             duration = 2
--]]
function insert_agendas(con,session,cname,description,startslot,duration)--
function delete_agendas(con,session,idagenda)
function get_scripts(con,session)
function insert_scripts(con,session,cname,description) --> id
function update_scripts_name(con,scriptid,name)
function update_scripts_description(con,scriptid,description)
function delete_scripts(con,scriptid)

function get_log(con,idteste,session)
--[[
request the data from line to the end
--]]
function get_log_delta(con,idteste,session,line)
```
