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

local bindings = require('module.bindings')
local plugin_installed = require('module.base').plugin_installed

if plugin_installed('hrsh7th/nvim-cmp') then
  local cmp = require('cmp')
  cmp.setup({
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'path' },
    },
    formatting = {
      fields = { 'kind', 'abbr', 'menu' },
      format = function(entry, vim_item)
        vim_item.menu = ({
          nvim_lsp = '[LSP]',
          buffer = '[Buffer]',
          path = '[Path]',
        })[entry.source.name]
        local ellipsis = '…'
        local label = 45
        local fill_ws = function(max, len)
          return (' '):rep(max - len)
        end
        local content = vim_item.abbr
        if #content > label then
          vim_item.abbr = vim.fn.strcharpart(content, 0, label) .. ellipsis
        else
          vim_item.abbr = content .. fill_ws(label, #content)
        end
        return vim_item
      end,
    },
    mapping = bindings.cmp(cmp),
  })
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = { { name = 'buffer' } },
  })
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' },
    }, {
      {
        name = 'cmdline',
        option = { ignore_cmds = { 'Man', '!' } },
      },
    }),
  })
end

if plugin_installed('p00f/clangd_extensions.nvim') then
  require('clangd_extensions').setup({
    server = {
      filetypes = { 'c', 'cpp' },
      on_attach = function(client, buffer)
        for _, keys in pairs(bindings.lsp) do
          bindings.map(keys.mode or 'n', keys[1], keys[2], { noremap = true, silent = true, buffer = buffer })
        end
      end,
      capabilities = (function()
        if plugin_installed('hrsh7th/nvim-cmp') then
          local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
          capabilities.textDocument.completion.completionItem.snippetSupport = false
          return capabilities
        else
          return vim.lsp.protocol.make_client_capabilities()
        end
      end)(),
    },
  })
end

if plugin_installed('ray-x/lsp_signature.nvim') then
  require('lsp_signature').setup({})
end
