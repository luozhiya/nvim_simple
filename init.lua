local opt = require('module.options')

if not vim.loop.fs_stat(opt.lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    opt.lazypath,
  })
end
require('lazy').setup('module.plugins', {
  root = opt.root,
  concurrency = 2,
})

require('module.settings')
require('module.lsp')
