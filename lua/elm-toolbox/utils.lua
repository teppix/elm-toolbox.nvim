local M = {}

M.get_top_level_symbols = function(result, is_workspace)
	local symbols = {}
	for _, symbol in ipairs(result) do
		local start_line, start_col, filename

		if is_workspace then
			start_line = symbol.location.range.start.line + 1
			start_col = symbol.location.range.start.character + 1
			filename = vim.uri_to_fname(symbol.location.uri)
		else
			local range = symbol.range or symbol.location.range
			start_line = range.start.line + 1
			start_col = range.start.character + 1
			filename = vim.api.nvim_buf_get_name(0)
		end

		if start_col == 1 then
			table.insert(symbols, {
				name = symbol.name,
				kind = symbol.kind,
				lnum = start_line,
				col = start_col,
				filename = filename,
			})
		end
	end

	return symbols
end

return M
