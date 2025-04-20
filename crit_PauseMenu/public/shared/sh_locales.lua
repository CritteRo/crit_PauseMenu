localesLanguages = {
    -- We use number keys to make sure the table remains in the same order.
    -- [0] = {"Language Name", "languageCode"}
    -- languageCode needs to be the same as the keys in "nuiLocales" and "nuiInfo"
    -- Make sure both of those arrays have the same language, and the same labels, otherwise it will start throwing errors.
    -- Having one or no language here will hide the language selector in UI. Only the default lang (from config) will be used.
    [1] = {"English", "en"},
    [2] = {"Romana", "ro"},
}

nuiLocales = {
    ['en'] = {
        MAIN_TITLE = "CritteR's Pause Menu",
        MAIN_DESCRIPTION = "This description works as well.",

        BUTTON_SOCIALS = "SOCIALS",
        BUTTON_MAP = "MAP",
        BUTTON_SETTINGS = "SETTINGS",
        BUTTON_GALLERY = "GALLERY",
        BUTTON_INFORMATION = "INFORMATION",
        BUTTON_PLAYER_LIST = "PLAYER LIST",
        BUTTON_CLOSE_MENU = "CLOSE MENU",
        BUTTON_LEAVE_SERVER = "LEAVE SERVER >>",

        BUTTON_DISCONNECT = "Disconnect",
        BUTTON_QUIT_GAME = "Quit Game",

        DISCONNECT_MESSAGE = "Disconnected.",

        HEADER_LEAVE_SERVER = "Are you sure you want to quit? We'll miss you :(",
        HEADER_SOCIALS = "You can reach out to us here:",

        TBL_ID = "ID",
        TBL_PLAYER_NAME = "PLAYER NAME",
        TBL_COL1 = "SOMETHING 1",
        TBL_COL2 = "SOMETHING 2",
        TBL_COL3 = "SOMETHING 3",
        TBL_COL4 = "SOMETHING 4"
    },
    ['ro'] = {
        MAIN_TITLE = "Meniul lui CritteR!",
        MAIN_DESCRIPTION = "Si descrierea functioneaza!.",

        BUTTON_SOCIALS = "SOCIAL MEDIA",
        BUTTON_MAP = "HARTĂ",
        BUTTON_SETTINGS = "SETĂRI",
        BUTTON_GALLERY = "GALERIE",
        BUTTON_INFORMATION = "INFORMAȚII",
        BUTTON_PLAYER_LIST = "LISTĂ JUCĂTORI",
        BUTTON_CLOSE_MENU = "ÎNCHIDE MENIU",
        BUTTON_LEAVE_SERVER = "IEȘI DE PE SERVER >>",

        BUTTON_DISCONNECT = "Deconectare",
        BUTTON_QUIT_GAME = "Inchide Jocul",

        DISCONNECT_MESSAGE = "Deconectat.",

        HEADER_LEAVE_SERVER = "Ești sigur că vrei să ne părăsești? Ne vei lipsi :(",
        HEADER_SOCIALS = "Ne poți contacta aici:",

        TBL_ID = "ID",
        TBL_PLAYER_NAME = "NUME JUCĂTOR",
        TBL_COL1 = "CEVA 1",
        TBL_COL2 = "CEVA 2",
        TBL_COL3 = "CEVA 3",
        TBL_COL4 = "CEVA 4"
    }
}

nuiInfo = {
    ['en'] = {
        -- {"title", "Title String", "Title pill, next to Title String"},
        -- {"text", "Text Component Header", "Text Component Paragraph.", "ImageURL String.", "Link URL that transforms the image into a button"}
        -- All components, except ImageURL and Link URL, can contain HTML entities.

        {"title", "INFORMATION PANEL", "v1.0.0"},
        {'text', "Component Title", "Pause Menu Description - Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium voluptate dolorum ratione, distinctio natus perferendis laborum nemo eveniet dignissimos odit sunt vitae libero iure tempora, debitis ad facilis quisquam recusandae?"},
        {'text', "Video Showcase", '<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ?si=-c6nXP1z5I_MhxZW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>'},
        {'text', "Test it out!", "The pause menu is currently hosted on Nostalgiq Romania RPG!", "https://critte.ro/share/img/fivem_banner.png", "https://nostalgiq.ro"},
        {'title', "<a href = 'https://github.com/CritteRo/crit_PauseMenu' target='_blank'>Get it now on Github</a>, or check out my <a href = 'https://crittero.tebex.io/category/1788480' target='_blank'>paid scripts!</a>", ""},
    },
    ['ro'] = {
        {"title", "PANOU INFORMAȚII", "v1.0.0"},
        {'text', "Titlu Componentă", "Descriere Meniu Pauză - Lorem ipsum dolor sit amet consectetur adipisicing elit. Laudantium voluptate dolorum ratione, distinctio natus perferendis laborum nemo eveniet dignissimos odit sunt vitae libero iure tempora, debitis ad facilis quisquam recusandae?"},
        {'text', "Prezentare Video", '<iframe width="560" height="315" src="https://www.youtube.com/embed/dQw4w9WgXcQ?si=-c6nXP1z5I_MhxZW" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>'},
        {'text', "Testează-l!", "Pause Menu-ul este găzduit în prezent pe Nostalgiq Romania RPG!", "https://critte.ro/share/img/fivem_banner.png", "https://nostalgiq.ro"},
        {'title', "<a href = 'https://github.com/CritteRo/crit_PauseMenu' target='_blank'>Descarca-l acum de pe Github</a>, sau verifică <a href = 'https://crittero.tebex.io/category/1788480' target='_blank'>scripturile mele cu plata!</a>", ""},
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