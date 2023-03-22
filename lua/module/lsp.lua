local bindings = require('module.bindings')

local M = {}
M.setup = function()
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
  require('mason').setup()
  require('mason-lspconfig').setup({ ensure_installed = { 'lua_ls' } })
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
  require('clangd_extensions').setup({ server = { filetypes = { 'c', 'cpp' }, on_attach = lsp_on_attach, capabilities = lsp_capabilities } })
  require('neodev').setup()
  require('lspconfig').lua_ls.setup({ on_attach = lsp_on_attach, capabilities = lsp_capabilities })
end

return M
