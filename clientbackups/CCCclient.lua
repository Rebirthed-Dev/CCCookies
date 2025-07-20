local comms = require "recommunicate"
local ui = require "guiComponents"
local db = require "restore"

local handshake = false

-- homeData, things displayed on home menu
local data = {
    ["Cookies"] = 0,
    ["CPS"] = 0
}

local OPTIONS = {
    {"Use Scientific Notation", "USE_NOTATION"},
    {"Erlking Mode", "USE_ERLKING"},
    {"Inverse Mode", "LIGHT_MODE"}
}


-- buildingData, things displayed on building menu
local buildingData = {
}

local upgradeData = {

}

local cookieString = " Cookies"

local undefaultColors = {
    ["white"] = colors.packRGB(240, 240, 240),
    ["orange"] = colors.packRGB(242, 178, 51),
    ["magenta"] = colors.packRGB(229, 127, 216),
    ["lightBlue"] = colors.packRGB(153, 178, 242),
    ["yellow"] = colors.packRGB(222, 222, 108),
    ["lime"] = colors.packRGB(127, 204, 25),
    ["pink"] = colors.packRGB(242, 178, 204),
    ["gray"] = colors.packRGB(76, 76, 76),
    ["lightGray"] = colors.packRGB(153, 153, 153),
    ["cyan"] = colors.packRGB(76, 153, 178),
    ["purple"] = colors.packRGB(178, 102, 229),
    ["blue"] = colors.packRGB(51, 102, 204),
    ["brown"] = colors.packRGB(127, 102, 76),
    ["green"] = colors.packRGB(87, 166, 78),
    ["red"] = colors.packRGB(204, 76, 76),
    ["black"] = colors.packRGB(17, 17, 17)
}

local defaultColors = {
    ["white"] = {240, 240, 240},
    ["orange"] = {242, 178, 51},
    ["magenta"] = {229, 127, 216},
    ["lightBlue"] = {153, 178, 242},
    ["yellow"] = {222, 222, 108},
    ["lime"] = {127, 204, 25},
    ["pink"] = {242, 178, 204},
    ["gray"] = {76, 76, 76},
    ["lightGray"] = {153, 153, 153},
    ["cyan"] = {76, 153, 178},
    ["purple"] = {178, 102, 229},
    ["blue"] = {51, 102, 204},
    ["brown"] = {127, 102, 76},
    ["green"] = {87, 166, 78},
    ["red"] = {204, 76, 76},
    ["black"] = {17, 17, 17}
}


local currentArea = 1
local scrollBoxPositionBuildings = 1
local scrollBoxPositionUpgrades = 1

comms.format("genericUser")
local mon = peripheral.find("monitor")

-- 5x5 TEXT SCALE 1 MONITOR SIZE: 50x33
local monW, monH = mon.getSize()

mon.clear()

local client = {}

-- Start DB.
_ = db.init()

-- used to make our player DB file 
local OPTIONS_TEMPLATE = {
    ["ActiveSettings"] = {}
}

-- where to save our options in the DB, hardcoded, but could be used in future to have "setting profiles" or something.
local optionAddress = "settingStore"

-- to prevent latency we're gonna keep the options loaded in memory so they're easily accessible.
-- I don't wanna have to reload them every time we change scene because that would be a Mess!!
local dbOptions = {}

-- Define an identity.
local identity = comms.initialise()

-- Define a protocol.
local protocol = comms.createProtocol(identity, "Cookie")

local daemon = comms.getDaemon()

-- The server's address.
local server = "iCgiBsW4a6ElIi9WPZVKPZZyk_9nYb4kueZth_vKlSE="

local serverConnection = comms.connectToServer(protocol, server)

local shortnumberstring = function(number)
    if not client.getOption("USE_NOTATION") then
        local steps = {
            {1,""},
            {1e3,"k"},
            {1e6,"m"},
            {1e9,"b"},
            {1e12,"t"},
        }
        for _,b in ipairs(steps) do
            if b[1] <= number+1 then
                steps.use = _
            end
        end
        local result = string.format("%.1f", number / steps[steps.use][1])
        if tonumber(result) >= 1e3 and steps.use < #steps then
            steps.use = steps.use + 1
            result = string.format("%.1f", tonumber(result) / 1e3)
        end
        --result = string.sub(result,0,string.sub(result,-1) == "0" and -3 or -1) -- Remove .0 (just if it is zero!)
        return result .. steps[steps.use][2]
    else
        return string.format ("%3.2e", number)
    end
