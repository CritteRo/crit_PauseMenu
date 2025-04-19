local clientPlayer = {
    lang = "en",

    isMenuOpen = false,
    currentPanel = "info",
}

local getbacktoNUI = false


function SetupNUI() -- This also runs when the NUI is open, and the language is changed.

    SendNUIMessage({
        type = 'SETUP_DATA',
        labels = nuiLocales[clientPlayer.lang],
        overrideTitle = title,
        overrideDesc = desc,
        info = nuiInfo[clientPlayer.lang],
        copVehicles = _copVehs,
        robVehicles = _robVehs,
        leaderboard = clientLeaderboard,
        useCfxImg = Config.UseCfxImagesForNUI,
        languages = localesLanguages, -- from sh_locales.lua
        currentLanguage = clientPlayer.lang,
    })
end

local function LoadMap()
    Wait(10)
    local defaultAspectRatio = 1920 / 1080       -- Base resolution.
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local gameAspectRatio = GetAspectRatio(true)
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end
    SetMinimapComponentPosition("bigmap", "I", "I", 0.55, 0.35, 0.364, 0.460416666)
    -- SetMinimapComponentPosition("bigmap", "I", "I", 0.311, 0.147, 0.996, 0.7968)
    SetMinimapComponentPosition("bigmap_mask", "I", "I", 0.301, 0.242, 0.676, 0.525)
    SetMinimapComponentPosition('bigmap_blur', 'I', 'I', 0.301, 0.242, 0.662, 0.564)
    SetRadarBigmapEnabled(true, false)
    LockMinimapAngle(0)
end

local function resetMap()
    SetMinimapComponentPosition("bigmap", "L", "B", -0.003975, 0.022, 0.364, 0.460416666)
    SetMinimapComponentPosition("bigmap_mask", "L", "B", 0.015, 0.176, 0.176, 0.395)
    SetMinimapComponentPosition('bigmap_blur', 'L', 'B', -0.019, 0.022, 0.262, 0.464)
    SetRadarBigmapEnabled(false, false)
    LockMinimapAngle(-1)
end


RegisterNUICallback('TOGGLE_PANEL', function(data, cb)
    debug("TOGGLE_PANEL :: Panel: "..data.panel.." / Option: "..data.option)
    if data.option == "map" then
        -- SetNuiFocus(false, false)
        -- ReleaseControlOfFrontend()
        -- SendNUIMessage({
        --     type = 'NUI_TOGGLE',
        --     viz = false
        -- })
        -- ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE", false, -1) --Opens a frontend-type menu. Scaleform is already loaded, but can be changed.
        -- while not IsPauseMenuActive() or IsPauseMenuRestarting() do --Making extra-sure that the frontend menu is fully loaded
        --     Wait(0)
        -- end
        -- PauseMenuceptionGoDeeper(0) --Setting up the context menu of the Pause Menu. For other frontend menus, use https://docs.fivem.net/natives/?_0xDD564BDD0472C936
        -- PauseMenuceptionTheKick()
        -- while not IsControlJustPressed(2,202) and not IsControlJustPressed(2,200) and not IsControlJustPressed(2,199) do --Waiting for any of frontend cancel buttons to be hit. Kinda slow but whatever.
        --     Wait(0)
        -- end
        -- PauseMenuceptionTheKick() --doesn't really work, but the native's name is funny.
        -- SetFrontendActive(false) --Force-closing the entire frontend menu. I wanted a simple back button, but R* forced my hand.
        LoadMap()
    elseif data.option == "settings" then
        resetMap()
        SetNuiFocus(false, false)
        ReleaseControlOfFrontend()
        SendNUIMessage({
            type = 'NUI_TOGGLE',
            viz = false
        })
        ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE", false, 6) --Opens a frontend-type menu. Scaleform is already loaded, but can be changed.
        while not IsPauseMenuActive() or IsPauseMenuRestarting() do --Making extra-sure that the frontend menu is fully loaded
            Wait(0)
        end
        PauseMenuceptionGoDeeper(6) --Setting up the context menu of the Pause Menu. For other frontend menus, use https://docs.fivem.net/natives/?_0xDD564BDD0472C936
        local _,menuId,z = GetPauseMenuSelectionData()
        while true do 
            if IsControlJustPressed(2,202) or IsControlJustPressed(2,200) or IsControlJustPressed(2,199) then --Waiting for any of frontend cancel buttons to be hit. Kinda slow but whatever.
                break
            end
            Wait(0)
        end
        PauseMenuceptionTheKick() --doesn't really work, but the native's name is funny.
        SetFrontendActive(false) --Force-closing the entire frontend menu. I wanted a simple back button, but R* forced my hand.
    else
        resetMap()
    end
    clientPlayer.currentPanel = data.option
    cb({["ok"]=true})
    return 
end)

