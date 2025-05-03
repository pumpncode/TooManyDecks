deckstext = SMODS.Atlas {
	key = "decks",
	px = 71,
	py = 95,
	path = "decks.png"
}
SMODS.Atlas {
	key = "decks sleeves",
	px = 73,
	py = 95,
	path = "sleeves.png"
}
SMODS.Atlas {
	key = "modicon",
	px = 32,
	py = 32,
	path = "modicon.png"
}

SMODS.Atlas {
	key = "thedeckblind",
	px = 34,
	py = 34,
	atlas_table = 'ANIMATION_ATLAS',
	path = "deckblind.png",
	frames = 21
}

to_number = to_number or function (x) return x end

TMD = {}

-- Credit to cryptid
local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
	local ret = oldfunc(change_context)
	local bbb = "b_SGTMD_argyle"
	if math.random() < 0.1 then
		bbb = "b_SGTMD_prodeck"
	end
	local newcard = Card(
		G.title_top.T.x,
		G.title_top.T.y,
		G.CARD_W,
		G.CARD_H,
		G.P_CARDS.empty,
		G.P_CENTERS[bbb],
		{ bypass_discovery_center = true }
	)
	-- recenter the title
	if not Cryptid then
		G.title_top.T.w = G.title_top.T.w * 1.7675
		G.title_top.T.x = G.title_top.T.x - 0.8
	end

	G.title_top:emplace(newcard)
	-- make the card look the same way as the title screen Ace of Spades
	newcard.T.w = newcard.T.w * 1.1 * 1.2
	newcard.T.h = newcard.T.h * 1.1 * 1.2
	newcard.no_ui = true
	newcard.states.visible = false


	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0,
		blockable = false,
		blocking = false,
		func = function()
			if change_context == "splash" then
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
			else
				newcard.states.visible = true
				newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
			end
			return true
		end,
	}))

	return ret
end


TMD.splashpos = {{x=5,y=0},{x=1,y=0},{x=2,y=0},{x=3,y=0},{x=4,y=0},
							  {x=0,y=1},{x=1,y=1},{x=2,y=1},{x=3,y=1},{x=4,y=1},
							  {x=0,y=2},{x=4,y=2},{x=4,y=3},
							  {x=0,y=3},{x=1,y=3},{x=3,y=3},{x=5,y=3},{x=6,y=3},
							  {x=6,y=2},{x=6,y=1},{ x = 5, y = 2}}



SMODS.Blind {
	key = "deckblind",
	loc_txt = {
		name = "The Deck",
		text = {"You lost to the deck"}
	},
	atlas = "thedeckblind",
	unlocked = false,
	no_collection = true
}


SMODS.Back {
	key = "nane",
	check_for_unlock = function(self, args)
		if args.type == "chip_score" and to_number(args.chips) >= 1.8*10^308 then
			return true
		end
	end,
	unlocked = false,
	atlas = "decks",
	pos = { x = 1, y = 0},
	calculate = function(self, card, context)
    	if context.final_scoring_step then
    		hand_chips = 1.8*10^308
    		mult = 1.8*10^308
    	end
    end
}

SMODS.Back {
	key = "oops",
	config = {only_one_rank = '6', ante_scaling = 1.6},
	atlas = "decks",
	pos = { x = 0, y = 0},
	apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, card in ipairs(G.playing_cards) do
                    assert(SMODS.change_base(card, nil, self.config.only_one_rank))
                end
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
    	if context.final_scoring_step then
    		hand_chips = hand_chips*6
    		mult = math.max(1, mult - (mult % 6))
    		return{
    			chips = 0,
    			mult = 0,
    			message = "Sixed!"
    		}
    	end

    end

}



SMODS.Back {
	key = "argyle",
	atlas = "decks",
	unlocked = false,
	pos = { x = 1, y = 1},
	check_for_unlock = function(self,args)
		if args.type == "win_deck" and G.GAME.selected_back.effect.center.key == "b_black" then
			return true
		end
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, card in ipairs(G.playing_cards) do
					if card:is_suit("Hearts") then
						assert(SMODS.change_base(card, "Diamonds"))
					end
					if card:is_suit("Spades") then
						assert(SMODS.change_base(card, "Clubs"))
					end
				end
				return true
		   	end
		}))
	end
}




