Config = {
    debug = true, -- Show debug prints in server and client console.
    defaultPlayerLanguage = 'en',   -- Needs to match a language in sh_locales.lua. Otherwise it will start throwing errors.
                                    -- If you only want to have one language, I would just leave this as "en", and only change the strings.
}

Events = { -- List of events. Feel free to modify the names if you want.
    -- I used this method instead of just using the events the normal way, in case you want to scramble the events, like some (weird) ACs do.
    -- Events are secure though, the client can't really do anything harmful without the server noticing.
    CHANGE_MY_LANGUAGE = "crit_PauseMenu.ChangeMyLanguage",
    RECEIVE_PLAYERLIST = "crit_PauseMenu.ReceivePlayerlist",
    SEND_OPTION_TO_SERVER = "crit_PauseMenu.SendOptionToServer",
    UPDATE_CLIENT = "crit_PauseMenu.UpdateClient"
}