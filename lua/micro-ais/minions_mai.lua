local AH = wesnoth.require "ai/lua/ai_helper.lua"

-- please note this Micro AI was specifically tailored 
-- for this campaign's scenarios
-- Might be possible to make it work for in general but 
-- might not get time to get that done
-- grad-school starts soon

function wesnoth.micro_ais.minions_ai(cfg)
	if (cfg.action ~= 'delete') then
		if (not cfg.id) and (not wml.get_child(cfg, "filter")) then
			wml.error("Minions AI [micro_ai] tag requires either id= key or [filter] tag")
		end
	end

	local required_keys = {}
	local optional_keys = { id = 'string', enemy_death_chance = 'float', filter = "tag", filter_second = 'tag', invert_order = 'boolean', messenger_death_chance = 'float', waypoint_loc = "string", waypoint_x = 'integer_list', waypoint_y = 'integer_list' }
	local score = cfg.ca_score or 300000
	local CA_parms = {
		ai_id = 'northlands_minions_ai',
		{ ca_id = 'attack', location = 'ca_messenger_attack.lua', score = score },
		{ ca_id = 'escort_move', location = 'ca_messenger_escort_move.lua', score = score - 2 }
	}
    return required_keys, optional_keys, CA_parms
end