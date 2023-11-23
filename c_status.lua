Status = {
    displaying = true; 
    settings = {}; 
}; 

Citizen.CreateThread(function()
    Citizen.Wait(1500); 

    local self = Status;

    self.settings = Settings:TriggerCallback({
        eventName = 'lowkey_status:fetchSettings', 
        args = {}
    })

    if not self.settings.success then 
        print('Failed to fetch settings.')
        return 
    end

    SendNUIMessage({
        type = 'setup', 
        data = {
            settings = self.settings.data
        }
    })

    while true do 
        if Status.displaying then 
            TriggerEvent("status:getStatus", "thirst", function(thirst)
                TriggerEvent("status:getStatus", "hunger", function(hunger)
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
                                value = hunger.val / 10000 -1,
                            },
            
                            thirst = {
                                value = thirst.val / 10000 -1,
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