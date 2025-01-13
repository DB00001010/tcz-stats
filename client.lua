local QBCore = exports['qb-core']:GetCoreObject()

function GetReputationDetails(repType, repValue)
    -- Find the category that contains this repType
    local repConfig = nil
    for _, category in pairs(Config.ReputationCategories) do
        if category.types[repType] then
            repConfig = category.types[repType]
            break
        end
    end

    -- If the repType isn't found in the config, return an error
    if not repConfig then
        print('Error: Reputation type ' .. repType .. ' not found in config.')
        return
    end

    -- Initialize the level, next threshold, and progress
    local level = 0
    local nextThreshold = 0
    local progress = 0

    -- Loop through the levels and find the player's level based on their reputation points
    for i, levelData in ipairs(repConfig.levels) do
        -- If the player has reputation points greater than or equal to the current threshold
        if repValue >= levelData.threshold then
            level = i
            -- Set the next threshold, or keep it the same if it's the highest level
            nextThreshold = repConfig.levels[i + 1] and repConfig.levels[i + 1].threshold or levelData.threshold
        else
            break
        end
    end

    -- Calculate progress only if there's a next threshold, else it's 100% for the last level
    if nextThreshold > 0 then
        progress = (repValue / nextThreshold) * 100
    else
        progress = 100  -- If no next threshold, the progress is 100%
    end

    -- Return the details for this reputation type
    return {
        level = level,  -- Player's current level
        levelName = repConfig.levels[level] and repConfig.levels[level].name or "Unknown",  -- Level name
        nextThreshold = nextThreshold,  -- Next threshold for leveling up (0 if no higher level)
        progress = progress  -- Calculate progress as a percentage
    }
end


-- Helper function to format money (e.g., $1,000,000)
local function formatMoney(amount)
    if amount then
        -- Convert amount to string
        local formatted = tostring(amount)

        -- Add commas to the formatted string
        local reversed = string.reverse(formatted)
        local withCommas = string.gsub(reversed, "(%d%d%d)", "%1,")
        local finalFormatted = string.reverse(withCommas):gsub("^,", "")  -- Reverse back and remove the leading comma if present

        -- Return formatted money with dollar sign
        return finalFormatted
    else
        return "0"  -- Return "$0" if no amount is provided
    end
end


-- Helper function to capitalize the first letter of a name
local function capitalizeFirstLetter(name)
    if name and name ~= "" then
        return name:sub(1, 1):upper() .. name:sub(2):lower()  -- Capitalize first letter, lowercase the rest
    else
        return "N/A"
    end
end

-- Function to display Player Info Menu
local function showPlayerInfoMenu()
    local playerStats = QBCore.Functions.GetPlayerData()  -- Fetch player data

    -- Prepare menu options
    local menuOptions = {}

    -- Option for Character Data and Citizen ID
    table.insert(menuOptions, {
        title = (capitalizeFirstLetter(playerStats.charinfo.firstname or "N/A") .. " " .. capitalizeFirstLetter(playerStats.charinfo.lastname or "N/A")) .. "\n" .. (playerStats.citizenid or "N/A"),
        description = "Birthdate: " .. (playerStats.charinfo.birthdate or "N/A") .. " | " .. "Gender: " .. (playerStats.charinfo.gender == 0 and "Male" or "Female"),  -- Birthdate and Gender on new line
        icon = "fas fa-id-badge",
        readOnly = true,
    })


    -- Option for Job and Job Grade
    table.insert(menuOptions, {
        title = "Job: " .. (playerStats.job.label or "N/A"),  -- Display job label or "N/A"
        description = "Grade: " .. (playerStats.job.grade.name or "N/A"),  -- Display job grade or "N/A"
        icon = "fas fa-briefcase",
        readOnly = true,
    })

    -- Option for Bank Balance
    table.insert(menuOptions, {
        title = "Bank Balance",
        description = "$ " .. formatMoney(playerStats.money.bank),  -- Display formatted bank balance
        icon = "money-check",
        readOnly = true,
    })

    -- Option for Cash
    table.insert(menuOptions, {
        title = "Cash",
        description = "$ " .. formatMoney(playerStats.money.cash),  -- Display formatted cash amount
        icon = "fas fa-wallet",
        readOnly = true,
    })

    -- Option for Crypto
    table.insert(menuOptions, {
        title = "Crypto",
        description = formatMoney(playerStats.money.crypto) .. " " .. Config.CyptoName,  -- Display formatted crypto balance
        icon = "fa-brands fa-bitcoin",  -- You can replace this with any crypto-related icon
        readOnly = true,
    })

    -- Register the Player Info menu with updated options
    lib.registerContext({
        id = 'player_info_menu',
        title = 'Player Info',  -- Menu title
        menu = 'player_stats_menu',
        options = menuOptions  -- Populate the menu options dynamically
    })

    -- Show the Player Info menu
    lib.showContext('player_info_menu')
end

