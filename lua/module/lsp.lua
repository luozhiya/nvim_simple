local bindings = require('module.bindings')
local plugin_installed = require('base').plugin_installed

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'rounded',
  width = 60,
})
vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
  signs = false,
  update_in_insert = false,
  underline = true,
})

if plugin_installed('williamboman/mason.nvim') then
  require('mason').setup({})
  require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls' } })
end

if plugin_installed('hrsh7th/nvim-cmp') then
  local cmp = require('cmp')
  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'luasnip' },
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.menu = ({ nvim_lsp = '[LSP]', buffer = '[Buffer]', path = '[Path]' })[entry.source.name]
        local max = 45
        local content = vim_item.abbr
        if #content > max then
          vim_item.abbr = vim.fn.strcharpart(content, 0, max) .. '…'
        else
          vim_item.abbr = content .. (' '):rep(max - #content)
        end
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = bindings.cmp(cmp),
    completion = { completeopt = 'menuone, noinsert, noselect' },
    experimental = { ghost_text = true },
  })
  require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged, TextChangedI' })
  require('luasnip.loaders.from_vscode').load()
  require('nvim-autopairs').setup()
  cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } },
  })
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
      { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
    }),
  })
end

local lsp_on_attach = function(client, buffer)
  for _, keys in pairs(bindings.lsp) do
    bindings.map(keys.mode or 'n', keys[1], keys[2], { noremap = true, silent = true, buffer = buffer })
  end
end

local lsp_capabilities = (function()
  local ex = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  ex.textDocument.completion.completionItem.snippetSupport = true
  ex.textDocument.completion.completionItem.resolveSupport = { properties = { 'documentation', 'detail', 'additionalTextEdits' } }
  return ex
end)()

if plugin_installed('p00f/clangd_extensions.nvim') then
  require('clangd_extensions').setup({ server = { filetypes = { 'c', 'cpp' }, on_attach = lsp_on_attach, capabilities = lsp_capabilities } })
end

if plugin_installed('folke/neodev.nvim') then
  require('neodev').setup({})
  require('lspconfig').lua_ls.setup({ on_attach = lsp_on_attach, capabilities = lsp_capabilities })
end

if plugin_installed('ray-x/lsp_signature.nvim') then
  require('lsp_signature').setup({ hint_prefix = ' ' })
end

if plugin_installed('j-hui/fidget.nvim') then
  vim.cmd([[highlight FidgetTitle ctermfg=110 guifg=#0887c7]])
  vim.cmd([[highlight FidgetTask ctermfg=110 guifg=#0887c7]])
  require('fidget').setup({ text = { done = ' ' }, window = { blend = 0 } })
end
