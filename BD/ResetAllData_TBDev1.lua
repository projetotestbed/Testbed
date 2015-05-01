------------------------------------------------------------------
-- Testbed System v2
-- Script to reset database data
--
-- - Erase all data
-- - Populate basic tables
-- - Create 1 user admin, manager, and basic
-- - Create two networks, netid=1 with 3 nodes and netid=2 with 1 node
--
-- Author - abranco@inf.puc-rio.br
-- Date - 2015, February
------------------------------------------------------------------

local md5 = require "md5"
-- load driver
local driver = require "luasql.postgres"
-- create environment object
env = assert (driver.postgres())
-- connect to data source
con = assert (env:connect("portal2","postgres","postgres","localhost"))
con:setautocommit(false)


--------------------------
-- Erase all tables
--------------------------
tables = { -- Order is important
	"test","logdata",
	"agenda",
	"config",
	"scriptsteps","script",
	"netconfigdefaultfiles","netconfignodes","netconfig",
	"userfiles",
	"slotstemplate","extraslots",
	"userconfig","userroles","users","roles","operroles","appopers","configparams",
	"network","networks",
	"nodestype","nodestatus"
}	

for k,tab in pairs (tables) do
	res = assert (con:execute(string.format([[delete from %s]], tab)))
end
con:commit()

--------------------------
-- Create default data
--------------------------

-- roles/users/userroles/appopers/operroles

roles = {
  {roleid=1, rolename="básico", entry="index"},
  {roleid=2, rolename="intermediário", entry="index"},
  {roleid=3, rolename="avançado", entry="index"},
  {roleid=4, rolename="gerente", entry="index"},
  {roleid=5, rolename="configurador", entry="index"},
  {roleid=6, rolename="administrador", entry="useradmin"},
}
for i, p in pairs (roles) do
  res = assert (con:execute(string.format([[
    INSERT INTO roles(roleid, rolename, entry)
    VALUES (%d, '%s', '%s')]], p.roleid, p.rolename, p.entry)
  ))
end 

configparams = {
	{paramid=1, paramname="netdefault"},
	{paramid=2, paramname="activetab"},
	{paramid=3, paramname="roledefault"},
	{paramid=4, paramname="showoldtests"},
}
for i, p in pairs (configparams) do
	res = assert (con:execute(string.format([[
		INSERT INTO configparams(paramid, paramname)
		VALUES (%d, '%s')]], p.paramid, p.paramname)
	))
end	


users = {
	{uid=1, ulogin="afbranco@gmail.com",   uname="afbranco",   accesslevel=100, upassword=md5.sumhexa("admin"),  roleid={3,4,6,1},		params={"1","111111","gerente","true"}},
}

res = assert (con:execute("ALTER SEQUENCE users_uid_seq RESTART WITH 1;"))

for i, p in pairs (users) do
	res = assert (con:execute(string.format([[
		INSERT INTO users(
			ulogin, uname, accesslevel, upassword)
		VALUES ('%s', '%s', %d, '%s')]], p.ulogin, p.uname, p.accesslevel, p.upassword)
	))
	for k, r in pairs (p.roleid) do
	res = assert (con:execute(string.format([[
		INSERT INTO userroles(
				uid, roleid)
		VALUES (%d, %d)]], p.uid, r)
	))
	end
	for k, r in pairs (p.params) do
	res = assert (con:execute(string.format([[
		INSERT INTO userconfig(
				uid,paramid, paramvalue)
		VALUES (%d, %d,'%s')]], p.uid, k, r)
	))
	end
end


appopers = {
	{operid=1,opername="report_self"},  	-- pode executar relatórios dos prórpios dados de uso
	{operid=2,opername="report_all"},  		-- pode executar relatórios dos dados de uso dos outros usuário

	{operid=10,opername="agenda_short"},		-- Pode agendar pequenos períodos (max 2h) 
	{operid=11,opername="agenda_medium"},	-- Pode agendar periodos médios (max 24h)
	{operid=12,opername="agenda_long"},		-- Pode agendar longos períodos (max 7 dias)
	{operid=13,opername="agenda_free"},		-- Não tem limite de agendamento

	{operid=20,opername="cfg_net"},			-- Permissão para alterar a configuração da rede

	{operid=31,opername="reset_tbc"},		-- Permissão para reiniciar o TBControl
	{operid=32,opername="reset_ws"},			-- Permissão para reiniciar o Apache
}

