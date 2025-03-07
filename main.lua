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
		text = {"naneinf"}
	},
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
				"Total mult rounded to lower 6"}
	},
	config = {only_one_rank = '6'},
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
				"Total mult rounded to lower 6"}
		},
		config = {only_one_rank = '6'},
		atlas = "decks sleeves",
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
end

SMODS.Back {
	key = "argyle",
	loc_txt = {
		name = "Argyle Deck",
		text = {"Start run with",
					"{C:attention}26{} {C:clubs}Clubs{} and",
				"{C:attention}26{} {C:diamonds}Diamonds{} in deck"}
	},
	atlas = "decks",
	pos = { x = 1, y = 1},
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
				"are Jack's"}
	},
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
					"are Jack's"}
		},
		atlas = "decks sleeves",
		pos = { x = 2, y = 0},
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
end

SMODS.Back {
	key = "fuckyou",
	loc_txt = {
		name = "Fuck you",
		text = {"You start with 1",
		"card in your deck",
		"{X:mult,C:white}X0.5{} Mult",
		"{s:2.0}Fuck You{}"}
	},
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
	key = "pro",
	loc_txt = {
		name = "Pro Deck",
		text = {
			"{C:blue}+1{} hand {C:red}+1{} discard",
			"{C:attention}+2{} hand size",
			"Start with extra {C:yellow}$10{}",
			"{X:mult,C:white}X1.4{} base Blind size",
			"{C:red}-1{} consumeable slot",
			"Earn No {C:attention}Interest{}"
		}
	},
	config = {hands = 1, discards = 1,hand_size = 2,joker_slot = 1, consumable_slot = -1,no_interest = true,ante_scaling = 1.4},
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
					"are duplicated twice"}
	},
	atlas = "decks",
	pos = { x = 3, y = 0},
	calculate = function(self, card, context)
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
					"Deck contains only 6, 9, 4, and 2's"}
	},
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