SMODS.Back {
	key = "doubleup",
	atlas = "decks",
	pos = { x = 2, y = 0},
	apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
            	local newcards = {}
                for i = 1, #G.playing_cards do
  					local card = G.playing_cards[i]

                    local _card = copy_card(card, nil, nil, G.playing_card)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                    
                end
                return true
            end
        }))
    end
}


SMODS.Back {
	key = "kingdom",
	config = {hand_size = -2, no_interest = true},
	unlocked = false,
	check_for_unlock = function(self, args)
		if args.type == "hand" and #args.full_hand >= 5 then
			local yes = true
			for _,card in ipairs(args.full_hand) do
				if not (card.base.value == "Jack" and card.ability.effect == "Gold Card") then
					yes = false
				end
			end
			return yes
		end
	end,
	atlas = "decks",
	pos = { x = 0, y = 1},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, card in ipairs(G.playing_cards) do
					if not card:is_face(false) then
						assert(SMODS.change_base(card, nil, "Jack" ))
					end
				end
			return true
		end
		}))
    end
}


local og = set_deck_loss
function set_deck_loss()
	local ret = og()
	check_for_unlock({type = "loss"})
	return ret
end

SMODS.Back {
	key = "fuckyou",
	locked_loc_vars = function (self, info_queue, card)
		return { vars = { (G.GAME.probabilities.normal or 1)}}
	end,
	
	unlocked = false,
	check_for_unlock = function (self, args)
		if args.type == "loss" and pseudorandom("fuckyou") < G.GAME.probabilities.normal / 15 then
			return true
		end
		
	end,
	atlas = "decks",
	pos = { x = 0, y = 2},
	
	apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
				SMODS.add_card { key = 'j_popcorn' }
				local ante_UI = G.hand_text_area.ante
				G.GAME.round_resets.ante = 0
				G.GAME.round_resets.ante_disp = number_format(G.GAME.round_resets.ante)
				ante_UI.config.object:update()
				G.HUD:recalculate()
            	local newcards = {}
                for i = 1, #G.playing_cards do
  					local card = G.playing_cards[1]
					G.deck:remove_card(card)
					card:remove()
                    
                end
                card = create_playing_card({front = G.P_CARDS.S_K},G.deck)
                return true
            end
        }))
		
    end,
	calculate = function(self, card, context)

		 if context.final_scoring_step then
			return{
				xmult = 0.5
			}
		 end
		
	end
}

SMODS.DrawStep {
    key = 'float_back',
    order = 60,
    func = function(self)
        if self.children.back_float and (self.config.center.discovered or self.bypass_discovery_center) then
            local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
            local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2


			self.children.back_float:draw_shader('dissolve',0, nil, nil, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
			self.children.back_float:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod, rotate_mod)

            if self.edition then 
                for k, v in pairs(G.P_CENTER_POOLS.Edition) do
                    if v.apply_to_float then
                        if self.edition[v.key:sub(3)] then
                            self.children.back_float:draw_shader(v.shader, nil, nil, nil, self.children.center, scale_mod, rotate_mod)
                        end
                    end
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'back' },
}

local cssref = Card.set_sprites

function  Card:set_sprites(_center,_front)
	local ret = cssref(self,_center,_front)
	if _center and _center.set then 
		if  G.GAME.selected_back and G.GAME.selected_back.effect.center.float_pos or _center.float_pos  then
			if _center.float_pos or _center.set ~= "Back" or (self.back == "viewed_back" and G.GAME.viewed_back.effect.center.float_pos) then
				if self.children.back_float then self.children.back_float:remove() end
				self.children.back_float = Sprite(self.T.x, self.T.y, self.T.w, self.T.h,  G.ASSET_ATLAS[(G.GAME.viewed_back or G.GAME.selected_back) and ((G.GAME.viewed_back or G.GAME.selected_back)[G.SETTINGS.colourblind_option and 'hc_atlas' or 'lc_atlas'] or (G.GAME.viewed_back or G.GAME.selected_back).atlas) or 'centers'],_center.float_pos or G.GAME.selected_back.effect.center.float_pos  )
				
				self.children.back_float:set_role({major = self, role_type = 'Glued', draw_major = self})
				self.children.back_float.role.draw_major = self
				if self.area == G.deck then
					self.children.back_float.role.draw_major = nil
				end
				self.children.back_float.states.visible = false
				self.children.back_float.states.hover.can = false
				self.children.back_float.states.click.can = false
			end
		end
	end
	return ret
