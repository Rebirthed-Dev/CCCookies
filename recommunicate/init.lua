local module = {}
local encryptnet = require "ecnet2"
local mainModule = require "recommunicate.recom"

-- OPEN ENDER MODEM HERE - DEFAULT "TOP"
encryptnet.open("back")

local encryptnet = require "ecnet2"

function module.mephistopheles()
    -- Extract Identity
    return mainModule.openIdentityFromDisk()
end

function module.getDaemon()
    return encryptnet.daemon
end

function module.initialise()
    return module.mephistopheles()
end

function module.createProtocol(identity, name)
    return mainModule.createProtocol(identity, name)
end

function module.openAsServerLoop(protocol, messageFunction)
    mainModule.openAsServerLoop(protocol, messageFunction)
end

function module.connectToServer(protocol, serverAddress)
   return mainModule.connectToServer(protocol, serverAddress)
end

function module.listenToServerLoop(connection, messageFunction)
    mainModule.listenToServerLoop(connection, messageFunction)
end

function module.serverSendToID(id, message)
    mainModule.serverSendToID(id, message)
end

function module.format(username)
    mainModule.formatDisk(username)
end

return module