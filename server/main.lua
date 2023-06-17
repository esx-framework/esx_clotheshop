RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
		store.save()
	end)
end)

ESX.RegisterServerCallback('esx_clotheshop:buyClothes', function(source, cb, newSkin, oldSkin)
	local xPlayer = ESX.GetPlayerFromId(source)
	local purchaseCost = 0

	if(Config.ChargePerPiece) then
		for key,value in pairs(Config.SkinProps) do
			if (newSkin[value .. '_1'] ~= oldSkin[value .. '_1']) or (newSkin[value .. '_2'] ~= oldSkin[value .. '_2']) then
				purchaseCost = purchaseCost + Config.Price
			end
		end
	else
		purchaseCost = Config.Price
	end

	if xPlayer.getMoney() >= purchaseCost then
		xPlayer.removeMoney(purchaseCost, "Outfit Purchase")
		TriggerClientEvent('esx:showNotification', source, TranslateCap('you_paid', purchaseCost))
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)
