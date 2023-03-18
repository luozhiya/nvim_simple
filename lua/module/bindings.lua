local M = {}
vim.g.mapleader = ','
vim.g.maplocalleader = ','

local function map(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end
M.map = map

vim.cmd([[
  nnoremap ; :
  nnoremap : ;
  vnoremap ; :
  vnoremap : ;
]])

map('n', '<M-h>', '<C-w>h', { desc = 'Go to left window' })
map('n', '<M-j>', '<C-w>j', { desc = 'Go to lower window' })
map('n', '<M-k>', '<C-w>k', { desc = 'Go to upper window' })
map('n', '<M-l>', '<C-w>l', { desc = 'Go to right window' })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
map('n', '<C-j>', '15gj')
map('n', '<C-k>', '15gk')

M.lsp = {
  { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
  { 'K', vim.lsp.buf.hover, desc = 'Hover' },
  { 'gn', vim.lsp.buf.rename, desc = 'Rename' },
  { 'ga', vim.lsp.buf.code_action, desc = 'Code Action' },
}

M.cmp = function(cmp)
  local loop = function(forward)
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        if forward then
          cmp.select_next_item()
        else
          cmp.select_prev_item()
        end
      else
        fallback()
      end
    end, { 'i', 's' })
  end
  return {
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<Up>'] = cmp.mapping.select_prev_item(),
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<Tab>'] = loop(true),
    ['<S-Tab>'] = loop(false),
    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
  }
end

M.aerial = function(buffer)
  map('n', '{', '<cmd>AerialPrev<CR>', { buffer = buffer })
  map('n', '}', '<cmd>AerialNext<CR>', { buffer = buffer })
end

M.wk = function()
  return {
    ['a'] = { '<cmd>AerialToggle!<CR>', 'Toggle aerial' },
    ['o'] = { '<cmd>:e! $MYVIMRC<cr>', 'Edit config' },
    ['f'] = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", 'Find files' },
    l = {
      name = 'LSP',
      i = { '<cmd>LspInfo<cr>', 'Info' },
      d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document Diagnostics' },
      f = { '<cmd>lua vim.lsp.buf.format{async=true}<cr>', 'Format' },
      h = { '<esc>:ClangdSwitchSourceHeader<cr>', 'Switch C/C++ header/source' },
    },
  }
end

return M
