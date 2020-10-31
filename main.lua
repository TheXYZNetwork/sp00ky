  GNU nano 5.2                                                                                                      main.lua
local discordia = require('discordia')
local client = discordia.Client()
local olib = require("./olib.lua")
local config = require("./config.lua")
local timer = require("timer")


client:on('ready', function()
        print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
        -- Check if not a DM
        if not message.guild then return end

        -- Actually from the bot
        if not (message.author.id == "755580145078632508") then return end

        -- The config has given a guild restriction
        if not ((not config.limitToGuild) or (config.limitToGuild == "")) then
                if not (message.guild.id == config.limitToGuild) then return end
        end

        -- Check if it has an embed
        if not message.embed then return end

        -- Check if it's a trick or treater
        if not (message.embed.title == "A trick-or-treater has stopped by!") then return end

        -- Run the correct response
        local breakDown = olib.Explode(" ", message.embed.description, false)
        local command = breakDown[#breakDown]

        print("Running the following command:", command, "In channel:", message.channel.name, "At guild:", message.guild.name)

        timer.setTimeout(500, function() -- If we do it too soon the bot won't be able to keep up.
                coroutine.wrap(function()
                        message.channel:send(command)
                end)()
        end)
end)

client:run(config.key)