operroles = {
	{operid=1, roleid= 1}, 	-- report_serf 		x basic
	{operid=1, roleid= 2}, 	-- report_serf 		x intermediate
	{operid=1, roleid= 3}, 	-- report_serf 		x advanced
	{operid=2, roleid= 4}, 	-- report_all		x manager

	{operid=10, roleid= 1}, -- agenda_short		x basic
	{operid=11, roleid= 2}, -- agenda_medium	x intermediate
	{operid=12, roleid= 3}, -- agenda_long  	x advanced
	{operid=13, roleid= 4}, -- agenda_free  	x manager

	{operid=20, roleid= 5}, -- cfg_net  		x config

	{operid=30, roleid= 6}, -- reset_tbc  		x admin
	{operid=31, roleid= 6}, -- reset_ws  		x admin
}

for i, p in pairs (appopers) do
	res = assert (con:execute(string.format([[
		INSERT INTO appopers(operid, opername)
		VALUES (%d, '%s')]], p.operid, p.opername)
	))
end	

for i, p in pairs (operroles) do
	res = assert (con:execute(string.format([[
		INSERT INTO operroles(operid, roleid)
		VALUES (%d, %d)]], p.operid, p.roleid)
	))
end	


con:commit()

-- nodestatus/nodestype/networks/network
nodestatus = {
	{statusid=0,code="ACTIVE",description="Ativo"},
	{statusid=1,code="OFF",description="Desligado"},
	{statusid=2,code="OUT",description="Removido"}
}
for i, p in pairs (nodestatus) do
	res = assert (con:execute(string.format([[
		INSERT INTO nodestatus(statusid, code, description)
		VALUES (%d, '%s', '%s')]], p.statusid, p.code, p.description)
	))
end	

nodestype = {
	{nodetype=1,short="micaz300",description="Mote MicaZ com o sensor MTS300"},
	{nodetype=2,short="telosb",description="Mote TelosB"},
}
for i, p in pairs (nodestype) do
	res = assert (con:execute(string.format([[
		INSERT INTO nodestype(nodetype, short, description)
		VALUES (%d,'%s','%s')]], p.nodetype, p.short, p.description)
	))
end	

networks = {
	{netid=1,netversion=1,nname="Rede 1.1",description="Rede de Teste 1", vdescription="Versão 1",
	  node={
		{nodeid=1,notetype=1,statusid=0,location="Sala 1",posx=20,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.1", datachannel="10001 192.168.0.1 10002"},
		{nodeid=2,notetype=1,statusid=0,location="Sala 1",posx=100,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.2", datachannel="10002 192.168.0.2 10002"},
		{nodeid=3,notetype=1,statusid=0,location="Sala 1",posx=180,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.3", datachannel="10003 192.168.0.3 10002"},
    {nodeid=4,notetype=2,statusid=0,location="Sala 1",posx=160,posy=20,posz=0,ctlchannel="192.168.0.101 10001", datachannel="10004 192.168.0.101 10002"},
	  },
	},

	{netid=2,netversion=1,nname="Rede 2.1",description="Rede de Teste 2", vdescription="Versão 1",
	  node={
		{nodeid=1,notetype=1,statusid=0,location="Sala 2",posx=20,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.4", datachannel="10051 192.168.0.4 10002"},
	  },
	},

}

for i, p in pairs (networks) do
	res = assert (con:execute(string.format([[
		INSERT INTO networks(netid, netversion, nname, description, vdescription)
		VALUES (%d, %d, '%s', '%s', '%s')]], 
		p.netid, p.netversion, p.nname, p.description, p.vdescription)
	))
	for k, r in pairs (p.node) do
	res = assert (con:execute(string.format([[
		INSERT INTO network(
				netid, netversion, nodeid, nodetype, statusid, location, posx,posy,posz,ctlchannel,datachannel)
		VALUES (%d, %d, %d, %d, %d, '%s', %d, %d, %d, '%s', '%s')]], 
		p.netid, p.netversion, r.nodeid, r.notetype, r.statusid, r.location, r.posx, r.posy, r.posz, r.ctlchannel, r.datachannel)
	))
	end
end
con:commit()

-- slottemplate
for day=0, 6, 1 do
	for hour=0, 23, 1 do
		for min=0,30,30 do
			slot= day*10000+hour*100+min
			res = assert (con:execute(string.format([[
				INSERT INTO slotstemplate(
					slotoffset, netid, enabled, accesslevel)
				VALUES (%d, '%d', TRUE, 100)]], slot, 1,1)
			))
			res = assert (con:execute(string.format([[
				INSERT INTO slotstemplate(
					slotoffset, netid, enabled, accesslevel)
				VALUES (%d, '%d', TRUE, 100)]], slot, 2,1)
			))
		end
	end 

end
-- Reserva o slot "Domingo, 2h00" para re-start do TBControl
res = assert (con:execute(string.format([[
  update slotstemplate set (enabled)=(FALSE) where slotoffset=%d]], 60200)
))
con:commit()

-- close everything
if cur then cur:close() end-- already closed because all the result set was consumed
con:close()
env:close()
