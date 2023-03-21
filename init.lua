local bindings = require('module.bindings')
local opt = require('module.options')
bindings.setup_leader()
bindings.setup_vim()
opt.setup()

if not vim.loop.fs_stat(opt.lazy) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    opt.lazy,
  })
end
require('lazy').setup('module.plugins', {
  root = opt.root,
  concurrency = 2,
})

require('module.settings')
require('module.lsp')
bindings.setup_st()
