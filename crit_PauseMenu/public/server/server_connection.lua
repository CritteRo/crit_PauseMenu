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
        name = GetPlayerName(source),
        license = GetPlayerIdentifierByType(source, 'license'),
        lang = Config.defaultPlayerLanguage,
        isAdmin = IsPlayerAnAdmin(source),
        isSuperAdmin = IsPlayerSuperAdmin(source)
    }
    local license = GetPlayerIdentifierByType(source, 'license')
    if license then
        local data = SQL_LoadPlayerData(license)
        if type(data) == 'table' then
            retval.name = data.name
            retval.lang = data.lang
            retval.isAdmin = IsPlayerAnAdmin(source)
            retval.isSuperAdmin = IsPlayerSuperAdmin(source)
            debug("PLAYER LOADED :: "..license)
        else
            SQL_SavePlayerData(retval)
            debug("PLAYER CREATED :: "..license)
        end
    end

    return retval
end

--===========================================================================================--
--                                     PLAYER CHECKS                                         --
--===========================================================================================--

-- Below function is used to verify if a source or user id, or any player identifier is valid.
-- The resource will give any input provided by the user or script as "input", and expects a valid player source return.
-- It is used by admins to find other players.
function FindPlayer(input)
    local retval = false
    if type(tonumber(input)) == 'number' then
        if GetPlayerPing(tonumber(input)) ~= 0 then
            retval = tonumber(input)
        end
    elseif type(input) == 'string' then
        for i,k in pairs(GetPlayers()) do
            local s = string.lower(GetPlayerName(tonumber(k)))
            local found, _= string.find(s, string.lower(input))
            if found ~= nil then
                retval = tonumber(k)
                break
            end
        end
    end
    return retval -- The resource expects this to be a player source or `false`.
end

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


--===========================================================================================--
--                                         EVENTS                                            --
--===========================================================================================--

AddEventHandler('playerJoining', function(oldID)
    local src = source
    Wait(1000) -- wait a moment for the public scripts to do their thing.
    serverPlayers[src] = CreateNewPlayerData(src)
    TriggerClientEvent(Events.UPDATE_CLIENT, src, serverPlayers[src])
end)

AddEventHandler('onResourceStart', function(_name) --make sure we register ALL ONLINE players, in case the resource needs to be restarted while the server runs.
    if _name == GetCurrentResourceName() then
        for _,_src in ipairs(GetPlayers()) do
            local src = tonumber(_src) -- GetPlayers() returns sources as strings instead of integers. Lua usually handles them in the backend, but they are still different var types.
            serverPlayers[src] = CreateNewPlayerData(src)
            TriggerClientEvent(Events.UPDATE_CLIENT, src, serverPlayers[src])
        end
    end
end)