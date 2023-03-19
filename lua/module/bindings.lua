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

map('n', '<c-p>', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown previewer=false<cr>')
map('n', '<c-s-p>', '<cmd>Telescope commands<cr>')

vim.cmd([[
  command -nargs=+ LspHover lua vim.lsp.buf.hover()
  set keywordprg=:LspHover
]])
M.lsp = {
  { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
  { 'gh', vim.lsp.buf.hover, desc = 'Hover' },
  { 'gn', vim.lsp.buf.rename, desc = 'Rename' },
  { 'ga', vim.lsp.buf.code_action, desc = 'Code Action' },
  { '[d', vim.diagnostic.goto_prev, desc = 'Goto Diagnostic Prev' },
  { ']d', vim.diagnostic.goto_next, desc = 'Goto Diagnostic Next' },
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
  map('n', '{', '<cmd>AerialPrev<cr>', { buffer = buffer })
  map('n', '}', '<cmd>AerialNext<cr>', { buffer = buffer })
end

M.toggleterm = function()
  return {
    open_mapping = [[<c-\>]],
    on_open = function(buffer)
      map('n', 'q', '<cmd>close<CR>', { noremap = true, silent = true, buffer = buffer })
    end,
  }
end

M.wk = function()
  return {
    ['o'] = { '<cmd>e! $MYVIMRC<cr>', 'Edit config' },
    ['q'] = { '<cmd>qa<CR>', 'Quit All' },
    ['f'] = { "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", 'Find files' },
    l = {
      name = 'LSP',
      i = { '<cmd>LspInfo<cr>', 'Info' },
      f = { '<cmd>lua vim.lsp.buf.format{async=true}<cr>', 'Format' },
    },
    c = {
      name = 'Clangd',
      a = { '<cmd>ClangAST<cr>', 'Clang AST' },
      t = { '<cmd>ClangdTypeHierarchy<cr>', 'Clang Type Hierarchy' },
      h = { '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch C/C++ header/source' },
      m = { '<cmd>ClangdMemoryUsage<cr>', 'Clangd Memory Usage' },
    },
    g = {
      name = 'Git',
      l = { '<cmd>ToggleTerminalLazyGit<cr>', 'Lazygit' },
      g = { '<cmd>ToggleTerminalGitUI<cr>', 'GitUI' },
    },
    t = {
      name = 'Telescope',
      d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document Diagnostics' },
      a = { '<cmd>Telescope aerial bufnr=0<cr>', 'Document Aerial Outline' },
      u = { '<cmd>Telescope undo bufnr=0<cr>', 'Undo Tree' },
      p = { '<cmd>Telescope projects<cr>', 'Projects' },
      o = { '<cmd>Telescope oldfiles<cr>', 'Recently Used Files' },
      O = { '<cmd>Telescope frecency<cr>', 'Mozilla Frecency Algorithm' },
      l = { '<cmd>Telescope live_grep<cr>', 'Find Text' },
      L = { '<cmd>Telescope live_grep_args<cr>', 'Find Text Args' },
      f = { '<cmd>Telescope file_browser<cr>', 'File Browser' },
      s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
      S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
    },
    e = {
      name = 'Terminal',
      h = { '<cmd>ToggleTerm direction=horizontal<cr>', 'Terminal Horizontal' },
      f = { '<cmd>ToggleTerm direction=float<cr>', 'Terminal Floating' },
    },
    r = {
      name = 'Tree',
      e = { '<cmd>NvimTreeToggle<cr>', 'Tree Explorer' },
      f = { '<cmd>NvimTreeFindFile<cr>', 'Tree Find' },
    },
    z = {
      name = 'Lazy',
      i = { '<cmd>Lazy<cr>', 'Lazy Dashboard' },
      p = { '<cmd>Lazy profile<cr>', 'Lazy Profile' },
      u = { '<cmd>Lazy update<cr>', 'Lazy Update' },
      c = { '<cmd>Lazy clean<cr>', 'Lazy Clean' },
    },
  }
end

M.telescope_file_browser = function(fb_actions)
  return {
    i = {
      ['<c-n>'] = fb_actions.create,
      ['<c-r>'] = fb_actions.rename,
      ['<c-h>'] = fb_actions.toggle_hidden,
      ['<c-x>'] = fb_actions.remove,
      ['<c-p>'] = fb_actions.move,
      ['<c-y>'] = fb_actions.copy,
      ['<c-a>'] = fb_actions.select_all,
    },
  }
end

M.tree = function(fx)
  return {
    list = {
      {
        key = '<c-f>',
        action_cb = function()
          return fx('find_files')
        end,
      },
      {
        key = '<c-g>',
        action_cb = function()
          return fx('live_grep')
        end,
      },
    },
  }
end

return M
