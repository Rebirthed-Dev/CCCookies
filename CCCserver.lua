local comms = require "recommunicate"

local cookie = require "cookielib"

local db = require "restore"

local db_locks = {}

print("This lua file is for testing. This will format the drive in the disk drive for use with Cookie Clicker.")

print("If you would like to format this drive, enter Y: ")
local choice = read()

if choice == "Y" then
    comms.format("testingServer")
end

--local TEMPLATE = {
    --["Cookies"] = 0,
--}

--local buildingData = {
--    [0] = {
--        ["Name"] = "Cursor",
--        ["ImagePath"] = "images/imagecursor.bimg",
--        ["Count"] = 0,
--        ["Cost"] = 15,
--        ["CPS"] = 0.1,
--        ["Desc1"] = "A cursor to click more cookies.",
--        ["Desc2"] = ""
--    }
--}

--local buildings = {
--    [0] = {
--        ["Name"] = "Cursor",
--        ["Image"] = "images/imagecursor.bimg",
--        ["BaseCost"] = 15,
--        ["BaseCPS"] = 0.1,
--        ["Desc1"] = "A cursor to click more cookies.",
 --       ["Desc2"] = ""
--    }
--}

-- To initialise a server
-- Intialise Identity for clients to send their messages to.
-- Create a CookieClicker Protocol with a Listener that can hear messages.
-- Begin listening for messages from communications.

local identity, name = comms.initialise()

local daemon = comms.getDaemon()

local protocol = comms.createProtocol(identity, "Cookie")

db.init()

local server = {}

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

server.awaitTurnWithUserData = function(communicationID, address)
    if db_locks[address] then
        -- this is locked
        while db_locks[address] == true do
            os.sleep()
        end
        db_locks[address] = true
        return
    else
        -- unlocked
        db_locks[address] = true
        return
    end
end

server.unlockUserData = function(address)
    if db_locks[address] then
        db_locks[address] = nil
    end
end

server.hydrateBuildingData = function(userData)
    local modifiedBuildings = cookie.getBuildingClientData()
    for i, buildingData in pairs(modifiedBuildings) do
        -- need to add a Count variable for how many buildings this user has
        -- need to calculate the CPS per building based on user's upgrades
        -- need to calculate the cost of a new building based on how many buildings this user has.
        buildingData["Count"] = userData["Buildings"][buildingData["Name"]]
        buildingData["CPS"] = cookie.server_calculateCookiesFromBuilding(buildingData["Name"], userData)
        buildingData["Cost"] = cookie.getBuildingCost(userData, buildingData["Name"], nil)
    end

    return modifiedBuildings
end

server.hydrateUpgradeData = function(userData)
    local upgradeDataToGive = cookie.getUpgradeClientData(userData)

    return upgradeDataToGive
end

server.applyCookiesPerSecond = function(userData, address)
    if userData["LastUpdate"] < 1000 then -- meant to catch 0 but giving it some tolerance just in case
        userData["LastUpdate"] = os.epoch("utc") - 1000 -- we've set their lastUpdate to be up to date so let's give them a pity second
    end

    local timeDifference = os.epoch("utc") - userData["LastUpdate"]
    local secondDifference = timeDifference / 1000

    local updatedData, cookiesPerSecond = cookie.gainCookiesPerSecond(userData, secondDifference)

    updatedData["LastUpdate"] = os.epoch("utc")
    db.updateDatabase(address, "LastUpdate", updatedData["LastUpdate"])

    return updatedData, cookiesPerSecond
end

