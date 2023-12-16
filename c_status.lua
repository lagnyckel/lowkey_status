Status = {
    displaying = true; 
    settings = {}; 
}; 

Citizen.CreateThread(function()
    while not ESX.IsPlayerLoaded() do 
        Citizen.Wait(500)
    end

    local self = Status;

    self.settings = Settings:TriggerCallback({
        eventName = 'lowkey_statusui:fetchSettings', 
        args = {}
    })

    DisplayRadar(false)

    Citizen.Wait(1500); 

    SendNUIMessage({
        type = 'init', 
        data = {
            settings = self.settings.data
        }
    })

    while true do 
        if Status.displaying then 
            TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
                TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
                    local _hunger = hunger.getPercent(); 
                    local _thirst = thirst.getPercent();

                    SendNUIMessage({
                        type = 'updateStatus',
                        data = {
                            voice = {
                                value = 100,
                                isTalking = MumbleIsPlayerTalking(PlayerId()),
                            }, 
                    
                            health = {
                                value = GetEntityHealth(PlayerPedId()) / 2 -1,
                            }, 
                    
                            armor = {
                                value = GetPedArmour(PlayerPedId()) -1,
                            },
                    
                            hunger = {
                                value = _hunger,
                            },
                    
                            thirst = {
                                value = _thirst,
                            }, 
                        }
                    })
                end)
            end)
        end

        Citizen.Wait(500)
    end
end)

function Status:hide()
    self.displaying = false; 

    SendNUIMessage({
        type = 'hide', 
    })
end

function Status:display()
    self.displaying = true; 
end

exports('hide', function(...)
    Status:hide(...)
end)

exports('display', function(...)
    Status:display(...)
end)

RegisterCommand('loadcharacter', function()
    print('loadcharacter')

    TriggerServerEvent('es_extended:loadCharacter', '1993-04-12-9941')
end)