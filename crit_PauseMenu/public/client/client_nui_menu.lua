getbacktoNUI = false -- Needed to get back to the NUI after using a default pause page, like Settings or Gallery.
firstOpen = true -- Needed in order to use the default panel settings. 

onlinePlayers = {
    -- {id = src, name = PlayerName, col1 = "", col2 = "", col3 = "", col4 = ""}
}

minimapState = false
bigMapState = {false, false}

RegisterNetEvent(Events.RECEIVE_PLAYERLIST, function(data)
    onlinePlayers = data
    debug("RECEIVE_PLAYERLIST :: Event Ran. "..json.encode(onlinePlayers))
    if IsNuiFocused() then
        SendNUIMessage({
            type = 'UPDATE_PLAYER_LIST',
            players = onlinePlayers
        })
    end
end)

function SetupNUI() -- This also runs when the NUI is open, and the language is changed.
    local title = nil
    local desc = nil
    SendNUIMessage({
        type = 'SETUP_DATA',
        labels = nuiLocales[clientPlayer.lang], -- Button / table text labels.
        info = nuiInfo[clientPlayer.lang], -- Components on the Information panel.
        overrideTitle = title, -- Pause menu title, if you want to override it from the config.
        overrideDesc = desc, -- Pause menu subtitle, if you want to override it from the config.
        players = onlinePlayers, -- Player list
        socialButtons = Config.socialButtons, -- Social buttons panel.
        languages = localesLanguages, -- from sh_locales.lua
        currentLanguage = clientPlayer.lang, -- Menu language, needed, but you can have only one if you want.
    })
end

RegisterNUICallback('TOGGLE_PANEL', function(data, cb)
    debug("TOGGLE_PANEL :: Panel: "..data.panel.." / Option: "..data.option)
    if data.option == "map" then
        if GetProfileSetting(204) == 1 then
            LoadMap()
        else
            ToggleFullscreenMap()
        end
    elseif data.option == "settings" then
        SetupSettings()
    elseif data.option == "gallery" then
        SetupGallery()
    -- elseif data.option == "players" then
    --     SetupStats()
    end
    if (GetProfileSetting(204) == 1 and data.option == "map") or data.option ~= "map" then
        clientPlayer.currentPanel = data.option
    end
    cb({["ok"]=true})
    return 
end)