end

SMODS.Back {
	key = "prodeck",
	
	check_for_unlock = function(self,args)
		if args.type == "win_deck" and G.GAME.selected_back.effect.center.key == "b_SGTMD_fuckyou" then
			return true
		end
	end,
	unlocked = false,
	config = {hands = 1, discards = 1,hand_size = 2, consumable_slot = -1,no_interest = true,ante_scaling = 1.4, dollars = 10},
	atlas = "decks",
	pos = { x = 0, y = 3},
	--float_pos = {x=3,y=2}
}


SMODS.Back {
	key = "storage",
	
	--unlocked = false,
	check_for_unlock = function (self, args)
		if args.type == "modify_deck" and #G.playing_cards > 1 then
			local first = G.playing_cards[1].ability
			
			local ret = true
			for _,card in ipairs(G.playing_cards) do
				
				if not inspect(card.ability) == inspect(first) then
					
					ret = false
				end
				return false
			end
		end
	end,
	atlas = "decks",
	pos = { x = 3, y = 0},
	calculate = function(self, card, context)
		if context.end_of_round and G.GAME.blind.boss and not context.repetition and not context.individual  then
			G.E_MANAGER:add_event(Event({
				func = function()
					SMODS.add_card { key = 'c_hanged_man', edition = "e_negative" }
					SMODS.add_card { key = 'c_hanged_man', edition = "e_negative" }
					return true
				end
			}))
		end
		if context.remove_playing_cards and not G.GAME.blind.in_blind then
			G.E_MANAGER:add_event(Event({
				func = function()
					local newcards = {}
					for i = 1, #context.removed do
						local card = context.removed[i]
						for x = 1, 2 do
							
							local _card = copy_card(card, nil, nil, G.playing_card)
							_card:add_to_deck()
							G.deck.config.card_limit = G.deck.config.card_limit + 1
							table.insert(G.playing_cards, _card)
							G.deck:emplace(_card)
						end
					end
					
					return true
				end
			}))
		end
	end
}

SMODS.Back {
	key = "shit",
	
	check_for_unlock = function (self,args)
		if os.date("*t").month == 4 and os.date("*t").day == 20 and args.type == "chip_score" and to_number(args.chips) == 69 then
			return true
		end
	end,
	unlocked = false,
	atlas = "decks",
	pos = { x = 2, y = 1},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
            func = function()
                for _,card in ipairs(G.playing_cards) do
                    if card.base.value == "Ace" or card.base.value == "3" then
						assert(SMODS.change_base(card, nil, "2"))
					end
					if card.base.value == "5" or card.base.value == "7" then
						assert(SMODS.change_base(card, nil, "4"))
					end
					if card.base.value == "Jack" or card.base.value == "Queen" then
						assert(SMODS.change_base(card, nil, "6"))
					end
					if card.base.value == "King" or card.base.value == "8" then
						assert(SMODS.change_base(card, nil, "9"))
					end
                    if card.base.value == "10" then
						assert(SMODS.change_base(card, "Hearts", "King"))
					end
                end
                SMODS.add_card { key = 'j_egg' , area = G.consumeables,  stickers = { 'eternal' } }
				SMODS.add_card { key = 'j_obelisk', stickers = { 'eternal' } }
                return true
            end
        }))
	end
}