end

local splitString = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end


local clientLoop = function()
    while true do
        if handshake == true then
            write("Press Enter to ask server to increment database cookies by 1... ")
            local messageToSend = "cookieClick"
            handshake = false
            serverConnection:send(messageToSend)
        end
        os.sleep(0.1)
    end
end

local resetPaletteBad = function(mon)
    for colorName, rgb in pairs(undefaultColors) do
        mon.setPaletteColor(colors[colorName], colors.unpackRGB(rgb))
    end
end

local resetPalette = function(mon)
    for colorName, rgb in pairs(defaultColors) do
        mon.setPaletteColor(colors[colorName], rgb[1]/255, rgb[2]/255, rgb[3]/255)
    end
end

local incrementCookies = function()
    local messageToSend = "cookieClick"
    serverConnection:send(messageToSend)
end

-- any setup we need to do before client can run

client.init = function()
    if db.checkIfPlayerDatabaseExists(optionAddress) == false then
        client.createDB()
    end

    local loadedOptions = client.loadDBOptions()

    print(loadedOptions)

    for i, option in ipairs(loadedOptions) do
        dbOptions[option] = true
    end
    client.checkForErlkingMode()
end

client.checkForErlkingMode = function()
    if client.getOption("USE_ERLKING") then
        cookieString = " Erlkings"
    else
        cookieString = " Cookies"
    end
end

client.createDB = function()
    db.createPlayerDatabase(optionAddress, OPTIONS_TEMPLATE)
end

client.loadDBOptions = function()
    local options = db.queryPlayerDatabase(optionAddress, "ActiveSettings")
    return options
end

client.saveDBOptions = function()
    local optionsToSave = {}
    for option, _ in pairs(dbOptions) do
        table.insert(optionsToSave, option)
    end

    db.updateDatabase(optionAddress, "ActiveSettings", optionsToSave)
end

client.manageOptions = function(newOption, value) 
    if value then
        dbOptions[newOption] = true 
    else
        dbOptions[newOption] = nil
    end

    client.saveDBOptions()
end

client.getOption = function(option)
    if dbOptions[option] then
        return dbOptions[option]
    else
        return false
    end
end

client.optionToColor = function(option)
    if client.getOption(option) then
        return colors.green
    else 
        return colors.red
    end
end

client.toggleOption = function(option)
    client.manageOptions(option, not client.getOption(option))
end

client.uiDrawHome = function()
    local cookies = shortnumberstring(data["Cookies"])
    local cps = shortnumberstring(data["CPS"])
    ui.centerLabel(mon, 1, 1, monW, "Cookie Clicker")

    ui.centerLabel(mon, 1, 3, monW, cookies .. cookieString)
    ui.centerLabel(mon, 1, 4, monW, cps .. " CPS")

    if client.getOption("USE_ERLKING") then
        -- god fucking help you.
        ui.drawImage(mon, 15, 10, "images/erlkingScuffed.bimg", 1, true)
        mon.setPaletteColor(colors.black, 17/255, 17/255, 17/255)
    else
        ui.drawImage(mon, 15, 10, "images/cookie.bimg", 1, true)
        ui.clickRegion(mon, 15, 10, 20, 12, incrementCookies, "monitor_0")
    end
end

client.scrollBoxHandlerBuildings = function(scrollWindow, movementOperation, windowWidth, movement)
    local newPosition = scrollBoxPositionBuildings + movement
    if newPosition < 1 or newPosition > windowWidth then
        -- do nothing
    else
        movementOperation(newPosition)
        scrollBoxPositionBuildings = newPosition
    end
end

client.scrollBoxHandlerUpgrades = function(scrollWindow, movementOperation, windowWidth, movement)
    local newPosition = scrollBoxPositionUpgrades + movement
    if newPosition < 1 or newPosition > windowWidth then
        -- do nothing
    else
        movementOperation(newPosition)
        scrollBoxPositionUpgrades = newPosition
    end
