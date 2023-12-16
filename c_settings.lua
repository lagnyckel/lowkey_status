Settings = {}; 

ESX = exports.es_extended:getSharedObject();

RegisterNUICallback('fetchSettings', function(_, callback)
    local settings = Settings:TriggerCallback({
        eventName = 'lowkey_statusui:fetchSettings', 
        args = {}
    })

    if not settings.success then 
        callback({
            success = false, 
            message = 'Failed to fetch settings.'
        }) 
    end

    callback({
        success = true, 
        data = {
            colors = Config.Colors, 
            settings = settings.data
        }
    })
end)

RegisterNUICallback('saveSettings', function(data, callback)
    local settings = Settings:TriggerCallback({
        eventName = 'lowkey_statusui:saveSettings', 
        args = {
            settings = data
        }
    })

    if not settings.success then 
        callback({
            success = false, 
            message = 'Failed to save settings.'
        }) 
    end

    callback({
        success = true, 
        message = 'Successfully saved settings.'
    })
end)

RegisterNUICallback('closeApp', function(_, callback)
    SetNuiFocus(false, false); 

    callback({
        success = true, 
        message = 'Successfully closed app.'
    })
end)

function Settings:TriggerCallback(data)
    local p = promise:new(); 

    ESX.TriggerServerCallback(data.eventName, function(results) 
        p:resolve(results);
    end, data.args)

    return Citizen.Await(p);
end

function Settings:Display()
    SetNuiFocus(true, true); 

    SendNUIMessage({
        type = 'openSettings'
    })
end

RegisterCommand('settings', function()
    Settings:Display(); 
end)