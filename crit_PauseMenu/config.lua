Config = {
    debug = true, -- Show debug prints in server and client console.
    defaultPlayerLanguage = 'en',   -- Needs to match a language in sh_locales.lua. Otherwise it will start throwing errors.
                                    -- If you only want to have one language, I would just leave this as "en", and only change the strings.
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
        {name = "Discord", url = "https://nostalgiq.ro/discord", urlImg = "https://static0.gamerantimages.com/wordpress/wp-content/uploads/2024/04/untitled-design-233.jpg"},
        {name = "Forum", url = "https://forum.cfx.re/u/critter/summary", urlImg = "https://cdn2.steamgriddb.com/thumb/178e124b7c4d43dfd40b32c96774f0e3.jpg"},
        {name = "Youtube", url = "https://www.youtube.com/@nostalgiqro", urlImg = "https://lh3.googleusercontent.com/3zkP2SYe7yYoKKe47bsNe44yTgb4Ukh__rBbwXwgkjNRe4PykGG409ozBxzxkrubV7zHKjfxq6y9ShogWtMBMPyB3jiNps91LoNH8A=s500"},
        {name = "Mastodon", url = "https://mstdn.ro/@nostalgiq", urlImg = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu4wKlfMPvYVhuiEosdccgeTF2nh5fyrgCiw&s"},
    },
}

Events = { -- List of events. Feel free to modify the names if you want.
    -- I used this method instead of just using the events the normal way, in case you want to scramble the events, like some (weird) ACs do.
    -- Events are secure though, the client can't really do anything harmful without the server noticing.
    CHANGE_MY_LANGUAGE = "crit_PauseMenu.ChangeMyLanguage",
    RECEIVE_PLAYERLIST = "crit_PauseMenu.ReceivePlayerlist",
    SEND_OPTION_TO_SERVER = "crit_PauseMenu.SendOptionToServer",
    UPDATE_CLIENT = "crit_PauseMenu.UpdateClient",
    DISCONNECT_ME = "crit_PauseMenu.DisconnectMe"
}