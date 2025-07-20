local module = {}

local BUILDING_CONFIG = {
    ["Cursor"] = {
        ["BaseProduction"]  = 0.1, -- How many Cookies Per Second this Building produces at Base, no Upgrades. So, 1 cursor = 1x base Prod, 5 = 5x.
        ["BaseCost"] = 15,        -- Signifies the Base Cost, that is then increased by the Scaling.
        ["CostScaling"] = 1.15,      -- Signifies how much this building must scale in price.
        ["Upgrades"] = {
            ["Platinum Cursors"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Cursors",
                    ["Count"] = 1
                },
                ["Cost"] = 100,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
            ["Larger Cursors"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Cursors",
                    ["Count"] = 5
                },
                ["Cost"] = 500,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Recursive Cursors"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Cursors",
                    ["Count"] = 10
                },
                ["Cost"] = 10000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Cursor Cream"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Cursors",
                    ["Count"] = 25
                },
                ["Cost"] = 100000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Fidget Cursors"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Cursors",
                    ["Count"] = 50
                },
                ["Cost"] = 10000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            
        },        -- Valid upgrades for this building.
        ["CookiesToUnlock"] = 1,  -- How many cookies a user must currently have for this building to appear in the building list.

    },

    ["Player"] = {
        ["BaseProduction"] = 1,
        ["BaseCost"] = 100,
        ["CostScaling"] = 1.15,
        ["Upgrades"] = {
            ["Crafting Manual"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Player",
                    ["Count"] = 1
                },
                ["Cost"] = 1000,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
            ["Chests"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Player",
                    ["Count"] = 5
                },
                ["Cost"] = 5000,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
            ["QOL Mods"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Player",
                    ["Count"] = 25
                },
                ["Cost"] = 50000,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
            ["Pyramid Scheme"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Player",
                    ["Count"] = 50
                },
                ["Cost"] = 5000000,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
            ["Steak"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Player",
                    ["Count"] = 100
                },
                ["Cost"] = 500000000,
                ["Effect"] = { -- effect definition
                    ["Type"] = "Multiplier", -- hello everybody
                    ["Power"] = 2
                }
            },
        },
        ["CookiesToUnlock"] = 20
    },

    ["Farm"] = {
        ["BaseProduction"] = 8,
        ["BaseCost"] = 1100,
        ["CostScaling"] = 1.15,
        ["Upgrades"] = {
            ["Fence"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Farm",
                    ["Count"] = 1
                },
                ["Cost"] = 11000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Skeleton Farm"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Farm",
                    ["Count"] = 5
                },
                ["Cost"] = 55000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Advanced Farming Strategies"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Farm",
                    ["Count"] = 25
                },
                ["Cost"] = 550000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Redstone Farming"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Farm",
                    ["Count"] = 50
                },
                ["Cost"] = 55000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Water"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Farm",
                    ["Count"] = 100
                },
                ["Cost"] = 55000000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
        },
        ["CookiesToUnlock"] = 550
    },

    ["Village"] = {
        ["BaseProduction"] = 47,
        ["BaseCost"] = 12000,
        ["CostScaling"] = 1.15,
        ["Upgrades"] = {
            ["Translators"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Village",
                    ["Count"] = 1
                },
                ["Cost"] = 120000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Another Fence"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Village",
                    ["Count"] = 5
                },
                ["Cost"] = 600000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Hero of The Village"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Village",
                    ["Count"] = 25
                },
                ["Cost"] = 6000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Remodeling"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Village",
                    ["Count"] = 50
                },
                ["Cost"] = 600000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Excessive Bread"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Village",
                    ["Count"] = 100
                },
                ["Cost"] = 60000000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
        },
        ["CookiesToUnlock"] = 7000
    },

    ["Crafter"] = {
        ["BaseProduction"] = 260,
        ["BaseCost"] = 130000,
        ["CostScaling"] = 1.15,
        ["Upgrades"] = {
            ["Automatic Crafting"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Crafter",
                    ["Count"] = 1
                },
                ["Cost"] = 1300000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Artificial Unintelligence"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Crafter",
                    ["Count"] = 5
                },
                ["Cost"] = 6500000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Workforce Re-Education"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Crafter",
                    ["Count"] = 25
                },
                ["Cost"] = 65000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Globalisation"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Crafter",
                    ["Count"] = 50
                },
                ["Cost"] = 6500000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
            ["Compact Setups"] = {
                ["Requirement"] = {
                    ["Type"] = "Building",
                    ["Data"] = "Crafter",
                    ["Count"] = 100
                },
                ["Cost"] = 650000000000,
                ["Effect"] = {
                    ["Type"] = "Multiplier",
                    ["Power"] = 2
                }
            },
        },
        ["CookiesToUnlock"] = 80000
    }
}

