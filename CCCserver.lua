local comms = require "recommunicate"

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

local onMessage = function(communicationID, address, messageRecieved)
    print("got " .. messageRecieved .. " from a user, sending ACK")
    print()
    comms.serverSendToID(communicationID, "ACK")
end

local ServerLoopWrapper = function()
    comms.openAsServerLoop(protocol, onMessage)
end

parallel.waitForAny(ServerLoopWrapper, daemon)