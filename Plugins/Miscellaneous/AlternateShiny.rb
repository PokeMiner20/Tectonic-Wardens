def shiftSpeciesBitmapHue(baseBitmap, species)
    species_data = GameData::Species.get(species)
    firstSpecies = species_data
    while GameData::Species.get(firstSpecies.get_previous_species()) != firstSpecies do
        firstSpecies = GameData::Species.get(firstSpecies.get_previous_species())
    end
    hueShift = hue_shift_from_id(firstSpecies.id_number)
    echoln("Shifting bitmap hue by #{hueShift}")
    ret = baseBitmap.copy
    baseBitmap.dispose
    ret.each { |bitmap| bitmap.hue_change(hueShift) }
    return ret
end

def hue_shift_from_id(id)
    shift = ((((id << 16) ^ 1000000000063) >> 8) ^ 6597069766657) >> 8
    if id % 2 == 0
        shift = 30 + shift % 60
    else
        shift = 330 - shift % 60
    end
    return shift
end

class PokemonSprite < SpriteWrapper
    def setSpeciesBitmapHueShifted(species, gender = 0, form = 0, shiny = false, shadow = false, back = false, egg = false)
        @_iconbitmap.dispose if @_iconbitmap
        @_iconbitmap = GameData::Species.sprite_bitmap(species, form, gender, shiny, shadow, back, egg)
        @_iconbitmap = shiftSpeciesBitmapHue(@_iconbitmap,species)
        self.bitmap = (@_iconbitmap) ? @_iconbitmap.bitmap : nil
        changeOrigin
    end
end