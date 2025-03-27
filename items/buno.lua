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



--- BUNO END!!!!!!!
