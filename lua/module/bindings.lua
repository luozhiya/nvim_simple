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

M.semicolon_to_colon = function()
  vim.cmd([[
    nnoremap ; :
    nnoremap : ;
    vnoremap ; :
    vnoremap : ;
  ]])
  -- M.map('n', ';', ':', { silent = false })
end

M.lsp = {
  { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
  { 'gh', vim.lsp.buf.hover, desc = 'Hover' },
  { 'K', vim.lsp.buf.hover, desc = 'Hover' },
  { 'L', '<cmd>Lspsaga show_line_diagnostics<CR>', 'Show Line Diagnostics' },
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
      l = {
        name = 'lspsaga',
        l = { '<cmd>Lspsaga show_line_diagnostics<CR>', 'Lspsaga Show Line Diagnostics' },
      },
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
      v = {
        name = 'VGit',
        s = { [[<cmd>lua require('vgit').buffer_hunk_stage()<cr>]], 'Buffer Hunk Stage' },
        r = { [[<cmd>lua require('vgit').buffer_hunk_reset()<cr>]], 'Buffer Hunk Reset' },
        p = { [[<cmd>lua require('vgit').buffer_hunk_preview()<cr>]], 'Buffer Hunk Preview' },
        b = { [[<cmd>lua require('vgit').buffer_blame_preview()<cr>]], 'Buffer Blame Preview' },
        f = { [[<cmd>lua require('vgit').buffer_diff_preview()<cr>]], 'Buffer Diff Preview' },
        h = { [[<cmd>lua require('vgit').buffer_history_preview()<cr>]], 'Buffer History Preview' },
        u = { [[<cmd>lua require('vgit').buffer_reset()<cr>]], 'Buffer Reset' },
        g = { [[<cmd>lua require('vgit').buffer_gutter_blame_preview()<cr>]], 'Buffer Gutter Blame Preview' },
        d = { [[<cmd>lua require('vgit').project_diff_preview()<cr>]], 'Project Diff Preview' },
        q = { [[<cmd>lua require('vgit').project_hunks_qf()<cr>]], 'Project Hunks QF' },
        x = { [[<cmd>lua require('vgit').toggle_diff_preference()<cr>]], 'Toggle Diff Preference' },
        l = { [[<cmd>lua require('vgit').buffer_hunks_preview()<cr>]], 'Buffer Hunks Preview' },
        m = { [[<cmd>lua require('vgit').project_hunks_staged_preview()<cr>]], 'Project Hunks Staged Preview' },
      },
    },
    t = {
      name = 'Telescope',
      a = { '<cmd>Telescope aerial bufnr=0<cr>', 'Document Aerial Outline' },
      c = { '<cmd>Telescope registers<cr>', 'Register Cached' },
      d = { '<cmd>Telescope diagnostics bufnr=0<cr>', 'Document Diagnostics' },
      e = { '<cmd>Telescope file_browser<cr>', 'File Explorer' },
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

M.telescope = function(telescope)
  local actions = telescope.extensions.file_browser.actions
  return {
    extensions = {
      file_browser = {
        mappings = {
          i = {
            ['<c-n>'] = actions.create,
            ['<c-r>'] = actions.rename,
            ['<c-h>'] = actions.toggle_hidden,
            ['<c-x>'] = actions.remove,
            ['<c-p>'] = actions.move,
            ['<c-y>'] = actions.copy,
            ['<c-a>'] = actions.select_all,
          },
        },
      },
    },
  }
end

M.nvim_tree = function()
  local launch_telescope_ontree = function(action, opts)
    local actions = require('telescope.actions')
    local node = require('nvim-tree.lib').get_node_at_cursor()
    if node == nil then
      return
    end
    local is_folder = node.fs_stat and node.fs_stat.type == 'directory' or false
    local basedir = is_folder and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ':h')
    if node.name == '..' and TreeExplorer ~= nil then
      basedir = TreeExplorer.cwd
    end
    opts = opts or {}
    opts.cwd = basedir
    opts.search_dirs = { basedir }
    opts.attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = require('telescope.actions.state').get_selected_entry()
        local filename = selection.filename
        if filename == nil then
          filename = selection[1]
        end
        require('nvim-tree.actions.node.open-file').fn('preview', filename)
      end)
      return true
    end
    return require('telescope.builtin')[action](opts)
  end
  return { view = { mappings = { list = {
    { key = '<c-f>', action_cb = function() return launch_telescope_ontree('find_files') end },
    { key = '<c-g>', action_cb = function() return launch_telescope_ontree('live_grep') end },
  } } } }
