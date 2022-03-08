local COLOR = FindMetaTable("Color")

do

    local lerpFunc = environment.saveFunc( "Color Extensions:Lerp", Lerp )
    function LerpColor( frac, a, b )
        a["r"] = lerpFunc( frac, b["r"], a["r"] )
        a["g"] = lerpFunc( frac, b["g"], a["g"] )
        a["b"] = lerpFunc( frac, b["b"], a["b"] )
        a["a"] = lerpFunc( frac, b["a"] or 255, a["a"] or 255 )

        return a
    end

    -- do

    --     local getmetatable = getmetatable
    --     function Lerp( frac, a, b )
    --         if ( getmetatable( a ) == COLOR ) then
    --             return LerpColor( frac, a, b )
    --         end

    --         return lerpFunc
    --     end

    -- end

end

do

    local colorFunc = environment.saveFunc( "Color", Color )
    function Color( hex, g, b, a )

        if ( type( hex ) == "string" ) then
            hex = hex:gsub( "#", "" )
            if ( hex:len() == 3 ) then
                return colorFunc( tonumber("0x" .. hex:sub(1, 1)) * 17, tonumber("0x" .. hex:sub(2, 2)) * 17, tonumber("0x" .. hex:sub(3, 3)) * 17 )
            else
                return colorFunc( tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6)) )
            end
        end

        if (g == nil) and (b == nil) and (a == nil) and (type( hex ) == "number") and (type( pbit ) == "table") and (type(pbit.Vec4FromInt) == "function") then
            return colorFunc( pbit.Vec4FromInt( hex ) )
        end

        return colorFunc( hex or 0, g or 0, b or 0, a or 0 )
    end

end

do

    function COLOR:SetAlpha( alpha )
        self["a"] = alpha
        return self
    end

    function COLOR:Lerp( frac, b )
        return LerpColor( frac, self, b )
    end

end