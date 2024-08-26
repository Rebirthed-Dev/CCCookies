local module = {}

local fullDBPath = nil
local mainDBFile = nil
local playerDBFolder = nil
local backupFolder = nil
local mainDB = nil


module.openDatabaseFile = function(filepath)
    local db = fs.open(filepath, "r")
    local dbTable = module.readIntoTable(db)
    db.close()
    return dbTable
end

module.createDatabaseFile = function(filepath, backuppath, template)
    -- make file
    -- set contents to template
    module.saveToFile(filepath, backuppath,  template)
    -- open file
    local createdMainDB = module.openDatabaseFile(filepath)

    -- return database
    return createdMainDB
end

module.readIntoTable = function(file)
    local fileData = file.readAll()
    local table = textutils.unserialise(fileData)
    return table
end

module.saveToFile = function(fileToOpen, backupPath, data)
    -- Save operation that overwrites the file completely because lol lmao
    if fs.exists(fileToOpen) then
        module.cloneDatabaseFile(fileToOpen, backupPath)
    end
    local openFile = fs.open(fileToOpen, "w+")
    local serialisedData = textutils.serialise(data)
    openFile.write(serialisedData)
    openFile.flush()
    openFile.close()
end

module.safeSave = function(openFile, file)
    -- Advanced save operation that only changes data that is "different"

end

module.cloneDatabaseFile = function(filePath, backupPath)
    fs.delete(backupPath)
    fs.copy(filePath, backupPath)
end

module.createEntryInTable = function(database, newEntry, newValue)
    if database[entry] == nil then
        database[entry] = value
    end
end

module.updateEntry = function(database, entry, value)
    if database[entry] ~= nil then
        database[entry] = value
    end
end

module.getEntry = function(database, entry)
    if database[entry] ~= nil then
        return database[entry]
    end
end

module.databaseAutoUpdate = function(database, file)
    module.saveToFile(file, database)
    --module.safeSave(database, file)
end

module.closeDatabaseFile = function(openDB, filepath, backupPath)
    --module.safeSave(openDB, filepath)
    module.saveToFile(filepath, backupPath, openDB)
end

module.init = function(databaseFolder, mainFile, playerFolder, backupFolder, mainTemplate)
    fullDBPath = databaseFolder
    mainDBFile = mainFile
    playerDBFolder = playerFolder
    backupFolder = backupFolder
    if not fs.exists(fullDBPath) then
        fs.makeDir(playerDBFolder)
    end
    if not fs.exists(playerDBFolder) then
        fs.makeDir(playerDBFolder)
    end
    if not fs.exists(backupFolder) then
        fs.makeDir(backupFolder)
    end
    if not fs.exists(mainDBFile) then
        mainDB = module.createDatabaseFile(mainDBFile, backupFolder .. "/" .. "main", mainTemplate)
    else
        mainDB = module.openDatabaseFile(mainDBFile)
    end

    return mainDB
end


return module