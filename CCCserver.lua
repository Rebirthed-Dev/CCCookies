local comms = require "recommunicate"

local db = require "restore"

print("This lua file is for testing. This will format the drive in the disk drive for use with Cookie Clicker.")

--comms.format("testingUser")

-- To initialise a server
-- Intialise Identity for clients to send their messages to.
-- Create a CookieClicker Protocol with a Listener that can hear messages.
-- Begin listening for messages from communications.

local identity, name = comms.initialise()
print(identity)

local daemon = comms.getDaemon()

local protocol = comms.createProtocol(identity, "Cookie")

db.init()

local onMessage = function(communicationID, address, messageRecieved)
    local cookies = nil
    print("got " .. messageRecieved .. " from a user, checking cookies, incrementing by 1, and sending current count")
    print()
    if db.checkIfPlayerDatabaseExists(address) == true then
        cookies = db.queryPlayerDatabase(address, "Cookies")
    else
        cookies = 0
        db.createPlayerDatabase(address)
    end
    if cookies ~= nil then
        print("cookies not nil")
        cookies = cookies + 1
        comms.serverSendToID(communicationID, "Current Cookie count: " .. cookies)
        print("message sent")
        db.updateDatabase(address, "Cookies", cookies)
    end
end

local ServerLoopWrapper = function()
    comms.openAsServerLoop(protocol, onMessage)
end

parallel.waitForAny(ServerLoopWrapper, daemon)