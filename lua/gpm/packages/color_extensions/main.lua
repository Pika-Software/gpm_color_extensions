local COLOR = {}
COLOR.__index = COLOR
debug.getregistry().Color = COLOR

local function number( any, deff )
	if ( any == nil ) then
		return deff
	elseif type( any ) != "number" then
		return tonumber( any )
	end

	return any
end

function CreateColor( r, g, b, a )
	return setmetatable( { r = r, g = g, b = b, a = a }, COLOR )
end

do
    local function int255( any )
        return math.min( number( any, 255 ), 255 )
    end

    function Color( r, g, b, a )
        if ( type( r ) == "string" ) and r:match( "#" ) then
            local hex = r:gsub( "#", "" )
            if ( hex:len() == 3 ) then
                r = math.min( number( "0x" .. hex:sub(1, 1), 255 ) * 17, 255 )
                g = math.min( number( "0x" .. hex:sub(2, 2), 255 ) * 17, 255 )
                b = math.min( number( "0x" .. hex:sub(3, 3), 255 ) * 17, 255 )
            else
                local h1, h2, h3 = hex:match("(%w%w)(%w%w)(%w%w)")
                r = tonumber(h1, 16) or 255
                g = tonumber(h2, 16) or 255
                b = tonumber(h3, 16) or 255
            end
        end

        return CreateColor( int255( r ), int255( g ), int255( b ), int255( a ) )
    end
end

do

    local lerpFunc = environment.saveFunc( "Color Extensions:Lerp", Lerp )

    function COLOR:Lerp( frac, b )
        return CreateColor( lerpFunc( frac, self["r"], b["r"] ), lerpFunc( frac, self["g"], b["g"] ), lerpFunc( frac, self["b"], b["b"] ), lerpFunc( frac, self["a"] or 255, b["a"] or 255 ) )
    end

    function LerpColor( frac, a, b )
        return a:Lerp( frac, b )
    end

    do
        local getmetatable = getmetatable
        function Lerp( frac, a, b )
            if ( getmetatable( a ) == COLOR ) then
                return LerpColor( frac, a, b )
            end

            return lerpFunc( frac, a, b )
        end
    end
end

function ColorAlpha( c, a )
	return Color( c.r, c.g, c.b, a )
end

COLOR.SetAlpha = ColorAlpha

function isColor( any )
	return getmetatable( any ) == COLOR
end

function COLOR:__tostring()
	return string.format( "Color(%d, %d, %d, %d)", self.r, self.g, self.b, self.a )
end

function COLOR:__eq( c )
	return self.r == c.r and self.g == c.g and self.b == c.b and self.a == c.a
end

function COLOR:ToHSL()
	return ColorToHSL( self )
end

function COLOR:ToHSV()
	return ColorToHSV( self )
end

function COLOR:ToVector()
	return Vector( self.r / 255, self.g / 255, self.b / 255 )
end

function COLOR:ToTable()
	return { self.r, self.g, self.b, self.a }
end

function COLOR:ToHEX()
	return string.format( "#%02X%02X%02X", self.r, self.g, self.b )
end

function COLOR:Unpack()
	return self.r, self.g, self.b, self.a
end

function COLOR:SetUnpacked( r, g, b, a )
	self.r = r or 255
	self.g = g or 255
	self.b = b or 255
	self.a = a or 255
end