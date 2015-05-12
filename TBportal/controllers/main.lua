local Ssession = require "sailor.session"
--local mail = require "sailor.mail"
local validation = require "valua"
local form = require "sailor.form"

local main = {}
local Gpage

indexData={
  [1]={colId='test',      title='Testes',             url='?r=main/teste',      icon="<i class='fa fa-rocket' style='color:DarkBlue'></i>",  delete=function (con,session,id) return delete_test(con,session,id) end},
  [2]={colId='agenda',    title='Agendamentos',       url='?r=main/agenda',     icon="<i class='fa fa-calendar'  style='color:Green'></i>",  delete=function (con,session,id) return delete_agenda(con,session,id) end},
  [3]={colId='plan',      title='Planos',             url='?r=main/plano',      icon="<i class='fa fa-cogs'  style='color:SaddleBrown '></i>",  delete=function (con,session,id) return delete_plan(con,session,id) end},
  [4]={colId='script',    title='Scripts',            url='?r=main/script',     icon="<i class='fa fa-list'  style='color:Purple '></i>",  delete=function (con,session,id) return delete_script(con,session,id) end},
  [5]={colId='netconfig', title='Config. Rede',       url='?r=main/netconfig',  icon="<i class='fa fa-star-o'  style='color:GoldenRod '></i>",  delete=function (con,session,id) return delete_netconfig(con,session,id) end},
  [6]={colId='userfiles', title='Executáveis',        url='?r=main/arquivo',    icon="<i class='fa fa-files-o'  style='color:red'></i>",  delete=function (con,session,id) return delete_userfiles(con,session,id) end},
}

require "controllers/utilidades"

local session = {}
local SESSION_TIMEOUT = 4 * 60 * 60 -- 4 horas
Ssession.setsessiontimeout(SESSION_TIMEOUT)


-- Controle de objetos para consulta (hierarquia/dependências)
local indexConsulta = {
  [1]={1,3,5}, -- Hierarquia (quem tem filho)
  [2]={2,3,4,5,6} -- Dependências (quem tem pai)
}

function getIndexDataPos(colId)
  for k,v in pairs(indexData) do
    if (v.colId==colId) then return k; end
  end
  return nil;
end

function getIcon(colId) 
  return indexData[getIndexDataPos(colId)].icon;
end
 
--[[

funcao de um controller xxx
recebe 
    page, 
        um objeto contendo as informações passadas pelo servidor
        exemplos: a url, o conteudo de um formulario post, o navegador..
retorna
    nao retorna nada, 
        mas cenvostuma chamar metodos de page, 
        como write ou render, para apresentar uma resposta para o cliente
        se chamar write, a resposta é dada diretamente, util por exemplo para retornar um json.
        se chamar render, o primeiro argumento é a luapage a ser renderizada, ela estará localizada em views/


funcao correspondente a url "?r=xxx/yyy"

function xxx.yyy( page )
    
end

--]]

-- verifica se o usúario etá logado
function checkSession(page,noLogin)
  --Ssession.cleanup()
  local sID = Ssession.open(page.r)
  if Ssession.is_active() then
    if (Ssession.data and Ssession.data.uid) then
      session = Ssession.data
      if ((os.time() - session.created) > SESSION_TIMEOUT) then 
        session={}
        --page:write("<script> popup('alert','Alerta','Sessão expirada!');</script>")
        if not noLogin then main.login(page) end
        return false
      else
        return true
      end
    else
      if not noLogin then main.login(page) end
      return false
    end
  end
  if not noLogin then main.login(page) end
  return false
end

function saveSession(page,sessionData)
  Ssession.open(page.r)
  Ssession.save(sessionData)
  session = Ssession.data
end

-- renderiza a situação atual do usuario no banco, dando uma visão geral.
-- monta 6 colunas, cada uma com um titulo, uma url para o formulario em que o usuario poderá adicionar uma nova linha e as linhas obtidas atraves das funções get_xxx, declaradas em utilidades.lua  
function main.index( page )
    if not checkSession(page) then return end
    env,con = connect()

    local errormsg
    if next(page.GET) then
      if page.GET.activetab then
        session.activeTab=page.GET.activetab
      end
      if page.GET.action then
        if page.GET.action =='up' then
          local pos = page.GET.col
          session.activeTab = session.activeTab:sub(1, pos-1) .. '1' .. session.activeTab:sub(pos+1)
          saveSession(page,session)
        end
        if page.GET.action =='down' then
          local pos = page.GET.col
          session.activeTab = session.activeTab:sub(1, pos-1) .. '0' .. session.activeTab:sub(pos+1)
          saveSession(page,session)
        end
        if page.GET.action =='del' then
          local pos = page.GET.col
          local id = page.GET.id
          local stat, err = indexData[tonumber(pos)].delete(con,session,id)
          if (tonumber(pos) == getIndexDataPos('test') and stat) then sendTBControl(session.netid,id,TBC.newConfig); end
          if not stat then errormsg = "Item não pode ser removido.Verifique se está sendo utilizado em alguma configuração." end
        end
        if page.GET.action =='oldtest' then
          session.oldtest = (((session.oldtest == 'true') and 'false') or 'true')
          saveSession(page,session)
        end
      end
    end


    local targets = get_targets(con,session)

    local testes = get_tests(con,session,((session.oldtest=='true') and 'all') or 'new')
    testes.icon = indexData[1].icon
    testes.nome = indexData[1].title
    testes.url = indexData[1].url
    testes.actions={}
    for i,row in ipairs(testes) do
      row.actions={}
      if row.old then
        table.insert(row.actions,{icon="fa  fa-file-text-o pull-right",href="?r=main/viewlog&testid="..row.id,title="Visualizar log"})
      else
        table.insert(row.actions,{icon="",href="#",title=""})
      end    
    end
    
    local flagAll = false
    local agendas = get_agendas(con,session,flagAll)
    agendas.icon = indexData[2].icon
    agendas.nome = indexData[2].title
    agendas.url = indexData[2].url
    for i,row in ipairs(agendas) do
        row.actions={}
        table.insert(row.actions,{icon="fa  fa-link pull-right",href="#",title="Dependências",onclick="viewDep('"..indexData[2].colId .."',".. 2 ..","..row.id ..")"})
    end

    local planos = get_planos(con,session)
    planos.icon = indexData[3].icon
    planos.nome = indexData[3].title
    planos.url = indexData[3].url
    for i,row in ipairs(planos) do
        row.actions={}
        table.insert(row.actions,{icon="fa  fa-link pull-right",href="#",title="Dependências",onclick="viewDep('"..indexData[3].colId .."',".. 3 ..","..row.id ..")"})
    end

    local scripts = get_scripts(con,session)
    scripts.icon = indexData[4].icon
    scripts.nome = indexData[4].title
    scripts.url = indexData[4].url
    for i,row in ipairs(scripts) do
        row.actions={}
        table.insert(row.actions,{icon="fa  fa-link pull-right",href="#",title="Dependências",onclick="viewDep('"..indexData[4].colId .."',".. 4 ..","..row.id ..")"})
    end

    local netconfigs = get_netconfig(con,session)
    netconfigs.icon = indexData[5].icon
    netconfigs.nome = indexData[5].title
    netconfigs.url = indexData[5].url
    for i,row in ipairs(netconfigs) do
        row.actions={}
        table.insert(row.actions,{icon="fa  fa-link pull-right",href="#",title="Dependências",onclick="viewDep('"..indexData[5].colId .."',".. 5 ..","..row.id ..")"})
    end

    local arquivos = get_userfiles(con,session)
    arquivos.icon = indexData[6].icon
    arquivos.nome = indexData[6].title
    arquivos.url = indexData[6].url
    for i,row in ipairs(arquivos) do
        row.actions={}
        table.insert(row.actions,{icon="fa  fa-link pull-right",href="#",title="Dependências",onclick="viewDep('"..indexData[6].colId .."',".. 6 ..","..row.id ..")"})
    end
    
    
       
    local data = {}
    table.insert(data,testes)    
    table.insert(data,agendas)    
    table.insert(data,planos)    
    table.insert(data,scripts)
    table.insert(data,netconfigs)
    table.insert(data,arquivos)
    if (errormsg) then data.alert = errormsg end
    
    close_connect(env,con)
    page:render('index',{session=session,tabela = data,activetab=session.activeTab})
