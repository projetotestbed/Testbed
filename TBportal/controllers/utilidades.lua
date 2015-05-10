--TODO: remove e update checando o uid tambem, visto que o cliente pode mudar os parametros (como fileid) no browser
  local luasql = require "luasql.postgres"
  local md5 = require "md5"
  local socket = require("socket")
  
function connect() 
  -- create environment object
  local env = assert (luasql.postgres())
  -- connect to data source
    --TODO: ler de sailor.config
  local con = assert (env:connect("portal2","postgres","postgres","localhost"))
    con:setautocommit(false)
    return env,con
end
function close_connect(e,c)
    e:close()
    c:close()
end
function get_all(cursor,dest)
  local row = cursor:fetch({}, "a")
  while row do
    table.insert(dest,row)
      row = cursor:fetch({}, "a")
  end
end
function get_slots(con,session,year,month,day)
    local date = string.format("%04d%02d%02d",year,month,day)
  local cur = assert (con:execute(string.format("SELECT * from getslots('%s',%d,%d)",date,session.uid,session.netid)))
    slots = {}
    get_all(cur,slots)
    cur:close()
    slots.offset = 1
    for k, v in ipairs (slots) do
      if v.slot:sub(1,8)==date then
        slots.offset = k
        break
      end
    end
    return slots
end

function validate_user(con,login,password)
  local cur = assert (con:execute(string.format("SELECT uid,uname from users WHERE ulogin='%s' and upassword='%s'",login,md5.sumhexa(password))))
  local row = cur:fetch ({}, "a")
  cur:close()
  if row then
    return row.uid, (row.uname or login)
  end
end

function get_user_bylogin(con,ulogin)
  local user = {}
  local cur = (con:execute(string.format("SELECT uid,ulogin,uname from users WHERE ulogin='%s' ",ulogin)))
  local row = cur:fetch ({}, "a")
  cur:close()
  if row then
    user.uid = row.uid
    user.uname = row.uname
    user.ulogin = row.ulogin
  end
  return user
end

function get_userconfig(con,uid)
  local config = {}
  local cur = con:execute(string.format("SELECT cp.paramname, uc.paramvalue from userconfig as uc, configparams as cp WHERE uc.uid=%d and uc.paramid=cp.paramid",uid))
  local row = cur:fetch ({}, "a") 
  while row do
    config[row.paramname]=row.paramvalue
    row = cur:fetch ({}, "a")
  end
  cur:close()
  return config
end
function get_configparams(con)
  local params={}
  local cur = assert (con:execute(string.format("SELECT paramid, paramname  from configparams")))
  local row = cur:fetch ({}, "a") 
  while row do
    params[row.paramname]=row.paramid
    row = cur:fetch ({}, "a")
  end
  cur:close()
  return params
end

function create_user(con,ulogin,uname,password,config,userRoles,roles)
  local cur, err = con:execute(string.format("INSERT INTO users (ulogin,uname,accesslevel,upassword) VALUES ('%s','%s',500,'%s') RETURNING uid",ulogin,uname,md5.sumhexa(password)))
  local uid
  
  if cur then
    local row = cur:fetch ({}, "a")
    uid = row.uid
  else
    con:rollback();
    err = '1'
    return cur,err
  end
  
  local stat, err
  for i=1,#userRoles do
    stat, err = con:execute(string.format("INSERT INTO userroles (uid,roleid) VALUES (%d,%d)",uid,userRoles[i]))
    if not stat then 
      con:rollback(); 
      err = '2'
      return stat, err 
    end
  end
  
  local params=get_configparams(con)
  local stat, err 
  for paramname,paramvalue in pairs(config) do
    stat, err = con:execute(string.format("INSERT INTO userconfig (uid,paramid,paramvalue) VALUES (%d,%d,'%s')",uid,params[paramname],paramvalue))
    if not stat then 
      con:rollback(); 
      err = '3'
      break; 
    else 
      con:commit()
    end
  end
  return stat, err
end
function update_userconfig(con,uid,config)
  local params=get_configparams(con)
  local stat, err 
  for paramname,paramvalue in pairs(config) do
    stat, err = assert (con:execute(string.format("UPDATE userconfig SET paramvalue='%s' WHERE uid='%d' and paramid='%d'",paramvalue,uid,params[paramname])))
    if not stat then 
      con:rollback(); 
      break; 
    else 
      con:commit()
    end
  end
  return stat, err
end
function update_password(con,session,old_password,new_password)
    local stat, err = assert (con:execute(string.format("UPDATE users SET upassword='%s' WHERE uid='%d' and upassword='%s'",md5.sumhexa(new_password),session.uid,md5.sumhexa(old_password))))
    if stat then con:commit() else con:rollback() end
    return stat, err