end

client.buyBuildingEntry = function(buildingName)
    print("buying " .. buildingName)
    serverConnection:send("buy_" .. buildingName)
end

client.buyUpgradeEntry = function(upgradeName)
    print("buying " .. upgradeName)
    serverConnection:send("buy_upgrade_" .. upgradeName)
end

client.scrollBoxCreateBuildingEntry = function(win, index, buildingImage, buildingName, buildingCount, buildingCost, buildingCPS, desc1, desc2)
    -- BUILDING ENTRIES
    local canAfford = data["Cookies"] >= buildingCost
    local borderColor = colors.red

    if canAfford then
        borderColor = colors.green
    end

    ui.drawImage(win, 3, 4 + (index * 12), buildingImage, 1, true)
    ui.borderBox(win, 3, 3 + (index * 12), 45, 9, borderColor, colors.black)

    local titleText = buildingName .. " (" .. buildingCount .. ")"
    local cpsText = buildingCPS .. " CpS per " .. buildingName

    ui.label(win, 13, 3 + (index * 12), titleText, colors.white, colors.black)
    ui.label(win, 13, 4 + (index * 12), cpsText, colors.white, colors.black)

    --desc1 and desc2 lines
    ui.label(win, 13, 6 + (index * 12), desc1, colors.white, colors.black)
    ui.label(win, 13, 7 + (index * 12), desc2, colors.white, colors.black)

    local purchaseText = "Buy 1x for " .. shortnumberstring(buildingCost) .. cookieString
    ui.label(win, 13, 10 + (index * 12), purchaseText, colors.white, colors.black)

    ui.clickRegion(win, 2, 2+(index * 12), 47, 11, function() client.buyBuildingEntry(buildingName) end, "monitor_0")
end

client.scrollBoxCreateUpgradeEntry = function(win, index, upgradeImage, upgradeName, upgradeCost, func1, func2, desc1, desc2)
    -- UPGRADE ENTRIES
    local canAfford = data["Cookies"] >= upgradeCost
    local borderColor = colors.red

    if canAfford then
        borderColor = colors.green
    end

    ui.drawImage(win, 3, 4 + (index * 12), upgradeImage, 1, true)
    ui.borderBox(win, 3, 3 + (index * 12), 45, 9, borderColor, colors.black)

    local titleText = upgradeName

    ui.label(win, 13, 3 + (index * 12), titleText, colors.white, colors.black)
    ui.label(win, 13, 4 + (index * 12), func1, colors.white, colors.black)
    ui.label(win, 13, 5 + (index * 12), func2, colors.white, colors.black)

    --desc1 and desc2 lines
    ui.label(win, 13, 7 + (index * 12), desc1, colors.white, colors.black)
    ui.label(win, 13, 8 + (index * 12), desc2, colors.white, colors.black)

    local purchaseText = "Purchase for " .. shortnumberstring(upgradeCost) .. cookieString
    ui.label(win, 13, 10 + (index * 12), purchaseText, colors.white, colors.black)

    ui.clickRegion(win, 2, 2+(index * 12), 47, 11, function() client.buyUpgradeEntry(upgradeName) end, "monitor_0")
end

client.uiDrawBuildings = function ()
    -- BUILDINGS
    -- BUILDINGS
    -- BUILDINGS
    ui.centerLabel(mon, 1, 1, monW, "Cookie Clicker")

    local windowInnerHeight = 100

    local newWindow, scrollFunc = ui.scrollBox(mon, 1, 2, 50, 24, windowInnerHeight, true, true, colors.red, colors.black)

    ui.label(mon, 11, 27, "\\/ \\/")
    ui.label(mon, 35, 27, " /\\ /\\")

    ui.borderBox(mon, 3, 27, 21, 1)

    ui.borderBox(mon, 28, 27, 21, 1)

    scrollFunc(scrollBoxPositionBuildings)

    -- clicking "down"
    ui.clickRegion(mon, 2, 26, 21, 2, function() client.scrollBoxHandlerBuildings(newWindow, scrollFunc, windowInnerHeight, 1) end, "monitor_0")
    
    -- clicking "up"
    ui.clickRegion(mon, 28, 26, 21, 2, function() client.scrollBoxHandlerBuildings(newWindow, scrollFunc, windowInnerHeight, -1)  end, "monitor_0")

    for i, building in pairs(buildingData) do
        client.scrollBoxCreateBuildingEntry(newWindow, tonumber(i), building["Image"], building["Name"], building["Count"], building["Cost"], shortnumberstring(building["CPS"]), building["Desc1"], building["Desc2"])
    end

    --client.scrollBoxCreateBuildingEntry(newWindow, 2, "images/imagecursor.bimg", "Cursor", 40000, "400,000 Qd", "400,000 Qd", "A cursor to click more cookies.", "")
