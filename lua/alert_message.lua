function wesnoth.wml_actions.alert( cfg )
	if cfg.title then
		gui.alert(cfg.title, cfg.message)
	else
		gui.alert(cfg.message)
	end
end