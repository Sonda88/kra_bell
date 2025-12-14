fx_version 'cerulean'
games { 'rdr3' }
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page 'html/index.html'

files {
  	'html/index.html',
  	'html/Campana.ogg',
	'html/Campana2.ogg'
}

client_scripts{
    'config.lua',
    'client.lua',
}

server_scripts {
	'config.lua',
  	'server.lua'
}