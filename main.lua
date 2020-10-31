local discordia = require('discordia')
local client = discordia.Client()
local config = require("./config.lua")
local timer = require("timer")

local string_sub = string.sub
local string_find = string.find
local string_len = string.len
local function stringExplose(separator, str, withpattern)
	if ( separator == "" ) then return {str} end
	if ( withpattern == nil ) then withpattern = false end

	local ret = {}
	local current_pos = 1

	for i = 1, string_len( str ) do
		local start_pos, end_pos = string_find( str, separator, current_pos, not withpattern )
		if ( not start_pos ) then break end
		ret[ i ] = string_sub( str, current_pos, start_pos - 1 )
		current_pos = end_pos + 1
	end

	ret[ #ret + 1 ] = string_sub( str, current_pos )

	return ret
end

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
        local breakDown = stringExplose(" ", message.embed.description)
        local command = breakDown[#breakDown]

        print("Running the following command:", command, "In channel:", message.channel.name, "At guild:", message.guild.name)

        timer.setTimeout(500, function() -- If we do it too soon the bot won't be able to keep up.
                coroutine.wrap(function()
                        message.channel:send(command)
                end)()
        end)
end)

client:run(config.key)
