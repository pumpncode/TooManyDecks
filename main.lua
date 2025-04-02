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

-- Credit to multiplayer mod for finding this code in cryptids code


TMD.splashpos = {{x=5,y=0},{x=1,y=0},{x=2,y=0},{x=3,y=0},{x=4,y=0},
							  {x=0,y=1},{x=1,y=1},{x=2,y=1},{x=3,y=1},{x=4,y=1},
							  {x=0,y=2},{x=4,y=2},{x=4,y=3},
							  {x=0,y=3},{x=1,y=3},{x=3,y=3},{x=5,y=3},{x=6,y=3}}



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
	loc_txt = {
		name = "Nil",
		text = {"naneinf"},
		unlock = {"Score naneinf or higher"}
	},
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
		"Start at {C:attention}ante 0{}","Start with a {T:j_popcorn}popcorn{}",
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



SMODS.Back {
	key = "prodeck",
	loc_txt = {
		name = "Pro Deck",
		text = {
			"{C:blue}+1{} hand {C:red}+1{} discard",
			"{C:attention}+2{} hand size",
			"Start with extra {C:money}$10{}",
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
	config = {hands = 1, discards = 1,hand_size = 2, consumable_slot = -1,no_interest = true,ante_scaling = 1.4, dollars = 10},
	atlas = "decks",
	pos = { x = 0, y = 3}
}


SMODS.Back {
	key = "storage",
	loc_txt = {
		name = "Storage Deck",
		text = {"Any playing cards destroyed in ",
					"a shop are duplicated twice",
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
	loc_txt = {
		name = "Shitposter deck",
		text = {"Start with an {T:st_eternal,T:j_egg,C:attention}Eternal Egg",
					"Deck contains only 6, 9, 4, 2's and King of {C:hearts}Hearts{}"},
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

	if self.ability.SGTMD_PermaFlip and (self.area == G.hand or self.area == G.jokers) then
		self.flipping = "f2b"
        self.facing='back'
        self.sprite_facing = 'back'
		self.pinch.x = false
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
	loc_txt = {
		name = "Invisible Deck",
		text = {"All cards are flipped",
					"Create a {T:e_negative,C:dark_edition}negative{} copy","of leftmost joker when blind selected"}
	},
	atlas = "decks",
	pos = {x=3,y=3},
	calculate = function (self, card, context)
		
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
	loc_txt = {
		name = "Deck of Betrayal",
		text = {"Start run with",
					"{C:attention}26{} {C:hearts}Hearts{} and",
				"{C:attention}26{} {C:diamonds}Diamonds{} in deck",
			"Kings are replaced with Jacks",
		"{C:blue}-1{} hand every round"},
		unlock = {"Win a run with","{C:attention}Black Deck{}","on any difficulty"}
	},
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
	loc_txt = {
		name = "Blackboard Deck",
		text = {"Start run with",
					"{C:attention}26{} {C:spades}Spades{} and",
				"{C:attention}26{} {C:clubs}Clubs{} in deck",
				"2s are replaced with Aces",
		"{C:red}-1{} discard every round"},
		unlock = {"Win a run with","{C:attention}Black Deck{}","on any difficulty"}
	},
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
	loc_txt = {
		name = "Gambler's Deck",
		text = {
			"Gain {C:money}$1{} for every","{C:chips}500{} base chips scored",
			"{s:0.75}(chips before multiplication)",
			"Small and Big Blinds cost {C:money}$5{}",
			"Boss Blinds cost {C:money}$7{}",
			"All Buy-ins return 2 to 1",
			"reaching {C:money}$0{} ends your run"
		}
	},
	config = {dollars = 6},
	atlas = "decks",
	pos = { x = 1, y = 3},
	calculate = function (self,card,context)
		if to_number(G.GAME.dollars)<= 0 then
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
	loc_txt = {
		name = "Joker Deck",
		text  = {
			"All jokers and buffon packs are free",
			"+2 joker slots",
			"Non-jokers no longer show up in shop",
			"{C:blue}-2{} hands every round"
		}
	},
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
			return true end }))
	end

}



local gfts = G.FUNCS.toggle_shop
		G.FUNCS.toggle_shop = function(e)
			gfts(e)
			if G.GAME.RETRO then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.5,
					func = function()
						G.GAME.RETRO = false
						
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = 0.5,
					func = function()
						G.GAME.current_round.used_packs = {}
						G.STATE = G.STATES.SELECTING_HAND
						return true
					end,
				}))
			end
		end
		local gus = Game.update_shop
		function Game:update_shop(dt)
			gus(self, dt)
			if not G.GAME.RETRO_COMPLETE then G.GAME.RETRO_COMPLETE = 0 end
			if G.GAME.RETRO and G.STATE_COMPLETE and G.GAME.RETRO_COMPLETE < 60 then
				G.shop.alignment.offset.y = -5.3
				G.GAME.RETRO_COMPLETE = G.GAME.RETRO_COMPLETE + 1
			end
		end
		local guis = G.UIDEF.shop
		function G.UIDEF.shop()
			local ret = guis()
			if G.GAME.RETRO then
				G.SHOP_SIGN:remove()
				G.SHOP_SIGN = {
					remove = function()
						return true
					end,
					alignment = { offset = { y = 0 } },
				}
			end
			return ret
		end


