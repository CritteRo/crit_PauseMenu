fx_version 'cerulean'
game 'gta5'
author 'CritteR / CritteRo'
mastodon 'crittero@mastodon.social'
website 'https://critte.ro'
cfx_forum 'https://forum.cfx.re/u/critter/summary'

description 'NUI PauseMenu replacement, inspired by the original '
version '1.0.0'

lua54 'yes'

ui_page('public/client/html/index.html')

server_scripts {
    'public/server/**/*.lua',
}

client_scripts {
    'public/client/**/*.lua',
}

shared_scripts {
    'config.lua',
    'public/shared/sh_locales.lua',
}

files {
    'public/client/html/index.html',
    'public/client/html/style.css',
    'public/client/html/script.js',
    'public/client/html/img/*.webp',
}

exports {
    'IsPauseMenuOpen'
}

escrow_ignore {
    'fxmanifest.lua',
    'config.lua',
    'public/**/*.lua'
}