end
--[[ 
renderiza a agenda:
    obtendo a data atual, baseada no sistema operacional;
    usando a função getslots do banco de dados;
    montando uma matriz de 48 horarios (30min cada) por 7 dias da semana;
    passando essa matriz para a luapage;
--]]
function main.agenda(page)
  if not checkSession(page) then return end
  env,con = connect()
  local date = os.date("*t")
  
  local agenda={}

    if next(page.POST) then
      par = page.POST
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
      agenda.btnSave = 'true'
      agenda.duration_color ='back'
      if par.nd_newdate then
        agenda.idagenda = tonumber(par.nd_idagenda)
        agenda.name = con:escape(par.nd_name)
        agenda.description = con:escape(par.nd_description)
        agenda.startslot = con:escape(par.nd_startslot)
        agenda.startslot_str = con:escape(par.nd_startslot_str)
        agenda.startslot_dt = con:escape(par.nd_startslot_dt)
        agenda.endslot = con:escape(par.nd_endslot)
        agenda.endslot_str = con:escape(par.nd_endslot_str)
        agenda.endslot_dt = con:escape(par.nd_endslot_dt)
        agenda.duration = con:escape(par.nd_duration)
        agenda.duration_color = con:escape(par.nd_duration_color)
        agenda.btnSave = con:escape(par.nd_btnSave) 

        date = os.date("*t",os.time{year=par.nd_year, month=par.nd_month, day=par.nd_day})
              
      else            
        agenda.name = con:escape(par.name)
        agenda.description = con:escape(par.description)
        agenda.startslot = con:escape(par.startslot)
        agenda.endslot = con:escape(par.endslot)
        agenda.startslot_dt = con:escape(par.startslot_dt)
        agenda.endslot_dt = con:escape(par.endslot_dt)
  
        action = con:escape(par.action)
        if action=='save' then
          local stat, err = insert_agenda(con,session,agenda)
          -- if not stat then page:print('UtilError: ',stat or '-', err or '-'); x = 1+c end
            if not stat then
              agenda={}
              agenda.alert="Não foi possível criar a agenda.</br>Possivelmente nem todos os slots estão livres."
            end
        end
        if action=='update' then
          if tonumber(par.idagenda) and tonumber(par.idagenda) ~= 0 then
            agenda.idagenda = tonumber(par.idagenda)
            if agendaIsCurrent(con,session,agenda.idagenda) > 0 then
                  agenda.alert="Não foi possível atualizar a agenda.</br>Agenda está associada ao teste corrente."
            else
              local stat, err = update_agenda(con,session,agenda)
              --if not stat then page:print('UtilError: ',stat or '-', err or '-'); x = 1+c end
              if not stat then
                agenda.alert="Não foi possível atualizar a agenda.</br>Possivelmente nem todos os slots estão livres."
              end
            end
          end

        end
      end
