local utils = require("elm-toolbox.utils")

local M = {}

local function show_symbols_picker(symbols, title)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	local opts = {}
	pickers
		.new(opts, {
			prompt_title = title,
			finder = finders.new_table({
				results = symbols,
				entry_maker = make_entry.gen_from_lsp_symbols(opts),
			}),
			previewer = conf.qflist_previewer(opts),
			sorter = conf.generic_sorter(opts),
		})
		:find()
end

M.top_level_document_symbols = function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		utils.notify("No LSP client attached to this buffer", vim.log.levels.WARN)
		return
	end

	local params = { textDocument = vim.lsp.util.make_text_document_params() }
	vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result)
		if err then
			utils.notify("Error when getting document symbols", vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			utils.notify("No symbols found")
			return
		end

		local symbols = utils.get_top_level_symbols(result)
		show_symbols_picker(symbols, "Top-level Document Symbols")
	end)
end

M.top_level_workspace_symbols = function()
	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		utils.notify("No LSP clients active", vim.log.levels.WARN)
		return
	end

	vim.lsp.buf_request(0, "workspace/symbol", { query = "" }, function(err, result)
		if err then
			utils.notify("Error when getting workspace symbols", vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			utils.notify("No symbols found")
			return
		end

		local symbols = utils.get_top_level_symbols(result)
		show_symbols_picker(symbols, "Top-level Workspace Symbols")
	end)
end

return M
