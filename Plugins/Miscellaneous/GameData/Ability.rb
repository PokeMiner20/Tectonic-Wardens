module GameData
    class Ability
        SUN_ABILITIES = %i[DROUGHT INNERLIGHT CHLOROPHYLL SOLARPOWER LEAFGUARD FLOWERGIFT MIDNIGHTSUN
                        HARVEST SUNCHASER HEATSAVOR BLINDINGLIGHT SOLARCELL SUSTAINABLE FINESUGAR REFRESHMENTS
                        HEATVEIL OXYGENATION DESOLATELAND
        ]

        RAIN_ABILITIES = %i[DRIZZLE STORMBRINGER SWIFTSWIM RAINDISH HYDRATION TIDALFORCE STORMFRONT
                          DREARYCLOUDS DRYSKIN RAINPRISM STRIKETWICE AQUAPROPULSION OVERWHELM ARCCONDUCTOR
                          PRIMORDIALSEA
        ]

        SAND_ABILITIES = %i[SANDSTREAM SANDBURST SANDRUSH SANDSHROUD DESERTSPIRIT SANDDRILLING SANDDEMON
                          IRONSTORM SANDSTRENGTH SANDPOWER CRAGTERROR DESERTSCAVENGER
        ]

        HAIL_ABILITIES = %i[SNOWWARNING FROSTSCATTER ICEBODY SNOWSHROUD BLIZZBOXER SLUSHRUSH ICEFACE
                          BITTERCOLD ECTOPARTICLES ICEQUEEN ETERNALWINTER TAIGATRECKER ICEMIRROR WINTERINSULATION
                          POLARHUNTER WINTERWISDOM
        ]

        ECLIPSE_ABILITIES = %i[HARBINGER SUNEATER APPREHENSIVE TOTALGRASP EXTREMOPHILE WORLDQUAKE RESONANCE
                            DISTRESSING SHAKYCODE MYTHICSCALES SHATTERING STARSALIGN WARPINGEFFECT TOLLDANGER
                            DRAMATICLIGHTING CALAMITY ANARCHIC MENDINGTONES PEARLSEEKER HEAVENSCROWN
        ]

        MOONGLOW_ABILITIES = %i[MOONGAZE LUNARLOYALTY LUNATIC MYSTICTAP ASTRALBODY NIGHTLIGHT NIGHTLIFE
                              MALICIOUSGLOW NIGHTVISION MOONLIGHTER LUNARCLEANSING NIGHTSTALKER WEREWOLF
                              FULLMOONBLADE MOONBUBBLE MIDNIGHTTOIL MOONBASKING NIGHTOWL
        ]

        GENERAL_WEATHER_ABILITIES = %i[STOUT TERRITORIAL NESTING]

        MULTI_ITEM_ABILITIES = %i[BERRYBUNCH HERBALIST FASHIONABLE ALLTHATGLITTERS STICKYFINGERS KLUMSYKINESIS]

        FLINCH_IMMUNITY_ABILITIES = %i[INNERFOCUS JUGGERNAUT MENTALBLOCK]

        UNCOPYABLE_ABILITIES = %i[TRACE RECEIVER POWEROFALCHEMY OVERACTING]

        HAZARD_IMMUNITY_ABILITIES = %i[AQUASNEAK NINJUTSU DANGERSENSE HYPERSPEED]

        attr_reader :signature_of, :cut, :primeval

        def initialize(hash)
          @id               = hash[:id]
          @id_number        = hash[:id_number]   || -1
          @real_name        = hash[:name]        || "Unnamed"
          @real_description = hash[:description] || "???"
          @cut              = hash[:cut]         || false
          @primeval         = hash[:primeval]    || false
        end

        # The highest evolution of a line
        def signature_of=(val)
          @signature_of = val
        end

        def is_signature?()
          return !@signature_of.nil?
        end

        def legal?(isBoss = false)
          return false if @cut
          return false if @primeval && !isBoss
          return true
        end
    end
  end