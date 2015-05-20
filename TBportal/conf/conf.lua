local conf = {
	sailor = {
		app_name = 'Céu na Terra',
		default_static = nil, -- If defined, default page will be a rendered lp as defined. 
							  -- Example: 'maintenance' will render /views/maintenance.lp
		default_controller = 'main', 
		default_action = 'index',
		layout = 'default',
		route_parameter = 'r',
    portalAddr = 'ceunaterra.voip.ufrj.br'
	},
	db = {
		driver = 'postgres',
		host = 'localhost',
		user = "postgres",
		pass = "postgres",
		dbname = 'portal2'
	},
	smtp = {
		server = 'smtp.gmail.com',
    port = 465,
		user = 'ceunaterra.testbed@gmail.com',
		pass = 'projetotestbed',
		from = 'ceunaterra.testbed@gmail.com'
	}
}

return conf