-- Function to show the reputation types for a specific category
local function showReputationTypesForCategory(category, categoryData)
    local player = QBCore.Functions.GetPlayerData()  -- Get the player data

    if not player then
        print('Error: Player data not found.')
        return
    end

    local menuOptions = {}
    for repType, repData in pairs(categoryData.types) do
        -- Get the reputation value for the specified type
        local repValue = player.metadata.rep[repType] or 0  -- Default to 0 if no reputation
        if repValue > 0 then  -- Only show reputations with values greater than 0
            local repDetails = GetReputationDetails(repType, repValue)

            -- Construct description with progress details
            local description = string.format(
                "%s\nProgress: %d%%",
                string.format("Reputation Points: %d/%d", repValue, repDetails.nextThreshold),
                math.floor(repDetails.progress)
            )

            -- Add menu item for each reputation type
            table.insert(menuOptions, {
                title = string.format('%s: Level %d (%s)', repData.displayName, repDetails.level, repDetails.levelName),
                description = description,
                progress = math.floor(repDetails.progress),  -- Progress bar (0-100)
                colorScheme = Config.Menu.progressBarColor,  -- Progress bar color
                icon = repData.icon,  -- Icon for the reputation
                readOnly = true,
                --disabled = true  -- Disable the button to make it non-clickable
            })
        end
    end

    -- Register and show the reputation types menu for the selected category
    if #menuOptions > 0 then
        lib.registerContext({
            id = 'reputation_types_menu',
            title = categoryData.displayName,
            options = menuOptions,
            menu = 'reputation_category_menu'
        })

        lib.showContext('reputation_types_menu')
    else
        TriggerClientEvent('QBCore:Notify', player.source, 'No reputation found for this category.', 'error')
    end
end


local function showReputationsMenu()
    local player = QBCore.Functions.GetPlayerData()  -- Fetch player data
    local reputation = player.metadata.rep  -- Get reputation data

    -- Debug: Check if Config.ReputationCategories exists and is properly structured
    if not Config.ReputationCategories then
        print('Error: Config.ReputationCategories is missing or not defined.')
        return
    end

    -- Check if reputation data exists, show a message if not
    if not reputation or next(reputation) == nil then
        local menuOptions = {
            {
                title = "No Reputation Data",
                description = "You haven't done anything in the city yet. Please do some activities to earn reputation!",
                icon = "fas fa-exclamation-circle",
                readOnly = true,
                --disabled = true,  -- Disable the button to make it non-interactive
            }
        }

        -- Register and show the "No Reputation" message
        lib.registerContext({
            id = 'reputation_menu',
            title = "Reputation Status",
            menu = "player_stats_menu",
            options = menuOptions,
        })

        lib.showContext('reputation_menu')
        return  -- Exit the function early to prevent further processing
    end

    -- Prepare the categories menu options
    local categoryMenuOptions = {}
    for category, categoryData in pairs(Config.ReputationCategories) do
        -- Debug: Check if the category and types are properly defined
        if not categoryData or not categoryData.types then
            print('Error: Missing types for category ' .. category)
            return
        end

        -- Check if the player has any reputation in this category
        local hasReputation = false
        for repType, repData in pairs(categoryData.types) do
            if reputation[repType] and reputation[repType] > 0 then
                hasReputation = true
                break
            end
        end

        -- If the player has reputation in this category, add it to the menu
        if hasReputation then
            table.insert(categoryMenuOptions, {
                title = categoryData.displayName,
                description = "View " .. categoryData.displayName,
                icon = categoryData.icon,
                arrow = true,
                onSelect = function()
                    -- Show the reputation types for the selected category
                    showReputationTypesForCategory(category, categoryData)
                end
            })
        end
    end

    -- Register and show the categories menu
    if #categoryMenuOptions > 0 then
        lib.registerContext({
            id = 'reputation_category_menu',
            title = "Reputation Categories",
            menu = "player_stats_menu",
            options = categoryMenuOptions,
        })

        lib.showContext('reputation_category_menu')
    else
        TriggerClientEvent('QBCore:Notify', player.source, 'You have no reputation in any category.', 'error')
    end
end

-- Function to show Player Stats Menu
local function showPlayerStatsMenu()
    -- Prepare menu options
    local menuOptions = {}

    -- Option to view Player Info
    table.insert(menuOptions, {
        title = "Player Info",
        description = "View your information.",
        icon = "fas fa-id-card",
        arrow = true,
        onSelect = showPlayerInfoMenu  -- Trigger the Player Info menu
    })

    -- Option to view Reputations
    table.insert(menuOptions, {
        title = "Reputations & Stats",
        description = "View your reputation stats.",
        icon = "fas fa-chart-simple",
        arrow = true,
        onSelect = showReputationsMenu  -- Trigger the Reputations menu
    })

    -- Register the Player Stats menu with ox_lib
    lib.registerContext({
        id = "player_stats_menu",
        title = "Player Stats",  -- Menu title
        options = menuOptions  -- Populate the menu options dynamically
    })

    -- Show the Player Stats menu
    lib.showContext('player_stats_menu')
end


local function addPlayerStatsRadialOption()
    if Config.RadialMenu.enable then
        exports['qb-radialmenu']:AddOption({
            id = "player_stats_button",
            icon = Config.RadialMenu.icon,
            title  = Config.RadialMenu.label,
            type = 'client',
            event = 'tcz-stats:openPlayerStatsMenu',  -- Event to trigger the Player Stats menu
            shouldClose = true,  -- Close the radial menu after selecting
        })
    end
end

-- -- When player data is loaded, add the radial menu button
-- AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
--     addPlayerStatsRadialOption()
-- end)

-- AddEventHandler('QBCore:Client:OnPlayerUnload', function()
--     exports['qb-radialmenu']:RemoveOption('player_stats_button')
-- end)

-- When the resource starts or restarts, add the radial menu button
AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        addPlayerStatsRadialOption()
    end
end)

-- Event to open the Player Stats menu
RegisterNetEvent('tcz-stats:openPlayerStatsMenu')
AddEventHandler('tcz-stats:openPlayerStatsMenu', function()
    showPlayerStatsMenu()  -- This function will display the Player Stats menu
end)