end

M.nvim_tree_hydra = function()
  local hint = [[
    _w_: cd CWD   _c_: Path yank    _/_: Filter
    _y_: Copy     _x_: Cut          _p_: Paste
    _r_: Rename   _d_: Remove       _n_: New
    _h_: Hidden   _?_: Help
    ^
    ]]
  return {
    hint = hint,
    heads = {
      { 'w', require('nvim-tree.api').tree.change_root(vim.fn.getcwd()), { silent = true } },
      { 'c', require('nvim-tree.api').fs.copy.absolute_path, { silent = true } },
      { '/', require('nvim-tree.api').live_filter.start, { silent = true } },
      { 'y', require('nvim-tree.api').fs.copy.node, { silent = true } },
      { 'x', require('nvim-tree.api').fs.cut, { exit = true, silent = true } },
      { 'p', require('nvim-tree.api').fs.paste, { exit = true, silent = true } },
      { 'r', require('nvim-tree.api').fs.rename, { silent = true } },
      { 'd', require('nvim-tree.api').fs.remove, { silent = true } },
      { 'n', require('nvim-tree.api').fs.create, { silent = true } },
      { 'h', require('nvim-tree.api').tree.toggle_hidden_filter, { silent = true } },
      { '?', require('nvim-tree.api').tree.toggle_help, { silent = true } },
    },
  }
end

M.neotree = function()
  local function getTelescopeOpts(state, path)
    return {
      cwd = path,
      search_dirs = { path },
      attach_mappings = function(prompt_bufnr, map)
        local actions = require('telescope.actions')
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local action_state = require('telescope.actions.state')
          local selection = action_state.get_selected_entry()
          local filename = selection.filename
          if filename == nil then
            filename = selection[1]
          end
          require('neo-tree.sources.filesystem').navigate(state, state.path, filename)
        end)
        return true
      end,
    }
  end
  return {
    window = {
      mappings = {
        ['e'] = function() vim.api.nvim_exec('Neotree focus filesystem left', true) end,
        ['b'] = function() vim.api.nvim_exec('Neotree focus buffers left', true) end,
        ['g'] = function() vim.api.nvim_exec('Neotree focus git_status left', true) end,
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['O'] = 'system_open',
          ['tf'] = 'telescope_find',
          ['tg'] = 'telescope_grep',
        },
      },
      commands = {
        system_open = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('base').open(path)
        end,
        telescope_find = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').find_files(getTelescopeOpts(state, path))
        end,
        telescope_grep = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          require('telescope.builtin').live_grep(getTelescopeOpts(state, path))
        end,
      },
    },
  }
end