-- messagerecieved will be the action the user wants to do. e.g getData or cookieClick.
server.onMessage = function(communicationID, address, messageRecieved)
    if messageRecieved == "initialDataRequest" then
        server.onMessage(communicationID, address, "getBuildingData")
        server.onMessage(communicationID, address, "getUpgradeData")
        server.onMessage(communicationID, address, "update_Home")
        return
    end
    local cookies = nil
    print("got " .. messageRecieved .. " from a username")
    print()
    if db.checkIfPlayerDatabaseExists(address) == false then
        db.createPlayerDatabase(address)
    end
    if messageRecieved == "cookieClick" then
        server.awaitTurnWithUserData(communicationID, address)
        if db.checkIfPlayerDatabaseExists(address) == true then
            cookies = db.queryPlayerDatabase(address, "Cookies")
        else
            cookies = 0
            db.createPlayerDatabase(address)
        end
        if cookies ~= nil then
            cookies = cookies + 1
            comms.serverSendToID(communicationID, textutils.serialiseJSON({["Message"] = "home", ["Data"] = {["Cookies"] = cookies}}))
            db.updateDatabase(address, "Cookies", cookies)
        end
        server.unlockUserData(address)
    elseif messageRecieved == "getBuildingData" then
        server.awaitTurnWithUserData(communicationID, address)
        local userData = db.queryAllPlayerData(address)
        local dataToSend = server.hydrateBuildingData(userData)

        local formattedData = {["Message"] = "buildings", ["Data"] = nil}

        formattedData["Data"] = dataToSend

        comms.serverSendToID(communicationID, textutils.serialiseJSON(formattedData))
        server.unlockUserData(address)
    elseif messageRecieved == "getUpgradeData" then
        server.awaitTurnWithUserData(communicationID, address)
        local userData = db.queryAllPlayerData(address)
        local dataToSend = server.hydrateUpgradeData(userData)

        local formattedData = {["Message"] = "upgrades", ["Data"] = nil}

        formattedData["Data"] = dataToSend

        comms.serverSendToID(communicationID, textutils.serialiseJSON(formattedData))
        server.unlockUserData(address)
    elseif string.find(messageRecieved, "buy_") then
        local resultData = nil

        local splitString = splitString(messageRecieved, "_")
        local buildingToBuy = splitString[2]
        server.awaitTurnWithUserData(communicationID, address)
        local userData = db.queryAllPlayerData(address)
        local sanitisedData, _ = server.applyCookiesPerSecond(userData, address)
        if buildingToBuy == "upgrade" then
            local newData = cookie.server_purchaseUpgrade(sanitisedData, splitString[3])
            db.updateDatabase(address, "Cookies", newData["Cookies"])
            db.updateDatabase(address, "Upgrades", newData["Upgrades"])

            local upgradeClientData = server.hydrateUpgradeData(newData)

            local formattedData = {["Message"] = "upgrades", ["Data"] = nil}
            formattedData["Data"] = upgradeClientData
            comms.serverSendToID(communicationID, textutils.serialiseJSON(formattedData))

            resultData = newData
        else
            local newData = cookie.purchaseBuilding(sanitisedData, buildingToBuy)
            db.updateDatabase(address, "Cookies", newData["Cookies"])
            db.updateDatabase(address, "Buildings", newData["Buildings"])
            local buildingClientData = server.hydrateBuildingData(newData)
            local formattedData = {["Message"] = "buildings", ["Data"] = nil}
            formattedData["Data"] = buildingClientData
            comms.serverSendToID(communicationID, textutils.serialiseJSON(formattedData))

            local upgradeClientData = server.hydrateUpgradeData(newData)

            local formattedData = {["Message"] = "upgrades", ["Data"] = nil}
            formattedData["Data"] = upgradeClientData
            comms.serverSendToID(communicationID, textutils.serialiseJSON(formattedData))

            resultData = newData
        end

        local _, newCPS = server.applyCookiesPerSecond(resultData, address)

        comms.serverSendToID(communicationID, textutils.serialiseJSON({["Message"] = "home", ["Data"] = {["Cookies"] = resultData["Cookies"], ["CPS"] = newCPS}}))

        server.unlockUserData(address)

    elseif string.find(messageRecieved, "update_") then
        local splitString = splitString(messageRecieved, "_")
        local updateWanted = splitString[2]
        if updateWanted == "Home" then
            server.awaitTurnWithUserData(communicationID, address)
            local userData = db.queryAllPlayerData(address)
            local newData, CPStoSend = server.applyCookiesPerSecond(userData, address)

            db.updateDatabase(address, "Cookies", newData["Cookies"])

            comms.serverSendToID(communicationID, textutils.serialiseJSON({["Message"] = "home", ["Data"] = {["Cookies"] = newData["Cookies"], ["CPS"] = CPStoSend}}))

            server.unlockUserData(address)
        end
    end
end

local ServerLoopWrapper = function()
    comms.openAsServerLoop(protocol, server.onMessage)
end

parallel.waitForAny(ServerLoopWrapper, daemon)