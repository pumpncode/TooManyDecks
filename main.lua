SMODS.Atlas {
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


SMODS.Back {
	key = "nane",
	loc_txt = {
		name = "Nil",
		text = {"naneinf"},
		unlock = {"Score naneinf or higher"}
	},
	check_for_unlock = function(self, args)
		if args.type == "chip_score" and args.chips >= 1.8*10^308 then
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
	loc_txt = {
		name = "Oops! All Sixes!",
		text = {"All Cards start",
				"as 6's",
				"Total chip's multiplied by 6",
				"Total mult rounded to lower 6",
				"{X:mult,C:white}X1.6{} base Blind size"}
	},
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

if CardSleeves then
	CardSleeves.Sleeve {
		key = "oops",
		loc_txt = {
		name = "Oops! All Sixes!",
		text = {"All Cards start",
				"as 6's",
				"Total chip's multiplied by 6",
				"Total mult rounded to lower 6",
				"{X:mult,C:white}X1.6{} base Blind size"}
		},
		config = {only_one_rank = '6', ante_scaling = 1.6},
		atlas = "decks sleeves",
		pos = { x = 0, y = 0},
		apply = function(self, sleeve)
			CardSleeves.Sleeve.apply(sleeve)
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
end

SMODS.Back {
	key = "argyle",
	loc_txt = {
		name = "Argyle Deck",
		text = {"Start run with",
					"{C:attention}26{} {C:clubs}Clubs{} and",
				"{C:attention}26{} {C:diamonds}Diamonds{} in deck"},
		unlock = {"Win a run with","{C:attention}Black Deck{}","on any difficulty"}
	},
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


if CardSleeves then
	CardSleeves.Sleeve {
		key = "argylesleeve",
		loc_txt = {
			name = "Argyle Sleeve",
			text = {"Start run with",
						"{C:attention}26{} {C:clubs}Clubs{} and",
					"{C:attention}26{} {C:diamonds}Diamonds{} in deck"}
		},
		atlas = "decks sleeves",
		pos = { x = 3, y = 0},
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
end

SMODS.Back {
	key = "doubleup",
	loc_txt = {
		name = "Double Deck",
		text = {"There are two of",
				"every base card"}
	},
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
if CardSleeves then
    CardSleeves.Sleeve {
    key = "doubleupsleeve",
    atlas = "decks sleeves",  -- you will need to create an atlas yourself
    pos = { x = 1, y = 0 },
    loc_txt = {
        name = "Double Sleeve",
        text = {"There are two of",
				"every base card"}
    },
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
end

SMODS.Back {
	key = "kingdom",
	loc_txt = {
		name = "Kingdom Deck",
		text = {"All non-face cards",
					"are Jack's",
				"{C:red}-2{} hand size",
				"Earn no {C:attention}Interest{}"},
				unlock = {"Play {C:attention}5 Gold Jacks{} in one hand"}
	},
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
if CardSleeves then
	CardSleeves.Sleeve {
		key = "kingdom",
		loc_txt = {
			name = "Kingdom Sleeve",
			text = {"All non-face cards",
					"are Jack's",
				"{C:red}-2{} hand size",
				"Earn no {C:attention}Interest{}"},
				unlock = {"Play {C:attention}5 Gold Jacks{} in one hand"}
		},
		loc_vars = function (self)
			self.config = {hand_size = -2, no_interest = true}
		end,
		config = {hand_size = -2, no_interest = true},
		atlas = "decks sleeves",
		pos = { x = 2, y = 0},
		apply = function(self, sleeve)
			CardSleeves.Sleeve.apply(sleeve)
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
end

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
	loc_txt = {
		name = "Fuck you",
		text = {"You start with 1",
		"card in your deck",
		"{X:mult,C:white}X0.5{} Mult",
		"{s:2.0}Fuck You{}"},
		unlock = {"{C:green}#1# in 15{} chance this","deck unlock when","losing a run"}
	},
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
            	local newcards = {}
                for i = 1, #G.playing_cards do
  					local card = G.playing_cards[1]
					G.deck:remove_card(card)
					card:remove()
                    
                end
                card = create_playing_card(nil,G.deck)
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
	key = "profront",
	order = 5000,
	func = function (card,layer)
		
		if card.config.center.soul_pos then
			
			
			
        	    local scale_mod = 0.07 + 0.02*math.sin(1.8*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL))*math.pi*14)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^3
        	    local rotate_mod = 0.05*math.sin(1.219*G.TIMERS.REAL) + 0.00*math.sin((G.TIMERS.REAL)*math.pi*5)*(1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL)))^2

        	    if type(card.config.center.soul_pos.draw) == 'function' then
        	        card.config.center.soul_pos.draw(card, scale_mod, rotate_mod)
        	    else
        	        card.children.floating_sprite:draw_shader('dissolve',0, nil, nil, card.children.center,scale_mod, rotate_mod,nil, 0.1 + 0.03*math.sin(1.8*G.TIMERS.REAL),nil, 0.6)
        	        card.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        	    end
        	    if card.edition then 
        	        for k, v in pairs(G.P_CENTER_POOLS.Edition) do
        	            if v.apply_to_float then
        	                if card.edition[v.key:sub(3)] then
        	                    card.children.floating_sprite:draw_shader(v.shader, nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        	                end
        	            end
        	        end
        	    end
        	
		end
	end,
	conditions = {facing = "back"}
}

SMODS.Back {
	key = "prodeck",
	loc_txt = {
		name = "Pro Deck",
		text = {
			"{C:blue}+1{} hand {C:red}+1{} discard",
			"{C:attention}+2{} hand size",
			"Start with extra {C:yellow}$10{}",
			"{X:mult,C:white}X1.4{} base Blind size",
			"{C:red}-1{} consumeable slot",
			"Earn no {C:attention}Interest{}"
		},
		unlock = {"Win a run with","{C:attention}Fuck you{}","on any difficulty"}
	},
	check_for_unlock = function(self,args)
		if args.type == "win_deck" and G.GAME.selected_back.effect.center.key == "b_SGTMD_fuckyou" then
			return true
		end
	end,
	unlocked = false,
	config = {hands = 1, discards = 1,hand_size = 2, consumable_slot = -1,no_interest = true,ante_scaling = 1.4},
	atlas = "decks",
	pos = { x = 0, y = 3},
	
	apply = function(self,back)
		ease_dollars(10)
		
		
	end
}

SMODS.Back {
	key = "storage",
	loc_txt = {
		name = "Storage Deck",
		text = {"Any playing cards destroyed",
					"are duplicated twice",
				"Create a {T:e_negative,C:dark_edition}Negative{} {T:c_hanged_man,C:tarot}Hanged Man{}",
				"after boss blind defeated"},
				unlock = {"Create and destroy a card","in one hand"}
	},
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
		if context.remove_playing_cards then
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
	loc_txt = {
		name = "Shitposter deck",
		text = {"Start with an {T:sticker_eternal,T:j_egg,C:attention}Eternal Egg",
					"Deck contains only 6, 9, 4, and 2's"},
		unlock = {"Score exactly {C:attention}69{} chips",
	"on {C:green}April 20th{}"}
	},
	check_for_unlock = function (self,args)
		if os.date("*t").month == 4 and os.date("*t").day == 20 and args.type == "chip_score" and args.chips == 69 then
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
	key = "Buno",
	loc_txt = {
		name = "Buno Deck",
		text = {"Literally just a deck",
	"of Buno cards",
"{s:2.0,C:attention}VERY W.I.P.{}",
	"use at your own risk"},
	unlock = {"Play a High Card with","{C:attention}0{} cards held in hand"}
	},
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
	
			if context.individual and context.other_card.area == G.play then
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


-- -------------------------------------BUNO!!!!-------------------------------------

SMODS.Atlas {
	key = "hcbunocards",
	px = 71,
	py = 95,
	path = "buno2.png"
}

SMODS.Atlas {
	key = "bunocards",
	px = 71,
	py = 95,
	path = "buno1.png"
}



SMODS.Rank {
	key = "BAce",
	card_key = "BAce",
	pos = {x=12},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "One"},
	shorthand = "A",
	face_nominal = 1,
	nominal = 1,
	next = {"SGTMD_B2"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B2",
	card_key = "B2",
	pos = {x=0},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Two"},
	shorthand = "2",
	nominal = 2,
	next = {"SGTMD_B3"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B3",
	card_key = "B3",
	pos = {x=1},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Three"},
	shorthand = "3",
	nominal = 3,
	next = {"SGTMD_B4"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B4",
	card_key = "B4",
	pos = {x=2},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Four"},
	shorthand = "4",
	nominal = 4,
	next = {"SGTMD_B5"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B5",
	card_key = "B5",
	pos = {x=3},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Five"},
	shorthand = "5",
	nominal = 5,
	next = {"SGTMD_B6"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B6",
	card_key = "B6",
	pos = {x=4},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Six"},
	shorthand = "6",
	nominal = 6,
	next = {"SGTMD_B7"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B7",
	card_key = "B7",
	pos = {x=5},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Seven"},
	shorthand = "7",
	nominal = 7,
	next = {"SGTMD_B8"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B8",
	card_key = "B8",
	pos = {x=6},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Eight"},
	shorthand = "8",
	nominal = 8,
	next = {"SGTMD_B9"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B9",
	card_key = "B9",
	pos = {x=7},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Nine"},
	shorthand = "9",
	nominal = 9,
	next = {"SGTMD_B10"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "B10",
	card_key = "B10",
	pos = {x=8},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Zero"},
	shorthand = "0",
	nominal = 1,
	face_nominal = 0,
	next = {"SGTMD_BAce"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BJack",
	card_key = "BJack",
	pos = {x=9},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Skip"},
	shorthand = "S",
	nominal = 10,
	next = {"SGTMD_BQueen"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BQueen",
	card_key = "BQueen",
	pos = {x=10},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "Reverse"},
	shorthand = "R",
	nominal = 10,
	next = {"SGTMD_BKing"},
	in_pool = function (self, args)
		return false
	end
}

SMODS.Rank {
	key = "BKing",
	card_key = "BKing",
	pos = {x=11},
	lc_atlas = "bunocards",
	hc_atlas = "hcbunocards",
	loc_txt = {name = "+2"},
	shorthand = "+2",
	nominal = 10,
	next = {"SGTMD_BJack"},
	in_pool = function (self, args)
		return false
	end
}