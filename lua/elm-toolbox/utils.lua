local M = {}

M.notify = function(msg, level)
	vim.notify(string.format("[elm-toolbox] %s", msg), level or vim.log.levels.INFO)
end

M.get_top_level_symbols = function(result)
	local symbols = {}
	for _, symbol in ipairs(result) do
		local range = symbol.range or (symbol.location and symbol.location.range)
		if range then
			local start_col = range.start.character + 1
			if start_col == 1 then
				local filename = symbol.location and vim.uri_to_fname(symbol.location.uri) or vim.api.nvim_buf_get_name(0)
				table.insert(symbols, {
					name = symbol.name,
					kind = symbol.kind,
					lnum = range.start.line + 1,
					col = start_col,
					filename = filename,
				})
			end
		end
	end

	return symbols
end

return M