SMODS.Back {
	key = "buno",
	
	atlas = "decks",
	unlocked = false,
	check_for_unlock = function (self, args)
		if args.type == "hand" and args.handname == "High Card" and #G.hand.cards <= 0  then
			return true
		end
	end,
	pos = { x = 3, y = 1},
	config = {
		extra = {
			temp_handsize = 0
		}
	},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
            func = function()
            	
                for _,card in ipairs(G.playing_cards) do
					assert(SMODS.change_base(card, nil, "SGTMD_B" .. card.base.value))
                end
                return true
            end
        }))
	end,
	calculate = function (self,card,context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.base.value == "SGTMD_BJack" then
				G.GAME.current_round.discards_left = 1 + G.GAME.current_round.discards_left
			elseif context.other_card.base.value == "SGTMD_BQueen" then
				local tempx = mult
				mult = hand_chips
				hand_chips = tempx
				return {
					chips = 0,
					mult = 0
				}
			elseif context.other_card.base.value == "SGTMD_BKing" then
				G.hand:change_size(2)
				card.effect.config.extra.temp_handsize = card.effect.config.extra.temp_handsize + 2
			end
		end
		if context.end_of_round and not context.repetition and not context.individual then
			G.hand:change_size(0-card.effect.config.extra.temp_handsize)
			card.effect.config.extra.temp_handsize = 0
		end
	end
}

assert(SMODS.load_file("items/buno.lua"))()


local flip_ref = Card.update
function Card:update(dt)
	local ret = flip_ref(self,dt)

	if self.ability.SGTMD_PermaFlip and (self.area == G.hand or self.area == G.jokers) and self.flipping ~= "f2b" then
		self.flipping = "f2b"
        self.facing='back'
        self.sprite_facing = 'back'
		self.pinch.x = false
		self.ability.wheel_flipped = true
	end
	return ret
end

local emplace_ref = CardArea.emplace
function CardArea:emplace(card, location, stay_flipped)
	local ret = emplace_ref(self, card, location, stay_flipped)

	if G.GAME.selected_back.effect.center.key == "b_SGTMD_invisible" and (card.area == G.hand or card.area == G.jokers)  then
		card.ability.SGTMD_PermaFlip = true
	else
		card.ability.SGTMD_PermaFlip = false
	end

	return ret
end


SMODS.Back {
	key = "invisible",
	
	atlas = "decks",
	pos = {x=3,y=3},
	calculate = function (self, card, context)
		if context.end_of_round and G.GAME.blind.boss and not context.repetition and not context.individual  then
			for x = 1,#G.jokers.cards do
				local c = G.jokers.cards[x]
				c.ability.SGTMD_PermaFlip = false
				c:flip()
			end
		end
		if context.starting_shop then
			for x = 1,#G.jokers.cards do
				local c = G.jokers.cards[x]
				c:flip()
				c.ability.SGTMD_PermaFlip = true
				
			end
		end
		if context.setting_blind and #G.jokers.cards > 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					local card = copy_card(G.jokers.cards[1], nil)
					card:set_edition({ negative = true }, true)
					card.children.back.sprite_pos = G.jokers.cards[1].children.back.sprite_pos
					card:add_to_deck()
					G.jokers:emplace(card)
					return true
				end
			}))
		end
	end
}


SMODS.Back {
	key = "betrayal",
	
	config = {hands = -1},
	atlas = "decks",
	pos = { x = 4, y = 0},
	check_for_unlock = function(self,args)
		if args.type == "win_deck" and G.GAME.selected_back.effect.center.key == "b_black" then
			return true
		end
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, card in ipairs(G.playing_cards) do
					if card.base.value == "King"then
						assert(SMODS.change_base(card, nil, "Jack"))
					end
					if card:is_suit("Clubs") then
						assert(SMODS.change_base(card, "Diamonds"))
					end
					if card:is_suit("Spades") then
						assert(SMODS.change_base(card, "Hearts"))
					end
				end
				return true
		   	end
		}))
	end
}

SMODS.Back {
	key = "blackboard",
	
	config = {discards = -1},
	atlas = "decks",
	pos = { x = 4, y = 1},
	check_for_unlock = function(self,args)
		if args.type == "win_deck" and G.GAME.selected_back.effect.center.key == "b_black" then
			return true
		end
	end,
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for _, card in ipairs(G.playing_cards) do
					if card.base.value == "2"then
						assert(SMODS.change_base(card, nil, "Ace"))
					end
					if card:is_suit("Diamonds") then
						assert(SMODS.change_base(card, "Clubs"))
					end
					if card:is_suit("Hearts") then
						assert(SMODS.change_base(card, "Spades"))
					end
				end
				return true
		   	end
		}))
	end
}