--[[
for k,v in pairs(agenda) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      if type(z)=='table' then
        for r,s in pairs(z) do
          page:print('</br>----',r,'|',s)
        end
      else
          page:print('</br>----',x,'|',z)
      end
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
    else
      if next(page.GET) then
        if page.GET.id then
          local idagenda = page.GET.id
          agenda=get_agenda_byid(con,session,idagenda)
          date = os.date("*t",(os.time(agenda.start_date) - (24*60*60)))
          agenda.btnSave = 'false'
        end
      end
    end
  
  local slots = get_slots(con,session,date.year,date.month,date.day)
    close_connect(env,con)
    for i=1,#slots do
      _ , _ , slots[i].year,slots[i].month,slots[i].day,slots[i].hour,slots[i].min = slot2date(slots[i].slot)
      slots[i].monthstr = strmonth[tonumber(slots[i].month)];
      slots[i].wdaystr =  strwday[os.date("*t",os.time(slots[i])).wday]
    end
    slots.refDate=date
    
  if not(agenda.alert) and (action=='save' or action=='update') then
    main.index(page)
  else
    page:render('agenda',{session=session,form=form, slots = slots,agenda = agenda, session=session})
  end
end

-- Ajax call
function main.getTestLog(page)
  if not checkSession(page,true) then  page:write(""); return end
  env,con = connect()
  local testid=0
  local testname=''
  local lines=0

  if next(page.POST) then
    local par = page.POST
    local wdt1='50px'
    local wdt2='150px'
    local wdt3='30px'
    local wdt4='60px'
    local testid, testname, logTable = get_logdelta(con,session,par.last_logseq,par.cmd)
    lines = #logTable
    if (par.cmd == 'TEST') then
      page:write("<!-- "..testid .. ' '.. lines .. ' *** '.. testname ..'-->')
    else
      page:write("<!-- ".. lines ..'-->')
    end
    for k,reg in pairs(logTable) do 
      local logtype=reg.logtype
      if string.find(reg.logline,"ERROR:") then
        logtype = '<font color="red">'..reg.logtype .. '</font>'
      end
      page:write('<tr>')
      page:write('<td hidden >'.. reg.logseq ..'</td>')
      page:write('<td style="min-width:'..wdt2 ..';">'.. reg.logtime ..'</td>')
      page:write('<td style="min-width:'..wdt3 ..';" '.. 'align="center">'.. reg.nodeid ..'</td>')
      page:write('<td style="min-width:'..wdt4 ..';">'..logtype ..'</td>')
      page:write('<td >'.. reg.logline ..'</td>')
      page:write('</tr>')
    end
  else
    page:write("<!-- "..testid .. ' '.. lines .. ' *** '.. testname ..'-->')
  end
    close_connect(env,con)
end

function main.test_monitor(page) 
    if not checkSession(page) then return end
    page:render('test_monitor',{session=session})
end
function main.sys_monitor(page) 
    if not checkSession(page) then return end
    page:render('sys_monitor',{session=session})
end

function main.viewlog(page) 
  if not checkSession(page) then return end
  env,con = connect()
  local logdata={}
  if next(page.POST) and page.POST.testid then
    logdata, logTable = get_log(con,session,page.POST.testid)
    close_connect(env,con)
    logdata.data = ""
    for k,reg in pairs(logTable) do 
      line = reg.logseq .. ', ' .. reg.logtime .. ', ' .. reg.nodeid .. ', ' .. reg.logtype .. ', ' .. reg.logline .. '\n'
      logdata.data= logdata.data .. line
    end    
    local serverfile = os.tmpname()
    local filename = "tblog_"..session.netid .."_" .. logdata.testid   ..".log"
    file, err = io.open (serverfile , 'w')
    io.output(file)
    io.write(logdata.data)
    io.close(file)          
    page.r.content_type="application/text"
    page.r.headers_out["Content-Disposition"]="attachment; filename="..filename
    page.r:sendfile(serverfile)
    os.remove(serverfile)
    return
  else
    if next(page.GET) and page.GET.testid then
      local wdt1='50px'
      local wdt2='150px'
      local wdt3='30px'
      local wdt4='60px'
      logdata, logTable = get_log(con,session,page.GET.testid)
      logdata.data = ""
      for k,reg in pairs(logTable) do 
        local logtype=reg.logtype
        if string.find(reg.logline,"ERROR:") then
          logtype = '<font color="red">'..reg.logtype .. '</font>'
        end
        logdata.data= logdata.data .. '<tr>'
        logdata.data= logdata.data .. '<td hidden >'.. reg.logseq ..'</td>'
        logdata.data= logdata.data .. '<td style="min-width:'..wdt2 ..';">'.. reg.logtime ..'</td>'
        logdata.data= logdata.data .. '<td style="min-width:'..wdt3 ..';" '.. 'align="center">'.. reg.nodeid ..'</td>'
        logdata.data= logdata.data .. '<td style="min-width:'..wdt4 ..';">'..logtype ..'</td>'
        logdata.data= logdata.data .. '<td >'.. reg.logline ..'</td>'
        logdata.data= logdata.data .. '</tr>'
      end
      close_connect(env,con)
      page:render('viewlog',{session=session,log=logdata})
      return
    end
  end
end


function main.arquivo(page)
    if not checkSession(page) then return end
    env,con = connect()
    local userfile
    local action
    local POST
    local alert

    if (page.r.method == 'POST') and not page.POST.action then -- retry parsebosy() if the first from Sailor fails.
        POST = page.r:parsebody(250000)
    else
        POST = page.POST
    end
    if POST.action then
        local par = POST
        local serverfile = os.tmpname ()
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      if type(z)=='table' then
        for r,s in pairs(z) do
          page:print('</br>----',r,'|',s)
        end
      else
          page:print('</br>----',x,'|',z)
      end
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
        action = par.action
        if action=='save' then
          file, err = io.open (serverfile , 'w')
          io.output(file)
          io.write(POST.bindata)
          io.close(file)
          os.execute('chmod ugo+r '..serverfile)  
          local stat = insert_userfiles(con,session,par.nodetype,par.filename,par.description,serverfile)
          if not stat then alert="Erro para salvar arquivo! ".. serverfile end
          os.remove(serverfile)
        end
        if action=='update' and par.fileid ~= '0' then
          local stat = update_userfiles(con,session,par.fileid, par.filename,par.description)
          if not stat then alert="Erro para atualizar arquivo! ".. par.filename end
        end
    else
      if next(page.GET) then
        if (page.GET.id) then
          userfile = get_userfile_byid(con,session,page.GET.id)
        end
      end
     end

    local targets = get_targets(con,session)
    close_connect(env,con)
    if (action=='update') then
      main.index(page)
    else
      page:render('arq',{session=session, targets = targets,userfile=userfile,alert=alert})
    end
end


function main.teste(page) 
    if not checkSession(page) then return end
    env,con = connect()
    
    local test={}
    if next(page.POST) then
      par = page.POST
      test.name = par.testname
      test.description = par.description
      test.idagenda = par.idagenda
      test.planid = par.planid
      test.remote_addr = par.remote_addr

      action = par.action
      if action=='save' then
        local testid, err = insert_test(con,session,test)
        if testid then 
          sendTBControl(session.netid,testid,TBC.newConfig)
        else
          test.alert='UtilError: ' .. (stat or '-') .. ' '.. (err or '-')
        end
      end
      if action=='update' and par.testid ~= '0' then
        test.testid = par.testid
        local stat, err = update_test(con,session,test)
        if stat then 
          sendTBControl(session.netid,test.testid,TBC.newConfig)
        else
          test.alert='UtilError: ' .. (stat or '-') .. ' '.. (err or '-')
        end
      end
    else
      if next(page.GET) then
        if page.GET.id then
          local testid = page.GET.id
          test=get_test_byid(con,session,testid) 
        end
      end
    end

    local planos = get_planos(con,session)
    local agendas = get_agendas(con,session,false)
    close_connect(env,con)
    page:render('teste',{session=session,form = form, planos = planos, test = test,agendas = agendas })
end

function splitSript(str)
  local t = {}
  local function helper(line)
    line = line:match "^%s*(.-)%s*$" -- trim from PiL2 20.4
    if string.len(line)>0 then 
      local r={}
      r.line = line
      r.command = string.upper(string.sub(line,1,1))
      r.paramvalue =  string.sub(line,2):match "^%s*(.-)%s*$" -- trim from PiL2 20.4
      table.insert(t, r) 
    end 
    return "" 
  end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function scriptCheck(t)
  for k,v in pairs(t) do
    if v.command == 'W' then
      if string.match(v.paramvalue, '[^0-9]') then -- Num: Só pode ter números
        return string.format("Parâmetro inválido para o comando '%s' na linha %d",v.command,k)
      end
    elseif v.command == 'A' or v.command == 'D' then
      if v.paramvalue=='ALL' then
      else      
        if not string.match(v.paramvalue, '[^0-9,%s]+') then  -- Lista: Só pode ter numeros, virgulas e espaços
          if string.match(v.paramvalue, '[0-9]+%s+[0-9]') then -- Não pode ter espaços entre números
            return string.format("Parâmetro inválido para o comando '%s' na linha %d",v.command,k)
          end
        elseif string.match(v.paramvalue, '^[0-9]+[%s]*%.%.[%s]*[0-9]+$') then -- Range: num .. num 
        elseif not string.match(v.paramvalue, '[^0-9]') then -- Num: Só pode ter números
        else
            return string.format("Parâmetro inválido para o comando '%s' na linha %d",v.command,k)      
        end
      end
    else
      return string.format("Comando '%s' inválido na linha %d",v.command,k)    
    end
  end
end

function main.script(page)
    if not checkSession(page) then return end
    env,con = connect()
 
    local script={}
    if next(page.POST) then
      par = page.POST
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
      script.name = par.scriptname
      script.description = par.description
      script.steps=splitSript(par.scriptsteps)
      script.text=""
      for i=1,#script.steps do script.text = script.text .."\r\n"..script.steps[i].command .." ".. script.steps[i].paramvalue end

      script.alert = scriptCheck(script.steps)

      if not script.alert then
        action = par.action
        if action=='save' then
          local stat, err = insert_script(con,session,script)
          if not stat then page:print('UtilError: ',stat or '-', err or '-') end
        end
        if action=='update' and par.scriptid ~= '0' then
          script.scriptid= par.scriptid
          local stat, err = update_script(con,session,script)
          if not stat then page:print('UtilError: ',stat or '-', err or '-') end
        end
      else
        script.scriptid= par.scriptid
      end
    else
      if next(page.GET) then
        if page.GET.id then
          local scriptid = page.GET.id
          script=get_script_byid(con,session,scriptid) 
          script.text=""
          for i=1,#script.steps do script.text = script.text .."\r\n"..script.steps[i].line end
        end
      end
    end

--[[
for k,v in pairs(script) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      if type(z)=='table' then
        for r,s in pairs(z) do
          page:print('</br>----',r,'|',s)
        end
      else
        page:print('>',z)  
      end
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
    page:render('script',{session=session,form = form, script = script,targets = targets})
end
function main.plano(page)
    if not checkSession(page) then return end
    env,con = connect()

    local plan={}
    if next(page.POST) then
      par = page.POST
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
      plan.name = par.planname
      plan.description = par.description
      plan.netconfigid = par.netconfigid
      plan.scriptid = par.scriptid

      action = par.action
      if action=='save' then
        local stat, err = insert_plano(con,session,plan)
        if not stat then page:print('UtilError: ',stat or '-', err or '-'); x = 1+c end
      end
      if action=='update' and par.planid ~= '0' then
        plan.planid = par.planid
        local stat, err = update_plano(con,session,plan)
        if not stat then page:print('UtilError: ',stat or '-', err or '-'); x = 1+c end
      end
    else
      if next(page.GET) then
        if page.GET.id then
          local planid = page.GET.id
          plan=get_plan_byid(con,session,planid) 
        end
      end
    end

--[[
for k,v in pairs(plan) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      if type(z)=='table' then
        for r,s in pairs(z) do
          page:print('</br>----',r,'|',s)
        end
      else
        page:print('>',z)  
      end
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]

    local netconfigs = get_netconfig(con,session)
    local scripts = get_scripts(con,session)
    close_connect(env,con)
    page:render('plano',{session=session,form = form, plan = plan,netconfigs = netconfigs, scripts = scripts})
end

function main.netconfig(page)
    if not checkSession(page) then return end
    env,con = connect()
 
    local netconfig={}
    if next(page.POSTMULTI) then
      par = page.POSTMULTI
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end

end
 x= 1+c
--]] 
      netconfig.name = par.name[1]
      netconfig.description = ((string.len(par.description[1])==0) and "") or par.description[1]
      netconfig.default={}
      for i=1,#par.deftype do
        netconfig.default[par.deftype[i]]={}
        netconfig.default[par.deftype[i]].nodetype = par.deftype[i]
        netconfig.default[par.deftype[i]].fileid = par.deffileid[i]
      end              
      netconfig.nodes={}
      local notAlert
      local qttSelected=0
      for i=1,#par.nodeid do
        netconfig.nodes[par.nodeid[i]]={}
        netconfig.nodes[par.nodeid[i]].nodeid = par.nodeid[i]
        netconfig.nodes[par.nodeid[i]].defaultBool = (par.default[i]=='1' and 'true') or 'false'
        netconfig.nodes[par.nodeid[i]].default = par.default[i]
        netconfig.nodes[par.nodeid[i]].fileid = ((par.fileid[i] == '-') and netconfig.default[par.nodetype[i]].fileid) or par.fileid[i]
        netconfig.nodes[par.nodeid[i]].logicid = par.logicid[i]
        netconfig.nodes[par.nodeid[i]].selectedBool = (par.selected[i]=='1' and 'true') or 'false'
        netconfig.nodes[par.nodeid[i]].selected = (par.selected[i]=='1' and '1') or '0'
        qttSelected = (par.selected[i]=='1' and (qttSelected+1)) or qttSelected
        local fileid = netconfig.nodes[par.nodeid[i]].fileid
        if (netconfig.nodes[par.nodeid[i]].selected == '1') and 
            not(tonumber(fileid) and tonumber(fileid) >0)       
        then notAlert=true end
      end        
      if notAlert then netconfig.alert = "Erro na configuração.</br>Nó selecionado e sem arquivo binário." end
    
      if qttSelected == 0 then netconfig.alert = "Erro na configuração.</br>Nenhum nó foi selecionado." end

      action = par.action[1]
      if not(netconfig.alert) and action=='save' then
        local stat, err = insert_netconfig(con,session,netconfig)
        if stat then netconfig.netconfigid=stat end
        if not stat then netconfig.alert=('UtilError: '.. (stat or '-') .. (err or '-')) end
      end
      if not(netconfig.alert) and action=='update' and par.netconfigid[1] ~= '0' then
        netconfig.netconfigid = par.netconfigid[1]
        if not(netconfig.alert) then
          local stat, err = update_netconfig(con,session,netconfig)
          if not stat then netconfig.alert=('UtilError: '.. (stat or '-') .. (err or '-')) end
        end
      end
    else
      if next(page.GET) then
        if page.GET.id then
          local netconfigid = page.GET.id
          netconfig=get_netconfig_byid(con,session,netconfigid)
        end
      end
    end
    local targets = get_targets(con,session)
    local motes = get_network(con,session)
    local netconfigs = get_netconfig(con,session)
    local arquivos = get_userfiles(con,session)
    close_connect(env,con)
    page:render('topologia',{session=session,motes = motes, netconfig = netconfig,arquivos = arquivos,targets = targets}) 
end

function main.update_net(page)
    if not checkSession(page) then return end
    env,con = connect()
    local auxNetId,auxNetVersion
    local alert
    local network={}

    local nodestype = get_nodestype(con,session)
    local nodestatus = get_nodestatus(con,session)
    
    if next(page.POSTMULTI) then
      local par = page.POSTMULTI
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end

end
 x= 1+c
--]] 
      network.netid = par.netid[1]
      network.netversion = par.netversion[1]
      network.nname = par.name[1]
      network.description = par.description[1]
      network.vdescription = par.vdescription[1]
      network.nodes={}
      local nodes={}
      local max_nodeid=0
      for i=1,#par.nodeid do
        nodes[tonumber(par.nodeid[i])]={}
        nodes[tonumber(par.nodeid[i])].nodeid = par.nodeid[i]
        nodes[tonumber(par.nodeid[i])].nodetype = par.nodetype[i]
        nodes[tonumber(par.nodeid[i])].typeshort = par.typeshort[i]
        nodes[tonumber(par.nodeid[i])].statusid = par.statusid[i]
        nodes[tonumber(par.nodeid[i])].location = par.location[i]
        nodes[tonumber(par.nodeid[i])].posx = par.posx[i]
        nodes[tonumber(par.nodeid[i])].posz = par.posz[i]
        nodes[tonumber(par.nodeid[i])].posy = par.posy[i]
        nodes[tonumber(par.nodeid[i])].ctlchannel = par.ctlchannel[i]
        nodes[tonumber(par.nodeid[i])].datachannel = par.datachannel[i]
        max_nodeid = ((max_nodeid < tonumber(par.nodeid[i])) and tonumber(par.nodeid[i])) or max_nodeid
      end
      -- Sort nodes table
      for i=1,max_nodeid do
        if nodes[i] then
          table.insert(network.nodes,nodes[i])
        end
      end
      local stat, err = update_netdata(con,session,network)
      if stat then
        alert = "Atualização efetuada com sucesso!"
        changeNetSession(page,con)
      else
        alert = "Falha de atualização! "
      end
    else
      network = get_netdata(con,session,auxNetId,auxNetVersion)
    end
    close_connect(env,con)
    page:render('update_net',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
end


-- Change Network values from 'session' after some modification like newVersion or newNet
function changeNetSession(page,con)
    local networks = get_networks(con) -- vai ser colocado na session
    local netversion, netname = get_netversion(con,session.netid)
    session.netversion = tonumber(netversion)
    session.netname = netname
    session.networks=networks
    saveSession(page,session)
end

function main.new_version(page)
    if not checkSession(page) then return end
    env,con = connect()
    local auxNetId,auxNetVersion
    local alert
    local network={}

    local nodestype = get_nodestype(con,session)
    local nodestatus = get_nodestatus(con,session)
    
    if next(page.POSTMULTI) then
      local par = page.POSTMULTI
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end

end
 x= 1+c
--]] 
      network.netid = par.netid[1]
      network.netversion = par.netversion[1]
      network.nname = par.name[1]
      network.description = par.description[1]
      network.vdescription = par.vdescription[1]
      network.nodes={}
      local nodes={}
      local max_nodeid=0
      for i=1,#par.nodeid do
        nodes[tonumber(par.nodeid[i])]={}
        nodes[tonumber(par.nodeid[i])].nodeid = par.nodeid[i]
        nodes[tonumber(par.nodeid[i])].nodetype = par.nodetype[i]
        nodes[tonumber(par.nodeid[i])].typeshort = par.typeshort[i]
        nodes[tonumber(par.nodeid[i])].statusid = par.statusid[i]
        nodes[tonumber(par.nodeid[i])].location = par.location[i]
        nodes[tonumber(par.nodeid[i])].posx = par.posx[i]
        nodes[tonumber(par.nodeid[i])].posz = par.posz[i]
        nodes[tonumber(par.nodeid[i])].posy = par.posy[i]
        nodes[tonumber(par.nodeid[i])].ctlchannel = par.ctlchannel[i]
        nodes[tonumber(par.nodeid[i])].datachannel = par.datachannel[i]
        max_nodeid = ((max_nodeid < tonumber(par.nodeid[i])) and tonumber(par.nodeid[i])) or max_nodeid
      end
      -- Sort nodes table
      for i=1,max_nodeid do
        if nodes[i] then
          table.insert(network.nodes,nodes[i])
        end
      end
      local stat, err = insert_netversion(con,session,network)
      if stat then
        alert = "Criação da nova versão efetuada com sucesso!"
        changeNetSession(page,con)
        local rolesdata = get_roles(con)
        close_connect(env,con)
        page:render('new_version',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
      else
        alert = "Falha ao criar nova versão! "
        close_connect(env,con)
        page:render('new_version',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
      end
    else
      network = get_netdata(con,session,auxNetId,auxNetVersion)
      close_connect(env,con)
      page:render('new_version',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
    end
end

function main.new_net(page)
    if not checkSession(page) then return end
    env,con = connect()
    local auxNetId,auxNetVersion
    local alert
    local network={}

    local nodestype = get_nodestype(con,session)
    local nodestatus = get_nodestatus(con,session)
    
    if next(page.POSTMULTI) then
      local par = page.POSTMULTI
--[[
for k,v in pairs(par) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end

end
 x= 1+c
--]]
      network.netid = par.netid[1]
      network.netversion = par.netversion[1]
      network.nname = par.name[1]
      network.description = par.description[1]
      network.vdescription = par.vdescription[1]
      network.nodes={}
      local nodes={}
      local max_nodeid=0
      for i=1,#par.nodeid do
        nodes[tonumber(par.nodeid[i])]={}
        nodes[tonumber(par.nodeid[i])].nodeid = par.nodeid[i]
        nodes[tonumber(par.nodeid[i])].nodetype = par.nodetype[i]
        nodes[tonumber(par.nodeid[i])].typeshort = par.typeshort[i]
        nodes[tonumber(par.nodeid[i])].statusid = par.statusid[i]
        nodes[tonumber(par.nodeid[i])].location = par.location[i]
        nodes[tonumber(par.nodeid[i])].posx = par.posx[i]
        nodes[tonumber(par.nodeid[i])].posz = par.posz[i]
        nodes[tonumber(par.nodeid[i])].posy = par.posy[i]
        nodes[tonumber(par.nodeid[i])].ctlchannel = par.ctlchannel[i]
        nodes[tonumber(par.nodeid[i])].datachannel = par.datachannel[i]
        max_nodeid = ((max_nodeid < tonumber(par.nodeid[i])) and tonumber(par.nodeid[i])) or max_nodeid
      end
      -- Sort nodes table
      for i=1,max_nodeid do
        if nodes[i] then
          table.insert(network.nodes,nodes[i])
        end
      end
      local stat, err = insert_netversion(con,session,network)
      if stat then
        alert = "Criação da nova rede efetuada com sucesso!"
        session.netid=network.netid
        session.netversion=network.netversion
        insert_slotstemplate(con,session,network.netid)
        changeNetSession(page,con)
        local rolesdata = get_roles(con)
        close_connect(env,con)
        page:render('new_net',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
      else
        alert = "Falha ao criar nova rede! "
        close_connect(env,con)
        page:render('new_net',{session=session, network=network, nodestype=nodestype, nodestatus=nodestatus,alert=alert})
      end
    else
      close_connect(env,con)
      page:render('new_net',{session=session, nodestype=nodestype, nodestatus=nodestatus})
    end
end


function main.update_nodestype(page)
  if not checkSession(page) then return end
    env,con = connect()
    local nodestype={}
    local alert
    
    
    if next(page.POSTMULTI) then
      local par = page.POSTMULTI
      if par.action[1] == 'update' then
        for i=1,#par.nodetype do
          nodestype[par.nodetype[i]]={}
          nodestype[par.nodetype[i]].nodetype = par.nodetype[i]
          nodestype[par.nodetype[i]].short = par.short[i]
          nodestype[par.nodetype[i]].description = par.description[i]
        end
        local stat, err = update_nodestype(con,session,nodestype)
        if stat then
          alert = "Atualização efetuada com sucesso!"
        else
          alert = "Falha de atualização! "
        end
      end
      if par.action[1] == 'create' then
        local i=1
        nodestype[par.nodetype[i]]={}
        nodestype[par.nodetype[i]].nodetype = par.nodetype[i]
        nodestype[par.nodetype[i]].short = par.short[i]
        nodestype[par.nodetype[i]].description = par.description[i]
        local stat, err = insert_nodestype(con,session,nodestype)
        if stat then
          alert = "Criação efetuada com sucesso!"
        else
          alert = "Falha de criação! Possivelmente ID já existe."
        end
      end
    else
      if next(page.GET) then
          if page.GET.action=='del' then
            if page.GET.nodetype then        
              local nodetype = page.GET.nodetype
              local stat, err = delete_nodestype(con,session,nodetype)
              if stat then
                alert = "Remoção efetuada com sucesso!"
              else
                alert = "Falha de remoção! Possivelmente ID em uso por alguma rede/versão."
              end
            end
          end
      end
    end
    nodestype = get_nodestype(con,session)
    close_connect(env,con)
    page:render('update_nodestype',{session=session,nodestype=nodestype,alert=alert})
end



function main.login(page)
    env,con = connect()
      
    local lsession={}
    
    if next(page.POST) and page.POST.btnLogin then
        local par = page.POST
        -- Verifica se o banco está configurado com as Redes/nós
        if check_DBConfig(con) > 0 then 
               
          local userid,uname = validate_user(con,par.ulogin,par.password) 
          if userid ~= nil then
              
              local networks = get_networks(con) -- vai ser colocado na session
              local userconfig = get_userconfig(con,userid)
              local netversion, netname = get_netversion(con,userconfig.netdefault)
              local roles = get_userroles(con,userid)
              local rolesdata = get_roles(con)
       
              lsession.uid = userid
              lsession.ulogin = par.ulogin
              lsession.username = uname
              lsession.netid = userconfig.netdefault
              lsession.netversion = tonumber(netversion)
              lsession.netname = netname
              lsession.activeTab=userconfig.activetab
              lsession.networks=networks
              lsession.oldtest=userconfig.showoldtests
              lsession.role = userconfig.roledefault
              lsession.roles = roles
              lsession.remote_addr = page.r.useragent_ip
              lsession.created = os.time()
              
              saveSession(page,lsession)
              close_connect(env,con)
              page:render(rolesdata.entry[userconfig.roledefault],{session=session})
          else
              close_connect(env,con)
              local alert = "Usuário/Senha inválido!"
              page:render('login',{session=session,alert=alert})
          end
      else
          close_connect(env,con)
          local alert = "Banco de dados não está configurado corrretamente!</br>Favor avisar ao administrador do Testbed."
          page:render('login',{session=session,alert=alert})
      end
    else
      close_connect(env,con)
      page:render('login',{session=session})
    end
end    


function main.logout(page)
    Ssession.destroy(page.r)
    session={}
    main.login(page)
end

function main.newnetid(page)
    if not checkSession(page) then return end
    if next(page.GET) then
      if page.GET.netid then
        env,con = connect()
        local netversion,netname = get_netversion(con,page.GET.netid)
        session.netid = tonumber(page.GET.netid)
        session.netversion = tonumber(netversion)
        session.netname = netname
        saveSession(page,session)
        local userconfig = get_userconfig(con,session.uid)
        local rolesdata = get_roles(con)
        close_connect(env,con)
        page:render(rolesdata.entry[userconfig.roledefault],{session=session})
      end
    end
end

function main.userconfig(page)
  if not checkSession(page) then return end
  env,con = connect()
 
  local defaultConfig = get_userconfig(con,session.uid); 

  if next(page.POST) then
    if page.POST.newPassword then
      local userid = validate_user(con,session.ulogin,page.POST.old_password)
      if userid ~= nil then
        if page.POST.new_password1 ~= page.POST.new_password2 then
          --deny
          local alert = "Senhas diferentes!"
          close_connect(env,con)
          page:render('userconfig',{session=session,config=defaultConfig,alert=alert,indexData=indexData})
        else
          --accept + update DB
          local stat, err = update_password(con,session,page.POST.old_password,page.POST.new_password1)
          if not stat then page:print('UtilError: ',stat or '-', err or '-'); x = 1+c end
          close_connect(env,con)
          --local alert = "Senha salva com sucesso!"
          main.index(page)
        end
      else
        --deny
        local alert = "Senha de usuario inválida!"
        close_connect(env,con)
        page:render('userconfig',{session=session,config=defaultConfig,alert=alert,indexData=indexData})
      end
    end
    
    if page.POST.newUserconfig then
      local newConfig = {}
      local userid = validate_user(con,session.ulogin,page.POST.cfg_password)

      if userid ~= nil   then

        newConfig['netdefault'] = page.POST.netdefault
        newConfig['activetab'] = page.POST.activetabs
        newConfig['roledefault'] = page.POST.roledefault
        newConfig['showoldtests'] = page.POST.showoldtests
     
        update_userconfig(con,userid,newConfig,page)

        -- read new config and save to session
        local userconfig = get_userconfig(con,userid)
        local netversion, netname = get_netversion(con,userconfig.netdefault)
        session.netid = userconfig.netdefault
        session.netversion = tonumber(netversion)
        session.netname = netname
        session.activeTab=userconfig.activetab
        session.oldtest=userconfig.showoldtests
        session.role = userconfig.roledefault
        saveSession(page,session)
        local rolesdata = get_roles(con)
        close_connect(env,con)
        page:render(rolesdata.entry[userconfig.roledefault],{session=session})
      else
        local alert = "Senha de usuario inválida!"
        close_connect(env,con)
        page:render('userconfig',{session=session,config=defaultConfig,alert=alert,indexData=indexData})
      end
    end
    
    if page.POST.newSessionRole then
      local userid = validate_user(con,session.ulogin,page.POST.role_password)
      if userid ~= nil   then
        session.role = page.POST.roledefault
        saveSession(page,session)
        local rolesdata = get_roles(con)
        close_connect(env,con)
        page:render(rolesdata.entry[session.role],{session=session})
      else
        local alert = "Senha de usuario inválida!"
        close_connect(env,con)
        page:render('userconfig',{session=session,config=defaultConfig,alert=alert,indexData=indexData})
      end
    end
  else
    close_connect(env,con)
    page:render('userconfig',{session=session,config=defaultConfig,indexData=indexData})
  end
end

function main.useradmin(page)
  if not checkSession(page) then return end
  env,con = connect()
  local roles = get_roles(con)
  close_connect(env,con)
  local alert

 
  if next(page.POSTMULTI) then        
--[[
for k,v in pairs(page.POSTMULTI) do
page:print('</br>',k,'|',type(v))
  if type(v)=='table' then
    for x,z in pairs(v) do
      page:print('</br>----',x,'|',z)
    end
  else
    page:print('>',v)  
  end
end
 x= 1+c
--]]
    if page.POSTMULTI.newUser then
      if page.POSTMULTI.password1[1] == page.POSTMULTI.password2[1] then
        local lowestRole = {}
        lowestRole.id = '99'  -- will always be replaced
        for i,k in pairs(page.POSTMULTI.create_roles) do
          if k < lowestRole.id then
            lowestRole.id = k
            lowestRole.name = roles.byid[tonumber(k)]
          end
        end
        
        local configDefault={
            ['netdefault'] = '1',
            ['activetab'] = string.rep('1',#indexData),
            ['roledefault'] = lowestRole.name,
            ['showoldtests'] = 'true'  
        }    
        env,con = connect()
        local stat, err = create_user(con,page.POSTMULTI.ulogin[1],page.POSTMULTI.unameCreate[1],page.POSTMULTI.password1[1],configDefault,page.POSTMULTI.create_roles,roles)
        close_connect(env,con)
        if err == '1' then
          alert = "Usuário já existe"
        elseif err == '2' then
          alert = "Falha ao inserir userroles"
        elseif err == '3' then
          alert = "Falha ao inserir userconfig"
        else
          alert = "Usuário criado com sucesso!"
        end
        page:render('useradmin',{session=session,alert=alert ,roles=roles})
      else
        local alert = "Senhas Diferentes!"
        page:render('useradmin',{session=session,alert=alert,roles=roles})
      end
    elseif page.POSTMULTI.editRoles then
      env,con = connect()
      local stat, err = update_userroles(con,page.POSTMULTI.uidUpdate[1],page.POSTMULTI.update_roles)
      close_connect(env,con)
      if stat then
        alert = "Perfil de " .. page.POSTMULTI.uloginUpt[1] .. " alterado com sucesso!"
      else
        alert = "Falha ao alterar o perfil de " .. page.POSTMULTI.uloginUpt[1] .. "!"
      end
      page:render('useradmin',{session=session,alert=alert,roles=roles})
    else
      page:render('useradmin',{session=session,roles=roles})
    end
  else
    page:render('useradmin',{session=session,roles=roles})
  end
end

function main.usermanual(page)
  if not checkSession(page) then return end
  env,con = connect()
  local netsinfo = get_netsinfo(con,session)
  close_connect(env,con)
  page:render('usermanual',{session=session,netsinfo=netsinfo})
end

function main.admmanual(page)
  if not checkSession(page) then return end
  env,con = connect()
  local netsinfo = get_netsinfo(con,session)
  close_connect(env,con)
  page:render('admmanual',{session=session,netsinfo=netsinfo})
end


-- Ajax call
function main.validateUser(page)
  if next(page.POST) then
    env,con = connect()
    local user = get_user_bylogin(con,page.POST.ulogin)
    local jsonMsg
    if (user and user.uid) then
      -- user exists
      local uRoleNames,uRoleIds = get_userroles(con,user.uid)
      jsonMsg = '{"data" : "true", "uid" : "' .. user.uid .. '", "uname" : "' .. user.uname .. '","roles" : ['
      for i=1,#uRoleIds do
        if i > 1 then jsonMsg = jsonMsg .. ',' end
        jsonMsg = jsonMsg .. '{"id":"'.. uRoleIds[i] .. '"}'
      end
      jsonMsg = jsonMsg .. ']}'    
      
    else
      -- user doesn't exist
      jsonMsg = '{"data" : "false"}'
    end
    close_connect(env,con)
    page:write(jsonMsg)
  else
    page:write("")
  end 
end

-- Ajax call
function main.getServerTime(page)
  if next(page.POST) then
    env,con = connect()
    local srvTime = getISODate(con)
    close_connect(env,con)
    page:write(srvTime);
  else
    page:write("")
  end
end

function main.sendTBControl(page)
  if next(page.POST) then
    local action = tonumber(page.POST.action)
    local testid = tonumber(page.POST.testid)
    local netid = tonumber(page.POST.netid)
    if action then 
      local stat = sendTBControl(netid,testid,action)
      if stat then
        page:write("0 @$ Ok")
      else
        page:write("1 @$Erro de comunicação com o Controle do Testbed (TBControl).</br>A ação não foi executada para o testeid ".. testid ..".")
      end
    else
      page:write("1 @$ Operação inválida!")
    end
  else
    page:write("1 @$ Operação inválida!")
  end
end


-- Ajax call - Colsulta Hierarquia
function main.objectLoad(page)
  if next(page.POST) then
    local jsonMsg
    jsonMsg = '{ "data" : ['
    for i,key in ipairs(indexConsulta[tonumber(page.POST.consType)]) do
      jsonMsg = jsonMsg .. ((i == 1 and '') or ',') .. '{"name" : "' .. indexData[key].title ..'",' .. '"id":"' .. key .. '"}'
    end
    jsonMsg = jsonMsg .. ']}'
--    jsonMsg = '{ "data" : [{"name":"'.. indexData[1].title .. '", "id":"1"}]}'
    page:write(jsonMsg)
  else
    page:write("")
  end
end

--Ajax call
function main.itemsLoad(page)
  if not checkSession(page) then return end
  if next(page.POST) then
    local jsonMsg = ''
    
    local funcTab = {
      ['1'] = function (con,session) return get_tests(con,session,'all') end,
      ['2'] = function (con,session) return get_agendas(con,session,true) end,
      ['3'] = function (con,session) return get_planos(con,session) end,
      ['4'] = function (con,session) return get_scripts(con,session) end,
      ['5'] = function (con,session) return get_netconfig(con,session) end,
      ['6'] = function (con,session) return get_userfiles(con,session) end
    }
    
    env,con = connect()
    local data = funcTab[page.POST.id](con,session)
    close_connect(env,con)
    
    jsonMsg = '{ "data" :['
    for i,k in ipairs(data) do
      jsonMsg = jsonMsg .. ((i == 1 and '') or ',') .. '{"name":"' .. k.nome .. '","id":"'.. k.id .. '"}'
    end
    jsonMsg = jsonMsg .. ']}'
    
    page:write(jsonMsg)
  else
    page:write("")
  end
end

-- Ajax call
function main.createTable(page)
  if not checkSession(page) then return end
  if next(page.POST)  then
    local Htable = {}
    local Dtable = {}
    local output -- page:write
    if page.POST.consType == '1'  then --Hierarchy
     
     local funcTabHierarchy = {
      ['1'] = function (con,session) return getH_test(con,session,page.POST.ItemId) end,
      ['2'] = function (con,session) return  end,
      ['3'] = function (con,session) return getH_plano(con,session,page.POST.ItemId) end,
      ['4'] = function (con,session) return  end,
      ['5'] = function (con,session) return getH_netconfig(con,session,page.POST.ItemId) end,
      ['6'] = function (con,session) return  end
     } 
     env,con = connect()
     
     Htable = funcTabHierarchy[page.POST.ObjId](con,session)
     output = luaToJson(Htable)
    elseif page.POST.consType == '2'  then
     
      local funcTabDepedency = {
      ['6'] = function (con,session) return getD_entry_userfiles(con,session,page.POST.ItemId) end,
      ['5'] = function (con,session) return getD_entry_netconfig(con,session,page.POST.ItemId) end,
      ['4'] = function (con,session) return getD_entry_script(con,session,page.POST.ItemId) end,
      ['3'] = function (con,session) return getD_entry_plano(con,session,page.POST.ItemId) end,
      ['2'] = function (con,session) return getD_entry_agenda(con,session,page.POST.ItemId) end,
      ['1'] = function (con,session) return  end
     } 
      env,con = connect()
      Dtable = funcTabDepedency[page.POST.ObjId](con,session)
      output = luaToJson(Dtable)
    end
    
    page:write(output)
    close_connect(env,con)
  end
  page:write("")
end

function luaToJson(tab)
  local jsonn = ''
  if (type(tab) == "table") then
    jsonn = jsonn .. '['
    for i=1,#tab do
      jsonn = jsonn .. ((i == 1 and '') or ',')
      jsonn = jsonn .. luaToJson(tab[i],jsonn)
      
    end
    jsonn = jsonn .. ']'
    
  else
    jsonn = jsonn .. '"' ..  tab .. '"'
  end
  return jsonn
end

function luaToJson2(tab)
  local jsonn = ''
  jsonn = jsonn .. '{"data":[{"name":"' .. tab.name .. '"}'
  for i=1,#tab do
    jsonn = jsonn .. ','
    jsonn = jsonn .. luaToJson(tab[i],jsonn)
  end
  jsonn = jsonn .. ']}'
  return jsonn 
end


--  CONSULTA
function main.cons_hierq_dep(page)
  if not checkSession(page) then return end
  if next(page.POST) then
    local par = page.POST
    local result = {}
    if par.btnConsultDep then
      local data = {
        nome = "data",
        22,
        {
          nome = "qqc1",
          33,
          {nome = "xpto1",1,2},
          {nome = "xpto2",4,5}
        },
        {
          44,
          nome = "qqc2",
          {nome = "xpto3",3} 
        }
      }
 --     data = '{ "name" : "testeeee", "data" :[{"name" : "bombombo"}]}'
      page:render('cons_hierq_dep',{session=session, data = data, indexData = indexData}) 
    end
  else
    page:render('cons_hierq_dep',{session = session, indexData = indexData})
  end
end
return main
