clientPlayer = {
    name = "PlayerName",
    lang = "en",

    isMenuOpen = false,
    currentPanel = "info",
}

RegisterNetEvent(Events.UPDATE_CLIENT, function(data)
    -- debug("UPDATE CLIENT :: "..json.encode(data))
    if data.name ~= nil then
        clientPlayer.name = data.name
    end
    if data.lang ~= nil then
        if clientPlayer.lang ~= data.lang and clientPlayer.lobby ~= 0 and IsNuiFocused() then
            clientPlayer.lang = data.lang
            SetupNUI()
        end
        clientPlayer.lang = data.lang
    end
end)

function IsPauseMenuOpen()
    return clientPlayer.isMenuOpen
end