local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  vim.notify("require(\"nvim-treesitter.configs\") failed.")
  return
end

treesitter.setup {
  ensure_installed = "all",
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
  },
}