-- Used for sending buildings to clients, this is what is DISPLAYED.
local buildings = {
    ["0"] = {
        ["Name"] = "Cursor",
        ["Image"] = "images/imagecursor.bimg",
        ["BaseCost"] = 15,
        ["BaseCPS"] = 0.1,
        ["Desc1"] = "A cursor to click more cookies.",
        ["Desc2"] = ""
    },
    ["1"] = {
        ["Name"] = "Player",
        ["Image"] = "images/imageplayer.bimg",
        ["BaseCost"] = 100,
        ["BaseCPS"] = 1,
        ["Desc1"] = "A player to craft some cookies.",
        ["Desc2"] = ""
    },
    ["2"] = {
        ["Name"] = "Farm",
        ["Image"] = "images/imagefarm.bimg",
        ["BaseCost"] = 1100,
        ["BaseCPS"] = 8,
        ["Desc1"] = "A farm to make more ingredients.",
        ["Desc2"] = "...to make more cookies."
    },
    ["3"] = {
        ["Name"] = "Village",
        ["Image"] = "images/imagevillage.bimg",
        ["BaseCost"] = 12000,
        ["BaseCPS"] = 47,
        ["Desc1"] = "A village to trade with for cookies.",
        ["Desc2"] = ""
    },
    ["4"] = {
        ["Name"] = "Crafter",
        ["Image"] = "images/imagecrafter.bimg",
        ["BaseCost"] = 130000,
        ["BaseCPS"] = 260,
        ["Desc1"] = "A crafter to craft more cookies.",
        ["Desc2"] = "May or may not take Player jobs."
    }
}

