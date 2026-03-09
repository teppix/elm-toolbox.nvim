local utils = require("elm-toolbox.utils")

local M = {}

local function show_symbols_picker(symbols, title, show_filename)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local conf = require("telescope.config").values

	local opts = {}
	pickers
		.new(opts, {
			prompt_title = title,
			finder = finders.new_table({
				results = symbols,
				entry_maker = function(entry)
					local display = entry.name
					if show_filename and entry.filename then
						display = entry.name .. " (" .. vim.fn.fnamemodify(entry.filename, ":t") .. ")"
					end

					return {
						value = entry.name,
						display = display,
						ordinal = entry.name,
						filename = entry.filename,
						lnum = entry.lnum,
						col = entry.col,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			previewer = conf.qflist_previewer(opts),
			attach_mappings = function(prompt_bufnr, map)
				local function on_select()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if not selection then
						return
					end
					if show_filename and selection.filename then
						vim.cmd.edit(selection.filename)
					end
					vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
				end

				actions.select_default:replace(on_select)
				return true
			end,
		})
		:find()
end

M.top_level_document_symbols = function()
	local params = { textDocument = vim.lsp.util.make_text_document_params() }
	vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result)
		if err then
			vim.notify("Error when getting document symbols", vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No symbols found")
			return
		end

		local symbols = utils.get_top_level_symbols(result, false)
		show_symbols_picker(symbols, "Top-level Document Symbols", false)
	end)
end

M.top_level_workspace_symbols = function()
	vim.lsp.buf_request(0, "workspace/symbol", { query = "" }, function(err, result)
		if err then
			vim.notify("Error when getting workspace symbols", vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No symbols found")
			return
		end

		local symbols = utils.get_top_level_symbols(result, true)
		show_symbols_picker(symbols, "Top-level Workspace Symbols", true)
	end)
end

return M
