------------------------------------------------------------------
-- Testbed System v2
-- Script to create user data for test
--
-- - Create one complete test for each network
--
-- Author - abranco@inf.puc-rio.br
-- Date - 2015, January
------------------------------------------------------------------

-- load driver
local driver = require "luasql.postgres"
-- create environment object
env = assert (driver.postgres())
-- connect to data source
con = assert (env:connect("portal2","postgres","postgres","localhost"))
con:setautocommit(false)


--------------------------
-- Erase user data tables
--------------------------
tables = {
	"test","logdata",
	"agenda",
	"config",
	"scriptsteps","script",
	"netconfigdefaultfiles","netconfignodes","netconfig",
	"userfiles"
}	

for k,tab in pairs (tables) do
	res = assert (con:execute(string.format([[delete from %s]], tab)))
end
con:commit()

--------------------------
-- Create test user data
--------------------------

-- script/scriptsteps
script = {
	{scriptid=1,netid=1,netversion=1,uid=3,cname="A ALL",description="Activate all nodes",steps={{step=1,command="A",paramvalue="ALL"}}},
	{scriptid=2,netid=2,netversion=1,uid=3,cname="A ALL",description="Activate all nodes",steps={{step=1,command="A",paramvalue="ALL"}}},
}

res = assert (con:execute("ALTER SEQUENCE script_planid_seq RESTART WITH 1;"))
for i, p in pairs (script) do
	res = assert (con:execute(string.format([[
		INSERT INTO script(netid,netversion,uid,cname,description)
		VALUES (%d, %d, %d,'%s','%s')]],p.netid,p.netversion,p.uid,p.cname,p.description)
	))
	for k, r in pairs (p.steps) do
	res = assert (con:execute(string.format([[
		INSERT INTO scriptsteps(
				scriptid, step, command, paramvalue)
		VALUES (%d, %d,'%s','%s')]], p.scriptid, r.step, r.command, r.paramvalue)
	))
	end
end
con:commit()

-- userfiles
userfiles = {
	{fileid=1,uid=3,nodetype=1,filename="Blink",description="Blink from Tutorial", bindata=""},
	{fileid=2,uid=3,nodetype=2,filename="Blink",description="Blink from Tutorial",bindata=""},
}

res = assert (con:execute("ALTER SEQUENCE userfiles_fileid_seq RESTART WITH 1;"))
for i, p in pairs (userfiles) do
	res = assert (con:execute(string.format([[
		INSERT INTO userfiles(uid,nodetype,filename,description,bindata)
		VALUES ( %d, %d,'%s','%s','%s')]], p.uid,p.nodetype,p.filename,p.description,p.bindata)
	))
end
-- Updata bindata to correct exe file
	res = assert (con:execute(string.format([[
		update userfiles 
			set bindata = bytea_import('/home/branco/gitspace/Testbed/TBControl/files/blink_micaz.exe')
			where nodetype=1]])
	))
	res = assert (con:execute(string.format([[
		update userfiles 
			set bindata = bytea_import('/home/branco/gitspace/Testbed/TBControl/files/blink_telosb.exe')
			where nodetype=2]])
	))
 --update userfiles set bindata = bytea_import('/home/branco/gitspace/Testbed/TBControl/files/noop_micaz.exe');
con:commit()


-- netconfig/netconfignodes/netconfigdefaultfiles
netconfig = {
	{netconfigid=1,netid=1,netversion=1,uid=3,cname="Teste 1",description="Config. Teste 1",
		defaultfiles={{nodetype=1,fileid=1},{nodetype=2,fileid=2}},
		nodes={
			{nodeid=1,usedefaultfile="FALSE",fileid=1,logicid=1,selected="TRUE"},
			{nodeid=2,usedefaultfile="TRUE",fileid=1,logicid=2,selected="TRUE"},
		}
	},
	{netconfigid=2,netid=2,netversion=1,uid=3,cname="Teste 2",description="Config. Teste 2",
		defaultfiles={{nodetype=1,fileid=1},{nodetype=2,fileid=2}},
		nodes={
			{nodeid=1,usedefaultfile="FALSE",fileid=1,logicid=1,selected="TRUE"},
			{nodeid=2,usedefaultfile="TRUE",fileid=1,logicid=2,selected="TRUE"},
		}
	},
}

