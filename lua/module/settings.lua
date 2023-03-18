vim.cmd([[colorscheme tokyonight]])
vim.opt.guifont = 'InconsolataGo Nerd Font'

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'cpp', 'c', 'lua' },
})

local bindings = require('module.bindings')
require('aerial').setup({
  backends = { 'treesitter', 'lsp' },
  on_attach = bindings.aerial,
  layout = { max_width = { 60, 0.4 } },
})

local wk = require('which-key')
wk.setup()
wk.register(bindings.wk(), {
  mode = 'n',
  prefix = '<leader>',
})

local telescope = require('telescope')
telescope.setup()
telescope.load_extension('aerial')

require('gitsigns').setup()

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
