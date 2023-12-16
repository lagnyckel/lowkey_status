fx_version 'cerulean'
game 'gta5'

client_scripts { 'c_*.lua' } 
server_scripts { 's_*.lua', '@mysql-async/lib/MySQL.lua',}

shared_scripts {
    '@es_extended/imports.lua', 
    'config.lua'
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html', 
    'web/dist/assets/**/**'
}
