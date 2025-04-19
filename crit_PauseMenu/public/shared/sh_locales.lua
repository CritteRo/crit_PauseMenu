localesLanguages = {
    -- We use number keys to make sure the table remains in the same order.
    -- [0] = {"Language Name", "languageCode"}
    -- languageCode needs to be the same as the keys in "locales", "nuiLocales" and "nuiInfo"
    -- Make sure all 3 of those arrays have the same language, and the same labels, otherwise it will start throwing errors.
    -- Having one or no language here will hide the language selector in UI. Only the default lang (from config) will be used.
    [1] = {"English", "en"},
    [2] = {"Romana", "ro"},
}

nuiLocales = {
    ['en'] = {
        MAIN_TITLE = "CritteR's Pause menu",
        MAIN_DESCRIPTION = "This description works as well.",

        READY_BUTTON = "DISCORD",
        SET_ROBBER_BUTTON = "MAP",
        SET_HELI_BUTTON = "SETTINGS",
        SET_COP_VEH_BUTTON = "Select Preferred Police Vehicle",
        SET_ROB_VEH_BUTTON = "Select Preferred Robber Vehicle",

        INFO_HEADER_BUTTON = "INFORMATION",
        PLAYERS_HEADER_BUTTON = "PLAYER LIST",
        LEADERBOARD_HEADER_BUTTON = "CLOSE MENU",
        LEAVE_HEADER_BUTTON = "LEAVE SERVER >>",

        HEADER_SELECT_ROBBER_VEHICLE = "Select your preferred robber vehicle. It's needed even if you don't want to play as one!",
        HEADER_SELECT_COP_VEHICLE = "Select your preferred police vehicle. It's needed even if you want to play as Robber / Heli!",

        YES = "YES",
        NO = "NO",
        TBL_PLAYER_NAME = "PLAYER NAME",
        TBL_IS_READY = "READY",
        TBL_WANTS_ROBBER = "WANTS ROBBER",
        TBL_WANTS_HELI = "WANTS HELI",
        TBL_TOTAL_POINTS = "TOTAL POINTS",
        TBL_WIN_RATIO = "WIN RATIO",

        TBL_TOTAL_GAMES = "GAMES PLAYED",
        TBL_ROBBER_GAMES = "ROBBER GAMES",
        TBL_ROBBER_WINS = "ROBBER WINS",
        TBL_COP_GAMES = "COP GAMES",
        TBL_COP_WINS = "COP WINS",
    }
}

nuiInfo = {
    ['en'] = {
        -- {"title", "Title String", "Title pill, next to Title String"},
        -- {"text", "Text Component Header", "Text Component Paragraph.", "ImageURL String."}
        -- All components, except ImageURL, can contain HTML entities.

        {"title", "INFORMATION PANEL", "v1.0.0"},
        {'text', "Nostalgiq Romania", "Pause Menu Description - Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium voluptate dolorum ratione, distinctio natus perferendis laborum nemo eveniet dignissimos odit sunt vitae libero iure tempora, debitis ad facilis quisquam recusandae?"},
        {'text', "Video Showcase", '<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ?si=-c6nXP1z5I_MhxZW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>'},
        {'text', "Test it out!", "The pause menu is currently hosted on Nostalgiq Romania RPG!", "https://critte.ro/share/img/fivem_banner.png"},
        {'title', "<a href = 'https://crittero.tebex.io/package/6763003' target='_blank'>Get it now on Tebex!</a>", ""},
    }
}

--------------------------------

function debug(str)
    if Config.debug then
        print(str)
    end
end

local function Format(Int)
	return string.format("%02i", Int)
end

function SecondsToString(Seconds)
    -- function to transform a second integer into a MM:SS string.
    -- The Escape string should not be there.
    if Seconds == -1 then
        return ""
    end
    local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	return Format(Minutes)..":"..Format(Seconds)
end

function SecondsToString2(Seconds)
	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end