
# Player Stats and Reputation Menu [tcz-stats]

This resource provides a **Player Stats and Info Menu** for QBCore, allowing players to view detailed information about their character and reputation. The menu includes **Player Info** (such as Citizen ID, Job, Bank Balance, Cash, and more) and **Reputation Levels** based on different in-game activities. Only works with **QB-Core** and integrates with **qb-radialmenu** for easy access.

## Features
- **Player Info Menu**: Displays essential player information, including:
  - Citizen ID
  - Job and Job Grade
  - Bank Balance, Cash, and Crypto balance
  - Name, Birthdate, and Gender
  
- **Reputation Menu**: Displays player reputation levels for different categories, such as:
  - Criminal Activities (e.g., Dealer)
  - Jobs (e.g., Crafting, Farming)
  - Crafting (e.g., Weapon Crafting, Attachment Crafting)
  
- **Radial Menu Integration**: Access the menu via the radial menu in-game, making it easy to view stats and reputations.

## Installation

1. Download and place the `tcz-stats` folder into your `resources` directory.
2. Add `start tcz-stats` to your `server.cfg`.

## Configuration

You can customize various aspects of the script in the **`config.lua`** file:

- **Crypto Name**: Change the name of the crypto currency shown (default: `TCZ COINS`).
- **Reputation Types**: Add or modify reputation types under different categories (e.g., `criminal`, `jobs`, `crafting`).
- **Menu Customization**: Control the display of reputation points, level names, and the progress bar color.
- **Radial Menu**: Customize the radial menu button that opens the stats menu (can be enabled/disabled).

### Example Config for Reputation Types

```lua
Config.ReputationCategories = {
    -- Criminal category
    ['criminal'] = {
        displayName = 'Crimes Stats',
        icon = 'skull-crossbones',  -- Icon for criminal category
        types = {
            ['dealer'] = {
                displayName = 'Dealer',
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
            -- Add more here
        }
    },
}
```

### Radial Menu Configuration

```lua
Config.RadialMenu = {
    enable = true,
    label = "View Stats",
    icon = "circle-info"
}
```

## Important Notes

### 1. **Predefined Reputation Types in QB-Core**
Only the following reputation types exist by default in **QB-Core**:
- **craftingrep**
- **dealer**
- **attachmentrep**

Other reputation types (like **farmingrep**, **robberyrep**, etc.) must be **manually implemented** by the server administrators. You can add custom types as needed in **`config.lua`** by following the provided example format.

### 2. **Applying New Reputations (Server-side)**
To **apply a new reputation** on the server-side, use the `AddRep` and `RemoveRep` functions in your scripts. This allows you to modify a player's reputation for specific activities.

Example:

```lua
-- Add reputation for a specific type (e.g., dealer)
QBCore.Functions.GetPlayer(source).Functions.AddRep('dealer', 50)

-- Remove reputation for a specific type (e.g., craftingrep)
QBCore.Functions.GetPlayer(source).Functions.RemoveRep('craftingrep', 10)
```

When adding or removing reputation, make sure to specify the **reputation type** (e.g., **dealer**, **craftingrep**) and the **amount** to add or subtract.

### 3. **Checking Player Reputation (Client-side)**
To **check a player's reputation** from the client-side, you can access the **`metadata['rep']`** field. Here’s an example of how to retrieve the player's reputation for a specific type:

```lua
local playerRep = QBCore.Functions.GetPlayerData().metadata['rep']['dealer'] or 0
print("Player's Dealer Reputation: " .. playerRep)
```

This function checks the **`metadata['rep']`** field for the reputation type (e.g., **dealer**) and returns the current reputation value, defaulting to `0` if it’s not set.

### 4. **Using Existing QB-Core Functions**
This script **does not implement a new reputation system** from scratch. It **enhances QB-Core’s existing functionality** by adding a display system to show the reputation data. Specifically, we use the existing **`metadata['rep']`** field and **functions like `AddRep` and `RemoveRep`** that are already part of **QB-Core**. 