local upgrades = {
    ["Cursor"] = {
        ["Platinum Cursors"] = {
            ["Image"] = "images/imagecursor.bimg",
            ["Func1"] = "Doubles Cursor CpS.",
            ["Func2"] = "Also makes you really cool.",
            ["Desc1"] = "Plates your cursors in platinum.",
            ["Desc2"] = "...they're too heavy now.",
        },
        ["Larger Cursors"] = {
            ["Image"] = "images/imagecursor.bimg",
            ["Func1"] = "Doubles Cursor CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Makes your cursors bigger,",
            ["Desc2"] = "for more click per click.",
        },
        ["Recursive Cursors"] = {
            ["Image"] = "images/imagecursor.bimg",
            ["Func1"] = "Doubles Cursor CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Fills each cursor with cursors.",
            ["Desc2"] = "This helps somehow.",
        },
        ["Cursor Cream"] = {
            ["Image"] = "images/imagecursor.bimg",
            ["Func1"] = "Doubles Cursor CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Prevents carpal tunnel.",
            ["Desc2"] = "",
        },
        ["Fidget Cursors"] = {
            ["Image"] = "images/imagecursor.bimg",
            ["Func1"] = "Doubles Cursor CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Gives cursors fidget toys to",
            ["Desc2"] = "stop them getting bored.",
        }
    },
    ["Player"] = {
        ["Crafting Manual"] = {
            ["Image"] = "images/imageplayer.bimg",
            ["Func1"] = "Doubles Player CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Stops players from repeatedly",
            ["Desc2"] = "crafting Bread."
        },
        ["Chests"] = {
            ["Image"] = "images/imageplayer.bimg",
            ["Func1"] = "Doubles Player CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Revolutionary technology to",
            ["Desc2"] = "reduce restocking time."
        },
        ["QOL Mods"] = {
            ["Image"] = "images/imageplayer.bimg",
            ["Func1"] = "Doubles Player CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Players install mods",
            ["Desc2"] = "made to craft Cookies."
        },
        ["Pyramid Scheme"] = {
            ["Image"] = "images/imageplayer.bimg",
            ["Func1"] = "Doubles Player CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Look, it's hard to keep",
            ["Desc2"] = "finding these guys."
        },
        ["Steak"] = {
            ["Image"] = "images/imageplayer.bimg",
            ["Func1"] = "Doubles Player CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Saves product from",
            ["Desc2"] = "being consumed."
        },
    },
    ["Farm"] = {
        ["Fence"] = {
            ["Image"] = "images/imagefarm.bimg",
            ["Func1"] = "Doubles Farm CpS.",
            ["Func2"] = "",
            ["Desc1"] = "You keep trampling crops.",
            ["Desc2"] = "Keeps you out."
        },
        ["Skeleton Farm"] = {
            ["Image"] = "images/imagefarm.bimg",
            ["Func1"] = "Doubles Farm CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Not for Bone Meal, it's",
            ["Desc2"] = "so the Farm has friends."
        },
        ["Advanced Farming Strategies"] = {
            ["Image"] = "images/imagefarm.bimg",
            ["Func1"] = "Doubles Farm CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Includes techniques such",
            ["Desc2"] = "as harvesting the crops."
        },
        ["Redstone Farming"] = {
            ["Image"] = "images/imagefarm.bimg",
            ["Func1"] = "Doubles Farm CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Redstone works as",
            ["Desc2"] = "fertiliser??"
        },
        ["Water"] = {
            ["Image"] = "images/imagefarm.bimg",
            ["Func1"] = "Doubles Farm CpS.",
            ["Func2"] = "",
            ["Desc1"] = "A freak accident led",
            ["Desc2"] = "to this new technology."
        },
    },
    ["Village"] = {
        ["Translators"] = {
            ["Image"] = "images/imagevillage.bimg",
            ["Func1"] = "Doubles Village CpS.",
            ["Func2"] = "",
            ["Desc1"] = "They're not good at it.",
            ["Desc2"] = ""
        },
        ["Another Fence"] = {
            ["Image"] = "images/imagevillage.bimg",
            ["Func1"] = "Doubles Village CpS.",
            ["Func2"] = "",
            ["Desc1"] = "A very jumpable fence.",
            ["Desc2"] = "100% effectiveness."
        },
        ["Hero of The Village"] = {
            ["Image"] = "images/imagevillage.bimg",
            ["Func1"] = "Doubles Village CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Sourced non-heroically.",
            ["Desc2"] = ""
        },
        ["Remodelling"] = {
            ["Image"] = "images/imagevillage.bimg",
            ["Func1"] = "Doubles Village CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Relocates village to a",
            ["Desc2"] = "luxury(?) high-rise."
        },
        ["Excessive Bread"] = {
            ["Image"] = "images/imagevillage.bimg",
            ["Func1"] = "Doubles Village CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Finally, a use for all",
            ["Desc2"] = "the Bread the Players make!"
        },
    },
    ["Crafter"] = {
        ["Automatic Crafting"] = {
            ["Image"] = "images/imagecrafter.bimg",
            ["Func1"] = "Doubles Crafter CpS.",
            ["Func2"] = "",
            ["Desc1"] = "For some reason, they're",
            ["Desc2"] = "currently Button operated."
        },
        ["Artificial Unintelligence"] = {
            ["Image"] = "images/imagecrafter.bimg",
            ["Func1"] = "Doubles Crafter CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Uninstalls self-aware AI.",
            ["Desc2"] = ""
        },
        ["Workforce Re-Education"] = {
            ["Image"] = "images/imagecrafter.bimg",
            ["Func1"] = "Doubles Crafter CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Stops Players from setting",
            ["Desc2"] = "Crafters to make Bread."
        },
        ["Globalisation"] = {
            ["Image"] = "images/imagecrafter.bimg",
            ["Func1"] = "Doubles Crafter CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Spreads out Crafters",
            ["Desc2"] = "to prevent lag."
        },
        ["Compact Setups"] = {
            ["Image"] = "images/imagecrafter.bimg",
            ["Func1"] = "Doubles Crafter CpS.",
            ["Func2"] = "",
            ["Desc1"] = "Use 1-block hoppers instead",
            ["Desc2"] = "of 20 block water streams."
        },
    }
}

-- ["Requirement"] = 
-- {
-- ["Type"] = "Upgrade" / "Building"
-- ["Data"] = "Platinum Cursors" / "Cursors"
-- ["Amount"] = nil / 10
--}

local SELL_PERCENTAGE = 0.5 -- 50% sellback, so 50% of a building will be refunded in cookies.

--local MAX_CLICKS_PER_MINUTE = 600 -- Maximum clicks per minute before we cap it, to prevent extreme cases of botting.

--local TEMPLATE = {
    --["Cookies"] = 0,
    --["Upgrades"] = {},
    --["Buildings"] = {
       --["Cursor"] = 0
    --},
    --["Stats"] = {
        --["LifetimeCookies"] = 0,
        --["AccountCreated"] = 0
    --}
--}

