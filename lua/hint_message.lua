if wesnoth.interface.add_overlay_text == nil then
    return {}
end

hint_label = {valid = false}
-- Takes 'caption' and 'message' arguments, similar to [message]
function wesnoth.wml_actions.hint_message(cfg)
    if hint_label.valid then
        hint_label:remove()
    end
    if cfg.message and cfg.message ~= "" then
        local text
        if cfg.caption and cfg.caption ~= "" then
            text = "<b>" .. cfg.caption .. "</b>\n" .. cfg.message
        else
            text = cfg.message
        end
        hint_label = wesnoth.interface.add_overlay_text(text, {
            size = 20,
            -- lavender RGB (230,230,250)
            color = "E6E6FA",
            --bgcolor = "0b0d2e",
            --bgalpha = 25,
            duration = "unlimited",
            valign = "top",
            halign = "left"
        })
    end
end