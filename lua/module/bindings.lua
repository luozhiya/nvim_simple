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

M.semicolon_to_colon = function() M.map('n', ';', ':', { silent = false }) end

M.lsp = {
  { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
  { 'gh', vim.lsp.buf.hover, desc = 'Hover' },
  { 'K', vim.lsp.buf.hover, desc = 'Hover' },
  { 'gn', vim.lsp.buf.rename, desc = 'Rename' },
  { 'ga', '<cmd>CodeActionMenu<cr>', desc = 'Code Action' },
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
    mapping = {
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
    },
  }
end

M.aerial = function()
  return {
    on_attach = function(buffer)
      M.map('n', '{', '<cmd>AerialPrev<cr>', { buffer = buffer })
      M.map('n', '}', '<cmd>AerialNext<cr>', { buffer = buffer })
    end,
  }
end

M.toggleterm = function()
  return {
    open_mapping = [[<c-\>]],
  }
end

M.telescope = function()
  local actions = require('telescope.actions')
  -- stylua: ignore start
  return { defaults = { mappings = { i = {
          ['<esc>'] = actions.close,
        }, }, }, }
  -- stylua: ignore end
end

M.wk = function(wk)
  function _any_toggle(cmd)
    local run = require('toggleterm.terminal').Terminal:new({
      cmd = cmd,
      dir = 'git_dir',
      direction = 'float',
      float_opts = { border = 'double' },
      on_open = function(term)
        vim.cmd('startinsert!')
        M.map('n', 'q', '<cmd>close<CR>', { noremap = true, silent = true, buffer = term.bufnr })
      end,
      on_close = function(term) vim.cmd('startinsert!') end,
    })
    run:toggle()
  end
  -- stylua: ignore start
  local wk_ve = function()
    return {
      name = 'Edit Config',
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
  local n = {
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
      a = { '', 'CloseAll' },
      f = { '<cmd>FlyBuf<cr>', 'Show All Buffers' },
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
      a = { '<cmd>ClangAST<cr>', 'Clang AST' },
      t = { '<cmd>ClangdTypeHierarchy<cr>', 'Clang Type Hierarchy' },
      h = { '<cmd>ClangdSwitchSourceHeader<cr>', 'Switch C/C++ header/source' },
      m = { '<cmd>ClangdMemoryUsage<cr>', 'Clangd Memory Usage' },
      f = { '<cmd>lua vim.lsp.buf.format{async=true}<cr>', 'Code Format' },
      o = { '<cmd>AerialToggle<cr>', 'Outline' },
    },
    d = {
      name = 'Trouble Diagnostics',
      x = { '<cmd>TroubleToggle<cr>', 'Trouble Toggle' },
      w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Trouble Workspace Diagnostics' },
      d = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Trouble Document Diagnostics' },
      l = { '<cmd>TroubleToggle loclist<cr>', 'Trouble Loclist' },
      q = { '<cmd>TroubleToggle quickfix<cr>', 'Trouble Quickfix' },
      r = { '<cmd>TroubleToggle lsp_references<cr>', 'Trouble LSP References' },
    },
    g = {
      name = 'Git',
      l = { function() _any_toggle('lazygit') end, 'Lazygit' },
      g = { function() _any_toggle('gitui') end, 'GitUI' },
      n = { '<cmd>Neogit<cr>', 'Neogit' },
      s = { '<cmd>SublimeMerge<cr>', 'Sublime Merge' },
    },
    t = {
      name = 'Telescope',
      c = { '<cmd>Telescope registers<cr>', 'Register Cached' },
      d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document Diagnostics' },
      f = { '<cmd>Telescope find_files theme=get_dropdown previewer=false<cr>', 'Find files' },
      l = { '<cmd>Telescope live_grep<cr>', 'Find Text' },
      L = { '<cmd>Telescope live_grep_args<cr>', 'Find Text Args' },
      p = { '<cmd>Telescope projects<cr>', 'Projects' },
      r = { '<cmd>Telescope oldfiles<cr>', 'Recently Used Files' },
      R = { '<cmd>Telescope frecency<cr>', 'Mozilla Frecency Algorithm' },
      s = { '<cmd>Telescope lsp_document_symbols<cr>', 'Document Symbols' },
      S = { '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', 'Workspace Symbols' },
      u = { '<cmd>Telescope undo bufnr=0<cr>', 'Undo Tree' },
    },
    c = {
      name = 'Command Terminal',
      h = { '<cmd>ToggleTerm direction=horizontal<cr>', 'Terminal Horizontal' },
      f = { '<cmd>ToggleTerm direction=float<cr>', 'Terminal Floating' },
    },
    r = {
      name = 'rrr Tree',
      r = { '<cmd>Neotree source=filesystem reveal=true position=left<cr>', 'Neo Tree' },
      e = { '<cmd>NvimTreeToggle<cr>', 'Tree Explorer' },
      f = { '<cmd>NvimTreeFindFile<cr>', 'Tree Find' },
    },
    e = {
      name = 'Edit',
      c = {
        name = 'Copy',
        c = { function() require('base').copy_content() end, 'Copy Content' },
        n = { function() require('base').copy_name() end, 'Copy File Name' },
        e = { function() require('base').copy_name_without_ext() end, 'Copy File Name Without Ext' },
        d = { function() require('base').copy_contain_directory() end, 'Copy Contain Directory' },
        p = { function() require('base').copy_path() end, 'Copy Path' },
        r = { function() require('base').copy_relative_path() end, 'Copy Relative Path' },
      },
      f = {
        name = 'File',
        o = { function() require('base').open_with_default_app() end, 'Open With Default APP' },
        c = { function() require('base').reveal_cwd_in_file_explorer() end, 'Reveal CWD In File Explorer' },
        e = { function() require('base').reveal_file_in_file_explorer() end, 'Reveal In File Explorer' },
        t = { function() require('base').reveal_in_tree() end, 'Reveal In Tree' },
        v = { '', 'Open In New Vim' },
      },
    },
  }
  wk.register(n, { mode = 'n', prefix = '<leader>' })
end

M.nvim_tree = function()
  local ts_opts = function(path, tree, any)
    return {
      cwd = path,
      search_dirs = { path },
      attach_mappings = function(prompt_bufnr, map)
        local actions = require('telescope.actions')
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry()
          local filename = selection.filename
          if filename == nil then
            filename = selection[1]
          end
          tree(filename, any)
        end)
        return true
      end,
    }
  end
  local telescope = require('telescope.builtin')
  local fs = require('nvim-tree.actions.node.open-file')
  local path = function()
    local node = require('nvim-tree.lib').get_node_at_cursor()
    if node == nil then
      return
    end
    local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
    local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ':h')
    if node.name == '..' and TreeExplorer ~= nil then
      basedir = TreeExplorer.cwd
    end
    return basedir
  end
