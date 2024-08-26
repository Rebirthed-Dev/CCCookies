local comms = require "recommunicate"

local handshake = false

-- Format Disk Drive to be a genericUser

comms.format("genericUser")

-- Define an identity.
local identity = comms.initialise()

-- Define a protocol.
local protocol = comms.createProtocol(identity, "Cookie")

local daemon = comms.getDaemon()

-- The server's address.
local server = "v9Ek8PAKUKvv05z9qbENXkLozJdFr2Zkfxbn2TMhISQ="

local serverConnection = comms.connectToServer(protocol, server)

local onServerMessage = function(sender, message)
    print("Got message from server: " .. message)
    handshake = true
end

local serverLoopWrapper = function()
    comms.listenToServerLoop(serverConnection, onServerMessage)
end

local clientLoop = function()
    while true do
        if handshake == true then
            write("Press Enter to ask server to increment database cookies by 1... ")
            local messageToSend = read()
            handshake = false
            serverConnection:send(messageToSend)
        end
        os.sleep(0.1)
    end
end

parallel.waitForAny(serverLoopWrapper, daemon, clientLoop)