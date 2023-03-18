vim.cmd([[colorscheme tokyonight]])
vim.opt.guifont = 'InconsolataGo Nerd Font'

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'cpp', 'c', 'lua' },
})

require('telescope').setup()

local bindings = require('module.bindings')
require('aerial').setup({
  backends = { 'treesitter', 'lsp' },
  on_attach = bindings.aerial,
  layout = { max_width = { 60, 0.4 } },
})

require('gitsigns').setup()

local wk = require('which-key')
wk.setup()
wk.register(bindings.wk(), {
  mode = 'n',
  prefix = '<leader>',
})