-- stylua: ignore start  
  return { view = { mappings = { list = {
          { key = '<c-f>', action_cb = function() telescope.find_files(ts_opts(path(), function(name) fs.fn('preview', name) end)) end, },
          { key = '<c-g>', action_cb = function() telescope.live_grep(ts_opts(path(), function(name) fs.fn('preview', name) end)) end, },
        }, }, }, }
  -- stylua: ignore end
end

M.setup_code = function()
  -- Core
  M.semicolon_to_colon()
  M.map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, noremap = true })
  M.map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, noremap = true })
  M.map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { noremap = true, desc = 'Escape And Clear hlsearch' })
  M.map('n', '<C-j>', '15gj', { noremap = true, desc = 'Move Down 15 Lines' })
  M.map('n', '<C-k>', '15gk', { noremap = true, desc = 'Move Up 15 Lines' })
  M.map('n', '<left>', '<C-w>h', { desc = 'Jump Left' })
  M.map('n', '<down>', '<C-w>j', { desc = 'Jump Down' })
  M.map('n', '<up>', '<C-w>k', { desc = 'Jump Up' })
  M.map('n', '<right>', '<C-w>l', { desc = 'Jump Right' })
  M.map('n', '<a-q>', '<cmd>ToggleWrap<cr>', { desc = 'Toggle Wrap' })
  M.map('v', '<', '<gv', { noremap = true, desc = 'deIndent Continuously' })
  M.map('v', '>', '>gv', { noremap = true, desc = 'Indent Continuously' })
  -- Edit
  M.map('n', '<leader>cc', function() require('Comment.api').toggle.linewise.current() end, { desc = 'Comment Line (Comment.nvim)' })
  M.map('x', '<leader>cc', function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment.api').toggle.linewise(vim.fn.visualmode())
  end, { desc = 'Comment Line (Comment.nvim)' })
  M.map('n', '<leader>cb', function() require('Comment.api').toggle.blockwise.current() end, { desc = 'Comment Line (Comment.nvim)' })
  M.map('x', '<leader>cb', function()
    local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
    vim.api.nvim_feedkeys(esc, 'nx', false)
    require('Comment.api').toggle.blockwise(vim.fn.visualmode())
  end, { desc = 'Comment Block (Comment.nvim)' })
  -- Selection
  M.map('n', '<A-j>', '<cmd>MoveLine(1)<cr>', { noremap = true, desc = 'Line: Move Up (move.nvim)' })
  M.map('n', '<A-k>', '<cmd>MoveLine(-1)<cr>', { noremap = true, desc = 'Line: Move Down (move.nvim)' })
  M.map('n', '<A-h>', '<cmd>MoveHChar(-1)<cr>', { noremap = true, desc = 'Line: Move Left (move.nvim)' })
  M.map('n', '<A-l>', '<cmd>MoveHChar(1)<cr>', { noremap = true, desc = 'Line: Move Right (move.nvim)' })
  M.map('v', '<A-j>', '<cmd>MoveBlock(1)<cr>', { noremap = true, desc = 'Block: Move Up (move.nvim)' })
  M.map('v', '<A-k>', '<cmd>MoveBlock(-1)<cr>', { noremap = true, desc = 'Block: Move Down (move.nvim)' })
  M.map('v', '<A-h>', '<cmd>MoveHBlock(-1)<cr>', { noremap = true, desc = 'Block: Move Left (move.nvim)' })
  M.map('v', '<A-l>', '<cmd>MoveHBlock(1)<cr>', { noremap = true, desc = 'Block: Move Right (move.nvim)' })
  -- View
  M.map('n', [[\]], '<cmd>Telescope cmdline<cr>', { noremap = true, desc = 'Cmdline... (telescope-cmdline.nvim)' })
  M.map('n', '<c-s-p>', '<cmd>Telescope commands<cr>', { noremap = true, desc = 'Command Palette... (telescope.nvim)' })
  -- Go
  M.map('n', '<c-p>', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown previewer=false<cr>', { noremap = true, desc = 'Go To File... (telescope.nvim)' })
  -- Run
  -- Terminal
  M.map('n', [[<c-\>]], '<cmd>ToggleTerm<cr>', { desc = 'Toggle Terminal' })
end

M.setup_comands = function()
  vim.api.nvim_create_user_command('BufferCloseOthers', function() require('close_buffers').wipe({ type = 'other' }) end, { desc = 'Close Others' })
  vim.api.nvim_create_user_command('ToggleWrap', function() vim.opt.wrap = vim.opt.wrap._value == false end, { desc = 'Toggle Wrap' })
  vim.api.nvim_create_user_command('ToggleFocusMode', function() vim.opt.laststatus = vim.opt.laststatus._value == 0 and 3 or 0 end, { desc = 'Toggle Focus Mode' })
  vim.api.nvim_create_user_command('SublimeMerge', function()
    local Job = require('plenary.job')
    Job:new({
      command = 'sublime_merge',
      args = { '-n', require('base').to_native(vim.fn.getcwd()) },
    }):start()
  end, { desc = 'Sublime Merge' })
end

M.setup_autocmd = function()
  local augroup = vim.api.nvim_create_augroup('bindings.lua', {})
  vim.api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    pattern = '*',
    callback = function(args)
      local info = vim.loop.fs_stat(args.file)
      if info and info.type == 'directory' then
        require('module.settings').config('nvim-tree/nvim-tree.lua')()
        require('nvim-tree.api').tree.toggle({ path = args.file, find_file = true })
      end
    end,
    desc = 'Hijack Directories',
  })
end

return M