Our script does not modify the underlying **QB-Core** reputation management system but extends it by providing a way to display this data through a menu. The core logic for manipulating reputation points (adding or removing) remains unchanged and relies on QB-Core's existing functionality.

## How to Use

Once installed and configured:

- Players can access the **Player Stats Menu** by selecting the **"Player Stats"** option from the radial menu.
- The menu contains two sections:
  - **Player Info**: Shows player information, including Citizen ID, Job, Bank Balance, Cash, and Name.
  - **Reputations**: Displays the player’s reputation levels for different categories (e.g., Criminal, Jobs, Crafting).

## Customization

You can add more reputation categories and types in **`config.lua`** by following the example format:

```lua
Config.ReputationCategories = {
    ['criminal'] = {
        displayName = 'Criminal',
        icon = 'skull-crossbones',
        types = {
            ['dealer'] = {
                displayName = 'Dealer',
                icon = 'cannabis',
                levels = { [1] = { threshold = 0, name = 'Rookie' } }
            },
            ['robbery'] = {
                displayName = 'Robbery',
                icon = 'hand-holding-usd',
                levels = { [1] = { threshold = 0, name = 'Novice' } }
            }
        }
    },
    ['jobs'] = {
        displayName = 'Jobs',
        icon = 'briefcase',
        types = {
            ['craftingrep'] = {
                displayName = 'Crafting',
                icon = 'wrench',
                levels = { [1] = { threshold = 0, name = 'Beginner' } }
            }
        }
    }
}
```

### Add More Reputation Types

To add more **reputation types** to the system, you need to define them under **`Config.ReputationCategories`** in the `config.lua` file. Each **reputation type** will fall under a specific **category** (e.g., **criminal**, **jobs**, **crafting**) and will have its own **levels** (e.g., **Rookie**, **Pro**, **Legend**).

For each **reputation type**, you'll define:
- **`displayName`**: A readable name for the reputation type (e.g., **Dealer**, **Crafting**).
- **`icon`**: An icon for the reputation type, typically used for visual representation (e.g., **cannabis** for dealer).
- **`levels`**: A table where you define each **level**, including its **threshold** and **name**.

#### Example of Adding a New Reputation Type

Let’s add a new reputation type called **"farmingrep"** under the **jobs** category.

```lua
Config.ReputationCategories = {
    -- Jobs category
    ['jobs'] = {
        displayName = 'Jobs',
        icon = 'briefcase',
        types = {
            ['craftingrep'] = {
                displayName = 'Crafting',
                icon = 'wrench',
                levels = {
                    [1] = { threshold = 0, name = 'Beginner' },
                    [2] = { threshold = 50, name = 'Skilled' },
                    [3] = { threshold = 150, name = 'Expert' },
                    [4] = { threshold = 300, name = 'Master' },
                }
            },
            ['farmingrep'] = {
                displayName = 'Farming',
                icon = 'seedling',
                levels = {
                    [1] = { threshold = 0, name = 'Farmer' },
                    [2] = { threshold = 50, name = 'Agriculturist' },
                    [3] = { threshold = 150, name = 'Horticulturist' },
                    [4] = { threshold = 300, name = 'Agronomist' },
                }
            }
        }
    }
}
```

#### Explanation:
- **`farmingrep`** is added under the **jobs** category.
- It has **4 levels**:
  - **Farmer** (Threshold 0)
  - **Agriculturist** (Threshold 50)
  - **Horticulturist** (Threshold 150)
  - **Agronomist** (Threshold 300)

You can now easily add new **reputation types** by following this pattern. Each **type** has its own **levels** with **thresholds** and **names**.

---

## Troubleshooting

1. **No Reputation Data**: If the player has no reputation data, they will see a message like **"You haven't done anything in the city yet. Please do some activities to earn reputation!"**
2. **Error: "Attempt to index a nil value"**: This occurs if the **`Config.ReputationCategories`** is not defined properly. Ensure these are set up as shown in the examples.

## Dependencies

This script requires the following resources:
- **qb-core**: Core framework for QB-based servers.
- **qb-radialmenu**: Radial menu used for accessing the player stats menu.
- **ox_lib**: Library for advanced menu features and UI handling.

---