SMODS.Back {
	key = "letsgogambling!!!!!",
	
	config = {dollars = 6},
	atlas = "decks",
	pos = { x = 1, y = 3},
	calculate = function (self,card,context)
		if to_number(G.GAME.dollars)<= 0 and G.STATE ~= G.STATES.GAME_OVER then
			G.GAME.blind.config.blind = G.P_BLINDS.bl_SGTMD_deckblind
			G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
		end
		
		if context.final_scoring_step then
			
			if math.floor(to_number(hand_chips)/500) > 0 then
				return {dollars = math.floor(to_number(hand_chips)/500) }
			end
		end
		if context.setting_blind then
			if G.GAME.blind.boss then
				G.GAME.SGTMD_GD_B = 7
				
			elseif context.blind == "bl_pvp" then
				G.GAME.SGTMD_GD_B = 10
			else
				G.GAME.SGTMD_GD_B = 5
			end
			if to_number(G.GAME.dollars) - G.GAME.SGTMD_GD_B < 0 then
				G.GAME.SGTMD_GD_B = G.GAME.SGTMD_GD_B - (G.GAME.SGTMD_GD_B - to_number(G.GAME.dollars))
			end
			return { dollars = 0-G.GAME.SGTMD_GD_B}
		end
		if context.end_of_round and not context.individual and not context.repetition then
			return{dollars = G.GAME.SGTMD_GD_B * 2}
		end
	end
}


local cost_ref = Card.set_cost
function Card:set_cost()
	local ret = cost_ref(self)
	if not G.GAME.selected_back then return ret end
	if (self.ability.set == 'Joker' or (self.ability.set == 'Booster' and self.ability.name:find('Buffoon'))) and G.GAME.selected_back.effect.center.key == "b_SGTMD_Joker" then self.cost = 0 end
	
	return ret
end

SMODS.Back {
	key = "Joker",
	
	config = {hands = -2, joker_slot = 2},
	atlas = "decks",
	pos = { x = 4, y = 2},
	apply = function (self)
		local banned = {
			'p_celestial_normal_1','p_celestial_normal_2',"p_celestial_normal_3","p_celestial_normal_4","p_celestial_jumbo_1","p_celestial_jumbo_2","p_celestial_mega_1","p_celestial_mega_2"
		,'p_standard_normal_1','p_standard_normal_2',"p_standard_normal_3","p_standard_normal_4","p_standard_jumbo_1","p_standard_jumbo_2","p_standard_mega_1","p_standard_mega_2"
		,'p_arcana_normal_1','p_arcana_normal_2',"p_arcana_normal_3","p_arcana_normal_4","p_arcana_jumbo_1","p_arcana_jumbo_2","p_arcana_mega_1","p_arcana_mega_2"
		,'p_spectral_normal_1','p_spectral_normal_2',"p_spectral_jumbo_1","p_spectral_mega_1",
		"v_tarot_merchant","v_tarot_tycoon","v_planet_merchant","v_planet_tycoon","v_telescope","v_observatory","v_crystal_ball","v_omen_globe"}
		for k,v in ipairs(banned) do
			G.GAME.banned_keys[v] = true
		end

		G.E_MANAGER:add_event(Event({func = function()
            G.GAME.tarot_rate = 0
			G.GAME.planet_rate = 0
			return true 
		end }))
	end

}