end
function delete_users(con,uid)
  local stat, err = con:execute(string.format("DELETE FROM users WHERE uid='%d'",uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function get_targets(con,session)
  local cur = assert (con:execute(string.format("SELECT nt.nodetype,nt.short,nt.description from nodestype as nt, (select distinct nodetype from network where netid=%d and netversion=%d) as active where active.nodetype = nt.nodetype ORDER BY nt.nodetype",session.netid or 1,session.netversion or 1)))
    local targets = {}
    get_all(cur,targets)
    cur:close()
    return targets
end
function get_nodestatus(con,session)
  local cur = assert (con:execute(string.format("SELECT statusid,code,description FROM nodestatus ORDER BY statusid ASC")))
  local nodestatus = {}
  local row = cur:fetch ({}, "a") 
  while row do
    nodestatus[row.statusid+1]={}
    nodestatus[row.statusid+1].statusid=row.statusid
    nodestatus[row.statusid+1].code=row.code
    nodestatus[row.statusid+1].description=row.description
    row = cur:fetch ({}, "a")
  end
  cur:close()
  return nodestatus
end

function get_nodestype(con,session)
  local cur = assert (con:execute(string.format("SELECT nodetype,short,description from nodestype order by nodetype asc" )))
    local nodestype = {}
    get_all(cur,nodestype)
    cur:close()
    return nodestype
end

function insert_nodestype(con,session,nodestype)
  local stat, err
    for k,v in pairs(nodestype) do
      stat, err = con:execute(string.format("INSERT INTO nodestype(nodetype,short,description) VALUES (%d,'%s','%s')",v.nodetype,v.short,v.description))
       if stat == nil then break end
    end
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function update_nodestype(con,session,nodestype)
  local stat, err
    for k,v in pairs(nodestype) do
       stat, err = con:execute(string.format("UPDATE nodestype SET (short,description) = ('%s','%s') WHERE nodetype=%d ",v.short,v.description,v.nodetype))
       if stat == nil then break end
    end
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function delete_nodestype(con,session,nodetype)
  local stat, err = con:execute(string.format("DELETE FROM nodestype WHERE nodetype='%d'",nodetype))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function get_network(con,session,auxNetId,auxNetVersion)
  local cur = assert (con:execute(string.format("SELECT nw.nodeid,nw.nodetype,tp.short as typeshort,nw.statusid,nw.location,nw.posx,nw.posy,nw.posz,nw.ctlchannel, nw.datachannel, substring(nw.datachannel,'([0-9]+)') as srvport from network as nw, nodestype as tp where nw.netid=%d and nw.netversion=%d and nw.nodetype = tp.nodetype order by nw.nodeid asc",auxNetId or session.netid,auxNetVersion or session.netversion)))
  local nodes = {}
  get_all(cur,nodes)
  cur:close()
  return nodes 
end

function get_netdata(con,session,auxNetId,auxNetVersion)
  local network={}
  local cur = assert (con:execute(string.format("SELECT netid, netversion, nname, description, vdescription from networks where netid=%d and netversion=%d",auxNetId or session.netid,auxNetVersion or session.netversion)))
  local row = cur:fetch ({}, "a")
  cur:close()
  if row then
    network = row
  end
  network.nodes = get_network(con,session,auxNetId,auxNetVersion)
  return network
end

function update_netdata(con,session,network)
  local stat, err
  stat, err = con:execute(string.format("UPDATE networks SET (nname,description,vdescription) = ('%s','%s','%s') WHERE netid=%d and netversion=%d",network.nname,network.description,network.vdescription,network.netid,network.netversion))
  if stat then
    for k,v in pairs(network.nodes) do
       stat, err = con:execute(string.format("UPDATE network SET (statusid,location,posx,posy,posz,ctlchannel,datachannel) = (%d,'%s',%d,%d,%d,'%s','%s') WHERE netid=%d and netversion=%d and nodeid=%d",v.statusid,v.location,v.posx,v.posy,v.posz,v.ctlchannel,v.datachannel,network.netid,network.netversion,v.nodeid))
       if stat == nil then break end
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function insert_netversion(con,session,network)
  local stat, err
  stat, err = con:execute(string.format("INSERT INTO networks(netid,netversion,nname,description,vdescription) VALUES (%d,%d,'%s','%s','%s')",network.netid,network.netversion,network.nname,network.description,network.vdescription))
  if stat then
    for k,v in pairs(network.nodes) do
       stat, err = con:execute(string.format("INSERT INTO network (netid,netversion,nodeid,nodetype,statusid,location,posx,posy,posz,ctlchannel,datachannel) VALUES (%d,%d,%d,%d,%d,'%s',%d,%d,%d,'%s','%s')",network.netid,network.netversion,v.nodeid,v.nodetype,v.statusid,v.location,v.posx,v.posy,v.posz,v.ctlchannel,v.datachannel))
       if stat == nil then break end
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function insert_slotstemplate(con, session, netid)
  -- slottemplate
  for day=0, 6, 1 do
    for hour=0, 23, 1 do
      for min=0,30,30 do
        slot= day*10000+hour*100+min
        stat, err = con:execute(string.format([[
          INSERT INTO slotstemplate(
            slotoffset, netid, enabled, accesslevel)
          VALUES (%d, '%d', TRUE, 100)]], slot, netid))
      end
    end 
  end
  -- Reserva o slot "Domingo, 2h00" para re-start do TBControl
  stat, err = con:execute(string.format([[
    update slotstemplate set (enabled)=(FALSE) where slotoffset=%d and netid=%d]], 60200,netid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function get_roles(con)
  local roles = {}
  roles.byname = {}
  roles.byid = {}
  roles.entry = {}
  local cur = assert (con:execute(string.format("SELECT roleid,rolename,entry FROM roles")))
  local row = cur:fetch ({}, "a") 
  while row do
    roles.byid[tonumber(row.roleid)] = row.rolename
    roles.byname[row.rolename] = tonumber(row.roleid)
    roles.entry[row.rolename] = row.entry
    row = cur:fetch ({}, "a")
  end
  cur:close()
  return roles
end
function get_networks(con)
  local networks = {}
  local cur = assert (con:execute(string.format("SELECT net.netid,net.netversion,net.nname FROM networks as net, (SELECT netid,max(netversion) as netversion FROM networks GROUP BY netid ) as nid WHERE net.netid = nid.netid and net.netversion=nid.netversion ORDER BY netid")))
  local row = cur:fetch ({}, "a") 
  while row do
    table.insert(networks,{netid = row.netid,name = row.nname, netversion = row.netversion})
    row = cur:fetch ({}, "a")
  end
  cur:close()
  return networks
end

function get_netconfig(con,session)
  local netconfigs = {}
  local cur = assert (con:execute(string.format("SELECT netconfigid, netconfigid as id,cname as nome,description,created  from netconfig WHERE uid=%d and netid=%d and netversion=%d",session.uid,session.netid,session.netversion)))
  get_all(cur,netconfigs)
  cur:close()
  return netconfigs
end
function get_netconfig_byid(con,session,netconfigid)
  local netconfig={}
  if (netconfigid == nil) then return netconfig end
  local cur1 = assert (con:execute(string.format("SELECT netid,netversion,uid,cname,description FROM netconfig WHERE netconfigid = %d",netconfigid)))
  local row1 = cur1:fetch ({}, "a")
  cur1:close()
  if row1 ~= nil then
    netconfig.name = row1.cname
    netconfig.description = row1.description
    netconfig.netconfigid = netconfigid
    local cur2 = assert (con:execute(string.format("SELECT nodeid,usedefaultfile,fileid,logicid,selected FROM netconfignodes WHERE netconfigid = %d",netconfigid)))
    local row2 = cur2:fetch ({}, "a")
    netconfig.nodes={}
    while row2 do
      netconfig.nodes[row2.nodeid]={}
      netconfig.nodes[row2.nodeid].nodeid = row2.nodeid
      netconfig.nodes[row2.nodeid].default = (row2.usedefaultfile == 't' and '1') or '0'
      netconfig.nodes[row2.nodeid].defaultBool = (row2.usedefaultfile == 't' and 'true') or 'false'
      netconfig.nodes[row2.nodeid].fileid = row2.fileid
      netconfig.nodes[row2.nodeid].logicid = row2.logicid
      netconfig.nodes[row2.nodeid].selected = (row2.selected == 't' and '1') or '0'
      netconfig.nodes[row2.nodeid].selectedBool = (row2.selected == 't' and 'true') or 'false'
      row2 = cur2:fetch ({}, "a")
    end
    cur2:close()
    local cur3 = assert (con:execute(string.format("SELECT nodetype,fileid FROM netconfigdefaultfiles WHERE netconfigid = %d",netconfigid)))
    local row3 = cur3:fetch ({}, "a")
    netconfig.default = {}
    while row3 do
      netconfig.default[row3.nodetype] = {}
      netconfig.default[row3.nodetype].nodetype = row3.nodetype
      netconfig.default[row3.nodetype].fileid = row3.fileid
      row3 = cur3:fetch ({}, "a")
    end
    cur3:close()
  end
  return netconfig
end
function insert_netconfig(con,session,netconfig)
  local stat, err, cur
  local netconfigid
  cur, err = con:execute(string.format("INSERT INTO netconfig(netid,netversion,uid,cname,description) VALUES (%d,%d,%d,'%s','%s') RETURNING netconfigid",session.netid,session.netversion,session.uid,netconfig.name,netconfig.description))
  if cur then
    local row = cur:fetch ({}, "a")
    netconfigid = row.netconfigid
    for k,v in pairs(netconfig.nodes) do
      if v.selectedBool=='true' then
        stat, err = con:execute(string.format("INSERT INTO netconfignodes(netconfigid,nodeid,usedefaultfile,fileid,logicid,selected) VALUES (%d,%d,%s,%d,%d,%s)",netconfigid,v.nodeid,v.defaultBool,v.fileid,v.logicid,v.selectedBool))
        if stat == nil then break end          
      end
    end
    if stat then
      for k,v in pairs(netconfig.default) do
        if tonumber(v.fileid) and tonumber(v.fileid) >0 then
          stat, err = con:execute(string.format("INSERT INTO netconfigdefaultfiles(netconfigid,nodetype,fileid) VALUES (%d,%d,%d)",netconfigid,v.nodetype,v.fileid))
          if stat == nil then break end          
        end
      end
    end
  end
  if stat then con:commit(); stat=netconfigid else con:rollback() end
  return stat, err
end

function update_netconfig(con,session,netconfig)
  local stat, err
  stat, err = con:execute(string.format("UPDATE netconfig SET (cname,description) = ('%s','%s') WHERE netconfigid=%d and uid=%d",netconfig.name,netconfig.description,netconfig.netconfigid,session.uid))
  if stat then
    stat, err = con:execute(string.format("DELETE FROM netconfignodes WHERE netconfigid='%d'",netconfig.netconfigid))
    if stat then
      for k,v in pairs(netconfig.nodes) do
        if v.selectedBool=='true' then
         stat, err = con:execute(string.format("INSERT INTO netconfignodes(netconfigid,nodeid,usedefaultfile,fileid,logicid,selected) VALUES (%d,%d,%s,%d,%d,%s)",netconfig.netconfigid,v.nodeid,v.defaultBool,v.fileid,v.logicid,v.selectedBool))
         if stat == nil then break end
        end 
      end
      if stat then
        local stat, err = con:execute(string.format("DELETE FROM netconfigdefaultfiles WHERE netconfigid=%d",netconfig.netconfigid))
        if stat then
          for k,v in pairs(netconfig.default) do
            if tonumber(v.fileid) and tonumber(v.fileid) >0 then
              stat, err = con:execute(string.format("INSERT INTO netconfigdefaultfiles(netconfigid,nodetype,fileid) VALUES (%d,%d,%d)",netconfig.netconfigid,v.nodetype,v.fileid))
              if stat == nil then break end          
            end
          end
        end
      end
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function delete_netconfig(con,session,id)
  local stat, err = con:execute(string.format("DELETE FROM netconfigdefaultfiles WHERE netconfigid=%d",id))
  if stat then 
    stat, err = con:execute(string.format("DELETE FROM netconfignodes WHERE netconfigid=%d",id))
    if stat then
      stat, err = con:execute(string.format("DELETE FROM netconfig WHERE netconfigid=%d and uid=%d",id,session.uid))
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function get_userfile_byid(con,session,fileid)
  local userfile = {}
  local cur = assert (con:execute(string.format("SELECT fileid,filename,nodetype,description FROM userfiles WHERE fileid = %d ",fileid)))
  local row = cur:fetch ({}, "a")
  if row then
      userfile.fileid = row.fileid
      userfile.filename = row.filename
      userfile.description = row.description
      userfile.nodetype = row.nodetype
  end
    cur:close()
    return userfile
end
function get_userfiles(con,session)
  local arquivos = {}
    local cur = assert (con:execute(string.format("SELECT fileid,filename, CONCAT(filename, ' (',short,')') as nome,userfiles.nodetype,userfiles.description,userfiles.created from userfiles, nodestype WHERE uid = %d and userfiles.nodetype = nodestype.nodetype",session.uid)))
  local row = cur:fetch ({}, "a")
  while row do
      row.id = row.fileid
      table.insert(arquivos,row)
      row = cur:fetch ({}, "a")
  end
    cur:close()
    return arquivos
end

function insert_userfiles(con,session,nodetype,filename,description,serverfile)
  local stat, err = con:execute(string.format("INSERT INTO userfiles (uid,nodetype,filename,description,bindata) VALUES (%d,%d,'%s','%s',bytea_import('%s'))",session.uid,nodetype,filename,description,serverfile))
  --local stat, err = con:execute(string.format("INSERT INTO userfiles (uid,nodetype,filename,description,bindata) VALUES (%d,%d,'%s','%s','%s')",session.uid,nodetype,filename,description,serverfile))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function update_userfiles(con,session,fileid,filename,description)
  local stat, err = con:execute(string.format("UPDATE userfiles SET (filename,description) = ('%s','%s') WHERE fileid=%d and uid=%d",filename,description,fileid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function delete_userfiles(con,session,fileid)
  local stat, err = con:execute(string.format("DELETE FROM userfiles WHERE fileid=%d and uid=%d",fileid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function get_motes(con,targets,netid,netversion)
  local motes = {}
    local cur = assert (con:execute(string.format("SELECT nodeid,nodetype from network where netid=%d and netversion=%d",netid,netversion)))
  local row = cur:fetch ({}, "a")
  while row do
    table.insert(motes,{nodeid = row.nodeid,nodetype = targets[row.nodetype]})
      row = cur:fetch ({}, "a")
  end
    cur:close()
    return motes
end



function get_tests(con,session,period)
  local testes = {}
  local cur
  if period=='new' then
    cur = assert (con:execute(string.format("SELECT (agenda.endslot <= date2slot(CURRENT_TIMESTAMP)) as old, test.testid,test.cname as nome,test.description,test.created, agenda.cname as agenda, config.cname as config, agenda.startslot from test, agenda, config WHERE test.idagenda = agenda.idagenda and test.configid = config.configid and test.uid=%d and test.netid=%d and test.netversion=%d and agenda.startslot >= date2slot(CURRENT_TIMESTAMP)",session.uid,session.netid,session.netversion)))
  elseif period=='old' then
    cur = assert (con:execute(string.format("SELECT (agenda.endslot <= date2slot(CURRENT_TIMESTAMP)) as old, test.testid,test.cname as nome,test.description,test.created, agenda.cname as agenda, config.cname as config, agenda.startslot from test, agenda, config WHERE test.idagenda = agenda.idagenda and test.configid = config.configid and test.uid=%d and test.netid=%d and test.netversion=%d and agenda.startslot < date2slot(CURRENT_TIMESTAMP)",session.uid,session.netid,session.netversion)))
  else -- period='all'
    cur = assert (con:execute(string.format("SELECT (agenda.endslot <= date2slot(CURRENT_TIMESTAMP)) as old, test.testid,test.cname as nome,test.description,test.created, agenda.cname as agenda, config.cname as config, agenda.startslot from test, agenda, config WHERE test.idagenda = agenda.idagenda and test.configid = config.configid and test.uid=%d and test.netid=%d and test.netversion=%d",session.uid,session.netid,session.netversion)))
  end
  local row = cur:fetch ({}, "a")
  while row do
    row.itens = "\tagenda: ".. row.agenda .. "\n\tplano: ".. row.config
    row.id = row.testid
    row.starttime = slot2str(row.startslot)
    row.old = (row.old=='t')
    table.insert(testes,row)
      row = cur:fetch ({}, "a")
  end
    cur:close()
    return testes
end

function get_test_byid(con,session,testid)
  local cur = assert (con:execute(string.format("SELECT testid,netid,netversion,uid,configid as planid,idagenda,cname as name,description, clientip as remote_addr FROM test WHERE testid = %d and uid=%d",testid,session.uid)))
  local row = cur:fetch ({}, "a")
    cur:close()
    return row
end
function insert_test(con,session,test)
  local cur, err = con:execute(string.format("INSERT INTO test (uid,netid,netversion,cname,description,configid,idagenda,clientip) VALUES (%d,%d,%d,'%s','%s',%d,%d,'%s') RETURNING testid",session.uid,session.netid,session.netversion,test.name,test.description,test.planid,test.idagenda,test.remote_addr))
  local stat = cur
  if cur then
    local row = cur:fetch ({}, "a")
    stat = row.testid
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function update_test(con,session,test)
  local stat, err = con:execute(string.format("UPDATE test SET (cname,description,configid,idagenda,clientip) = ('%s','%s',%d,%d,'%s') where testid=%d and uid =%d",test.name,test.description,test.planid,test.idagenda,test.remote_addr,test.testid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function delete_test(con,session,testid)
 local stat, err = con:execute(string.format("DELETE FROM test WHERE testid=%d and uid=%d",testid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function get_planos(con,session)
  local planos = {}
  local cur = assert (con:execute(string.format("SELECT config.configid,config.cname as nome,config.description,config.created, netconfig.cname as netconfig, script.cname as script FROM config, script,netconfig WHERE  config.netconfigid = netconfig.netconfigid and config.scriptid = script.scriptid and config.uid=%d and config.netid=%d and config.netversion=%d",session.uid,session.netid,session.netversion)))
  local row = cur:fetch ({}, "a")
  while row do
    row.itens = "\tscript: ".. row.script .."\n\tnetconfig: ".. row.netconfig
    row.id = row.configid
    table.insert(planos,row)
    row = cur:fetch ({}, "a")
  end
    cur:close()
    return planos
end
function get_plan_byid(con,session,planid)
  local cur = assert (con:execute(string.format("SELECT configid as planid,netid,netversion,uid,netconfigid,scriptid,cname as name,description FROM config WHERE configid = %d and uid=%d",planid,session.uid)))
  local row = cur:fetch ({}, "a")
    cur:close()
    return row
end
function insert_plano(con,session,plan)
  local stat, err = con:execute(string.format("INSERT INTO config (uid,netid,netversion,cname,description,netconfigid,scriptid) VALUES (%d,%d,%d,'%s','%s',%d,%d) RETURNING configid",session.uid,session.netid,session.netversion,plan.name,plan.description,plan.netconfigid,plan.scriptid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function update_plano(con,session,plan)
  local stat, err = con:execute(string.format("UPDATE config SET (cname,description,netconfigid,scriptid) = ('%s','%s',%d,%d) where configid=%d and uid =%d",plan.name,plan.description,plan.netconfigid,plan.scriptid,plan.planid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function delete_plan(con,session,configid)
  local stat, err = con:execute(string.format("DELETE FROM config WHERE configid=%d and uid=%d",configid,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function getISODate(con) -- with milliseconds for javascript side
  local cur = assert (con:execute(string.format("SELECT to_char(now(),'YYYY-MM-DDXHH24:MI:SS.MS') as date")))

  local row = cur:fetch ({}, "a")
  cur:close()
  -- Postgres date format use 'T' as control char.
  return string.gsub(row.date,"X","T",1)
end

function slot2date(slot)
    return string.find(slot, '(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)')
end 
function date2slot(year,month,day,hour,minute)
    return tonumber(tostring(year)..tostring(month)..tostring(day)..tostring(hour)..tostring(minute))
end
function slot2time(slot)
  local dt={}
    _, _, dt.year,dt.month,dt.day,dt.hour,dt.min = string.find(slot, '(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)')
  return os.time(dt)
end 
function time2slot(tm)
  local dt = os.date("*t",tm)
  return string.format("%04d%02d%02d%02d%02d",dt.year,dt.month,dt.day,dt.hour,dt.min)
end
function slot2str(slot)
  local dt={}
  _, _, dt.year,dt.month,dt.day,dt.hour,dt.min = string.find(slot, '(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)')
  return dt.day..'/'..dt.month..'/'..dt.year..' '..dt.hour.."h"..dt.min
end
function slots2duration(startslot,endslot)
  local start_t = slot2time(startslot)
  local end_t = slot2time(endslot)
  local minutos = (end_t - start_t + (30*60))/60
  return math.floor(minutos/60/24) .. 'd '.. math.floor(minutos/60)%24 .. 'h '.. minutos%60 .. 'min'; 
end

strmonth = {[1]='jan',[2]='fev',[3]='mar',[4]='abr',[5]='mai',[6]='jun',[7]='jul',[8]='ago',[9]='set',[10]='out',[11]='nov',[12]='dez'}
strwday = {[1]="Dom",[2]="Seg",[3]="Ter",[4]="Qua",[5]="Qui",[6]="Sex",[7]="Sab",}

function get_agendas(con,session,flagAll)
  local agendas = {}
  local cur
  if flagAll then
    cur = assert (con:execute(string.format("SELECT idagenda,cname,description,startslot,endslot,created from agenda WHERE uid=%d and netid=%d order by startslot",session.uid,session.netid)))
  else
    cur = assert (con:execute(string.format("SELECT idagenda,cname,description,startslot,endslot,created from agenda WHERE uid=%d and netid=%d and endslot > date2slot(CURRENT_TIMESTAMP) order by startslot",session.uid,session.netid)))
  end
  local row = cur:fetch ({}, "a")
  while row do
    local cur2 = assert (con:execute(string.format("SELECT testid from test WHERE idagenda=%d and uid=%d",row.idagenda,session.uid)))
    local row2 = cur2:fetch ({}, "a")
    row.testid = (row2 and row2.testid) or 0
    _, _, row.year,row.month,row.day,row.hour,row.min = slot2date(row.startslot)
    row.nome = ((row.testid ~= 0 and '*') or '')..row.cname .. ' ('.. row.day ..'/'..strmonth[tonumber(row.month)] .. ','..row.hour .. 'h'.. row.min ..')'
    row.id = row.idagenda
    -- In table "agenda", 'endslot' is the next slot.
    local end_dt = slot2time(row.endslot) - (30*60)  
    row.endslot = time2slot(end_dt)
    row.duration = slots2duration(row.startslot,row.endslot)
    row.itens = "\tduração: ".. row.duration
    table.insert(agendas,row)
    row = cur:fetch ({}, "a")
  end
    cur:close()
    return agendas
end
function insert_agenda(con,session,agenda)
  -- In table "agenda", 'endslot' is the next slot.
  local end_dt = slot2time(agenda.endslot) + (30*60)  
  local endslot = time2slot(end_dt)
  local stat, err = con:execute(string.format("INSERT INTO agenda (uid,netid,cname,description,startslot,endslot) VALUES (%d,%d,'%s','%s',%.0f,%.0f) RETURNING idagenda",session.uid,session.netid,agenda.name,agenda.description,agenda.startslot,endslot))
  if stat then con:commit() else con:rollback() end
  return stat, err    
end
function update_agenda(con,session,agenda)
  -- In table "agenda", 'endslot' is the next slot.
  local end_dt = slot2time(agenda.endslot) + (30*60)  
  local endslot = time2slot(end_dt)
  local stat, err = con:execute(string.format("UPDATE agenda SET (cname,description,startslot,endslot) = ('%s','%s',%.0f,%.0f) WHERE idagenda=%d and uid=%d",agenda.name,agenda.description,agenda.startslot,endslot,agenda.idagenda,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err    
end
function get_agenda_byid(con,session,idagenda)
  local cur = assert (con:execute(string.format("SELECT idagenda,cname as name,description,startslot,endslot FROM agenda WHERE idagenda = %d and uid=%d",idagenda,session.uid)))
  local row = cur:fetch ({}, "a")
  cur:close()
  -- In table "agenda", 'endslot' is the next slot.
  local end_dt = slot2time(row.endslot) - (30*60)  
  row.endslot = time2slot(end_dt)
  -- Text values
  row.startslot_str = slot2str(row.startslot) 
  row.endslot_str = slot2str(row.endslot)
  local sdt = {}
  _, _, sdt.year,sdt.month,sdt.day,sdt.hour,sdt.min = string.find(row.startslot, '(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)')
  local edt = {}
  _, _, edt.year,edt.month,edt.day,edt.hour,edt.min = string.find(row.endslot, '(%d%d%d%d)(%d%d)(%d%d)(%d%d)(%d%d)')
  row.startslot_dt = sdt.year .. '-' .. sdt.month .. '-' .. sdt.day .. 'T' .. sdt.hour .. ':' .. sdt.min
  row.endslot_dt = edt.year .. '-' .. edt.month .. '-' .. edt.day .. 'T' .. edt.hour .. ':' .. edt.min
  row.duration = slots2duration(row.startslot,row.endslot)
  row.start_date = sdt
  return row
end
function delete_agenda(con,session,idagenda)
  local stat, err = con:execute(string.format("DELETE FROM agenda WHERE idagenda=%d and uid=%d",idagenda,session.uid))
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function agendaIsCurrent(con,session,idagenda)
  local cur1 = assert (con:execute(string.format("select count(agenda.idagenda) as count from agenda,test where agenda.idagenda = %d and startslot <= date2slot(CURRENT_TIMESTAMP) and endslot > date2slot(CURRENT_TIMESTAMP) and agenda.idagenda = test.idagenda and agenda.uid=%d",idagenda,session.uid)))
  local row1 = cur1:fetch ({}, "a")
  cur1:close()
  return tonumber(row1.count)
end

function get_script_byid(con,session,scriptid)
  local script={}
  if (scriptid == nil) then return script end
  local cur1 = assert (con:execute(string.format("SELECT netid,netversion,uid,cname,description FROM script WHERE scriptid = %d and uid=%d",scriptid,session.uid)))
  local row1 = cur1:fetch ({}, "a")
  cur1:close()
  if row1 ~= nil then
    script.scriptid = scriptid
    script.name = row1.cname
    script.description = row1.description
    local cur2 = assert (con:execute(string.format("SELECT step,command,paramvalue FROM scriptsteps WHERE scriptid = %d ORDER BY step ASC",scriptid)))
    local row2 = cur2:fetch ({}, "a")
    script.steps={}
    while row2 do
      local r = {}
      r.line = row2.command .. ' ' .. row2.paramvalue
      r.command = row2.command
      r.paramvalue = row2.paramvalue
      table.insert(script.steps,r)
      row2 = cur2:fetch ({}, "a")
    end
    cur2:close()
  end
  return script
end
function get_scripts(con,session)
  local scripts = {}
  --local cur = assert (con:execute(string.format("SELECT scriptid,script.cname,script.description from config join script on uid=%d and netid=%d and netversion=%d and script.scriptid=config.scriptid",session.uid,session.netid,session.netversion)))
  local cur = assert (con:execute(string.format("SELECT scriptid,cname as nome,description,created from script where uid=%d and netid=%d and netversion=%d",session.uid,session.netid,session.netversion)))
  local row = cur:fetch ({}, "a")
  while row do
    row.id = row.scriptid
    table.insert(scripts,row)
    row = cur:fetch ({}, "a")
  end
    cur:close()
    return scripts
end

function insert_script(con,session,script)
  local cur, stat, err
  local cur, err  = assert (con:execute(string.format("INSERT INTO script (uid,netid,netversion,cname,description) VALUES (%d,%d,%d,'%s','%s') RETURNING scriptid",session.uid,session.netid,session.netversion,script.name,script.description)))
  stat = cur
  if cur then
    local row = cur:fetch ({}, "a")
    local scriptid = row.scriptid
    for k,v in pairs(script.steps) do
        stat, err = con:execute(string.format("INSERT INTO scriptsteps (scriptid,step,command, paramvalue) VALUES (%d,%d,'%s','%s')",scriptid,k,v.command,v.paramvalue))
        if stat==nil then break end
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function update_script(con,session,script)
  local stat, err = con:execute(string.format("UPDATE script SET (cname,description)=('%s','%s') WHERE scriptid=%d and uid=%d",script.name,script.description,script.scriptid,session.uid))
  if stat then
    stat, err = con:execute(string.format("DELETE FROM scriptsteps WHERE scriptid=%d",script.scriptid,session.uid))
    if stat then
      for k,v in pairs(script.steps) do
        stat, err = con:execute(string.format("INSERT INTO scriptsteps (scriptid,step,command, paramvalue) VALUES (%d,%d,'%s','%s')",script.scriptid,k,v.command,v.paramvalue))
        if stat==nil then break end
      end
    end
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end
function delete_script(con,session,scriptid)
  local stat, err = con:execute(string.format("DELETE FROM scriptsteps WHERE scriptid=%d ",scriptid))
  if stat then
    stat, err = con:execute(string.format("DELETE FROM script WHERE scriptid=%d and uid=%d",scriptid,session.uid))
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end



function get_log(con,session,testid)
  local logTab = {}
  local cur1 = assert (con:execute(string.format("select startslot, endslot, testid, test.cname from test, agenda where test.uid = %d and test.testid=%d and test.idagenda = agenda.idagenda;",session.uid,testid)))
  local row1 = cur1:fetch ({}, "a")
  local testname=''
  local log={}
  if row1 then
    log.starttime = slot2str(row1.startslot)
    log.endtime = slot2str(row1.endslot)
    log.testid = row1.testid or '0'
    log.testname = row1.cname or ''
    local minutos = (slot2time(row1.endslot) - slot2time(row1.startslot))/60
    log.duration = math.floor(minutos/60/24) .. 'd '.. math.floor(minutos/60)%24 .. 'h '.. minutos%60 .. 'min';
    local cur2 = assert (con:execute(string.format("SELECT logseq,testid,to_char(logtime,'YYYY/MM/DD HH24:MI:SS') as logtime,nodeid,logtype,logline, pid from logdata WHERE netid=%d and logtime>=to_timestamp('%s','DD/MM/YYYY HH24hMI') and (logtype = 'TEST' or logtype = 'DATA') order by logseq asc",session.netid,log.starttime)))
    local row2 = cur2:fetch ({}, "a")
    while row2 do
      table.insert(logTab,row2)
        row2 = cur2:fetch ({}, "a")
    end
    cur2:close()
  end
  return log, logTab 
end

function get_logdelta(con,session,last_logseq,cmd)
  local logTab = {}
  local testid=0
  local testname=''
  local starttime
  if (cmd=='TEST') then
    local cur1 = assert (con:execute(string.format("select startslot,testid, test.cname from (SELECT idagenda, startslot from agenda WHERE uid=%d and netid=%d and startslot <= date2slot(CURRENT_TIMESTAMP) and endslot > date2slot(CURRENT_TIMESTAMP)) as ag LEFT OUTER JOIN test ON (ag.idagenda = test.idagenda);",session.uid,session.netid)))
    local row1 = cur1:fetch ({}, "a")
    if row1 then
      starttime = slot2str(row1.startslot)
      testid = row1.testid or '0'
      testname = row1.cname or ''
      local cur2 = assert (con:execute(string.format("SELECT logseq,testid,to_char(logtime,'YYYY/MM/DD HH24:MI:SS') as logtime,nodeid,logtype,logline, pid from logdata WHERE netid=%d and logtime>=to_timestamp('%s','DD/MM/YYYY HH24hMI') and logseq > %d and (logtype = 'TEST' or logtype = 'DATA') order by logseq desc",session.netid,starttime,last_logseq)))
      local row2 = cur2:fetch ({}, "a")
      while row2 do
        table.insert(logTab,row2)
          row2 = cur2:fetch ({}, "a")
      end
      cur2:close()
    end
  else
      local cur2 = assert (con:execute(string.format("SELECT logseq,testid,to_char(logtime,'YYYY/MM/DD HH24:MI:SS') as logtime,nodeid,logtype,logline, pid from logdata WHERE netid=%d and logtime>=(CURRENT_TIMESTAMP - interval '2 days') and logseq > %d and logtype != 'TEST' and logtype != 'DATA' order by logseq desc",session.netid,last_logseq)))
      local row2 = cur2:fetch ({}, "a")
      while row2 do
        table.insert(logTab,row2)
          row2 = cur2:fetch ({}, "a")
      end
      cur2:close()  
  end
  return testid,testname, logTab
end

-- get the latest 

function get_netversion(con, network)
    local cur = assert (con:execute(string.format("SELECT nv.netversion, nt.nname from networks as nt, (SELECT max(netversion) as netversion FROM networks WHERE netid=%d) as nv WHERE nt.netid=%d and nv.netversion=nt.netversion",network,network)))
    local row = cur:fetch ({}, "a")
    if row then
      return row.netversion, row.nname
    else
      return 0, '-'
    end
end

function update_userroles(con,uid,uRoles)
  local stat, err = con:execute(string.format("DELETE FROM userroles WHERE uid=%d ",uid))
  if stat then
    for _,roleid in pairs(uRoles) do
      stat, err = con:execute(string.format("INSERT INTO userroles (uid,roleid) VALUES (%d,%d)",uid,roleid))
      if stat == nil then break end
    end  
  end
  if stat then con:commit() else con:rollback() end
  return stat, err
end

function get_userroles(con,uid)
   local roles = {}
   local roleIds = {}
   local cur = assert (con:execute(string.format("SELECT r.rolename, r.roleid FROM userroles as u, roles as r WHERE u.uid = %d and u.roleid = r.roleid",uid)))
   local row = cur:fetch ({}, "a")
   while row do
    table.insert(roles,row.rolename)
    table.insert(roleIds,row.roleid)
    row = cur:fetch ({}, "a")
   end
   cur:close()
   return roles,roleIds
end

TBC={Start=0,Stop=1,newConfig=2}

function sendTBControl(netid,testid,action)
  local port = 9999 - netid
  local tbcon = socket.connect('localhost', port)
  if tbcon then
    local stat, err = tbcon:send(string.format("%d %d",testid,action))
    tbcon:close()
    return stat, err
  end
  return tbcon
end

function check_DBConfig(con)
  local cur = assert (con:execute(string.format("SELECT count(netId) as count from networks")))
  local row = cur:fetch ({}, "a")
  return (row and tonumber(row.count)) or 0
end

function get_netsinfo(con,session)
  local netsinfo = {}
  local cur = assert (con:execute([[
    select nets.nname, ns.netid,ns.netversion,nt.short,ns.nodetype, count(ns.nodetype) as qtt
        from  network as ns, nodestype as nt, networks as nets,
              (select netid, max(netversion) as netversion from network group by netid) as lst
        where ns.netid = lst.netid and ns.netversion = lst.netversion and
              ns.nodetype = nt.nodetype and
              ns.netid = nets.netid and ns.netversion = nets.netversion
        group by nets.nname,ns.netid,ns.netversion,nt.short,ns.nodetype
        order by ns.netid asc,ns.nodetype asc]]))
        
   local row = cur:fetch ({}, "a")
   while row do
      if netsinfo[tonumber(row.netid)] == nil then 
        netsinfo[tonumber(row.netid)]={}
        netsinfo[tonumber(row.netid)].name=row.nname
        netsinfo[tonumber(row.netid)].netversion=row.netversion
        netsinfo[tonumber(row.netid)].type={}
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)]={}
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)].short=row.short
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)].qtt=row.qtt
      else
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)]={}
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)].short=row.short
        netsinfo[tonumber(row.netid)].type[tonumber(row.nodetype)].qtt=row.qtt
      end
      row = cur:fetch ({}, "a")
   end
   cur:close()
  return netsinfo
end

-- ##########################     CONSULTA HIERAQUIA   #######################################

function getH_test(con,session,testid)
  local test = {}
  local cur = con:execute(string.format("SELECT testid as id, cname as name, idagenda as agenda, configid as config,to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM test WHERE uid=%d and testid=%d",session.uid,testid))
  local row = cur:fetch ({}, "a")
  if row then
    local name = {}
    local temp = {}
    table.insert(name,getIcon('test') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(test,name)
    table.insert(temp,getH_plano(con,session,row.config))
    table.insert(temp,getH_agenda(con,session,row.agenda))
    table.insert(test,temp)
  end
  cur:close()
  return test
end

function getH_plano(con,session,configid)
  local plano = {}
  local cur = con:execute(string.format("SELECT configid as id, cname as name, netconfigid, scriptid as script,to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM config WHERE uid=%d and configid=%d",session.uid,configid))
  local row = cur:fetch ({}, "a")
  if row then
    local name = {}
    local temp = {}
    table.insert(name,getIcon('plan') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(plano,name)
    table.insert(temp,getH_netconfig(con,session,row.netconfigid))
    table.insert(temp,getH_script(con,session,row.script))
    table.insert(plano,temp)
  end
  cur:close()
  return plano
end

function getH_agenda(con,session,idagenda)
  local agenda = {}
  local cur = con:execute(string.format("SELECT idagenda as id, cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM agenda WHERE uid=%d and idagenda=%d",session.uid,idagenda))
  local row = cur:fetch({} , "a")
  if row then
    local name = {}
    table.insert(name,getIcon('agenda') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(agenda,name)
  end
  cur:close()
  return agenda
end

function getH_script(con,session,scriptid)
  local script = {}
  local cur = con:execute(string.format("SELECT scriptid as id, cname as name,to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM script WHERE uid=%d and scriptid=%d",session.uid,scriptid))
  local row = cur:fetch({} , "a")
  if row then
    local name = {}
    table.insert(name,getIcon('script') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(script,name)
  end
  cur:close()
  return script
end

function getH_netconfig(con,session,netconfigid)
  local netconfig = {}
  local cur = con:execute(string.format("SELECT netconfigid as id, to_char(created,'DD/MM/YY HH24:MI:SS') as date, cname as name FROM netconfig WHERE uid=%d and netconfigid=%d",session.uid,netconfigid))
  local row = cur:fetch({} , "a")
  if row then
    local name = {}
    local temp = {}
    table.insert(name,getIcon('netconfig') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(netconfig,name) 
 --   netconfig.date = row.date
    table.insert(temp,getH_files(con,session,netconfigid)) 
    table.insert(netconfig,getH_files(con,session,netconfigid)) 
  end
  cur:close()
  return netconfig
end
function getH_files(con,session,netconfigid)
  local files = {}
  local cur = con:execute(string.format("SELECT DISTINCT uf.fileid, uf.filename as name, tp.short, to_char(uf.created,'DD/MM/YY HH24:MI:SS') as date FROM userfiles as uf, netconfignodes as ncd, nodestype as tp WHERE uf.fileid = ncd.fileid and uf.nodetype = tp.nodetype and ncd.netconfigid = %d and uf.uid = %d",netconfigid,session.uid))
  local row = cur:fetch({}, "a")
  while row do
    local name = {}
    table.insert(name,getIcon('userfiles') ..' ' ..  row.name .. " (".. row.short ..")")
    table.insert(name,row.date)
    table.insert(files,{name})
--    table.insert(netconfig,name)
    row = cur:fetch({}, "a")
  end
  cur:close()
  return files
end

------ Dep. queries
function getD_entry_userfiles(con,session,fileid)
  local files = {}
  local cur = con:execute(string.format("SELECT uf.filename as name, tp.short, to_char(uf.created,'DD/MM/YY HH24:MI:SS') as date FROM userfiles as uf, nodestype as tp WHERE uid=%d and fileid=%d and uf.nodetype = tp.nodetype",session.uid,fileid))
  local row = cur:fetch({}, "a")
  if row then
    local name = {}
    table.insert(name,getIcon('userfiles') .. ' ' .. row.name .. " (" .. row.short .. ")")
    table.insert(name,row.date)
    table.insert(files,name)
    table.insert(files,getD_netconfig(con,session,fileid))
  end
    cur:close()
  return files
end

function getD_netconfig (con,session,fileid)
  local netconfig = {}
  local cur = con:execute(string.format("SELECT DISTINCT ntc.netconfigid as netid, ntc.cname as name,to_char(ntc.created,'DD/MM/YY HH24:MI:SS') as date  FROM netconfig as ntc, netconfignodes as ncn, netconfigdefaultfiles as ncdf WHERE (ntc.uid=%d and ntc.netconfigid = ncn.netconfigid and ncn.fileid=%d) or (ntc.uid=%d and ntc.netconfigid = ncdf.netconfigid and ncdf.fileid=%d)",session.uid,fileid,session.uid,fileid))
  local row = cur:fetch({}, "a")
  while row do
    local name = {}    
    local tmp = {}
    table.insert(name,getIcon('netconfig') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(tmp,name)
    table.insert(tmp,getD_plano_by_netconfig(con,session,row.netid))
    table.insert(netconfig,tmp)
    row = cur:fetch({}, "a")
  end
  cur:close()
  return netconfig
end

function getD_entry_netconfig(con,session,netconfigid)
  local netconfig = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM netconfig WHERE netconfigid=%d and uid=%d",netconfigid,session.uid))
  local row = cur:fetch({}, "a")
  if row then
    local name = {}
    table.insert(name,getIcon('netconfig') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(netconfig,name)
    table.insert(netconfig,getD_plano_by_netconfig(con,session,netconfigid))
  end
  cur:close()
  return netconfig
end

function getD_entry_script(con,session,scriptid)
  local script = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM script WHERE scriptid=%d and uid=%d",scriptid,session.uid))
  local row = cur:fetch({}, "a")
  if row then
    local name = {}
    table.insert(name,getIcon('script') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(script,name)
  end
  table.insert(script,getD_plano_by_script(con,session,scriptid))
  cur:close()
  return script
end

function getD_plano_by_netconfig(con,session,netconfigid)
  local plano = {}
  local cur = con:execute(string.format("SELECT cname as name, configid, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM config WHERE netconfigid=%d and uid=%d",netconfigid,session.uid))
  local row = cur:fetch({}, "a")
  while row do
    local name = {}
    local tmp = {}
    table.insert(name,getIcon('plan') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(tmp,name)
    table.insert(tmp,getD_test_by_plano(con,session,row.configid))
    table.insert(plano,tmp)
    row = cur:fetch({}, "a")
  end
  cur:close()
  return plano
end

function getD_plano_by_script(con,session,scriptid)
  local plano = {}
  local cur = con:execute(string.format("SELECT configid, cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM config WHERE scriptid=%d and uid=%d",scriptid,session.uid))
  local row = cur:fetch({}, "a")
  local tmp = {}
  while row do
    local name = {}
    local tmp = {}
    table.insert(name,getIcon('plan') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(tmp,name)
    table.insert(tmp,getD_test_by_plano(con,session,row.configid))
    table.insert(plano,tmp)
    row = cur:fetch({}, "a")
  end
  cur:close()
  return plano
end

function getD_entry_plano(con,session,configid)
  local plano = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM config WHERE configid=%d and uid=%d",configid,session.uid))
  local row = cur:fetch({}, "a")
  if row then
    local name = {}
    table.insert(name,getIcon('plan') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(plano,name)
    table.insert(plano,getD_test_by_plano(con,session,configid))
  end
  cur:close()
  return plano
end

function getD_entry_agenda(con,session,idagenda)
  local agenda = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM agenda WHERE idagenda=%d and uid=%d",idagenda,session.uid))
  local row = cur:fetch({}, "a")
  if row then
    local name = {}
    table.insert(name,getIcon('agenda') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(agenda,name)
    table.insert(agenda,getD_test_by_agenda(con,session,idagenda))
  end
  cur:close()
  return agenda
end

function getD_test_by_plano(con,session,configid)
  local test = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM test WHERE configid=%d and uid=%d",configid,session.uid))
  local row = cur:fetch({}, "a")
  while row do
    local name = {}
    table.insert(name,getIcon('test') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(test,{name})
    row = cur:fetch({}, "a")
  end
  cur:close()
  return test
end

function getD_test_by_agenda(con,session,idagenda)
  local test = {}
  local cur = con:execute(string.format("SELECT cname as name, to_char(created,'DD/MM/YY HH24:MI:SS') as date FROM test WHERE idagenda=%d and uid=%d",idagenda,session.uid))
  local row = cur:fetch({}, "a")
  while row do
    local name = {}
    table.insert(name,getIcon('test') ..' ' ..  row.name)
    table.insert(name,row.date)
    table.insert(test,{name})
    row = cur:fetch({}, "a")
  end
  cur:close()
  return test
end
