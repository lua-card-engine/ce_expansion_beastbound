return {

	--[[
		Expansion Sets
	--]]

	["expansion_set_ce_expansion_beastbound"] = "Beastbound",

	--[[
		Deck Rules
	--]]

	["ce_expansion_beastbound_deck_rule_energy_unlimited"] = "Energy cards can be included any number of times",
	["ce_expansion_beastbound_deck_rule_legendary_limit"] = "Legendary cards can be included only once",
	["ce_expansion_beastbound_deck_rule_needs_basic_beast"] = "At least one Basic Beast",

	--[[
		The game
	--]]

	["ce_expansion_beastbound_game_name"] = "Beastbound",
	["ce_expansion_beastbound_ai_name"] = "Beastbound Trainer",
	["ce_expansion_beastbound_deck_starter"] = "Starter Deck",

	--[[
		Special Conditions
	--]]

	["ce_expansion_beastbound_condition_paralyzed"] = "Paralyzed",
	["ce_expansion_beastbound_condition_confused"] = "Confused",
	["ce_expansion_beastbound_condition_asleep"] = "Asleep",
	["ce_expansion_beastbound_condition_poisoned"] = "Poisoned",
	["ce_expansion_beastbound_condition_burned"] = "Burned",

	--[[
		Coin flips
	--]]

	["ce_expansion_beastbound_flip_confusion"] = "Confusion: tails and the attack fails",
	["ce_expansion_beastbound_flip_burn_recovery"] = "Burn: heads and it wears off",
	["ce_expansion_beastbound_flip_sleep_recovery"] = "Sleep: heads and it wakes up",
	["ce_expansion_beastbound_flip_burn"] = "Heads and the Defending Beast is Burned",
	["ce_expansion_beastbound_flip_confuse"] = "Heads and the Defending Beast is Confused",
	["ce_expansion_beastbound_flip_paralyze"] = "Heads and the Defending Beast is Paralyzed",
	["ce_expansion_beastbound_flip_poison"] = "Heads and the Defending Beast is Poisoned",
	["ce_expansion_beastbound_flip_attack_works"] = "Tails and the attack does nothing",
	["ce_expansion_beastbound_flip_bonus_damage"] = "Heads for extra damage",

	--[[
		Questions a card asks
	--]]

	["ce_expansion_beastbound_prompt_choose_active"] = "Choose your Active Beast.",
	["ce_expansion_beastbound_prompt_choose_bench"] = "Choose any Basic Beasts to put on your Bench.",
	["ce_expansion_beastbound_prompt_promote"] = "Choose a Beast to take the Active spot.",
	["ce_expansion_beastbound_prompt_choose_own_beast"] = "Choose one of your Beasts.",
	["ce_expansion_beastbound_prompt_choose_opponent_bench"] = "Choose one of your opponent's Benched Beasts.",
	["ce_expansion_beastbound_prompt_discard_energy"] = "Choose Energy to discard.",
	["ce_expansion_beastbound_prompt_discard_retreat_energy"] = "Discard Energy to pay the Retreat Cost.",
	["ce_expansion_beastbound_prompt_discard_from_hand"] = "Choose a card to discard from your hand.",
	["ce_expansion_beastbound_prompt_search_deck"] = "Choose a card from your deck.",
	["ce_expansion_beastbound_prompt_order_bottom"] = "Put these on the bottom of your deck, in any order.",
	["ce_expansion_beastbound_prompt_discard_for_damage"] = "Discard Energy to make this attack stronger?",
	["ce_expansion_beastbound_prompt_tome_of_fate"] = "Choose a card to put into your hand.",
	["ce_expansion_beastbound_prompt_corrupt_luxpaws"] = "Choose a Luxpaws to corrupt into Umbramaw.",

	--[[
		Zones, and what is said about a Beast when it is inspected
	--]]

	["ce_expansion_beastbound_zone_deck"] = "Deck",
	["ce_expansion_beastbound_zone_hand"] = "Hand",
	["ce_expansion_beastbound_zone_discard"] = "Discard pile",
	["ce_expansion_beastbound_zone_prizes"] = "Prize cards",
	["ce_expansion_beastbound_zone_active"] = "Active spot",
	["ce_expansion_beastbound_zone_bench"] = "Bench",

	["ce_expansion_beastbound_inspect_hp"] = "Health",
	["ce_expansion_beastbound_inspect_hp_value"] = "{remaining} of {max} left",
	["ce_expansion_beastbound_inspect_conditions"] = "Special Conditions",
	["ce_expansion_beastbound_inspect_retreat"] = "Retreat Cost right now",
	["ce_expansion_beastbound_inspect_retreat_value"] = "{cost} Energy",
	["ce_expansion_beastbound_inspect_retreat_changed"] = "{cost} Energy (printed: {printed})",

	--[[
		Lasting effects
	--]]

	["ce_expansion_beastbound_effect_damage_reduction"] = "Takes less damage",
	["ce_expansion_beastbound_effect_damage_bonus"] = "Attacks do more damage",
	["ce_expansion_beastbound_effect_retreat_increase"] = "Costs more to retreat",
	["ce_expansion_beastbound_effect_retreat_free"] = "Retreats for free",
	["ce_expansion_beastbound_effect_cannot_attack"] = "Can't attack",
	["ce_expansion_beastbound_effect_ward_basic"] = "Warded against Basic Beasts",

	--[[
		Why an action was refused
	--]]

	["ce_expansion_beastbound_already_attached_energy"] = "You've already attached Energy this turn.",
	["ce_expansion_beastbound_no_energy_in_hand"] = "You have no Energy card in hand.",
	["ce_expansion_beastbound_no_item_in_hand"] = "You have no Item card in hand.",
	["ce_expansion_beastbound_no_supporter_in_hand"] = "You have no Supporter card in hand.",
	["ce_expansion_beastbound_no_basic_in_hand"] = "You have no Basic Beast in hand.",
	["ce_expansion_beastbound_nothing_to_evolve"] = "Nothing in your hand evolves a Beast you have in play.",
	["ce_expansion_beastbound_nothing_to_retreat_to"] = "You have no Benched Beast to bring out.",
	["ce_expansion_beastbound_action_retreat"] = "Swap In",
	["ce_expansion_beastbound_attack_button"] = "{name}  {damage}",
	["ce_expansion_beastbound_attack_button_no_damage"] = "{name}",
	["ce_expansion_beastbound_already_played_supporter"] = "You've already played a Supporter this turn.",
	["ce_expansion_beastbound_already_retreated"] = "You've already retreated this turn.",
	["ce_expansion_beastbound_already_evolved"] = "That Beast has already evolved this turn.",
	["ce_expansion_beastbound_played_this_turn"] = "A Beast can't evolve the turn it was played.",
	["ce_expansion_beastbound_card_not_in_hand"] = "That card isn't in your hand.",
	["ce_expansion_beastbound_not_energy"] = "That isn't an Energy card.",
	["ce_expansion_beastbound_not_item"] = "That isn't an Item card.",
	["ce_expansion_beastbound_not_supporter"] = "That isn't a Supporter card.",
	["ce_expansion_beastbound_not_beast"] = "That isn't a Beast card.",
	["ce_expansion_beastbound_not_basic_beast"] = "Only a Basic Beast can be put into play.",
	["ce_expansion_beastbound_does_not_evolve"] = "That card doesn't evolve from anything.",
	["ce_expansion_beastbound_wrong_evolution"] = "That card doesn't evolve from that Beast.",
	["ce_expansion_beastbound_hidden_evolution"] = "That Beast can only be put into play by another card.",
	["ce_expansion_beastbound_no_such_beast"] = "That Beast isn't in play.",
	["ce_expansion_beastbound_no_active_beast"] = "You have no Active Beast.",
	["ce_expansion_beastbound_no_defending_beast"] = "Your opponent has no Active Beast to attack.",
	["ce_expansion_beastbound_no_such_attack"] = "That Beast doesn't have that attack.",
	["ce_expansion_beastbound_not_enough_energy"] = "That Beast doesn't have the Energy for that attack.",
	["ce_expansion_beastbound_not_enough_energy_to_retreat"] = "That Beast doesn't have the Energy to retreat.",
	["ce_expansion_beastbound_cannot_attack_now"] = "That Beast can't attack right now.",
	["ce_expansion_beastbound_bench_full"] = "Your Bench is full.",

	--[[
		The match log
	--]]

	["ce_expansion_beastbound_log_attached_energy"] = "{player} attached {card} to {target}.",
	["ce_expansion_beastbound_log_played_card"] = "{player} played {card}.",
	["ce_expansion_beastbound_log_benched"] = "{player} put {card} on their Bench.",
	["ce_expansion_beastbound_log_evolved"] = "{player} evolved into {card}.",
	["ce_expansion_beastbound_log_retreated"] = "{player} retreated, bringing out {card}.",
	["ce_expansion_beastbound_log_attacked"] = "{player}'s {card} used {attack}.",
	["ce_expansion_beastbound_log_damage"] = "{target} took {amount} damage.",
	["ce_expansion_beastbound_log_damage_weak"] = "{target} took {amount} damage. Weakness!",
	["ce_expansion_beastbound_log_damage_resisted"] = "{target} took {amount} damage. Resisted.",
	["ce_expansion_beastbound_log_healed"] = "{target} healed {amount} damage.",
	["ce_expansion_beastbound_log_knocked_out"] = "{target} was Knocked Out.",
	["ce_expansion_beastbound_log_prize_taken"] = "{player} took a Prize card. {remaining} left.",
	["ce_expansion_beastbound_log_condition_applied"] = "{target} is now {condition}.",
	["ce_expansion_beastbound_log_condition_cured"] = "{target} is no longer {condition}.",
	["ce_expansion_beastbound_log_promoted"] = "{target} moved into the Active spot.",
	["ce_expansion_beastbound_log_mulligan"] = "{player} had no Basic Beast and redrew.",
	["ce_expansion_beastbound_log_a_card"] = "a card",
	["ce_expansion_beastbound_weak_marker"] = "(weak)",
	["ce_expansion_beastbound_resisted_marker"] = "(resisted)",

	--[[
		How a match ends
	--]]

	["ce_expansion_beastbound_win_prizes"] = "all six Prize cards taken",
	["ce_expansion_beastbound_win_no_beasts"] = "no Beasts left in play",
	["ce_expansion_beastbound_win_decked_out"] = "no cards left to draw",

	--[[
        Boosters
    --]]

	["ce_expansion_beastbound_booster_voltaris"] = "Beastbound Booster Pack (Voltaris)",
	["ce_expansion_beastbound_booster_luxpaws"] = "Beastbound Booster Pack (Luxpaws)",
	["ce_expansion_beastbound_booster_umbramaw"] = "Beastbound Booster Pack (Umbramaw)",
	["ce_expansion_beastbound_booster_description"] =
	"A booster pack containing random cards from the Beastbound expansion.",

	--[[
		Cards
	--]]

	-- Beasts
	["ce_expansion_beastbound_starkrat"] = "Starkrat",
	["ce_expansion_beastbound_starkrat_description"] =
	"Starkrat, the electric-type beast, is a bouncy little rodent whose fur crackles with static whenever it gets excited.",

	["ce_expansion_beastbound_thunderat"] = "Thunderat",
	["ce_expansion_beastbound_thunderat_description"] =
	"Thunderat, the electric-type beast, stores lightning in its bolt-shaped tail and lets it loose through crackling claws and snapping jaws.",

	["ce_expansion_beastbound_voltking"] = "Voltking",
	["ce_expansion_beastbound_voltking_description"] =
	"Voltking, the electric-type beast, harnesses the power of lightning to strike down its foes with unparalleled speed and precision.",

	["ce_expansion_beastbound_voltkey"] = "Voltkey",
	["ce_expansion_beastbound_voltkey_description"] =
	"Voltkey, the electric-type beast, is a cheerful baby monkey whose curly tail sparks every time it giggles.",

	["ce_expansion_beastbound_sparkian"] = "Sparkian",
	["ce_expansion_beastbound_sparkian_description"] =
	"Sparkian, the electric-type beast, is a scrappy monkey that swings from branch to branch on arcs of lightning.",

	["ce_expansion_beastbound_stormilla"] = "Stormilla",
	["ce_expansion_beastbound_stormilla_description"] =
	"Stormilla, the electric-type beast, is a hulking gorilla that pounds its lightning gauntlets together to call down thunderstorms.",

	["ce_expansion_beastbound_voltbob"] = "Voltbob",
	["ce_expansion_beastbound_voltbob_description"] =
	"Voltbob, the electric-type beast, is a bouncy blob of glossy slime that pops with tiny bolts of lightning as it wobbles along.",

	["ce_expansion_beastbound_maelsludge"] = "Maelsludge",
	["ce_expansion_beastbound_maelsludge_description"] =
	"Maelsludge, the electric-type beast, is a hulking storm-charged sludge that shocks everything caught in its slimy grasp.",

	["ce_expansion_beastbound_grubler"] = "Grubler",
	["ce_expansion_beastbound_grubler_description"] =
	"Grubler, the fighting-type beast, is a feisty little caterpillar that already wears its boxing gloves to every scrap.",

	["ce_expansion_beastbound_carapacer"] = "Carapacer",
	["ce_expansion_beastbound_carapacer_description"] =
	"Carapacer, the fighting-type beast, is a muscular bug brawler that trains its wrapped fists against anything that stands still.",

	["ce_expansion_beastbound_hornfist"] = "Hornfist",
	["ce_expansion_beastbound_hornfist_description"] =
	"Hornfist, the fighting-type beast, is an armored beetle champion that charges horn-first and finishes fights with spiked fists.",

	["ce_expansion_beastbound_pebblemite"] = "Pebblemite",
	["ce_expansion_beastbound_pebblemite_description"] =
	"Pebblemite, the fighting-type beast, is a shy little grub in a shell of pebbles that curls up whenever trouble comes near.",

	["ce_expansion_beastbound_boulderblade"] = "Boulderblade",
	["ce_expansion_beastbound_boulderblade_description"] =
	"Boulderblade, the fighting-type beast, is a rocky mantis whose stone scythes can slice through boulders as if they were fruit.",

	["ce_expansion_beastbound_kragcrush"] = "Kragcrush",
	["ce_expansion_beastbound_kragcrush_description"] =
	"Kragcrush, the fighting-type beast, is a towering rock mantis that shatters cliffs with its jagged scythe arms.",

	["ce_expansion_beastbound_pyrecko"] = "Pyrecko",
	["ce_expansion_beastbound_pyrecko_description"] =
	"Pyrecko, the fire-type beast, is a friendly baby gecko with a flame on its head that flares up when it is happy.",

	["ce_expansion_beastbound_emberaz"] = "Emberaz",
	["ce_expansion_beastbound_emberaz_description"] =
	"Emberaz, the fire-type beast, is a determined lizard whose blazing mane and tail light up the volcanic slopes it patrols.",

	["ce_expansion_beastbound_infernecko"] = "Infernecko",
	["ce_expansion_beastbound_infernecko_description"] =
	"Infernecko, the fire-type beast, is a majestic dragon-lizard that sweeps across the sky on enormous wings of living flame.",

	["ce_expansion_beastbound_emberling"] = "Emberling",
	["ce_expansion_beastbound_emberling_description"] =
	"Emberling, the fire-type beast, is a lively phoenix chick that trails sparks wherever it flutters.",

	["ce_expansion_beastbound_pyrenax"] = "Pyrenax",
	["ce_expansion_beastbound_pyrenax_description"] =
	"Pyrenax, the fire-type beast, is a proud young phoenix that streams a long ribbon of flame behind its tail.",

	["ce_expansion_beastbound_solarion"] = "Solarion",
	["ce_expansion_beastbound_solarion_description"] =
	"Solarion, the fire-type beast, is a grand phoenix whose burning cry lights the sky like a second sun.",

	["ce_expansion_beastbound_emberock"] = "Emberock",
	["ce_expansion_beastbound_emberock_description"] =
	"Emberock, the fire-type beast, is a sturdy little golem with a molten core that glows brighter with every punch it throws.",

	["ce_expansion_beastbound_magmacrag"] = "Magmacrag",
	["ce_expansion_beastbound_magmacrag_description"] =
	"Magmacrag, the fire-type beast, is a horned rock golem cracked with rivers of lava that erupts whenever it loses its temper.",

	["ce_expansion_beastbound_phixy"] = "Phixy",
	["ce_expansion_beastbound_phixy_description"] =
	"Phixy, the psychic-type beast, is a calm fennec fox in tiny robes that meditates over a swirling orb of dark energy.",

	["ce_expansion_beastbound_phyxo"] = "Phyxo",
	["ce_expansion_beastbound_phyxo_description"] =
	"Phyxo, the psychic-type beast, is a wise fox sage in golden robes whose crystal staff clouds the minds of its foes.",

	["ce_expansion_beastbound_phoxerer"] = "Phoxerer",
	["ce_expansion_beastbound_phoxerer_description"] =
	"Phoxerer, the psychic-type beast, is a regal elder fox sorcerer that shatters the will of its enemies with glowing magic circles.",

	["ce_expansion_beastbound_spooklet"] = "Spooklet",
	["ce_expansion_beastbound_spooklet_description"] =
	"Spooklet, the psychic-type beast, is a round little ghost that only wants a friend, even if it startles everyone it meets.",

	["ce_expansion_beastbound_hauntergeist"] = "Hauntergeist",
	["ce_expansion_beastbound_hauntergeist_description"] =
	"Hauntergeist, the psychic-type beast, is a mischievous imp-ghost that drifts through the dark with its green lantern, whispering bad dreams.",

	["ce_expansion_beastbound_wraithlord"] = "Wraithlord",
	["ce_expansion_beastbound_wraithlord_description"] =
	"Wraithlord, the psychic-type beast, is a hooded spectral knight that drains the spirit of anything it locks eyes with.",

	["ce_expansion_beastbound_genito"] = "Genito",
	["ce_expansion_beastbound_genito_description"] =
	"Genito, the psychic-type beast, is a smug little genie who is still learning that a wish always has a price.",

	["ce_expansion_beastbound_genitron"] = "Genitron",
	["ce_expansion_beastbound_genitron_description"] =
	"Genitron, the psychic-type beast, is a mighty djinn that lets its wishes run wild and shrugs off every blow from lesser foes.",

	["ce_expansion_beastbound_tadpool"] = "Tadpool",
	["ce_expansion_beastbound_tadpool_description"] =
	"Tadpool, the water-type beast, is a cheerful spotted frog that still has its tadpole tail and loves to lounge on lily pads.",

	["ce_expansion_beastbound_aquariog"] = "Aquariog",
	["ce_expansion_beastbound_aquariog_description"] =
	"Aquariog, the water-type beast, is a calm frog adventurer that summons swirling whirlpools with its droplet-tipped staff.",

	["ce_expansion_beastbound_krakentoa"] = "Krakentoa",
	["ce_expansion_beastbound_krakentoa_description"] =
	"Krakentoa, the water-type beast, is an imposing frog sea-lord that leads the tides with its coral crown and trident.",

	["ce_expansion_beastbound_sealpup"] = "Sealpup",
	["ce_expansion_beastbound_sealpup_description"] =
	"Sealpup, the water-type beast, is a chubby seal pup that slaps the waves with its flippers just to hear the splash.",

	["ce_expansion_beastbound_aquaskate"] = "Aquaskate",
	["ce_expansion_beastbound_aquaskate_description"] =
	"Aquaskate, the water-type beast, is a sleek seal that glides across the waves on fins of ice, always smirking.",

	["ce_expansion_beastbound_ocearus"] = "Ocearus",
	["ce_expansion_beastbound_ocearus_description"] =
	"Ocearus, the water-type beast, is a frost-maned sea lion in crystal armor that calls up crashing tidal waves.",

	["ce_expansion_beastbound_starieye"] = "Starieye",
	["ce_expansion_beastbound_starieye_description"] =
	"Starieye, the water-type beast, is a goofy starfish that stares at everything with its big googly eyes.",

	["ce_expansion_beastbound_stargazer"] = "Stargazer",
	["ce_expansion_beastbound_stargazer_description"] =
	"Stargazer, the water-type beast, is a sturdy star warrior that wields a coral mace and pulls foes in with a gaze of cosmic gravity.",

	["ce_expansion_beastbound_teristar"] = "Teristar",
	["ce_expansion_beastbound_teristar_description"] =
	"Teristar, the water-type beast, is a mighty armored sea-titan that hurls its foes with the crushing force of a falling star.",

	["ce_expansion_beastbound_turtling"] = "Turtling",
	["ce_expansion_beastbound_turtling_description"] =
	"Turtling, the nature-type beast, is a cheerful little turtle that naps in the sunlight beneath the forest vines.",

	["ce_expansion_beastbound_turterus"] = "Turterus",
	["ce_expansion_beastbound_turterus_description"] =
	"Turterus, the nature-type beast, is a grumpy tortoise whose crystal-studded shell shrugs off nearly everything.",

	["ce_expansion_beastbound_turtitan"] = "Turtitan",
	["ce_expansion_beastbound_turtitan_description"] =
	"Turtitan, the nature-type beast, is an ancient dragon-headed tortoise whose crystal shell is as tough as a mountain.",

	["ce_expansion_beastbound_chrysaloid"] = "Chrysaloid",
	["ce_expansion_beastbound_chrysaloid_description"] =
	"Chrysaloid, the nature-type beast, is a mysterious chrysalis that hangs from its silk thread, waiting patiently for something to happen.",

	["ce_expansion_beastbound_apiscout"] = "Apiscout",
	["ce_expansion_beastbound_apiscout_description"] =
	"Apiscout, the nature-type beast, is a fuzzy, friendly bee that scouts the meadow with its honey dipper in hand.",

	["ce_expansion_beastbound_vespalord"] = "Vespalord",
	["ce_expansion_beastbound_vespalord_description"] =
	"Vespalord, the nature-type beast, is a regal bee-king that commands its swarm from a honeycomb throne with a venomous sting.",

	["ce_expansion_beastbound_vineling"] = "Vineling",
	["ce_expansion_beastbound_vineling_description"] =
	"Vineling, the nature-type beast, is a shy little sprout of twisting vines that soaks up every ray of sunshine.",

	["ce_expansion_beastbound_lianalker"] = "Lianalker",
	["ce_expansion_beastbound_lianalker_description"] =
	"Lianalker, the nature-type beast, is a wild walking tangle of vines and blossoms that snares anyone who crosses its path.",

	["ce_expansion_beastbound_foresthing"] = "Foresthing",
	["ce_expansion_beastbound_foresthing_description"] =
	"Foresthing, the nature-type beast, is an ancient guardian of the forest, its mossy body blooming with flowers and thorny roots.",

	-- Supporters
	["ce_expansion_beastbound_jack"] = "Jack, the Stonecaller",
	["ce_expansion_beastbound_jack_description"] =
	"Search your deck for a Fighting Energy card and attach it to 1 of your Beasts. Shuffle your deck afterward.",

	["ce_expansion_beastbound_jane"] = "Jane, the Waverider",
	["ce_expansion_beastbound_jane_description"] =
	"Heal 30 damage from 1 of your Beasts.",

	["ce_expansion_beastbound_shane"] = "Shane, the Overclocker",
	["ce_expansion_beastbound_shane_description"] =
	"Draw 2 cards.",

	-- Items
	["ce_expansion_beastbound_minor_potion"] = "Minor Potion",
	["ce_expansion_beastbound_minor_potion_description"] =
	"Heal 20 damage from 1 of your Beasts.",

	["ce_expansion_beastbound_noxious_draught"] = "Noxious Draught",
	["ce_expansion_beastbound_noxious_draught_description"] =
	"Cure any Special Condition affecting 1 of your Beasts and heal 10 damage from it.",

	["ce_expansion_beastbound_tactic_scroll"] = "Tactic Scroll",
	["ce_expansion_beastbound_tactic_scroll_description"] =
	"Draw 3 cards, then discard 1 card from your hand.",

	["ce_expansion_beastbound_boots_of_flight"] = "Boots of Flight",
	["ce_expansion_beastbound_boots_of_flight_description"] =
	"Attach to 1 of your Beasts. That Beast's Retreat Cost is 0. Discard this card if that Beast is Knocked Out.",

	["ce_expansion_beastbound_lion_gauntlets"] = "Lion Gauntlets",
	["ce_expansion_beastbound_lion_gauntlets_description"] =
	"Attach to 1 of your Beasts. That Beast's attacks do 20 more damage. Discard this card if that Beast is Knocked Out.",

	["ce_expansion_beastbound_runic_sword"] = "Runic Sword",
	["ce_expansion_beastbound_runic_sword_description"] =
	"Attach to 1 of your Beasts. That Beast's attacks do 30 more damage. Discard this card if that Beast is Knocked Out.",

	["ce_expansion_beastbound_tome_of_fate"] = "Tome of Fate",
	["ce_expansion_beastbound_tome_of_fate_description"] =
	"Look at the top 3 cards of your deck. Put 1 into your hand and the rest on the bottom of your deck in any order.",

	-- Energy
	["ce_expansion_beastbound_electric_energy"] = "Electric Energy",
	["ce_expansion_beastbound_electric_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Electric Energy.",

	["ce_expansion_beastbound_fighting_energy"] = "Fighting Energy",
	["ce_expansion_beastbound_fighting_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Fighting Energy.",

	["ce_expansion_beastbound_fire_energy"] = "Fire Energy",
	["ce_expansion_beastbound_fire_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Fire Energy.",

	["ce_expansion_beastbound_psychic_energy"] = "Psychic Energy",
	["ce_expansion_beastbound_psychic_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Psychic Energy.",

	["ce_expansion_beastbound_water_energy"] = "Water Energy",
	["ce_expansion_beastbound_water_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Water Energy.",

	["ce_expansion_beastbound_nature_energy"] = "Nature Energy",
	["ce_expansion_beastbound_nature_energy_description"] =
	"Attach to 1 of your Beasts. Provides 1 Nature Energy.",

	-- Legendaries (hidden rares)
	["ce_expansion_beastbound_voltaris"] = "Voltaris",
	["ce_expansion_beastbound_voltaris_description"] =
	"Voltaris, the electric-type beast, is a legendary thunderbird whose wingbeats split the sky and whose feathers crackle with the fury of a storm.",

	["ce_expansion_beastbound_luxpaws"] = "Luxpaws",
	["ce_expansion_beastbound_luxpaws_description"] =
	"Luxpaws, the psychic-type beast, is a legendary winged cat that drifts on sacred clouds, its golden tails gathering the light of the dawn.",

	["ce_expansion_beastbound_umbramaw"] = "Umbramaw",
	["ce_expansion_beastbound_umbramaw_description"] =
	"Umbramaw, the psychic-type beast, is what remains when Luxpaws is bound by a corrupting crystal: a cracked, shadow-furred cat whose tails drip with ruinous energy.",

	["ce_expansion_beastbound_legendary_corrupter"] = "Legendary Corrupter",
	["ce_expansion_beastbound_legendary_corrupter_description"] =
	"Evolve 1 of your Luxpaws into Umbramaw from your hand or deck. Shuffle your deck afterward.",
}
