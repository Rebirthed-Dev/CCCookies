local enet = require "ecnet2"
local crypto_rand = require "ccryptolib.random"

local diskFolder = "CCCookieClicker"
local identityFolder = "Identity"
local nameFile = "Username"

local identity = nil
local name = ""

-- https://www.random.org/strings/?num=1&len=32&digits=on&upperalpha=on&loweralpha=on&unique=on&format=plain&rnd=new
-- Initialize the random generator.
local postHandle = assert(http.post("https://krist.dev/ws/start", "{}"))
local data = textutils.unserializeJSON(postHandle.readAll())
postHandle.close()
crypto_rand.init(data.url)
http.websocket(data.url).close()

local recommunicate = {}

local connections = {}

local address = ""

recommunicate.openIdentityFromDisk = function()
    print("Main opening Identity from Disk.")
    local path = "/" .. diskFolder
    local drive = peripheral.find("drive")

    -- check if drive has data
    if drive.hasData() == true then
        print("Data Present.")
        local drivePath = drive.getMountPath()
        local fullPath = drivePath .. path

        if fs.exists(fullPath) == true then
            print("Existence Verified - Main Path")
            if fs.exists(fullPath .. "/" .. identityFolder) then
                print("Existence Verified - Identity Folder")
                if fs.find(fullPath .. "/" .. nameFile) then
                    print("Existence Verified - nameFile")
                    -- get Identity and Name

                    identity = enet.Identity(fullPath .. "/" .. identityFolder)
                    nameFile = fs.open(fullPath .. "/" .. nameFile, "r")
                    name = nameFile.readAll()
                    nameFile.close()
                end
            end
        end
    end

    return identity, name
end

recommunicate.formatDisk = function(username)
    local drive = peripheral.find("drive")

    local drivePath = drive.getMountPath()

    local files = fs.list(drivePath)
    for i = 1, #files do
        fs.delete(files[i])
    end

    -- create CookieClicker folder
    fs.makeDir(drivePath .. "/" .. diskFolder)

    -- create Username file

    local userFile = fs.open(drivePath .. "/" .. diskFolder .. "/" .. nameFile, "w")
    userFile.write(username)
    userFile.close()

    -- create Identity
    fs.makeDir(drivePath .. "/" .. diskFolder .. "/" .. identityFolder)
    local tempID = enet.Identity(drivePath .. "/" .. diskFolder .. "/" .. identityFolder)

    return true
end

recommunicate.openAsServerLoop = function(protocol, messageFunction)
    local listener = protocol:listen()

    while true do
        local event, id, p2, p3, ch, dist = os.pullEvent()
        if event == "ecnet2_request" and id == listener.id then
            -- Accept the request and send a greeting message.
            local connection = listener:accept("Connection Accepted - Recommunicate Server", p2)
            connections[connection.id] = connection
        elseif event == "ecnet2_message" and connections[id] then
            --print("got", p3, "on channel", ch, "from", dist, "blocks away")
            --print(event)
            --print(id)
            --print(p2)
            --print(p3)
            --print(ch)
            --print(dist)
            messageFunction(id, p2, p3)
        end
    end
end

recommunicate.serverSendToID = function(id, message)
    connections[id]:send(message)
end

recommunicate.connectToServer = function(protocol, serverAddress)
    return protocol:connect(serverAddress, "back")
end

recommunicate.listenToServerLoop = function(connection, messageFunction)
    while true do
        local sender, message = connection:receive()
        messageFunction(sender, message)
    end
end

recommunicate.createProtocol = function(identity, name)
    return identity:Protocol {
        -- Programs will only see packets sent on the same protocol.
        -- Only one active listener can exist at any time for a given protocol name.
        name = name,
    
        -- Objects must be serialized before they are sent over.
        serialize = textutils.serialize,
        deserialize = textutils.unserialize,
    }
end

recommunicate.getIdentityAndUsernameFromDisk = function()
    recommunicate.openIdentityFromDisk()

    return identity, name
end

return recommunicate