local tableSortByCost = function(upgrade1, upgrade2)
    return upgrade1["Cost"] < upgrade2["Cost"]
end

module.getBuildingClientData = function()
    return buildings
end

module.getPossibleClientUpgrades = function(data)
    local upgradesToShow = {}
    local clientOwned = {}
    for building, ownedUpgrades in pairs(data["Upgrades"]) do
        if ownedUpgrades then
            for i, upgrade in ipairs(ownedUpgrades) do
                clientOwned[upgrade] = true
            end
        end
    end

    for buildingName, stats in pairs(BUILDING_CONFIG) do
        if stats["Upgrades"] then
            for upgradeName, upgradeInfo in pairs(stats["Upgrades"]) do
                if not clientOwned[upgradeName] then
                    -- not owned
                    -- check if requirement met
                    if module.getUpgradeEligibility(data, buildingName, upgradeName, upgradeInfo) then
                        -- eligible for upgrade
                        table.insert(upgradesToShow, {buildingName, upgradeName, upgradeInfo})
                    end
                    -- not eligible for upgrade
                end
            end
        end
    end

    return upgradesToShow
end

module.getUpgradeClientData = function(data)
    local upgradesToShow = module.getPossibleClientUpgrades(data)

    -- (win, index, upgradeImage, upgradeName, upgradeCost, func1, func2, desc1, desc2)
    local upgradeDataToSend = {}

    for i, upgradeData in ipairs(upgradesToShow) do
        local upgradeMeta = upgrades[upgradeData[1]][upgradeData[2]]
        local info = upgradeData[3]
        table.insert(upgradeDataToSend, {
            ["Name"] = upgradeData[2],
            ["Image"] = upgradeMeta["Image"],
            ["Cost"] = info["Cost"],
            ["Func1"] = upgradeMeta["Func1"],
            ["Func2"] = upgradeMeta["Func2"],
            ["Desc1"] = upgradeMeta["Desc1"],
            ["Desc2"] = upgradeMeta["Desc2"]
        })
    end

    table.sort(upgradeDataToSend, tableSortByCost)

    -- need to make each element have a string so it works over Serialisation

    local sendingUpgrades = {}

    for i, data in ipairs(upgradeDataToSend) do
        sendingUpgrades[tostring(i - 1)] = data
    end

    return sendingUpgrades
end

module.getCookiesPerSecond = function(data)
    local cookiesToAdd = 0
    local buildings = data["Buildings"]
    for name, building in pairs(buildings) do
        local prod = BUILDING_CONFIG[name]["BaseProduction"]
        cookiesToAdd = cookiesToAdd + module.calculateCookiesFromBuilding(prod, building, module.calculateUpgradeMultiplier(name, data))
    end

    return cookiesToAdd
end

module.getBuildingCost = function(data, buildingName, countOverride)
    local configuration = BUILDING_CONFIG[buildingName]
    if configuration then
        local count
        if countOverride then
            count = countOverride
        else
            if data["Buildings"][buildingName] then
                count = data["Buildings"][buildingName]
            else
                count = 0
            end
        end
        return module.costFunction(configuration["BaseCost"], count, 0, configuration["CostScaling"])
    end
end

module.costFunction = function(baseCost, amountOfBuildings, buildingOffset, scale)
    if scale == nil then
        scale = 1.15 -- default cost scaling
    end
    return math.ceil(baseCost * (math.pow(scale, (amountOfBuildings - buildingOffset))))
end

module.calculateUpgradeMultiplier = function(buildingName, userData)
    local baseMultiplier = 1
    local ownedUpgrades = {}

    local buildConfig = BUILDING_CONFIG[buildingName]

    if userData["Upgrades"][buildingName] ~= nil then
        for i, upgrade in ipairs(userData["Upgrades"][buildingName]) do
            ownedUpgrades[upgrade] = true
        end
    end

    for name, upgradeStats in pairs(buildConfig["Upgrades"]) do
        if ownedUpgrades[name] then
            local upgradeEffect = upgradeStats["Effect"]
            if upgradeEffect["Type"] == "Multiplier" then
                baseMultiplier = baseMultiplier * upgradeEffect["Power"]
            end
        end
    end

    return baseMultiplier
end

module.calculateCookiesFromBuilding = function(baseProduction, amountOfBuildings, upgradeMultiplier)
    -- upgrades don't exist at the moment, it's just base production * amount of building
    return (baseProduction * upgradeMultiplier) * amountOfBuildings
