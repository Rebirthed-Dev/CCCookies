local restore = {}
local db = require "restore.database"

DATABASE_PATH = "/db"
DATABASE_MAIN_FILE = "/db/main"
DATABASE_BACKUP_PATH = "/db/backups"
DATABASE_PLAYER_FILES = "/db/playerData"
MAIN = nil -- The main database is immutable and cannot be modified. It will only be loaded, never saved, sometimes backed up, but can only be edited by hand.
-- Consider the main db as a configuration file for holding settings that can be considered always true and never corrupted.

local TEMPLATE = {
    ["Cookies"] = 0,
    ["Upgrades"] = {},
    ["Buildings"] = {
        ["Cursor"] = 0
    },
    ["Stats"] = {
        ["LifetimeCookies"] = 0,
        ["AccountCreated"] = 0
    }
}

local MAIN_TEMPLATE = {
    ["VERSION"] = "1.0.0",
    ["MAX_COOKIES"] = 1000000000000,
    ["CASH_OUT_DOWNSIZE"] = 1, -- do not divide cash out cookies by anything
    ["MAX_BUILDING"] = 999,
    ["BUILDINGS"] = {
        "Cursor"
    }, -- if a player entry doesn't match this list any missing will be added
}

restore.init = function()
    -- load main db
    MAIN = db.init(DATABASE_PATH, DATABASE_MAIN_FILE, DATABASE_PLAYER_FILES, DATABASE_BACKUP_PATH, MAIN_TEMPLATE)
end

-- Generally before sending main module a filepath, add a "/" to the start.
restore.createPlayerDatabase = function(name)
    local filepath = restore.generatePlayerFilePath(name)
    local backupPath = restore.generateBackupFilePath(name)
    return db.createDatabaseFile(filepath, backupPath, TEMPLATE)
end

restore.queryAllPlayerData = function(name)
    local filepath = restore.generatePlayerFilePath(name)

    local data = db.openDatabaseFile(filepath)

    return data
end

restore.queryPlayerDatabase = function(name, value)
    local filepath = restore.generatePlayerFilePath(name)

    local data = db.openDatabaseFile(filepath)

    return data[value]
end

restore.updateDatabase = function(name, value, newVal)
    local filepath = restore.generatePlayerFilePath(name)

    local backupPath = restore.generateBackupFilePath(name)

    local data = db.openDatabaseFile(filepath)

    if data[value] ~= nil then
        data[value] = newVal
    end

    db.closeDatabaseFile(data, filepath, backupPath)
    restore.backupSanity(name)
end

restore.backupDatabase = function(name)
    local filepath = restore.generatePlayerFilePath(name)
    local backupPath = restore.generateBackupFilePath(name)
    
    db.cloneDatabaseFile(filepath, backupPath)
    restore.backupSanity(name)
    return backupPath
end

restore.createEntryInDatabase = function(name, value, newVal)
    local filepath = restore.generatePlayerFilePath(name)

    local backupPath = restore.generateBackupFilePath(name)

    local data = db.openDatabaseFile(filepath)

    if data[value] == nil then
        data[value] = newVal
    end

    db.closeDatabaseFile(data, filepath, backupPath)
    restore.backupSanity(name)
end

restore.deleteEntryInDatabase = function(name, value)
    local filepath = restore.generatePlayerFilePath(name)

    local backupPath = restore.generateBackupFilePath(name)

    local data = db.openDatabaseFile(filepath)

    if data[value] ~= nil then
        data[value] = nil
    end

    db.closeDatabaseFile(data, filepath, backupPath)
    restore.backupSanity(name)
end

restore.updateEntryName = function(name, value, newName)
    local filepath = restore.generatePlayerFilePath(name)

    local backupPath = restore.generateBackupFilePath(name)

    local data = db.openDatabaseFile(filepath)
    if data[newName] == nil then
        if data[value] ~= nil then
            data[newName] = data[value]
            data[value] = nil
        end
    end

    db.closeDatabaseFile(data, filepath, backupPath)
    restore.backupSanity(name)
end

restore.getMainValue = function(value)
    if MAIN[value] ~= nil then
        return MAIN[value]
    end
end

restore.generatePlayerFilePath = function(name)
    return DATABASE_PLAYER_FILES .. "/" .. name
end

restore.generateBackupFilePath = function(name)
    return DATABASE_BACKUP_PATH .. "/" .. name .. "_" .. os.epoch() -- timestamps files by milliseconds since world creation
end

restore.checkIfPlayerDatabaseExists = function(name)
    local filepath = restore.generatePlayerFilePath(name)
    if fs.exists(filepath) then
        return true
    else
        return false
    end
    
end

restore.backupSanity = function(name)
    local filepathToCheck = DATABASE_BACKUP_PATH .. "/" .. name .. "_*"
    local files = fs.find(filepathToCheck)

    local numbers = {}
    for i=1, #files do
        local num = nil
        for val in string.gmatch(files[i], "([^_]+)") do
            num = tonumber(val)
        end

        numbers[i] = num
    end

    local number = #files
    table.sort(numbers)
    while number >= 4 do
        local fullPath = DATABASE_BACKUP_PATH .. "/" .. name .. "_" .. numbers[1]
        table.remove(numbers, 1)
        fs.delete(fullPath)
        number = number - 1
    end
end

return restore