fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

description 'Free open source FiveM lawn mowing made by P1ngu'
author 'P1ngu'

version 'dev'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'@ox_lib/init.lua'
}

client_scripts {
    'config.lua',
    'client/*'
}

server_scripts {
    'config.lua',
    'server/*'
}