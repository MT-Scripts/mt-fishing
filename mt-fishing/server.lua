local QBCore = exports['qb-core']:GetCoreObject()

-- Eventos
QBCore.Functions.CreateUseableItem("cana_pesca", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent('mt-fishing:client:ComecarPesca', source)
    end
end)

RegisterNetEvent('mt-fishing:server:PerderIsco', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = 1

    Player.Functions.RemoveItem('isco_pesca', quantity)
end)

RegisterNetEvent('mt-fishing:server:DarPeixe', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(1, 5)
    local prob = math.random(1, 60)

    if prob < 50 then
        if Player.Functions.AddItem("peixe_pesca", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peixe_pesca"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end  
    elseif prob >= 51 and prob < 60 then
        if Player.Functions.AddItem("peixe_exotico_pesca", quantity) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["peixe_exotico_pesca"], 'add')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You have full pockets.', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'you dont catch any fish.', 'error')
    end
end)

RegisterNetEvent('mt-fishing:server:ComprarCana', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local quantity = 1
    local cash = 'bank'
    local price = 2500
    local Item = 'cana_pesca'

    if Player.Functions.AddItem(Item, quantity) then
        Player.Functions.RemoveMoney(cash, price)
	TriggerClientEvent('QBCore:Notify', src, 'You buy a Fishing Rod.', 'primary')
    end
end)

RegisterNetEvent('mt-fishing:server:ComprarIsco', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    local quantity = 1
    local cash = 'bank'
    local price = 500
    local Item = 'isco_pesca'

    if Player.Functions.AddItem(Item, quantity) then
        Player.Functions.RemoveMoney(cash, price)
	TriggerClientEvent('QBCore:Notify', src, 'You buy a Fishing Bait.', 'primary')		
    end
end)

local ItemList = {
    ["peixe_pesca"] =  200,
    ["peixe_exotico_pesca"] =  900,
}

RegisterNetEvent('mt-fishing:server:VenderPeixe', function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    
    local xItem = Player.Functions.GetItemsByName(ItemList)
    if xItem ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)

        Player.Functions.AddMoney("cash", price, "sold-fish")
            TriggerClientEvent('QBCore:Notify', src, "You sell some fish for $"..price)
                end
            end
        end
    else
        TriggerClientEvent('QBCore:Notify', src, "You dont/'t have anything to sell..")
    end
end)

RegisterNetEvent('mt-fishing:server:RemoverDinheiroAluger', function()
	local src = source
	local cash = 'bank'
	local price = 1000
	local Player = QBCore.Functions.GetPlayer(src)
		
	Player.Functions.RemoveMoney(cash, price)
end)
