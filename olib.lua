local olib = {}
local chars = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","z","x","c","v","b","n","m","Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M","1","2","3","4","5","6","7","8","9","0"}
local http = require('coro-http')

function olib.randomString(length)
	local string = ""
	for i=1, length do
		string = string..chars[math.random(#chars)] 
	end
	return string
end

function olib.stripDiscordID(id)
	local str = tostring(id) 
	str = str:gsub('[%p%c%s]','')
	return str
end

local string_sub = string.sub
local string_find = string.find
local string_len = string.len
function olib.Explode(separator, str, withpattern)
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

function olib.formatMoney(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end

function olib.HTTPFetch(url, onSuccess, onFailure, headers)
	if not url then return false end
	headers = headers or {}

	coroutine.wrap(function()
		local res, body = http.request("GET", url, headers)

		if res and body and onSuccess then
			onSuccess(body, string.len(body), headers)
		end
		if not body and onFailure then
			onFailure(res)
		end
	end)()
end


function olib.HTTPPost(url, onSuccess, onFailure, headers)
	if not url then return false end
	headers = headers or {}

	coroutine.wrap(function()
		local res, body = http.request("POST", url, headers)

		if res and body and onSuccess then
			onSuccess(body, string.len(body), headers)
		end
		if not body and onFailure then
			onFailure(res)
		end
	end)()
end


function olib.GetKeys( tab )

	local keys = {}
	local id = 1

	for k, v in pairs( tab ) do
		keys[ id ] = k
		id = id + 1
	end

	return keys

end

function olib.PrintTable(t, indent, done)
	done = done or {}
	indent = indent or 0
	local keys = olib.GetKeys( t )

	table.sort( keys, function( a, b )
		if ( type( a ) == "number" and type( b ) == "number" ) then return a < b end
		return tostring( a ) < tostring( b )
	end )

	done[ t ] = true

	for i = 1, #keys do
		local key = keys[ i ]
		local value = t[ key ]
		io.write( string.rep( "\t", indent ) )
		if  ( type( value ) == "table" and not done[ value ] ) then
			done[ value ] = true
			io.write( tostring( key ) .. ":" .. "\n" )
			olib.PrintTable( value, indent + 2, done )
			done[ value ] = nil
		else
			io.write( tostring( key ) .. "\t=\t" )
			io.write( tostring( value ) .. "\n" )
		end
	end
end


function olib.CloneVar(var)
	return var
end

-- yoink: https://github.com/Facepunch/garrysmod/blob/master/garrysmod/lua/includes/extensions/table.lua#L140
function olib.SortByKey( t, desc )

	local temp = {}

	for key, _ in pairs( t ) do table.insert( temp, key ) end
	if ( desc ) then
		table.sort( temp, function( a, b ) return t[ a ] < t[ b ] end )
	else
		table.sort( temp, function( a, b ) return t[ a ] > t[ b ] end )
	end

	return temp

end



return olib