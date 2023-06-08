require("nvim-gps").setup()
local bufferline = require("bufferline")
local lualine = require("lualine")
local colors = require("jr.colors")
local gps = require("nvim-gps")
local jesting = require("jesting")
local commands = require("jr.custom.commands")

local function pr_count()
	if commands.pr_count == nil then
		return ""
	end
	return " " .. commands.pr_count .. " PRs for Review"
end

lualine.setup({
	sections = {
		lualine_a = { pr_count },
		lualine_b = {
			{
				"branch",
				fmt = function(branch)
					if string.len(branch) > 20 then
						return branch:sub(1, 20) .. "..."
					end
					return branch
				end,
			},
		},
		lualine_c = { "filename" },
		-- lualine_x = { { gps.get_location, cond = gps.is_available } },
		lualine_x = { jesting.lualine_status },
		-- lualine_x = {"b:gitsigns_status"},
		lualine_y = { "filetype" },
		lualine_z = {
			"location",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = " ", info = " " },
				colored = true,
				diagnostics_color = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
					hint = "DiagnosticHint",
				},
			},
		},
	},
})

bufferline.setup({
	options = {
		view = "default",
		numbers = function(opts)
			return string.format("%s", opts.ordinal)
			-- return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
		end,
		-- mappings = false,
		buffer_close_icon = "",
		modified_icon = "•",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 25,
		max_prefix_length = 15,
		show_buffer_close_icons = false,
		persist_buffer_sort = true,
		-- separator_style = {"", ""},
		separator_style = "slant",
		enforce_regular_tabs = false,
		always_show_bufferline = true,
	},
	-- highlights = {
	--   modified = {guifg = colors.green, guibg = "#0F1E28"},
	--   modified_visible = {guifg = "#3C706F", guibg = "#16242E"},
	--   modified_selected = {guifg = colors.cyan, guibg = "#142832"},
	--   fill = {guibg = "#0F1E28"},
	--   background = {guibg = "#0F1E28", guifg = colors.base04},
	--   tab = {guibg = "#0F1E28", guifg = colors.base01},
	--   tab_selected = {guibg = "#142832"},
	--   tab_close = {guibg = "#0F1E28"},
	--   buffer_visible = {guibg = "#16242E"},
	--   buffer_selected = {guibg = "#142832", guifg = colors.white, gui = "NONE"},
	--   indicator_selected = {guifg = colors.cyan, guibg = "#142832"},
	--   separator = {guibg = "#62b3b2"},
	--   separator_selected = {guifg = colors.cyan, guibg = "#142832"},
	--   separator_visible = {guibg = colors.cyan},
	--   duplicate = {guibg = "#0F1E28", guifg = colors.base04, gui = "NONE"},
	--   duplicate_selected = {guibg = "#142832", gui = "NONE", guifg = colors.white},
	--   duplicate_visible = {guibg = "#16242E", gui = "NONE"}
	-- }
})