SMODS.Back {
	key = "throwback",
	loc_txt = {
		name = "Retro Deck",
		text = {
			"Skipping blinds creates 2 random tags",
			"Skipping enters the shop",
			"{C:white,X:mult}X1.5{} Base blind size"
		}
	},  
	config = {ante_scaling = 1.5},
	atlas = "decks",
	pos = { x = 5, y = 2},
	calculate = function (self,card,context)
		
		if context.skip_blind then
			
			for x=1 ,2 do
				local _pool, _pool_key = get_current_pool('Tag', nil, nil, "retro")
				local _tag = pseudorandom_element(_pool, pseudoseed(_pool_key))
				local it = 1
				while _tag == 'UNAVAILABLE' do
					it = it + 1
					_tag = pseudorandom_element(_pool, pseudoseed(_pool_key..'_resample'..it))
				end
				add_tag(Tag(_tag))
			end
			G.E_MANAGER:add_event(Event({
				trigger = 'before', delay = 0.2,
				func = function()
				  G.blind_prompt_box.alignment.offset.y = -10
				  G.blind_select.alignment.offset.y = 40
				  G.blind_select.alignment.offset.x = 0
				  return true
			end}))
			G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				G.blind_select:remove()
				G.blind_prompt_box:remove()
				G.blind_select = nil
				return true
			end}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = .9,
				func = function()
					-- G.blind_select:remove()
					-- G.blind_prompt_box:remove()

					G.GAME.current_round.jokers_purchased = 0
					G.STATE = G.STATES.SHOP
					G.GAME.shop_free = nil
					G.GAME.shop_d6ed = nil
					G.STATE_COMPLETE = false
					
					G.E_MANAGER:add_event(Event({
						trigger = "after",
						delay = 1.4,
						func = function()
							for i = 1, #G.GAME.tags do
								if G.GAME.tags[i]:apply_to_run({type = 'new_blind_choice'}) then break end
							end
							return true
						end,
					}))
					return true
				end,
			}))
		end
		
	end
}


assert(SMODS.load_file("items/paint.lua"))()

SMODS.Back {
	key = "artist",
	
	atlas = "decks",
	pos = { x = 4, y = 3},
	calculate =function (self, back, context)
		if context.setting_blind and #G.consumeables.cards < G.consumeables.config.card_limit then
			G.E_MANAGER:add_event(Event({func = function ()
				SMODS.add_card({set = "paint",area = G.consumeables})
				return true
			end}))
		end
	end
}

SMODS.Back {
	key = "ballot",
	
	config = {extra = {round = 0}},
	loc_vars = function (self, info_queue, card)
		
		return{ vars = { 3 - (self.config.extra.round or 0) }}
		
	end,
	atlas = "decks",
	pos = {x=6,y=0},
	calculate = function (self, back, context)
		if context.setting_blind then
			back.effect.config.extra.round = back.effect.config.extra.round + 1
			if back.effect.config.extra.round >= 3 then
				back.effect.config.extra.round = 0
				ease_ante(-1)
				G.hand:change_size(-1)
				return {
					message = "Again!"
				}
			end
		end
	end
}

SMODS.Back {
	key = "piquet",
	
	config = {hands = -1},
	
	atlas = "decks",
	pos = {x=5,y=3},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
            func = function()
            	local i2 = 1
                for i = 1, #G.playing_cards do
					local card = G.playing_cards[i2]

                    if not (card.base.value == "Ace" or card.base.value == "King"  or card.base.value == "Queen"  or card.base.value =="Jack"  or card.base.value =="10"  or card.base.value =="9"  or card.base.value =="8"  or card.base.value == "7") then
						G.deck:remove_card(card)
						card:remove()
						i2 = i2-1
					end
					i2 = i2 + 1
                end

                return true
            end
        }))
	end
}

SMODS.Back {
	key = "pinochle",
	
	config = {hands = -1},
	
	atlas = "decks",
	pos = {x=6,y=3},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
            func = function()
            	local i2 = 1
                for i = 1, #G.playing_cards do
					local card = G.playing_cards[i2]

                    if not (card.base.value == "Ace" or card.base.value == "King"  or card.base.value == "Queen"  or card.base.value =="Jack"  or card.base.value =="10"  or card.base.value =="9" ) then
						G.deck:remove_card(card)
						card:remove()
						i2 = i2-1
					end
					i2 = i2 + 1
                end

				local newcards = {}
                for i = 1, #G.playing_cards do
  					local card = G.playing_cards[i]

                    local _card = copy_card(card, nil, nil, G.playing_card)
                    _card:add_to_deck()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, _card)
                    G.deck:emplace(_card)
                    
                end

                return true
            end
        }))
	end
}


SMODS.Back {
	key = "snake",
	atlas = "decks",
	pos = {x=6,y=1},
	config = {hands = 1,discards = 1},
	apply = function (self, back)
		G.GAME.SGTMD_MOD = G.GAME.SGTMD_MOD or {}
		G.GAME.SGTMD_MOD.limitdraw = 3
	end
}

