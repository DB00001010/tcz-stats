fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'TCZ'
description '[tcz-stats]Player Stats and Info Menu'
version '1.0.0'

-- Shared metadata
shared_scripts {
    '@ox_lib/init.lua', -- Dependency for shared library functions
    'config.lua',
}

-- Client-side scripts
client_scripts {
    'client.lua',
}

-- Required dependencies
dependencies {
    'qb-core',
    'qb-radialmenu',
    'ox_lib',
}
