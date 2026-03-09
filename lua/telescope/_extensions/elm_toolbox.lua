return require("telescope").register_extension({
	exports = {
		document_symbols = require("elm-toolbox.pickers").top_level_document_symbols,
		workspace_symbols = require("elm-toolbox.pickers").top_level_workspace_symbols,
	},
})
