local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if not autopairs_ok then
  vim.notify("require(\"nvim-autopairs\") failed.")
  return
end

autopairs.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local keymap = vim.keymap.set
    local opts = { buffer = event.buf }

    keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    keymap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    keymap({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    keymap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end
})

local cmplsp_ok, cmplsp = pcall(require, "cmp_nvim_lsp")
if not cmplsp_ok then
  vim.notify("require(\"cmp_nvim_lsp\") failed.")
  return
end

local lsp_capabilities = cmplsp.default_capabilities()

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
  vim.notify("require(\"lspconfig\") failed.")
  return
end

local default_setup = function(server)
  lspconfig[server].setup({
    capabilities = lsp_capabilities,
  })
end

local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
  vim.notify("require(\"mason\") failed.")
  return
end

mason.setup({})

local masonconfig_ok, masonconfig = pcall(require, "mason-lspconfig")
if not masonconfig_ok then
  vim.notify("require(\"mason-lspconfig\") failed.")
  return
end

masonconfig.setup({
  ensure_installed = {
    "bashls",                          -- Bash
    "clangd",                          -- C and C++
    "omnisharp",                       -- C#
    "cmake",                           -- CMake
    "cssls",                           -- CSS
    "dockerls",                        -- Docker
    "docker_compose_language_service", -- Docker Compose
    "eslint",                          -- ESLint
    "html",                            -- HTML
    "biome",                           -- JavaScript, TypeScript, and JSON
    "java_language_server",            -- Java
    "ltex",                            -- LaTeX
    "lua_ls",                          -- Lua
    "marksman",                        -- Markdown
    "matlab_ls",                       -- Matlab
    "powershell_es",                   -- Powershell
    "pyright",                         -- Python
    "r_language_server",               -- R
    "rust_analyzer",                   -- Rust
    "sqls",                            -- SQL
    "ts_ls",                           -- TypeScript
    "lemminx",                         -- XML
  },
  handlers = {
    default_setup,
    lua_ls = function()
      lspconfig.lua_ls.setup({
        capabilities = lsp_capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim', 'check_backspace' },
            },
            workspace = {
              library = {
                vim.env.VIMRUNTIME,
              }
            },
          },
        },
      })
    end
  },
})

local mason_null_ls_ok, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_ok then
  vim.notify("require(\"mason-null-ls\") failed.")
  return
end

mason_null_ls.setup({
  ensure_installed = { "black" }
})

local null_ls_ok, null_ls = pcall(require, "null-ls")
if not null_ls_ok then
  vim.notify("require(\"null-ls\") failed.")
  return
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
  },
})

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
  vim.notify("require(\"cmp\") failed.")
  return
end

local autopairscmp_ok, autopairscmp = pcall(require, "nvim-autopairs.completion.cmp")
if not autopairscmp_ok then
  vim.notify("require(\"nvim-autopairs.completion.cmp\") failed.")
  return
end

cmp.event:on(
  "confirm_done",
  autopairscmp.on_confirm_done()
)

local luasnip_ok, luasnip = pcall(require, "luasnip")
if not luasnip_ok then
  vim.notify("require(\"cmp_nvim_ultisnips.mappings\") failed.")
  return
end

local friendlysnippets_ok, friendlysnippets = pcall(require, "luasnip.loaders.from_vscode")
if not friendlysnippets_ok then
  vim.notify("require(\"friendly-snippets\") failed.")
end

friendlysnippets.lazy_load()

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  mapping = cmp.mapping.preset.insert({
    -- Ctrl + space triggers completion menu
    ['<C-s>'] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

    -- Enter to accept
    ["<CR>"] = cmp.mapping.confirm { select = true },

    -- Ctrl n and p to navigate completion menu
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  }),
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
})
