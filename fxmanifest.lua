fx_version 'cerulean'
game 'gta5'

client_scripts { 'c_*.lua' } 
server_scripts { 's_*.lua', '@mysql-async/lib/MySQL.lua', '@async/async.lua', }

shared_scripts { 'config.lua' }

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html', 
    'web/dist/assets/**/**'
}

dependencies { 'es_extended', 'status' }