RegisterNUICallback('TOGGLE_PANEL_MAP', function(data, cb)
    debug("TOGGLE_PANEL_MAP :: Option: "..data.option)
    if data.option == "map" then
        getbacktoNUI = false
        SetNuiFocus(false, false)
        ReleaseControlOfFrontend()
        SendNUIMessage({
            type = 'NUI_TOGGLE',
            viz = false
        })
        ActivateFrontendMenu("FE_MENU_VERSION_MP_PAUSE", false, -1) --Opens a frontend-type menu. Scaleform is already loaded, but can be changed.
        while not IsPauseMenuActive() or IsPauseMenuRestarting() do --Making extra-sure that the frontend menu is fully loaded
            Wait(0)
        end
        PauseMenuceptionGoDeeper(0) --Setting up the context menu of the Pause Menu. For other frontend menus, use https://docs.fivem.net/natives/?_0xDD564BDD0472C936
        PauseMenuceptionTheKick()
        while not IsControlJustPressed(2,202) and not IsControlJustPressed(2,200) and not IsControlJustPressed(2,199) do --Waiting for any of frontend cancel buttons to be hit. Kinda slow but whatever.
            Wait(0)
        end
        getbacktoNUI = true
        PauseMenuceptionTheKick() --doesn't really work, but the native's name is funny.
        SetFrontendActive(false) --Force-closing the entire frontend menu. I wanted a simple back button, but R* forced my hand.
        clientPlayer.currentPanel = data.option
    else
        resetMap()
    end
    cb({["ok"]=true})
    return 
end)

RegisterNUICallback('REQUEST_LEAVE_LOBBY', function(data, cb)
    PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
    SetNuiFocus(false, false)
    ReleaseControlOfFrontend()
    SendNUIMessage({
        type = 'NUI_TOGGLE',
        viz = false
    })
    SetFrontendActive(false)
    TriggerScreenblurFadeOut(500)
    clientPlayer.isMenuOpen = false
    resetMap()
    cb({["ok"]=true})
    return 
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap") --get the minimap scaleform A.K.A minimap.gfx
    while true do
        if IsPauseMenuActive() and not clientPlayer.isMenuOpen then
            SetFrontendActive(false)
            clientPlayer.isMenuOpen = true
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
            TriggerScreenblurFadeIn(500)

            TakeControlOfFrontend()

            SetupNUI()

            SendNUIMessage({
                type = 'NUI_TOGGLE',
                viz = true
            })
            debug(clientPlayer.currentPanel)
            if clientPlayer.currentPanel == "map" then
                LoadMap()
                Wait(100)
                LoadMap()   -- He's making his list, He's loading it twice,
                            -- He's waiting 100ms because Scaleforms are a b*tch and don't want to cooperate.
            end
        end

        if clientPlayer.isMenuOpen then
            if clientPlayer.currentPanel == "map" then
                BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR") -- starting the same function as the one we modified previously
                ScaleformMovieMethodAddParamInt(3) -- overwriting whatever `healthType` the game has, with the GOLF one
                EndScaleformMovieMethod() -- end the function, so the game can run it.
            end
            if not IsPauseMenuActive() and getbacktoNUI == true then
                if clientPlayer.currentPanel == "map" or clientPlayer.currentPanel == "settings" then
                    SetNuiFocus(true, true)
                    SetNuiFocusKeepInput(false)
                    TriggerScreenblurFadeIn(1)
                    TakeControlOfFrontend()
                    local forceInfo = false
                    if clientPlayer.currentPanel == "settings" then
                        clientPlayer.currentPanel = "info"
                        forceInfo = true
                    end
                    SendNUIMessage({
                        type = 'NUI_TOGGLE',
                        viz = true,
                        forceInfo = forceInfo
                    })
                    getbacktoNUI = false
                end
            end
        end
        Citizen.Wait(1) -- 1ms wait to confuse the resmon and keep the kids happy.
    end
end)