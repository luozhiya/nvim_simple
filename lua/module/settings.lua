local plugin_installed = require('module.base').plugin_installed
local bindings = require('module.bindings')

if plugin_installed('folke/tokyonight.nvim') then
  vim.cmd([[colorscheme tokyonight]])
end

if plugin_installed('nvim-treesitter/nvim-treesitter') then
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'cpp', 'c', 'lua', 'cmake' },
  })
end

if plugin_installed('stevearc/aerial.nvim') then
  require('aerial').setup({
    backends = { 'treesitter', 'lsp' },
    on_attach = bindings.aerial,
    layout = { max_width = { 60, 0.4 } },
  })
  if plugin_installed('nvim-telescope/telescope.nvim') then
    require('telescope').load_extension('aerial')
  end
end

if plugin_installed('folke/which-key.nvim') then
  local wk = require('which-key')
  wk.setup()
  wk.register(bindings.wk(), {
    mode = 'n',
    prefix = '<leader>',
  })
end

if plugin_installed('nvim-telescope/telescope.nvim') then
  local telescope = require('telescope')
  telescope.setup({
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown({}),
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = 'smart_case', -- or "ignore_case" or "respect_case" -- the default case_mode is "smart_case"
      },
      file_browser = {
        -- theme = 'ivy',
        hijack_netrw = true,
        mappings = bindings.telescope_file_browser(telescope.extensions.file_browser.actions),
      },
    },
  })
  telescope.load_extension('ui-select')
  telescope.load_extension('undo')
  telescope.load_extension('fzf')
  telescope.load_extension('frecency')
  telescope.load_extension('live_grep_args')
  telescope.load_extension('file_browser')
  telescope.load_extension('cmdline')
end

if plugin_installed('lewis6991/gitsigns.nvim') then
  require('gitsigns').setup()
end

if plugin_installed('akinsho/toggleterm.nvim') then
  require('toggleterm').setup({
    open_mapping = bindings.toggleterm().open_mapping,
  })
  local terminal_float_run = function(cmd, dir)
    return require('toggleterm.terminal').Terminal:new({
      cmd = cmd,
      dir = dir,
      direction = 'float',
      float_opts = { border = 'double' },
      on_open = function(term)
        vim.cmd('startinsert!')
        bindings.toggleterm().on_open(term.bufnr)
      end,
      on_close = function(term)
        vim.cmd('startinsert!')
      end,
    })
  end
  vim.api.nvim_create_user_command('ToggleTerminalGitUI', function()
    terminal_float_run('gitui', 'git_dir'):toggle()
  end, {})
  vim.api.nvim_create_user_command('ToggleTerminalLazyGit', function()
    terminal_float_run('lazygit', 'git_dir'):toggle()
  end, {})
end

if plugin_installed('nvim-tree/nvim-tree.lua') then
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
  require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    hijack_directories = {
      enable = false,
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
    actions = {
      open_file = {
        resize_window = false,
      },
    },
    view = {
      adaptive_size = false,
      preserve_window_proportions = true,
      mappings = bindings.tree(launch_telescope_ontree),
    },
  })
  vim.api.nvim_create_user_command('TelescopeFindInTreeNode', function()
    launch_telescope_ontree('find_files')
  end, {})
  vim.api.nvim_create_user_command('TelescopeLiveGrepInTreeNode', function()
    launch_telescope_ontree('live_grep')
  end, {})

  if plugin_installed('anuvyklack/hydra.nvim') then
    local api = require('nvim-tree.api')
    local hint = [[
_w_: cd CWD   _c_: Path yank    _/_: Filter
_y_: Copy     _x_: Cut          _p_: Paste
_r_: Rename   _d_: Remove       _n_: New
_h_: Hidden   _?_: Help
^
]]
    local nvim_tree_hydra = nil
    local nt_au_group = vim.api.nvim_create_augroup('NvimTreeHydraAu', { clear = true })
    local Hydra = require('hydra')
    local function spawn_nvim_tree_hydra()
      nvim_tree_hydra = Hydra({
        name = 'NvimTree',
        hint = hint,
        config = {
          color = 'pink',
          invoke_on_body = true,
          buffer = 0, -- only for active buffer
          hint = {
            position = 'bottom',
            border = 'rounded',
          },
        },
        mode = 'n',
        body = 'H',
        heads = {
          { 'w', api.tree.change_root(vim.fn.getcwd()), { silent = true } },
          { 'c', api.fs.copy.absolute_path, { silent = true } },
          { '/', api.live_filter.start, { silent = true } },
          { 'y', api.fs.copy.node, { silent = true } },
          { 'x', api.fs.cut, { exit = true, silent = true } },
          { 'p', api.fs.paste, { exit = true, silent = true } },
          { 'r', api.fs.rename, { silent = true } },
          { 'd', api.fs.remove, { silent = true } },
          { 'n', api.fs.create, { silent = true } },
          { 'h', api.tree.toggle_hidden_filter, { silent = true } },
          { '?', api.tree.toggle_help, { silent = true } },
        },
      })
      nvim_tree_hydra:activate()
    end
    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
      pattern = '*',
      callback = function(opts)
        if vim.bo[opts.buf].filetype == 'NvimTree' then
          spawn_nvim_tree_hydra()
        else
          if nvim_tree_hydra then
            nvim_tree_hydra:exit()
          end
        end
      end,
      group = nt_au_group,
    })
  end
end

if plugin_installed('stevearc/dressing.nvim') then
  require('dressing').setup({
    input = {
      enabled = true,
      prompt_align = 'center',
      relative = 'editor',
      prefer_width = 0.6,
      win_options = {
        winblend = 0, -- Window transparency (0-100)
      },
    },
    select = {
      enabled = false,
    },
  })
end

if plugin_installed('ahmedkhalf/project.nvim') then
  require('project_nvim').setup({})
  if plugin_installed('nvim-telescope/telescope.nvim') then
    require('telescope').load_extension('projects')
  end
end