local setabitref = Card.set_ability
function Card:set_ability(center, initial, delay_sprites)
	local ret = setabitref(self, center, initial, delay_sprites)
	if G.GAME.selected_back then
		G.GAME.selected_back:trigger_effect({modify_playing_card = true,card = self,center = center})
	end
	return ret
end

SMODS.Back {
	key = "stone",
	atlas = "decks",
	pos = {x=6,y=2},
	config = {joker_slot = -4},
	apply = function (self, back)
		G.GAME.SGTMD_MOD = G.GAME.SGTMD_MOD or {}
		G.GAME.SGTMD_MOD.stonedeckcount = 0

	end,
	calculate = function (self, back, context)
		if context.modify_playing_card or context.final_scoring_step then
			local stonecount = 0
			
			for x=1,#G.playing_cards do
				local ccard = G.playing_cards[x]
				if ccard.config.center == G.P_CENTERS.m_stone then stonecount = stonecount +1 end
			end
			if math.floor(stonecount/10) ~= G.GAME.SGTMD_MOD.stonedeckcount then
				local diff =  math.floor(stonecount/10) - G.GAME.SGTMD_MOD.stonedeckcount
				G.E_MANAGER:add_event(Event({func = function()
					if G.jokers then 
						G.jokers.config.card_limit = G.jokers.config.card_limit + diff
					end
					return true end }))
				G.GAME.SGTMD_MOD.stonedeckcount  = G.GAME.SGTMD_MOD.stonedeckcount +diff
			end
		end
	end
}

TMD.wilddeckrandoms = {{"dollars",1},{"xmult",1.1},{"mult",5},{"chips",50}}

SMODS.Back {
	key = "wild",
	atlas = "decks",
	pos = {x=7,y=3},
	calculate = function (self, back, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.config.center == G.P_CENTERS.m_wild then
			local opt = pseudorandom_element(TMD.wilddeckrandoms,pseudoseed("wilddeck"))
			return {
				[opt[1]] = opt[2],
				card = context.other_card
			}
		end
		end
		if context.final_scoring_step then
			local wildcount = 0
			
			for x=1,#G.playing_cards do
				local ccard = G.playing_cards[x]
				if ccard.config.center == G.P_CENTERS.m_wild then wildcount = wildcount +1 end
			end
			return {
				chips = wildcount*10
			}
		end
	end
}



local ccr = create_card


create_card = function(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	
	-- if pseudorandom("rofdeckya") > 0.85 and not forced_key and _type == "Joker" and G.GAME and G.GAME.selected_back and (G.GAME.selected_back.name == "b_SGTMD_roffledeck" or  G.GAME.selected_sleeve == "sleeve_SGTMD_roffledeck") then
	-- 	if pseudorandom("roffledeck") >.5 then
	-- 		forced_key = "j_photograph"
	-- 	else
	-- 		forced_key = "j_hanging_chad"
	-- 	end
	-- 	if _rarity == 4 or legendary then
	-- 		forced_key = "j_triboulet"
	-- 	end
	-- end
	local ret = {}
	if G.STAGES.RUN then
		if G.GAME.selected_back.effect.center.card_creation then ret = G.GAME.selected_back.effect.center.card_creation(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, nil) end
		if ret then _type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append = unpack(ret) end
		if CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve).card_creation then ret = CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve).card_creation(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, nil) end
		if ret then _type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append = unpack(ret) end
	end

	local ret = ccr(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
	-- if _type == "Joker" and G.GAME and ( G.GAME.selected_back.name == "b_SGTMD_tds" or G.GAME.selected_sleeve == "sleeve_SGTMD_tds" ) then
	-- 	if ret.config.center.eternal_compat then
	-- 		ret:set_eternal(true)
	-- 	end
	-- 	if G.GAME.selected_back.name == "b_SGTMD_tds" and G.GAME.selected_sleeve == "sleeve_SGTMD_tds" then
	-- 		ret:set_rental(true)
	-- 	end
	-- end
	if G.GAME.selected_back.effect.center.card_creation then G.GAME.selected_back.effect.center.card_creation(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ret) end
	if CardSleeves and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve).card_creation then CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve).card_creation(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, ret) end

	return ret
