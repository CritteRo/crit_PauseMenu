local frontEndWhitelist = {
    [3] = true,
    [6] = true,
    [22] = true,
    [23] = true,
    [24] = true,
    [33] = true,
    [51] = true,
    [52] = true,
    [93] = true,
    [94] = true,
    [95] = true,
    [131] = true,
    [136] = true,
    [137] = true,
    [138] = true,
    [139] = true,
    [140] = true,
    [142] = true,
    [143] = true,
    [146] = true,
    [148] = true,
    [149] = true,
    [150] = true,
    [151] = true
}

headerCSStoPanelLua = {
    ['.mapHeader'] = "map",
    ['.infoHeader'] = "info",
    ['.socialsHeader'] = "socials",
    ['.settingsHeader'] = "settings",
    ['.galleryHeader'] = "gallery",
    ['.playersHeader'] = "players",
    ['.leaveLobby'] = "leaveserver"
}

local lockTabs = {-1000,0,1,2,3}


function LoadMap()
    Wait(10)
    local defaultAspectRatio = 1920 / 1080       -- Base resolution.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local gameAspectRatio = GetAspectRatio(true)
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetMinimapClipType(0)


    SetMinimapComponentPosition("bigmap", "I", "I", 0.55, 0.35, 0.364, 0.460416666)
    -- SetMinimapComponentPosition("bigmap", "I", "I", 0.311, 0.147, 0.996, 0.7968)
    SetMinimapComponentPosition("bigmap_mask", "I", "I", 0.301, 0.242, 0.676, 0.525)
    SetMinimapComponentPosition('bigmap_blur', 'I', 'I', 0.301, 0.242, 0.662, 0.564)
    SetRadarBigmapEnabled(true, false)
    LockMinimapAngle(0)
end

function resetMap()
    SetMinimapComponentPosition("bigmap", "L", "B", -0.003975, 0.022, 0.364, 0.460416666)
    SetMinimapComponentPosition("bigmap_mask", "L", "B", 0.015, 0.176, 0.176, 0.395)
    SetMinimapComponentPosition('bigmap_blur', 'L', 'B', -0.019, 0.022, 0.262, 0.464)
    SetRadarBigmapEnabled(false, false)
    SetMinimapClipType(0)
    LockMinimapAngle(-1)
end

function SetupSettings()
    resetMap()
    getbacktoNUI = false
    SetNuiFocus(false, false)
    ReleaseControlOfFrontend()
    SendNUIMessage({
        type = 'NUI_TOGGLE',
        viz = false
    })
    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 6) --Opens a frontend-type menu. Scaleform is already loaded, but can be changed.
    while not IsPauseMenuActive() or IsPauseMenuRestarting() do --Making extra-sure that the frontend menu is fully loaded
        Wait(0)
    end
    PauseMenuceptionGoDeeper(6) --Setting up the context menu of the Pause Menu. For other frontend menus, use https://docs.fivem.net/natives/?_0xDD564BDD0472C936
    
    BeginScaleformMovieMethodOnFrontendHeader("SHIFT_CORONA_DESC")
    ScaleformMovieMethodAddParamBool(true); --shifts the column headers a bit down.
    ScaleformMovieMethodAddParamBool(false); --This disables the colored strip above column headers.
    EndScaleformMovieMethod();
    Citizen.Wait(0)
    
    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE")
    ScaleformMovieMethodAddParamTextureNameString("Settings");       -- // Set the title
    ScaleformMovieMethodAddParamBool(false);        -- // purpose unknown, is always 0 in decompiled scripts.
    ScaleformMovieMethodAddParamTextureNameString("");    --// set the subtitle.
    ScaleformMovieMethodAddParamBool(false);          --// setting this to true distorts the header... for some reason. On normal MP_PAUSE menu, it makes the title a bit smaller.
    EndScaleformMovieMethod();
    Citizen.Wait(10)

    BeginScaleformMovieMethodOnFrontendHeader("SHOW_HEADING_DETAILS") --disables right side player mockshot and cash / bank
    ScaleformMovieMethodAddParamBool(false); --toggle
    EndScaleformMovieMethod()
    Citizen.Wait(0)

    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_ARROWS_VISIBLE") --disables right side player mockshot and cash / bank
    ScaleformMovieMethodAddParamBool(false); --toggle
    ScaleformMovieMethodAddParamBool(false); --toggle
    EndScaleformMovieMethod()
    Citizen.Wait(0)

    for i,k in pairs(lockTabs) do
        BeginScaleformMovieMethodOnFrontendHeader("LOCK_MENU_ITEM") --disables the column headers
        ScaleformMovieMethodAddParamInt(k); --toggle
        ScaleformMovieMethodAddParamBool(true); --toggle
        EndScaleformMovieMethod()
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethodOnFrontendHeader("SHOW_MENU") --disables the column headers
    ScaleformMovieMethodAddParamBool(false); --toggle
    EndScaleformMovieMethod()
    Citizen.Wait(0)

    local past, current,buttonId = GetPauseMenuSelectionData()
    while true do
        past, current,buttonId = GetPauseMenuSelectionData()
        if frontEndWhitelist[current] ~= nil or (current == -1 and frontEndWhitelist[past] ~= nil) then
            Wait(0)
        else
            break
        end
    end
    SetFrontendActive(false)
    getbacktoNUI = true
