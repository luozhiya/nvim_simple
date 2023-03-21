local M = {}

M.map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.setup_leader = function()
  vim.g.mapleader = ','
  vim.g.maplocalleader = ','
end

M.setup_vim = function()
  vim.cmd([[
    nnoremap ; :
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;
    command -nargs=+ LspHover lua vim.lsp.buf.hover()
    set keywordprg=:LspHover    
  ]])
  M.map('n', '<M-h>', '<C-w>h', { desc = 'Go to left window' })
  M.map('n', '<M-j>', '<C-w>j', { desc = 'Go to lower window' })
  M.map('n', '<M-k>', '<C-w>k', { desc = 'Go to upper window' })
  M.map('n', '<M-l>', '<C-w>l', { desc = 'Go to right window' })
  M.map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  M.map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  M.map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
  M.map('n', '<C-j>', '15gj')
  M.map('n', '<C-k>', '15gk')
  M.map('v', '<', '<gv')
  M.map('v', '>', '>gv')
end

M.setup_st = function()
  M.map('n', '<c-p>', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown previewer=false<cr>')
  M.map('n', '<c-s-p>', '<cmd>Telescope commands<cr>')
  M.map('n', '<M-cr>', '<cmd>FineCmdline<cr>')
  M.map('n', [[\]], '<cmd>Telescope cmdline<cr>')
  -- stylua: ignore start
  local comment = function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    local toggle = require('Comment.api').toggle
    M.map('n', '<leader>cc', toggle.linewise.current, { desc = 'Comment Line' })
    M.map('n', '<leader>cb', toggle.blockwise.current, { desc = 'Comment Block' })
    M.map('x', '<leader>cc', function() vim.api.nvim_feedkeys(esc, 'nx', false) toggle.linewise(vim.fn.visualmode()) end, { desc = 'Comment Line' })
    M.map('x', '<leader>cb', function() vim.api.nvim_feedkeys(esc, 'nx', false) toggle.blockwise(vim.fn.visualmode()) end, { desc = 'Comment Block' })
  end
  -- stylua: ignore end
  comment()
end

M.lsp = {
  { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
  { 'gh', vim.lsp.buf.hover, desc = 'Hover' },
  { 'gn', vim.lsp.buf.rename, desc = 'Rename' },
  { 'ga', vim.lsp.buf.code_action, desc = 'Code Action' },
  { '[d', vim.diagnostic.goto_prev, desc = 'Goto Diagnostic Prev' },
  { ']d', vim.diagnostic.goto_next, desc = 'Goto Diagnostic Next' },
}

M.cmp = function(cmp)
  local forward = function()
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' })
  end
  local backward = function()
    return cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif require('luasnip').jumpable(-1) then
        require('luasnip').jump(-1)
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
    ['<cr>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<Tab>'] = forward(),
    ['<S-Tab>'] = backward(),
    ['<C-y>'] = cmp.mapping.confirm({ select = false }),
    ['<C-e>'] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
  }
end

M.aerial = function(buffer)
  M.map('n', '{', '<cmd>AerialPrev<cr>', { buffer = buffer })
  M.map('n', '}', '<cmd>AerialNext<cr>', { buffer = buffer })
end

M.toggleterm = function()
  return {
    open_mapping = [[<c-\>]],
    on_open = function(buffer)
      M.map('n', 'q', '<cmd>close<cr>', { noremap = true, silent = true, buffer = buffer })
    end,
  }
end

M.wk = function()
  -- stylua: ignore start
  local wk_ve = function()
    return {
      name = 'Edit',
      i = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/init.lua') end,                'init.lua (bootstrap)' },
      b = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/base.lua') end,            'base.lua' },
      k = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/bindings.lua') end, 'bindings.lua' },
      l = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/lsp.lua') end,      'lsp.lua' },
      o = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/options.lua') end,  'options.lua' },
      p = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/plugins.lua') end,  'plugins.lua' },
      s = { function() vim.cmd('e ' .. vim.fn.stdpath('config') .. '/lua/module/settings.lua') end, 'settings.lua' },
    }
  end
  -- stylua: ignore end
  return {
    s = {
      name = 'Session',
      q = { '<cmd>qa<cr>', 'Quit All' },
      w = { '<cmd>wqall<cr>', 'Quit And Save Everything' },
      f = { '<cmd>q!<cr>', 'Quit Force' },
      F = { '<cmd>qa!<cr>', 'Quit All Force' },
      s = { '<cmd>w<cr>', 'Save' },
      S = { '<cmd>Obsession ~/session.vim<cr>', 'Save Session' },
      r = { '<cmd>Obsession ~/session.vim<cr>:!start neovide -- -S ~/session.vim<cr><cr>:wqall<cr>', 'Quit And Reload' },
    },
    w = {
      name = 'Windows',
      h = { '<C-w>h', 'Jump Left' },
      j = { '<C-w>j', 'Jump Down' },
      k = { '<C-w>k', 'Jump Up' },
      l = { '<C-w>l', 'Jump Right' },
      y = { '<cmd>vsplit<cr><esc>', 'Split Left' },
      u = { '<cmd>split<cr><C-w>j<esc>', 'Split Down' },
      i = { '<cmd>split<cr><esc>', 'Split Up' },
      o = { '<cmd>vsplit<cr><C-w>l<esc>', 'Split Right' },
    },
    b = {
      name = 'Buffer',
      b = { '<cmd>Buffers<cr>', 'Buffers' },
      h = { '<cmd>bprevious<cr>', 'Previous' },
      l = { '<cmd>bnext<cr>', 'Next' },
      k = { '<cmd>bfirst<cr>', 'First' },
      j = { '<cmd>blast<cr>', 'Last' },
      d = { '<cmd>BD<cr>', 'Delete' },
      o = { '<cmd>BufferCloseOthers<cr>', 'Only, Close Others' },
    },
    v = {
      name = 'Vim',
      i = { '<cmd>Lazy<cr>', 'Lazy Dashboard' },
      p = { '<cmd>Lazy profile<cr>', 'Lazy Profile' },
      u = { '<cmd>Lazy update<cr>', 'Lazy Update' },
      c = { '<cmd>Lazy clean<cr>', 'Lazy Clean' },
      f = { '<cmd>ToggleFocusMode<cr>', 'Focus Mode' },
      e = wk_ve(),
    },
    l = {
      name = 'LSP',
      i = { '<cmd>LspInfo<cr>', 'Info' },
    },
    c = {
      name = 'Code',
      a = { '<cmd>ClangAST<cr>', 'Clang AST' },
      t = { '<cmd>ClangdTypeHierarchy<cr>', 'Clang Type Hierarchy' },
      h = { '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch C/C++ header/source' },
      m = { '<cmd>ClangdMemoryUsage<cr>', 'Clangd Memory Usage' },
      f = { '<cmd>lua vim.lsp.buf.format{async=true}<cr>', 'Code Format' },
    },
    g = {
      name = 'Git',
      l = { '<cmd>ToggleTerminalLazyGit<cr>', 'Lazygit' },
      g = { '<cmd>ToggleTerminalGitUI<cr>', 'GitUI' },
    },
    e = {
      name = 'Telescope',
      d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document Diagnostics' },
      a = { '<cmd>Telescope aerial bufnr=0<cr>', 'Document Aerial Outline' },
      u = { '<cmd>Telescope undo bufnr=0<cr>', 'Undo Tree' },
      p = { '<cmd>Telescope projects<cr>', 'Projects' },
      r = { '<cmd>Telescope oldfiles<cr>', 'Recently Used Files' },
      R = { '<cmd>Telescope frecency<cr>', 'Mozilla Frecency Algorithm' },
      l = { '<cmd>Telescope live_grep<cr>', 'Find Text' },
      L = { '<cmd>Telescope live_grep_args<cr>', 'Find Text Args' },
      e = { '<cmd>Telescope file_browser<cr>', 'File Explorer' },
      s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
      S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
      f = { '<cmd>Telescope find_files theme=get_dropdown previewer=false<cr>', 'Find files' },
    },
    t = {
      name = 'Terminal',
      h = { '<cmd>ToggleTerm direction=horizontal<cr>', 'Terminal Horizontal' },
      f = { '<cmd>ToggleTerm direction=float<cr>', 'Terminal Floating' },
    },
    r = {
      name = 'Tree',
      e = { '<cmd>NvimTreeToggle<cr>', 'Tree Explorer' },
      f = { '<cmd>NvimTreeFindFile<cr>', 'Tree Find' },
    },
  }
end

M.t_fb = function(fb_actions)
  return { i = {
    ['<c-n>'] = fb_actions.create,
    ['<c-r>'] = fb_actions.rename,
    ['<c-h>'] = fb_actions.toggle_hidden,
    ['<c-x>'] = fb_actions.remove,
    ['<c-p>'] = fb_actions.move,
    ['<c-y>'] = fb_actions.copy,
    ['<c-a>'] = fb_actions.select_all,
  } }
end

-- stylua: ignore start
M.tree = function(fx)
  return { list = {
    { key = '<c-f>', action_cb = function() return fx('find_files') end },
    { key = '<c-g>', action_cb = function() return fx('live_grep') end },
  } }
end
-- stylua: ignore end

return M