end

local emr = ease_dollars
function  ease_dollars(mod, instant)
	TMD.easing_dollar = nil

	local ret = emr(mod,instant)
	G.E_MANAGER:add_event(Event({
		func = function( )
			if G.GAME and G.GAME.selected_back.name == "b_SGTMD_tds" or G.GAME.selected_sleeve == "sleeve_SGTMD_tds" then
				G.GAME.dollars = math.min(50, G.GAME.dollars) 
			end
			if G.GAME and G.GAME.selected_back.name == "b_SGTMD_tds" and G.GAME.selected_sleeve == "sleeve_SGTMD_tds" then
				G.GAME.dollars = math.min(35, G.GAME.dollars) 
			end
			return true
		end
	}))
	TMD.easing_dollar = true
	return ret
end

SMODS.Back {
	key = "tds",
	atlas = "decks",
	pos = {x=7,y=1},
	config = {no_interest = true},
	calculate = function (self, back, context)
		if context.buying_card or (context.open_booster and not context.card.from_tag) then
			
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function ()
					local startrerollcost = G.GAME.current_round.reroll_cost
					if (to_number(G.GAME.dollars-context.card.cost) - math.floor(G.GAME.current_round.reroll_cost/2) >= 0)
						or  G.GAME.selected_sleeve == "sleeve_SGTMD_tds" then
						if not G.GAME.selected_sleeve == "sleeve_SGTMD_tds" then
							G.GAME.current_round.reroll_cost = math.floor(G.GAME.current_round.reroll_cost/2)
						end
						G.FUNCS.reroll_shop()
						G.GAME.current_round.reroll_cost = startrerollcost + 1
					end
					return true
				end
			}))
			
		end
	end,
	card_creation = function(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, created_card)
        print('back_test: ' .. tostring(created_card ~= nil))
		if _type ~= "Joker" then return end
		if created_card and created_card.config.center.eternal_compat then
			created_card:set_eternal(true)
		end
	end
}

SMODS.Atlas {
	key = "lookinside",
	path = "roffledecklookinsidephotochad.png",
	px = 71,
	py = 95
}

SMODS.Back {
	key ="roffledeck",
	atlas = "lookinside",
	pos = {x=0,y=0},
	card_creation = function(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, created_card)
		if created_card or _type ~= "Joker" or forced_key then return end
		if pseudorandom("rofdeckya") > 0.85 then return end

		if pseudorandom("roffledeck") >.5 then
			forced_key = "j_photograph"
		else
			forced_key = "j_hanging_chad"
		end
		if _rarity == 4 or legendary then
			forced_key = "j_triboulet"
		end
		return {_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append}
	end
}

SMODS.Back {
	key = "midas",
	atlas = "decks",
	pos = {x=0,y=4},
	dependencies = {
		"najudbnawiudbawidvgawidagwidgwydhagwdkjyuawfgvd"
	}
}

SMODS.Shader {key = "midas", path = "midas.fs"}

SMODS.DrawStep {
    key = 'gold_deck',
    order = 60,
    func = function(self)
        if self.children.back then
			do return end -- REMOVE ME!
			if (((G.GAME.selected_back.name == "b_SGTMD_midas" and self.back == "selected_back") or (G.GAME.viewed_back.name == "b_SGTMD_midas" and self.back == "viewed_back")) 
			and (self.config.center.set ~= "Back" and self.config.center.set ~= "Sleeve")) or self.config.center.key == "b_SGTMD_midas"
			and not self.area.config.stake_select and not self.area.config.stake_chips then
				local t = self.area.config.type == "deck" or self.config.center.set == "Back" 
				if t then self.ARGS.send_to_shader = {0,0} end
			--self.children.back:draw_shader('voucher',0, nil, t, self.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
			self.children.back:draw_shader('SGTMD_midas', nil, self.ARGS.send_to_shader, t, self.children.center, 0,0)


        end
	end
    end,
    conditions = { vortex = false, facing = 'back' },
}


assert(SMODS.load_file("items/iamgoingtohaveaheadache.lua"))()
if CardSleeves then assert(SMODS.load_file("items/sleeves.lua"))() end
