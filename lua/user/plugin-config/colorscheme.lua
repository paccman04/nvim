local colorscheme = "monokai-pro-spectrum"

local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("Color scheme " .. colorscheme .. " not found.")
end
