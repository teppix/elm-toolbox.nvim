local M = {}

function M.setup(opts)
	M.config = opts or {}
end

-- Re-export pickers for convenience
M.document_symbols = function()
	require("elm-toolbox.pickers").top_level_document_symbols()
end

M.workspace_symbols = function()
	require("elm-toolbox.pickers").top_level_workspace_symbols()
end

return M
