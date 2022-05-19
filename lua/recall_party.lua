function wesnoth.wml_actions.recall_party(cfg)
	local units = wesnoth.units.find_on_recall(cfg)

	for i, u in ipairs(units) do
		wesnoth.wml_actions.recall({ id = u.id })
	end
end