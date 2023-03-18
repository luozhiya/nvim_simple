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
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
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

require('clangd_extensions').setup({
  server = {
    on_attach = function(client, buffer)
      for _, keys in pairs(bindings.lsp) do
        bindings.map(keys.mode or 'n', keys[1], keys[2], { noremap = true, silent = true, buffer = buffer })
      end
    end,
    capabilities = (function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = false
      return capabilities
    end)(),
  },
})
