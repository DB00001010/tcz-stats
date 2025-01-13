Config = {}

-- Define Reputations configurations
Config.ReputationCategories = {
    -- Criminal category
    ['criminal'] = {
        displayName = 'Criminal Stats',
        icon = 'skull-crossbones',  -- Icon for criminal category
        types = {
            ['dealer'] = {
                displayName = 'Drug Dealing',
                icon = 'cannabis',  -- Icon for dealer reputation
                levels = {
                    [1] = { threshold = 0, name = "Rookie" },
                    [2] = { threshold = 50, name = "Amateur" },
                    [3] = { threshold = 150, name = "Pro" },
                    [4] = { threshold = 300, name = "Legend" },
                }
            },
            ['robbery'] = {
                displayName = 'Robbery',
                icon = 'hand-holding-usd',  -- Icon for robbery reputation
                levels = {
                    [1] = { threshold = 0, name = "Novice" },
                    [2] = { threshold = 100, name = "Expert" },
                    [3] = { threshold = 250, name = "Master" },
                }
            },
            -- Add More Rep Types Here
        }
    },

    -- Jobs category
    ['jobs'] = {
        displayName = 'Jobs Stats',
        icon = 'briefcase',  -- Icon for jobs category
        types = {
            ['trucking'] = {
                displayName = 'Trucking',
                icon = 'truck',  -- Icon for crafting reputation
                levels = {
                    [1] = { threshold = 0, name = "Beginner" },
                    [2] = { threshold = 30, name = "Skilled" },
                    [3] = { threshold = 100, name = "Expert" },
                    [4] = { threshold = 200, name = "Master" },
                }
            },
            ['farming'] = {
                displayName = 'Farming',
                icon = 'seedling',  -- Icon for farming reputation
                levels = {
                    [1] = { threshold = 0, name = "Farmer" },
                    [2] = { threshold = 50, name = "Agriculturist" },
                    [3] = { threshold = 150, name = "Expert" },
                }
            },
            -- Add More Rep Types Here
        }
    },

    -- Crafting category
    ['crafting'] = {
        displayName = 'Crafting Stats',
        icon = 'hammer',  -- Icon for crafting category
        types = {
            ['craftingrep'] = {
                displayName = 'Item Crafting',
                icon = 'wrench',  -- Icon for item crafting reputation
                levels = {
                    [1] = { threshold = 0, name = "Novice" },
                    [2] = { threshold = 50, name = "Artisan" },
                    [3] = { threshold = 150, name = "Master" },
                }
            },
            ['attachmentcraftingrep'] = {
                displayName = 'Attachment Crafting',
                icon = 'tools',  -- Icon for weapon crafting reputation
                levels = {
                    [1] = { threshold = 0, name = "Rookie" },
                    [2] = { threshold = 100, name = "Veteran" },
                    [3] = { threshold = 250, name = "Craftsman" },
                }
            },
            --Add More Rep Types Here
        }
    },

    --- Add More Categories Here
}


-- Menu customization
Config.Menu = {
    progressBarColor = 'blue', -- Color of the progress bar (e.g., blue, red, green)
}

Config.CyptoName = 'QBits' -- Name to display for crypto

Config.RadialMenu = {
    enable = true, -- Enable or disable the radial menu option
    label = "View Stats", -- Label for the radial menu button
    icon = "circle-info", -- Icon for the radial menu button (FontAwesome or similar)
}