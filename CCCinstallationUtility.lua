local ui = require "guiComponents"
local comms = require "recommunicate"

local addressFile = "registrationUtility/address.txt"

local utility = {}

local mon = peripheral.find("monitor")

-- 5x5 TEXT SCALE 1 MONITOR SIZE: 50x33
local monW, monH = mon.getSize()

local drive = peripheral.find("drive")

mon.clear()

mon.setTextScale(1)

local diskFolder = "CCCookieClicker"
local identityFolder = "Identity"
local nameFile = "Username"

-- The installation utility is a tool for creating new Cookie Clicker Identities and installing the Cookie Clicker software.

-- It is utilised as follows:

-- Identity Creation / User Creation:
-- A drive is attached to this computer. When a new user wants to be created, a fresh disk is inserted into the drive.
-- To format this drive, press the button "Format New User onto Disk" on the computer's Terminal.
-- IMPORTANT NOTE: Each user disk must be installed with a Server Address to designate what computer should be connected to for the Cookie Clicker server.
-- Setup a server first, and then put the server's Identity Address in registrationUtility/address.txt.
-- The server software contains functionality for formatting a disk to create a new Server identity.

-- Cookie Clicker Software Installation:
-- Insert a new Advanced Computer into the Drive. This computer will have all the Client components installed based on the Client version installed on this system.
-- This can also be used as a software update functionality, though in the future modem-based wireless updates may be implemented.
-- When installing onto a computer, any existing Client components will be deleted and replaced with the Client components present on this system.


utility.formatDiskAsNewUser = function()
    comms.format("PLACEHOLDER_USERNAME")
    local drivePath = drive.getMountPath()

    -- create Address file
    fs.copy(addressFile, drivePath .. "/" .. diskFolder .. "/" .. "serverAddress.txt")
end

utility.installClientOnDriveComputer = function()

end

local utilityOptions = {
    {
        ["Name"] = "Format Disk as New User",
        ["Image"] = "images/saveicon.bimg",
        ["Desc1"] = "Format the disk in the Drive as a new CC user.",
        ["Desc2"] = "Server information will be embedded.",
        ["Action"] = utility.formatDiskAsNewUser
    },
    {
        ["Name"] = "Install Client on Computer",
        ["Image"] = "images/saveicon.bimg",
        ["Desc1"] = "Install/Update the Client on this computer.",
        ["Desc2"] = "This will overwrite existing files.",
        ["Action"] = utility.installClientOnDriveComputer
    }
}

utility.utilityDrawOption = function(win, index, utilityImage, utilityName, desc1, desc2, action)
    -- UPGRADE ENTRIES
    local borderColor = colors.blue

    ui.drawImage(win, 3, 4 + (index * 12), upgradeImage, 1, true)
    ui.borderBox(win, 3, 3 + (index * 12), 45, 9, borderColor, colors.black)

    local titleText = upgradeName

    ui.label(win, 13, 3 + (index * 12), titleText, colors.white, colors.black)

    --desc1 and desc2 lines
    ui.label(win, 13, 7 + (index * 12), desc1, colors.white, colors.black)
    ui.label(win, 13, 8 + (index * 12), desc2, colors.white, colors.black)

    local purchaseText = "Click to Execute"
    ui.label(win, 13, 10 + (index * 12), purchaseText, colors.white, colors.black)

    ui.clickRegion(win, 2, 2+(index * 12), 47, 11, function() print("hey") end, "top")
end

utility.uiDrawUtility = function()
    ui.centerLabel(mon, 1, 1, monW, "Cookie Clicker Installation Utility")

    local windowInnerHeight = 100

    local newWindow, scrollFunc = ui.scrollBox(mon, 1, 2, 50, 35, windowInnerHeight, true, true, colors.red, colors.black)

    ui.label(mon, 11, 35, "\\/ \\/")
    ui.label(mon, 35, 35, " /\\ /\\")

    ui.borderBox(mon, 3, 27, 21, 1)

    ui.borderBox(mon, 28, 27, 21, 1)

    -- clicking "down"
    ui.clickRegion(mon, 2, 26, 21, 2, function() client.scrollBoxHandlerBuildings(newWindow, scrollFunc, windowInnerHeight, 1) end, "top")
    
    -- clicking "up"
    ui.clickRegion(mon, 28, 26, 21, 2, function() client.scrollBoxHandlerBuildings(newWindow, scrollFunc, windowInnerHeight, -1)  end, "top")

    for i, utility in ipairs(utilityOptions) do
        utility.utilityDrawOption(newWindow, i, utility["Image"], utility["Name"], utility["Desc1"], utility["Desc2"], utility["Action"])
    end
end

utility.uiDrawUtility()

parallel.waitForAny(ui.run)