end

function SetupGallery()
    resetMap()
    getbacktoNUI = false
    SetNuiFocus(false, false)
    ReleaseControlOfFrontend()
    SendNUIMessage({
        type = 'NUI_TOGGLE',
        viz = false
    })
    ActivateFrontendMenu(GetHashKey("FE_MENU_VERSION_MP_PAUSE"), false, 3) --Opens a frontend-type menu. Scaleform is already loaded, but can be changed.
    while not IsPauseMenuActive() or IsPauseMenuRestarting() do --Making extra-sure that the frontend menu is fully loaded
        Wait(0)
    end
    PauseMenuceptionGoDeeper(3) --Setting up the context menu of the Pause Menu. For other frontend menus, use https://docs.fivem.net/natives/?_0xDD564BDD0472C936
    
    BeginScaleformMovieMethodOnFrontendHeader("SHIFT_CORONA_DESC")
    ScaleformMovieMethodAddParamBool(true); --shifts the column headers a bit down.
    ScaleformMovieMethodAddParamBool(false); --This disables the colored strip above column headers.
    EndScaleformMovieMethod();
    Citizen.Wait(0)
    
    BeginScaleformMovieMethodOnFrontendHeader("SET_HEADER_TITLE")
    ScaleformMovieMethodAddParamTextureNameString("Image Gallery");       -- // Set the title
    ScaleformMovieMethodAddParamBool(false);        -- // purpose unknown, is always 0 in decompiled scripts.
    ScaleformMovieMethodAddParamTextureNameString("");    --// set the subtitle.
    ScaleformMovieMethodAddParamBool(false);          --// setting this to true distorts the header... for some reason. On normal MP_PAUSE menu, it makes the title a bit smaller.
    EndScaleformMovieMethod();
    Citizen.Wait(10)

    BeginScaleformMovieMethodOnFrontendHeader("SHOW_HEADING_DETAILS") --disables right side player mockshot and cash / bank
    ScaleformMovieMethodAddParamBool(false); --toggle
    EndScaleformMovieMethod()
    Citizen.Wait(0)

    BeginScaleformMovieMethodOnFrontendHeader("SHOW_MENU") --disables the column headers
    ScaleformMovieMethodAddParamBool(true); --toggle
    EndScaleformMovieMethod()
    Citizen.Wait(0)

    for i,k in pairs(lockTabs) do
        BeginScaleformMovieMethodOnFrontendHeader("LOCK_MENU_ITEM") --disables the column headers
        ScaleformMovieMethodAddParamInt(k); --toggle
        ScaleformMovieMethodAddParamBool(true); --toggle
        EndScaleformMovieMethod()
        Citizen.Wait(0)
    end

    local past, current,buttonId = GetPauseMenuSelectionData()
    while true do
        SetFakePausemapPlayerPositionThisFrame(9999.9,9999.9)
        past, current,buttonId = GetPauseMenuSelectionData()
        if frontEndWhitelist[current] ~= nil or (current == -1 and frontEndWhitelist[past] ~= nil) then
            Wait(0)
        else
            break
        end
    end
    SetFrontendActive(false)
    getbacktoNUI = true
end