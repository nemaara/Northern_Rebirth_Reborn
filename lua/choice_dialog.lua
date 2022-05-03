-- to make code shorter
local wml_actions = wesnoth.wml_actions

-- metatable for GUI tags
local T = wml.tag

-- support for translatable strings, custom textdomain
local _ = wesnoth.textdomain "textdomain wesnoth-nrr"

function wml_actions.choice_box( cfg )
	local variable = cfg.variable or wml.error( "Missing variable= key in [choice_box]" )
	local choice_values = {} -- it will be populated by preshow, and supply values to postshow

	local buttonbox = T.grid {
				T.row {
					T.column {
						T.button { 
							label = _"OK",
							return_value = 1
						} 
					},
					T.column {
						T.spacer { width = 10 }
						},
					T.column {
						T.button {
							label = _"Cancel",
							return_value = 2
						}
					}
				}
			}

	local toggle_grid = T.grid {
				T.row {
					T.column {
						horizontal_alignment = "left",
						border = "all",
						border_size = 5,
						T.image {
							id = "choice_image",
							linked_group = "image"
							}
						},
					T.column {
						horizontal_alignment = "left",
						border = "all",
						border_size = 5,
						T.label {
							text_alignment = "left",
							id = "choice_description",
							linked_group = "description"
						}
					},
					T.column {
						horizontal_alignment = "right",
						border = "all",
						border_size = 5,
						T.label {
							text_alignment = "right",
							id = "choice_note",
							linked_group = "note"
						}
					}
				}
			}

	local listbox_dialog = {
		T.tooltip { id = "tooltip_large" },
		T.helptip { id = "tooltip_large" },
		-- these linked groups are essential to ensure
		-- that all the items in the listbox are nicely aligned
		T.linked_group {
			id = "image",
			fixed_width = "true",
			fixed_height = "true"
		},
		T.linked_group {
			id = "description",
			fixed_width = "true",
			fixed_height = "true"
		},
		T.linked_group {
			id = "note",
			fixed_width = "true",
			fixed_height = "true"
		},
		maximum_height = 600,
		maximum_width = 800,
		T.grid {
			T.row {
				T.column {
					horizontal_alignment = "left",
					border = "all",
					border_size = 5,
					T.label {
						definition = "title",
						id = "window_title"
					}
				}
			},
			T.row {
				T.column {
					horizontal_alignment = "left",
					border = "all",
					border_size = 5,
					T.scroll_label {
						id = "window_message",
					}
				}
			},
			T.row {
				T.column {
					border = "all",
					border_size = 5,
					T.listbox {
						id = "choices_listbox",
						horizontal_grow = true,
						T.list_definition {
							T.row {
								T.column {
									horizontal_grow = true,
									T.toggle_panel {
										toggle_grid
									}
								}
							}
						}
					}
				}
			},
			T.row {
				T.column {
					buttonbox
				}
			}
		}
	}

	local function preshow(dialog)
		dialog.window_title.label = cfg.title
		dialog.window_message.label = cfg.message
		dialog.window_message.use_markup = true
		
		local counter = 1
		for option in wml.child_range( cfg, "option") do
			if option.value then
				choice_values[counter] = option.value
			else
				choice_values[counter] = counter -- just the same number, for simplicity sake
			end
			dialog.choices_listbox[counter].choice_image.label = option.image or ""
			dialog.choices_listbox[counter].choice_description.label = option.description or ""
			dialog.choices_listbox[counter].choice_description.use_markup = true
			dialog.choices_listbox[counter].choice_note.label = option.note or ""
			dialog.choices_listbox[counter].choice_note.use_markup = true
			counter = counter + 1
		end
	end
	local function sync()
		local choice_index
		local function postshow(dialog)
			choice_index = dialog.choices_listbox.selected_index
		end
		local return_value = gui.show_dialog( listbox_dialog, preshow, postshow )
		return { return_value = return_value, choice = choice_values[choice_index] } -- and retrieve the associated value
	end

	local return_table = wesnoth.sync.evaluate_single(sync)
	local return_value = return_table.return_value

	if return_value == 1 or return_value == -1 then -- if used pressed OK or Enter
		wml.variables[variable] = return_table.choice
	elseif return_value == 2 or return_value == -2 then -- if user pressed Cancel or Esc
		wml.variables[variable] = "null" -- any better choice?
	else wml.error( ( tostring( _"Choice box" ) .. ": " .. tostring( _"Error, return value :" ) .. tostring( return_value ) ) ) end -- any unhandled case is handled here
end