end

client.uiDrawUpgrades = function ()
    -- UPGRADES
    -- UPGRADES
    -- UPGRADES
    ui.centerLabel(mon, 1, 1, monW, "Cookie Clicker")

    local windowInnerHeight = 100

    local newWindow, scrollFunc = ui.scrollBox(mon, 1, 2, 50, 24, windowInnerHeight, true, true, colors.red, colors.black)

    --ui.centerLabel(newWindow, 4, 4, 40, "hello from window")

    ui.label(mon, 11, 27, "\\/ \\/")
    ui.label(mon, 35, 27, " /\\ /\\")

    ui.borderBox(mon, 3, 27, 21, 1)

    ui.borderBox(mon, 28, 27, 21, 1)

    -- the upgrades screen can change in size so reset the scroll just to make sure we're good, a QOL change would be improving this later
    scrollBoxPositionUpgrades = 1

    scrollFunc(scrollBoxPositionUpgrades)

    -- clicking "down"
    ui.clickRegion(mon, 2, 26, 21, 2, function() client.scrollBoxHandlerUpgrades(newWindow, scrollFunc, windowInnerHeight, 1) end, "monitor_0")
    
    -- clicking "up"
    ui.clickRegion(mon, 28, 26, 21, 2, function() client.scrollBoxHandlerUpgrades(newWindow, scrollFunc, windowInnerHeight, -1)  end, "monitor_0")

    --client.scrollBoxCreateUpgradeEntry(newWindow, 0, "images/imagecursor.bimg", "Premium Cursors", "400,000 Qd", "Doubles cursor efficiency.", "Also makes you really cool.", "Plates your cursors in solid platinum.", "...they can't lift themselves anymore.")

    for i, upgrade in pairs(upgradeData) do
        client.scrollBoxCreateUpgradeEntry(newWindow, tonumber(i), upgrade["Image"], upgrade["Name"], upgrade["Cost"], upgrade["Func1"], upgrade["Func2"], upgrade["Desc1"], upgrade["Desc2"])
    end
end

client.uiDrawSettingsButton = function(y, settingName, stateName)
    local colorToUse = client.optionToColor(stateName)

    ui.borderBox(mon, 3, y, 46, 3, colorToUse)
    ui.label(mon, 4, y+1, settingName)
    ui.clickRegion(mon, 3, y-1, 46, 5, function() client.toggleOption(stateName) client.refreshDisplay() end, "monitor_0")
end

client.uiDrawSettings = function()
    -- stuff
    ui.centerLabel(mon, 1, 1, monW, "Cookie Clicker")

    for i, settingData in ipairs(OPTIONS) do
        client.uiDrawSettingsButton(5 + ((i - 1) * 6), settingData[1], settingData[2])
    end
end

client.changeArea = function(newArea)
    currentArea = newArea
    client.refreshDisplay()
end

