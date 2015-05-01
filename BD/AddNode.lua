------------------------------------------------------------------
-- Testbed System v2
-- Script to add nodes
--
-- - Add node
--
------------------------------------------------------------------

local md5 = require "md5"
-- load driver
local driver = require "luasql.postgres"
-- create environment object
env = assert (driver.postgres())
-- connect to data source
con = assert (env:connect("portal2","postgres","postgres","localhost"))
con:setautocommit(false)

-- network
networks = {
	{netid=1,netversion=1,nname="Rede 1.1",description="Rede de Teste 1", vdescription="Versão 1",
	  node={
		--{nodeid=1,notetype=1,statusid=0,location="Sala 1",posx=20,posy=20,posz=0,ctlchannel="-dprog=stk500 -dhost=192.168.0.1", datachannel="10001 192.168.0.1 10002"},
	},
	},

	{netid=2,netversion=1,nname="Rede 2.1",description="Rede de Teste 2", vdescription="Versão 1",
	  node={
		--{nodeid=1,notetype=2,statusid=0,location="Sala 2",posx=20,posy=20,posz=0,ctlchannel="192.168.0.101 10005", datachannel="10001 192.168.0.101 10006 "},
		
	  },
	},

}

for i, p in pairs (networks) do
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

-- close everything
if cur then cur:close() end-- already closed because all the result set was consumed
con:close()
env:close()
