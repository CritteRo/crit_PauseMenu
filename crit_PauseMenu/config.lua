Config = {
    debug = true, -- Show debug prints in server and client console.
    defaultPlayerLanguage = 'en',       -- Needs to match a language in sh_locales.lua. Otherwise it will start throwing errors.
                                        -- If you only want to have one language, I would just leave this as "en", and only change the strings.
    isPauseMenuEnabled = true,          -- If you want to use the pause menu or not.
    allowPlayerToDisableMenu = true,    -- If true, players can use /togglepausemenu to enable / disable the menu for themselves.
    statsInsteadOfPlayers = false,      -- If true, when pressing the Online players button, it will open the Stats menu instead. This will also stop the playerlist update.
    menuToggleKVP = "crit_PauseMenu:isEnabled", 
    menuToggleCommand = "togglepausemenu",
    defaultPanel = ".mapHeader",
    -- Panels:
        -- .infoHeader = Information Panel
        -- .socialsHeader = Socials Panel
        -- .mapHeader = Map Panel
        -- .settingsHeader = Settings page (Don't use)
        -- .galleryHeader = Gallery page (Don't use)
        -- .playersHeader = Player List Panel
        -- .leaveLobby = Leave Server Panel 
    socialButtons = {
        {name = "Discord",  url = "https://discord.gg/RAEfZRtsGt",          urlImg = ""},
        {name = "Forum",    url = "https://forum.cfx.re/u/critter/summary", urlImg = ""},
        {name = "Youtube",  url = "https://www.youtube.com/@crittero",      urlImg = ""},
        {name = "Mastodon", url = "https://mastodon.social/@crittero",      urlImg = ""},
    },
}

Events = { -- List of events. Feel free to modify the names if you want.
    -- I used this method instead of just using the events the normal way, in case you want to scramble the events, like some (weird) ACs do.
    -- Events are secure though, the client can't really do anything harmful without the server noticing.
    CHANGE_MY_LANGUAGE      = "crit_PauseMenu.ChangeMyLanguage",
    RECEIVE_PLAYERLIST      = "crit_PauseMenu.ReceivePlayerlist",
    SEND_OPTION_TO_SERVER   = "crit_PauseMenu.SendOptionToServer",
    UPDATE_CLIENT           = "crit_PauseMenu.UpdateClient",
    DISCONNECT_ME           = "crit_PauseMenu.DisconnectMe"
}