client.uiDrawBar = function()
    -- Draw navigation bar for the sections Home, Buildings, Upgrades and Settings.

    -- Buildings - Area 2
    if currentArea == 2 then
        ui.borderBox(mon, 3, 30, 13, 3, colors.orange, colors.black)
        ui.label(mon, 5, 31, "Home", nil, nil)
        ui.clickRegion(mon, 2, 29, 15, 5, function() client.changeArea(1) end, "monitor_0")
    else
        ui.borderBox(mon, 3, 30, 13, 3, colors.white, colors.black)
        ui.label(mon, 5, 31, "Buildings", nil, nil)
        ui.clickRegion(mon, 2, 29, 15, 5, function() client.changeArea(2) end, "monitor_0")
    end

    -- Upgrades - Area 3
    if currentArea == 3 then
        ui.borderBox(mon, 19, 30, 14, 3, colors.orange, colors.black)
        ui.label(mon, 22, 31, "Home", nil, nil)
        ui.clickRegion(mon, 18, 29, 16, 5, function() client.changeArea(1) end, "monitor_0")
    else
        ui.borderBox(mon, 19, 30, 14, 3, colors.white, colors.black)
        ui.label(mon, 22, 31, "Upgrades", nil, nil)
        ui.clickRegion(mon, 18, 29, 16, 5, function() client.changeArea(3) end, "monitor_0")
    end

    -- Settings - Area 4
    if currentArea == 4 then
        ui.borderBox(mon, 36, 30, 13, 3, colors.orange, colors.black)
        ui.label(mon, 39, 31, "Home", nil, nil)
        ui.clickRegion(mon, 35, 29, 15, 5, function() client.changeArea(1) end, "monitor_0")
    else
        ui.borderBox(mon, 36, 30, 13, 3, colors.white, colors.black)
        ui.label(mon, 39, 31, "Options", nil, nil)
        ui.clickRegion(mon, 35, 29, 15, 5, function() client.changeArea(4) end, "monitor_0")
    end
end

client.decodeServerMessage = function(message)
    -- ensures the first message we get doesn't crash the program because honestly can't be bothered
    if handshake == false then
        handshake = true
        serverConnection:send("initialDataRequest")
        return
    end

    local jsonMessage = textutils.unserializeJSON(message)

    if jsonMessage["Message"] == nil then
        return -- invalid message
    else
        if jsonMessage["Message"] == "home" then
            if jsonMessage["Data"] ~= nil then
                for field, value in pairs(jsonMessage["Data"]) do
                    data[field] = value
                end
            end
        elseif jsonMessage["Message"] == "buildings" then
            if jsonMessage["Data"] ~= nil then
                for field, value in pairs(jsonMessage["Data"]) do
                    buildingData[field] = value
                end
            end
        elseif jsonMessage["Message"] == "upgrades" then
            if jsonMessage["Data"] ~= nil then
                upgradeData = {}
                for field, value in pairs(jsonMessage["Data"]) do
                    upgradeData[field] = value
                end
            end
        end
    end
end

client.refreshDisplay = function()
    if client.getOption("LIGHT_MODE") then
        resetPaletteBad(mon)
    else
        resetPalette(mon)
    end
    mon.setPaletteColor(colors.lime, 0.22, 0.176, 0.129)
    if currentArea == 1 then
        ui.clearMonitor(mon)
        client.uiDrawHome()
        client.uiDrawBar()
    elseif currentArea == 2 then
        ui.clearMonitor(mon)
        client.uiDrawBuildings()
        client.uiDrawBar()
    elseif currentArea == 3 then
        ui.clearMonitor(mon)
        client.uiDrawUpgrades()
        client.uiDrawBar()
    elseif currentArea == 4 then
        ui.clearMonitor(mon)
        client.uiDrawSettings()
        client.uiDrawBar()
    end
end

client.onServerMessage = function(sender, message)
    --print("Got message from server: " .. message)
    client.decodeServerMessage(message)
    client.refreshDisplay()
end

client.serverLoopWrapper = function()
    comms.listenToServerLoop(serverConnection, client.onServerMessage)
end

client.serverUpdatePingLoop = function()
    local lastUpdate = os.epoch("utc")
    while true do
        if os.epoch("utc") - lastUpdate > 1000 then
            -- ask for update
            lastUpdate = os.epoch("utc")
            serverConnection:send("update_Home")
        end
        os.sleep(0.25)
    end
end

mon.setTextScale(1)

client.refreshDisplay()

client.init()

parallel.waitForAny(client.serverLoopWrapper, daemon, ui.run, client.serverUpdatePingLoop)