SMODS.Back {
	key = "Throwback",
	loc_txt = {
		name = "Retro Deck",
		text = {
			"Skipping blinds creates 2 random tags",
			"Skipping enters the shop",
			"{C:white,X:mult}X1.5{} Base blind size"
		}
	},
	dependencies = {
		"thismoddoesntexistandifitdoeswhybalatrohaahhahahadhudhaidhgaswioudgawodwqada3.14159265349"
	},    
	config = {ante_scaling = 1.5},
	atlas = "decks",
	pos = { x = 5, y = 2},
	calculate = function (self,card,context)
		
		if context.skip_blind then
			for x=1 ,2 do
			local tag = get_next_tag_key("retro")
			tag = Tag(tag)
			if tag.name == "Orbital Tag" then
				local _poker_hands = {}
				for k, v in pairs(G.GAME.hands) do
					if v.visible then
						_poker_hands[#_poker_hands + 1] = k
					end
				end
				tag.ability.orbital_hand = pseudorandom_element(_poker_hands, pseudoseed("retro"))
			end
			add_tag(tag)
			end
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.5,
				func = function()
					G.blind_select:remove()
					G.blind_prompt_box:remove()
					G.blind_select = nil
					G.GAME.current_round.jokers_purchased = 0
					G.GAME.RETRO = true
					G.STATE = G.STATES.SHOP
					G.STATE_COMPLETE = false
					G.GAME.current_round.used_packs = {}
					return true
				end,
			}))
		end
		
	end
}


assert(SMODS.load_file("items/paint.lua"))()

SMODS.Back {
	key = "artist",
	loc_txt = {
		name = "Artist Deck",
		text = {
			"When each blind is selected",
			"create a random {C:blue}Paint{} card",
			"{C:inactive}(must have room){}"
		}

	},
	atlas = "decks",
	pos = { x = 4, y = 3},
	calculate =function (self, back, context)
		if context.setting_blind and #G.consumeables.cards < G.consumeables.config.card_limit then
			G.E_MANAGER:add_event(Event({
				func = function ()
					
				
				SMODS.add_card({set = "paint",area = G.consumeables})
				return true
			end}))
			
		end
	end
}

SMODS.Back {
	key = "ballot",
	loc_txt = {
		name = "Ballot Deck",
		text = {
			"Every {C:attention}3{} rounds:","go back {C:attention}1 ante","{C:attention}-1{} hand size"
		}
	},
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
	loc_txt = {
		name = "Piquet Deck",
		text = {
			"Start run with 32 cards","From Ace to 7","{C:blue}-1 hand{} every round"
		}
	},
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
	loc_txt = {
		name = "Pinochle Deck",
		text = {
			"Start run with 48 cards","From Ace to 9","{C:blue}-1 hand{} every round"
		}
	},
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

assert(SMODS.load_file("items/iamgoingtohaveaheadache.lua"))()