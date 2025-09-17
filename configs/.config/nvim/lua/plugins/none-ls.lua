-- https://github.com/nvimtools/none-ls.nvim
return {
	'nvimtools/none-ls.nvim',
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md
			sources = {
				-- null_ls.builtins.formatting.jq,

				-- All
				-- null_ls.builtins.diagnostics.codespell,
				-- null_ls.builtins.formatting.codespell,

				-- Bazel
				-- null_ls.builtins.diagnostics.buildifier,
				-- null_ls.builtins.formatting.buildifier,

				-- CMake
				-- null_ls.builtins.formatting.cmake_format,

				-- CSS
				-- null_ls.builtins.diagnostics.stylelint,

				-- CSS/JS/TS
				-- null_ls.builtins.formatting.biome,
				-- null_ls.builtins.formatting.stylelint,

				-- GitHub Actions
				null_ls.builtins.diagnostics.actionlint,

				-- Go
				-- null_ls.builtins.diagnostics.golangci_lint,
				-- null_ls.builtins.diagnostics.revive,
				-- null_ls.builtins.diagnostics.staticcheck,

				-- HTML
				-- null_ls.builtins.diagnostics.tidy,
				-- null_ls.builtins.formatting.tidy,

				-- Make
				-- null_ls.builtins.diagnostics.checkmake,

				-- Markdown (or text)
				-- null_ls.builtins.code_actions.proselint,
				-- null_ls.builtins.code_actions.textlint,
				-- null_ls.builtins.diagnostics.markdownlint,
				-- null_ls.builtins.diagnostics.mdl,
				-- null_ls.builtins.diagnostics.proselint,
				-- null_ls.builtins.diagnostics.vale,
				-- null_ls.builtins.diagnostics.write_good,
				-- null_ls.builtins.formatting.cbfmt,
				-- null_ls.builtins.formatting.markdownlint,
				-- null_ls.builtins.formatting.mdformat,
				-- null_ls.builtins.formatting.remark,
				-- null_ls.builtins.formatting.textlint,

				-- Protobuf
				-- null_ls.builtins.diagnostics.buf,
				-- null_ls.builtins.diagnostics.protolint,
				-- null_ls.builtins.formatting.protolint,

				-- Python
				-- null_ls.builtins.diagnostics.pydoclint,
				-- null_ls.builtins.diagnostics.pylint,
				null_ls.builtins.formatting.black,
				-- null_ls.builtins.formatting.blackd,
				-- null_ls.builtins.formatting.isort,
				-- null_ls.builtins.formatting.usort,

				-- Shell
				-- null_ls.builtins.formatting.shellharden,
				-- null_ls.builtins.formatting.shfmt,

				-- SQL
				-- null_ls.builtins.formatting.pg_format,
				-- null_ls.builtins.formatting.sqlfluff.with({ extra_args = { "--dialect", "postgres" } }),
				-- null_ls.builtins.formatting.sqlfmt,
				-- null_ls.builtins.formatting.sqlformat,
				-- null_ls.builtins.formatting.sql_formatter,
				-- null_ls.builtins.formatting.sqruff,

				-- Swift
				-- null_ls.builtins.diagnostics.swiftlint,
				-- null_ls.builtins.formatting.swiftformat,
				-- null_ls.builtins.formatting.swiftlint,

				-- YAML
				-- null_ls.builtins.formatting.yamlfix,

				-- null_ls.builtins.formatting.prettier,
			},
		})
	end,
}