end

module.server_calculateCookiesFromBuilding = function(buildingName, data)
    local prod = BUILDING_CONFIG[buildingName]["BaseProduction"]
    local multi = module.calculateUpgradeMultiplier(buildingName, data)
    return module.calculateCookiesFromBuilding(prod, 1, multi)
end

module.purchaseBuilding = function(data, buildingName)
    local cost = module.getBuildingCost(data, buildingName)

    if cost and data["Cookies"] >= cost then
        if data["Buildings"][buildingName] == nil then
            data["Buildings"][buildingName] = 0
        end
        data["Buildings"][buildingName] = data["Buildings"][buildingName] + 1
        data["Cookies"] = data["Cookies"] - cost
    end

    return data
end

module.getUpgrade = function(buildingName, upgradeName)
    if BUILDING_CONFIG[buildingName] ~= nil then
        if BUILDING_CONFIG[buildingName]["Upgrades"][upgradeName] ~= nil then
            return BUILDING_CONFIG[buildingName]["Upgrades"][upgradeName]
        end
    end

    return nil
end

module.getUpgradeEligibility = function(data, buildingName, upgradeName, upgradeToBuy)
    local requirement = upgradeToBuy["Requirement"]
    local ownedUpgrades = {}
    local userUpgrades = data["Upgrades"]
    for building, upgrades in pairs(userUpgrades) do
        for _, upgrade in ipairs(upgrades) do
            if upgrade == upgradeName then
                return false
            end
            table.insert(ownedUpgrades, upgrade)
        end
    end

    if requirement then
        if requirement["Type"] == "Upgrade" then
            local requiredUpgrade = requirement["Data"]
            for _, upgrade in ipairs(ownedUpgrades) do
                if upgrade == requiredUpgrade then
                    return true
                end
            end
        elseif requirement["Type"] == "Building" then
            local requiredBuilding = requirement["Data"]
            local requiredAmount = requirement["Count"]

            if data["Buildings"][requiredBuilding] then
                local ownedBuildings = data["Buildings"][requiredBuilding]
                if ownedBuildings >= requiredAmount then
                    return true
                else
                    return false
                end
            end
        end
    else
        return true
    end
    return false
end

module.purchaseUpgrade = function(data, buildingName, upgradeName)
    local upgrade = module.getUpgrade(buildingName, upgradeName)

    if upgrade == nil then
        return data
    end

    local cost = upgrade["Cost"]

    local canPurchase = module.getUpgradeEligibility(data, buildingName, upgradeName, upgrade)

    if canPurchase then
        if cost and data["Cookies"] >= cost then
            --data["Buildings"][buildingName] = data["Buildings"][buildingName] + 1
            if data["Upgrades"][buildingName] == nil then
                data["Upgrades"][buildingName] = {}
            end

            table.insert(data["Upgrades"][buildingName], upgradeName)

            data["Cookies"] = data["Cookies"] - cost
        end
    end

    return data
end

module.server_purchaseUpgrade = function(data, upgradeName)
    for buildingName, buildingData in pairs(BUILDING_CONFIG) do
        for uName, _ in pairs(buildingData["Upgrades"]) do
            if uName == upgradeName then
                return module.purchaseUpgrade(data, buildingName, upgradeName)
            end
        end
    end
    return data
end

module.sellBuilding = function(data, buildingName)
    local currentCount = data["Buildings"][buildingName]

    if currentCount then
        local valueToRefund = module.getBuildingCost(data, buildingName, currentCount - 1) -- -1 will be the cost of the current owned building
        local multipliedValue = valueToRefund * SELL_PERCENTAGE -- return a lower percentage of the sell value for this building

        -- give cookies and decrement building
        data["Buildings"][buildingName] = data["Buildings"][buildingName] - 1
        data["Cookies"] = data["Cookies"] + multipliedValue

    end

    return data
end

module.gainCookiesPerSecond = function(data, secondsElapsed)
    local cookiesToGive = module.getCookiesPerSecond(data)

    local multipliedCookies = cookiesToGive * secondsElapsed

    data["Cookies"] = data["Cookies"] + multipliedCookies

    return data, cookiesToGive
end

module.cookieClick = function(data, clicks, timeElapsed)
    local maxClicksForTime = MAX_CLICKS_PER_MINUTE * (timeElapsed / 60)

    if clicks > maxClicksForTime then
        clicks = maxClicksForTime
    end

    data["Cookies"] = data["Cookies"] + clicks

    return data
end

return module