RegisterNUICallback('TOGGLE_BUTTON', function(data, cb)
    debug("TOGGLE_BUTTON :: Option: "..data.option)
    if data.option == "leaveServer" then
        TriggerServerEvent(Events.DISCONNECT_ME)
    elseif data.option == "quitGame" then
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
        AnimpostfxStop("MP_OrbitalCannon")
        QuitGame()
    elseif data.option == "changeLang" and clientPlayer.lang ~= data.lang then
        TriggerServerEvent(Events.CHANGE_MY_LANGUAGE, data.lang)
        PlaySoundFrontend(-1, "TOGGLE_ON", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
        debug('TOGGLE_BUTTON :: lang :: clientPlayer: '..clientPlayer.lang.." vs. NUI: "..data.lang)
        debug('TOGGLE_BUTTON :: lang Change')
    end
    if data.option ~= "changeLang" then
        clientPlayer.currentPanel = data.option
    end
    cb({["ok"]=true})
    return 
end)

RegisterNUICallback('TOGGLE_PANEL_MAP', function(data, cb)
    debug("TOGGLE_PANEL_MAP :: Option: "..data.option)
    if data.option == "map" then
        ToggleFullscreenMap()
    else
        -- resetMap()
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
    resetMap() -- Reseting the minimap after closing the menu. This causes a problem for slower systems, sometimes, but otherwise it won't work.
    AnimpostfxStop("MP_OrbitalCannon")
    TriggerEvent('crit_PauseMenu.PauseMenuClosed')
    cb({["ok"]=true})
    return 
end)

Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap") --get the minimap scaleform A.K.A minimap.gfx
    Wait(200) -- Waiting a bit for other scripts to do their thing.
    SetRadarBigmapEnabled(true, false)      --]
    Wait(0)                                 --] This whole nonsense is to not fuck up the other parts of the minimap... not sure why, but it works.
    SetRadarBigmapEnabled(false, false)     --]
    while true do
        if IsPauseMenuActive() and GetCurrentFrontendMenuVersion() == GetHashKey("FE_MENU_VERSION_MP_PAUSE") and not clientPlayer.isMenuOpen then
            SetFrontendActive(false)
            debug("OPENING THE MAP :: "..tostring(not minimapState).. " / "..tostring(bigMapState[1]).. " / "..tostring(bigMapState[2]))
            AnimpostfxPlay("MP_OrbitalCannon", 1000, true)
            SetNuiFocus(true, true)
            SetNuiFocusKeepInput(false)
            TriggerScreenblurFadeIn(500)

            TakeControlOfFrontend()

            SetupNUI()
            local nuiData = {
                type = 'NUI_TOGGLE',
                viz = true
            }
            if firstOpen then
                nuiData.forcePanel = Config.defaultPanel
                if nuiData.forcePanel == ".mapHeader" and GetProfileSetting(204) == 0 then
                    nuiData.forcePanel = ".infoHeader"
                end
                clientPlayer.currentPanel = headerCSStoPanelLua[nuiData.forcePanel] or "info"
                firstOpen = false
            end
            SendNUIMessage(nuiData)
            debug(clientPlayer.currentPanel)
            -- Wait(10)
            clientPlayer.isMenuOpen = true
            if clientPlayer.currentPanel == "map" then
                Wait(10)
                LoadMap()
                -- Wait(100)
                -- LoadMap()   -- He's making his list, He's loading it twice,
                --             -- He's waiting 100ms because Scaleforms are a b*tch and don't want to cooperate.
            end

            TriggerEvent('crit_PauseMenu.PauseMenuOpened')
        end

        if clientPlayer.isMenuOpen then
            if not IsPauseMenuActive() then
                DisableControlAction(0, 202, true)
                DisableControlAction(0, 200, true)
                DisableControlAction(0, 199, true)
            end
            if clientPlayer.currentPanel == "map" then
                BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR") -- starting the same function as the one we modified previously
                ScaleformMovieMethodAddParamInt(3) -- overwriting whatever `healthType` the game has, with the GOLF one
                EndScaleformMovieMethod() -- end the function, so the game can run it.

                BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR") -- starting the same function as the one we modified previously
                ScaleformMovieMethodAddParamInt(3) -- overwriting whatever `healthType` the game has, with the GOLF one
                EndScaleformMovieMethod() -- end the function, so the game can run it.

                if IsRadarHidden() and GetProfileSetting(204) == 1 then
                    DisplayRadar(true)
                end
                if not IsBigmapActive() then
                    SetRadarBigmapEnabled(true, false)
                end
            else
                HideHudAndRadarThisFrame()
                SetFakePausemapPlayerPositionThisFrame(9999.9,9999.9) -- Faking player location outside the map, because the fullscreen map sometimes flashes the player
            end
            if not IsPauseMenuActive() and getbacktoNUI == true then
                if clientPlayer.currentPanel == "map" or clientPlayer.currentPanel == "settings" or clientPlayer.currentPanel == "gallery" or clientPlayer.currentPanel == "players" then
                    SetNuiFocus(true, true)
                    SetNuiFocusKeepInput(false)
                    TriggerScreenblurFadeIn(1)
                    TakeControlOfFrontend()
                    local forceInfo = false
                    if GetProfileSetting(204) == 0 or clientPlayer.currentPanel ~= "map" then
                        clientPlayer.currentPanel = "info"
                        forceInfo = ".infoHeader"
                    else
                        LoadMap()
                    end
                    SendNUIMessage({
                        type = 'NUI_TOGGLE',
                        viz = true,
                        forcePanel = forceInfo
                    })
                    getbacktoNUI = false
                end
            end
        end
        Citizen.Wait(3) -- 1ms wait to confuse the resmon and keep the kids happy.
    end
end)

-- ... R* decided to return 1 and false for the minimap check natives ...
-- We are translating all the possibilities. Just in case.
local translateToBool = {
    [0] = false,
    [false] = false,
    ["0"] = false,
    [1] = true,
    [true] = true,
    ["1"] = true
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10) -- We don't need to run this all the time.
        if clientPlayer.isMenuOpen == false and not IsPauseMenuActive() then
            Citizen.Wait(10) -- MANDATORY WAIT. OMG I HATE THIS RESOURCE.
            if GetProfileSetting(204) == 1 then
                minimapState = translateToBool[IsRadarHidden()] or false
                bigMapState = {translateToBool[IsBigmapActive()] or false, translateToBool[IsBigmapFull()] or false}

                -- print("MINIMAP THREAD :: "..tostring(not minimapState).. " / "..tostring(bigMapState[1]).. " / "..tostring(bigMapState[2]))
            end
        end
    end
end)