res = assert (con:execute("ALTER SEQUENCE netconfig_netconfigid_seq RESTART WITH 1;"))
for i, p in pairs (netconfig) do
	res = assert (con:execute(string.format([[
		INSERT INTO netconfig(netid,netversion,uid,cname,description)
		VALUES ( %d, %d, %d,'%s','%s')]],p.netid,p.netversion,p.uid,p.cname,p.description)
	))
	for k, r in pairs (p.defaultfiles) do
	res = assert (con:execute(string.format([[
		INSERT INTO netconfigdefaultfiles(netconfigid, nodetype, fileid)
		VALUES (%d,%d,%d)]], p.netconfigid, r.nodetype, r.fileid)
	))
	end
	for l, s in pairs (p.nodes) do
	res = assert (con:execute(string.format([[
		INSERT INTO netconfignodes(netconfigid,nodeid, usedefaultfile, fileid,logicid,selected)
		VALUES (%d,%d,%s,%d,%d,%s)]], p.netconfigid,s.nodeid, s.usedefaultfile, s.fileid,s.logicid,s.selected)
	))
	end
end
con:commit()

-- config
config = {
	{configid=1,netid=1,netversion=1,uid=3,netconfigid=1,scriptid=1,cname="Teste 1",description="Config. Teste 1"},
	{configid=2,netid=2,netversion=1,uid=3,netconfigid=2,scriptid=2,cname="Teste 2",description="Config. Teste 2"},
}

res = assert (con:execute("ALTER SEQUENCE configid_seq RESTART WITH 1;"))
for i, p in pairs (config) do
	res = assert (con:execute(string.format([[
		INSERT INTO config(netid,netversion,uid,netconfigid,scriptid,cname,description)
		VALUES ( %d, %d, %i, %i, %d,'%s','%s')]],p.netid,p.netversion,p.uid,p.netconfigid,p.scriptid,p.cname,p.description)
	))
end
con:commit()

-- agenda
offset = 0 -- 3600
now = os.date("*t",os.time()+offset)
start1 = now.year*100000000 + now.month*1000000 + now.day*10000 + now.hour * 100 + math.floor(now.min/30,0)*30
now = os.date("*t",os.time()+offset+1800)
end1 = now.year*100000000 + now.month*1000000 + now.day*10000 + now.hour * 100 + math.floor(now.min/30,0)*30
print(start1,end1)
agenda={
	{idagenda=1,netid=1,startslot=start1,endslot=end1,uid=3,cname="Ag01",description="Agenda 01"},
	{idagenda=2,netid=2,startslot=start1,endslot=end1,uid=3,cname="Ag02",description="Agenda 02"},
}
res = assert (con:execute("ALTER SEQUENCE agenda_idagenda_seq RESTART WITH 1;"))
for i, p in pairs (agenda) do
	res = assert (con:execute(string.format([[
		INSERT INTO agenda(netid,startslot,endslot,uid,cname,description)
		VALUES ( %d, %.0f, %.0f, %d,'%s','%s')]],p.netid,p.startslot,p.endslot,p.uid,p.cname,p.description)
	))
end
con:commit()

-- test
test = {
	{testid=1,netid=1,netversion=1,configid=1,idagenda=1,uid=3,clientip="255.255.255.255",cname="Teste 1",description="Config. Teste 1"},
	{testid=2,netid=2,netversion=1,configid=2,idagenda=2,uid=3,clientip="255.255.255.255",cname="Teste 2",description="Config. Teste 2"},
}

res = assert (con:execute("ALTER SEQUENCE test_testid_seq RESTART WITH 1;"))
for i, p in pairs (test) do
	res = assert (con:execute(string.format([[
		INSERT INTO test(netid,netversion,configid,idagenda,uid,clientip,cname,description)
		VALUES ( %d, %d, %i, %i, %d,'%s','%s','%s')]],p.netid,p.netversion,p.configid,p.idagenda,p.uid,p.clientip,p.cname,p.description)
	))
end
con:commit()


-- close everything
if cur then cur:close() end-- already closed because all the result set was consumed
con:close()
env:close()
