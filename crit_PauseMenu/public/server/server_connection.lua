local tobool = { -- Imagine coding in Lua.
    [0] = false,
    [1] = true
}

serverPlayers = {
    [0] = {
        name = "PlayerName", -- Probably won't be used.
        license = "license:unk",
        lang = 'en',
        isAdmin = false,
        isSuperAdmin = false
    }
}

function CreateNewPlayerData(source)
    local retval = {
        name = PreferredPlayerName(source),
        license = GetPlayerIdentifierByType(source, 'license'),
        lang = Config.defaultPlayerLanguage,
        isAdmin = IsPlayerAnAdmin(source),
        isSuperAdmin = IsPlayerSuperAdmin(source),

        col1 = "", -- First Custom Column Data
        col2 = "", -- Second Custom Column Data
        col3 = "", -- Third Custom Column Data
        col4 = "", -- Fourth Custom Column Data
    }
    return retval
end

--===========================================================================================--
--                                     PLAYER CHECKS                                         --
--===========================================================================================--

-- Below function is used to get the player's preferred name from a given player source. By default we used the regular GetPlayerName.
-- The resource expects a string return.
function PreferredPlayerName(source)
    local src = tonumber(source)
    local retval = "**INVALID**"
    if src ~= nil and GetPlayerPing(src) ~= 0 then
        retval = GetPlayerName(src)
    end

    return retval
end

-- Checks if the player source is an "admin". Not used anywhere, for now.
-- By default, the system checks for "BustedAdminAccess" ACE permission.
-- Receives player source.
-- Expect a bool return.
function IsPlayerAnAdmin(source)
    local src = tonumber(source)
    if src ~= nil and GetPlayerPing(src) ~= 0 then
        local retval = tobool[IsPlayerAceAllowed(src, 'PauseMenuAdminAccess') or 0]
        return retval                                                   -- Return player's ACE permission in case source is valid.
    end
    return false                                                        -- Just return false if player is not valid.
end

-- Not used anywhere, for now. Checks if the player source is an "super admin". This is give more access to already existing admins.
-- Only give this to trusted players, like server owners and developers. This bypasses everything.
-- By default, the system checks for "BustedSuperAdminAccess" ACE permission.
-- Receives player source.
-- Expect a bool return.
function IsPlayerSuperAdmin(source)
    local src = tonumber(source)
    if src ~= nil and GetPlayerPing(src) ~= 0 then
        local retval = tobool[IsPlayerAceAllowed(src, 'PauseMenuSuperAdminAccess') or 0]
        return retval                                                   -- Return player's ACE permission in case source is valid.
    end
    return false                                                        -- Just return false if player is not valid.
end

-- Below functions showcase how you can update a player's playerlist.
function BuildPlayerList()
    local playerlist = {}
    for i,k in ipairs(GetPlayers()) do
        local src = tonumber(k) -- global `source` is an int in Lua, but string in `GetPlayers()`. which means that main array also has Ints as sources.
        table.insert(playerlist, {id = src, name = PreferredPlayerName(src), col1 = "", col2 = "", col3 = "", col4 = ""})
    end
    TriggerClientEvent(Events.RECEIVE_PLAYERLIST, -1, playerlist)
    debug("BuildPlayerList() :: Event Ran.")
end


--===========================================================================================--
--                                         EVENTS                                            --
--===========================================================================================--

AddEventHandler('playerJoining', function(oldID)
    local src = source
    Wait(1000) -- wait a moment for the public scripts to do their thing.
    serverPlayers[src] = CreateNewPlayerData(src)
    TriggerClientEvent(Events.UPDATE_CLIENT, src, serverPlayers[src])
    BuildPlayerList()
end)

AddEventHandler('playerDropped', function(source, reason)
    local src = source
    if serverPlayers[src] ~= nil then
        serverPlayers[src] = nil                                        --Cleanup array after the player leaves.
    end
    BuildPlayerList()
end)

AddEventHandler('onResourceStart', function(_name) --make sure we register ALL ONLINE players, in case the resource needs to be restarted while the server runs.
    if _name == GetCurrentResourceName() then
        for _,_src in ipairs(GetPlayers()) do
            local src = tonumber(_src) -- GetPlayers() returns sources as strings instead of integers. Lua usually handles them in the backend, but they are still different var types.
            serverPlayers[src] = CreateNewPlayerData(src)
            TriggerClientEvent(Events.UPDATE_CLIENT, src, serverPlayers[src])
        end
        BuildPlayerList()
    end
end)