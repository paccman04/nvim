-- local parsers_ok, treesitter_parsers = pcall(require, "nvim-treesitter.parsers")
-- if not parsers_ok then
--   vim.notify("require(\"nvim-treesitter.parsers\") failed.")
--   return
-- end

-- local parser_config = treesitter_parsers.get_parser_configs()
-- parser_config.mcfunction = {
--   install_info = {
--     url = "https://github.com/IoeCmcomc/tree-sitter-mcfunction",
--     files = { "src/parser.c" },
--     branch = "main",
--   },
-- }

local configs_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not configs_ok then
  vim.notify("require(\"nvim-treesitter.configs\") failed.")
  return
end

treesitter_configs.setup {
  ensure_installed = "all",
  ignore_install = { "ipkg" },
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
  },
}
