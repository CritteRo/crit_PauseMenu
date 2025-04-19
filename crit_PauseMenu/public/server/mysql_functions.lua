function SQL_LoadPlayerData(license)
    -- Receives player license, expects a return array with all the user data, or false.
    local retval = -1
    exports.oxmysql:execute("SELECT * FROM crit_Busted_Users WHERE `license` = ?", {license}, function(result)
        retval = result[1]
    end)
    while retval == -1 do -- I don't like writing SQL code.
        Wait(0)
    end
    if type(retval) ~= 'table' then
        retval = false
    end
    return retval
end

function SQL_SavePlayerData(data)
    -- Async SQL function. No need to return anything. data is the entire serverPlayers[source] array.
    exports.oxmysql:execute("SELECT COUNT(license) AS idcount FROM crit_Busted_Users WHERE `license` = ?", {data.license}, function(result)
        if result[1].idcount >= 1 then 
            exports.oxmysql:execute("UPDATE `crit_Busted_Users` SET `name` = ?, `lang` = ?, `chaseWins` = ?, `chaseGames` = ?, `copWins` = ?, `copGames` = ?, `points` = ? WHERE `license` = ?", {data.name, data.lang, data.chaseWins, data.chaseGames, data.copWins, data.copGames, data.points, data.license}, function(result)
            end)
        else
            local send = 0
            exports.oxmysql:insert("INSERT INTO crit_Busted_Users (name, license, lang, chaseWins, chaseGames, copWins, copGames, points) VALUES(?, ?, ?, ?, ?, ?, ?, ?)", {data.name, data.license, data.lang, data.chaseWins, data.chaseGames, data.copWins, data.copGames, data.points}, function(result)
            end)
        end
    end)
end

-- This function will get the current leaderboard, after a game round ends.
-- It will get the Top 10 players (configurable), and save it memory, so the clients won't ping the DB every time.
function SQL_GetLeaderboardFromDB(top)
    local retval = -1
    exports.oxmysql:execute("SELECT * FROM crit_Busted_Users ORDER BY `points` DESC LIMIT ?", {top}, function(result)
        retval = result
        for i,k in pairs(retval) do
            retval[i].wlr = 0
            if (k.copGames + k.chaseGames) > 0 then
                retval[i].wlr = (k.copWins + k.chaseWins) / (k.copGames + k.chaseGames)
            end
        end
    end)
    while retval == -1 do -- I couldn't get ox_mysql export to not run async. This will do.
        Wait(0)
    end
    if type(retval) ~= 'table' then
        retval = false
    end
    return retval
end