M.legendary = function()
  return {
    keymaps = {
      {
        itemgroup = 'Core',
        keymaps = {
          -- { ';', ':', opts = { silent = false } },
          { 'j', "v:count == 0 ? 'gj' : 'j'", opts = { expr = true, noremap = true } },
          { 'k', "v:count == 0 ? 'gk' : 'k'", opts = { expr = true, noremap = true } },
          { '<esc>', '<cmd>noh<cr><esc>', description = 'Escape And Clear hlsearch', opts = { noremap = true }, mode = { 'i', 'n' } },
          { '<C-j>', '15gj', description = 'Move Down 15 Lines', opts = { noremap = true } },
          { '<C-k>', '15gk', description = 'Move Up 15 Lines', opts = { noremap = true } },
          { '<', '<gv', description = 'deIndent Continuously', opts = { noremap = true }, mode = { 'v' } },
          { '>', '>gv', description = 'Indent Continuously', opts = { noremap = true }, mode = { 'v' } },
          { '<left>', '<C-w>h', description = 'Jump Left' },
          { '<down>', '<C-w>j', description = 'Jump Down' },
          { '<up>', '<C-w>k', description = 'Jump Up' },
          { '<right>', '<C-w>l', description = 'Jump Right' },
          { '<a-q>', '<cmd>ToggleWrap<cr>', description = 'Toggle Wrap' },
        },
      },
      {
        itemgroup = 'Edit',
        keymaps = {
          {
            '<leader>cc',
            {
              n = { function() require('Comment.api').toggle.linewise.current() end },
              x = {
                function()
                  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
                  vim.api.nvim_feedkeys(esc, 'nx', false)
                  require('Comment.api').toggle.linewise(vim.fn.visualmode())
                end,
              },
            },
            description = 'Comment Line (Comment.nvim)',
          },
          {
            '<leader>cb',
            {
              n = { function() require('Comment.api').toggle.blockwise.current() end },
              x = {
                function()
                  local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
                  vim.api.nvim_feedkeys(esc, 'nx', false)
                  require('Comment.api').toggle.blockwise(vim.fn.visualmode())
                end,
              },
            },
            description = 'Comment Block (Comment.nvim)',
          },
        },
      },
      {
        itemgroup = 'Selection',
        keymaps = {
          { '<A-j>', '<cmd>MoveLine(1)<cr>', description = 'Line: Move Up (move.nvim)', mode = { 'n' }, opts = { noremap = true } },
          { '<A-k>', '<cmd>MoveLine(-1)<cr>', description = 'Line: Move Down (move.nvim)', mode = { 'n' }, opts = { noremap = true } },
          { '<A-h>', '<cmd>MoveHChar(-1)<cr>', description = 'Line: Move Left (move.nvim)', mode = { 'n' }, opts = { noremap = true } },
          { '<A-l>', '<cmd>MoveHChar(1)<cr>', description = 'Line: Move Right (move.nvim)', mode = { 'n' }, opts = { noremap = true } },
          { '<A-j>', '<cmd>MoveBlock(1)<cr>', description = 'Block: Move Up (move.nvim)', mode = { 'v' }, opts = { noremap = true } },
          { '<A-k>', '<cmd>MoveBlock(-1)<cr>', description = 'Block: Move Down (move.nvim)', mode = { 'v' }, opts = { noremap = true } },
          { '<A-h>', '<cmd>MoveHBlock(-1)<cr>', description = 'Block: Move Left (move.nvim)', mode = { 'v' }, opts = { noremap = true } },
          { '<A-l>', '<cmd>MoveHBlock(1)<cr>', description = 'Block: Move Right (move.nvim)', mode = { 'v' }, opts = { noremap = true } },
        },
      },
      {
        itemgroup = 'View',
        keymaps = {
          { '<M-cr>', '<cmd>FineCmdline<cr>', description = 'Fine Cmdline... (fine-cmdline.nvim)', opts = { noremap = true } },
          { [[\]], '<cmd>Telescope cmdline<cr>', description = 'Cmdline... (telescope-cmdline.nvim)', opts = { noremap = true } },
          { '<c-s-p>', '<cmd>Telescope commands<cr>', description = 'Command Palette... (telescope.nvim)', mode = { 'n' }, opts = { noremap = true } },
        },
      },
      {
        itemgroup = 'Go',
        keymaps = { { '<c-p>', '<cmd>Telescope buffers show_all_buffers=true theme=get_dropdown previewer=false<cr>', description = 'Go To File... (telescope.nvim)', mode = { 'n' }, opts = { noremap = true } } },
      },
      {
        itemgroup = 'Terminal',
        keymaps = { { [[<c-\>]], '<cmd>ToggleTerm<cr>', description = 'Toggle Terminal' } },
      },
    },
    commands = {
      {
        ':BufferCloseOthers',
        function() require('close_buffers').wipe({ type = 'other' }) end,
        description = 'Close Others',
      },
      {
        ':ToggleFocusMode',
        function()
          vim.opt.laststatus = vim.opt.laststatus._value == 0 and 3 or 0
          vim.opt.number = vim.opt.number._value == false
        end,
        description = 'Toggle Focus Mode',
      },
      {
        ':ToggleWrap',
        function() vim.opt.wrap = vim.opt.wrap._value == false end,
        description = 'Toggle Wrap',
      },
      {
        ':SublimeMerge',
        function()
          local Job = require('plenary.job')
          Job:new({
            command = 'sublime_merge',
            args = { '-n', vim.fn.getcwd() },
          }):start() -- or start()
        end,
        description = 'Sublime Merge',
      },
    },
    funcs = {},
    autocmds = {
      {
        'BufEnter',
        function(args)
          local info = vim.loop.fs_stat(args.file)
          if info and info.type == 'directory' then
            -- require('module.settings').config('nvim-neo-tree/neo-tree.nvim')()
            -- vim.cmd('Neotree position=current ' .. args.file)
            require('module.settings').config('nvim-tree/nvim-tree.lua')()
            require('nvim-tree.api').tree.toggle({ path = args.file, find_file = true })
          end
        end,
        opts = { pattern = { '*' } },
        description = 'Hijack Directories',
      },
    },
  }
end

return M
