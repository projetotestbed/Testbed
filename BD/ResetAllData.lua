------------------------------------------------------------------
-- Testbed System v2
-- Script to reset database data
--
-- - Erase all data
-- - Populate basic tables
-- - Create 3 users: admin, manager, and teste
-- - Create two networks with 4 nodes each one
--
-- Author - abranco@inf.puc-rio.br
-- Date - 2015, January
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
	{uid=1, ulogin="admin@testbed.com.br",   uname="Admin A",   accesslevel=100, upassword=md5.sumhexa("admin"),  roleid={6},		params={"1","111111","administrador","true"}},
	{uid=2, ulogin="gerente@testbed.com.br", uname="Gerente G", accesslevel=500, upassword=md5.sumhexa("gerente"),roleid={3,4},	params={"1","111111","gerente","true"}},
	{uid=3, ulogin="teste@testbed.com.br",   uname="Teste T",   accesslevel=500, upassword=md5.sumhexa("teste"),  roleid={1},		params={"1","111111","básico","true"}},
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
	{operid=1, roleid= 1}, 	-- report_serf 		x básico
	{operid=1, roleid= 2}, 	-- report_serf 		x intermediário
	{operid=1, roleid= 3}, 	-- report_serf 		x avançado
	{operid=2, roleid= 4}, 	-- report_all		  x gerente

	{operid=10, roleid= 1}, -- agenda_short		x básico
	{operid=11, roleid= 2}, -- agenda_medium	x intermediário
	{operid=12, roleid= 3}, -- agenda_long  	x avançado
	{operid=13, roleid= 4}, -- agenda_free  	x gerente

	{operid=20, roleid= 5}, -- cfg_net  		x configurador

	{operid=30, roleid= 6}, -- reset_tbc  		x administrador
	{operid=31, roleid= 6}, -- reset_ws  		x administrador
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
		{nodeid=2,notetype=2,statusid=0,location="Sala 1",posx=100,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.2", datachannel="10002 192.168.0.2 10002"},
		{nodeid=3,notetype=1,statusid=0,location="Sala 1",posx=180,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.3", datachannel="10003 192.168.0.3 10002"},
		{nodeid=4,notetype=1,statusid=2,location="Sala 1",posx=250,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.4", datachannel="10004 192.168.0.4 10002"},
		{nodeid=6,notetype=1,statusid=0,location="Sala 1",posx=378,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.6", datachannel="10006 192.168.0.6 10002"},
		{nodeid=7,notetype=1,statusid=0,location="Sala 1",posx=60,posy=90,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.7", datachannel="10007 192.168.0.7 10002"},
		{nodeid=8,notetype=1,statusid=0,location="Sala 1",posx=120,posy=90,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.8", datachannel="10008 192.168.0.8 10002"},
		{nodeid=9,notetype=1,statusid=0,location="Sala 1",posx=180,posy=90,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.9", datachannel="10009 192.168.0.9 10002"},
		{nodeid=10,notetype=1,statusid=0,location="Sala 1",posx=240,posy=90,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.10", datachannel="10010 192.168.0.10 10002"},
		{nodeid=11,notetype=1,statusid=0,location="Sala 1",posx=280,posy=90,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.11", datachannel="10011 192.168.0.11 10002"},
		{nodeid=12,notetype=1,statusid=0,location="Sala 1",posx=20,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.12", datachannel="10012 192.168.0.12 10002"},
		{nodeid=13,notetype=1,statusid=0,location="Sala 1",posx=40,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.13", datachannel="10013 192.168.0.13 10002"},
		{nodeid=14,notetype=1,statusid=0,location="Sala 1",posx=60,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.14", datachannel="10014 192.168.0.14 10002"},
		{nodeid=15,notetype=1,statusid=0,location="Sala 1",posx=80,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.15", datachannel="10015 192.168.0.15 10002"},
		{nodeid=16,notetype=1,statusid=0,location="Sala 1",posx=240,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.16", datachannel="10016 192.168.0.16 10002"},
		{nodeid=17,notetype=1,statusid=0,location="Sala 1",posx=220,posy=150,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.17", datachannel="10017 192.168.0.17 10002"},
		{nodeid=18,notetype=1,statusid=0,location="Sala 1",posx=100,posy=180,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.18", datachannel="10018 192.168.0.18 10002"},
		{nodeid=19,notetype=1,statusid=0,location="Sala 1",posx=200,posy=180,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.19", datachannel="10019 192.168.0.19 10002"},
		{nodeid=20,notetype=1,statusid=0,location="Sala 1",posx=300,posy=180,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.20", datachannel="10020 192.168.0.20 10002"},
		{nodeid=21,notetype=1,statusid=0,location="Sala 1",posx=378,posy=180,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.21", datachannel="10021 192.168.0.21 10002"},
	  },
	},

	{netid=2,netversion=1,nname="Rede 2.1",description="Rede de Teste 2", vdescription="Versão 1",
	  node={
		{nodeid=1,notetype=1,statusid=0,location="Sala 2",posx=20,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.3", datachannel="10011 192.168.0.3 10002"},
		{nodeid=2,notetype=1,statusid=0,location="Sala 2",posx=60,posy=100,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.4", datachannel="10012 192.168.0.4 10002"},
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
