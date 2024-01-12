Status = {}; 

ESX = exports.es_extended:getSharedObject();

function Status:Init()
    ESX.RegisterServerCallback('lowkey_statusui:fetchSettings', function(source, callback)
        local player = ESX.GetPlayerFromId(source); 

        if not player then return end; 

        local results = MySQL.Sync.fetchAll([[
            SELECT settings FROM users WHERE identifier = @identifier
        ]], {
            ['@identifier'] = player.identifier
        })

        if not results[1] or results[1].settings == '[]' then 
            local settings = self:CreateSettings(player);

            callback({ success = true, data = settings })
            return 
        end

        local settings = json.decode(results[1].settings);

        callback({ success = true, data = settings })
    end)

    ESX.RegisterServerCallback('lowkey_statusui:saveSettings', function(source, callback, data)
        local player = ESX.GetPlayerFromId(source); 

        if not player then return end; 

        local affectedRows = MySQL.Sync.execute([[
            UPDATE users SET settings = @settings WHERE identifier = @identifier
        ]], {
            ['@identifier'] = player.identifier, 
            ['@settings'] = json.encode(data.settings)
        })

        if affectedRows == 0 then 
            callback({ success = false, message = 'Failed to save settings.' })
            return 
        end

        callback({ success = true })
    end)
end

function Status:CreateSettings(player)
    local defaultSettings = Config.DefaultSettings;

    if not defaultSettings then 
        print('Failed to create settings, default settings not found.')
        return 
    end

    local affectedRows = MySQL.Sync.execute([[
        UPDATE users SET settings = @settings WHERE identifier = @identifier
    ]], {
        ['@socialnumber'] = player.identifier, 
        ['@settings'] = json.encode(defaultSettings)
    })

    self:debugPrint(('[status] Created settings for %s'):format(player.identifier))

    return defaultSettings
end

function Status:debugPrint(message)
    if not Config.Debug then return end; 

    print(message)
end

Citizen.CreateThread(function()
    Status:Init(); 
end)