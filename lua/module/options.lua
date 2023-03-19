require('module.bindings')

vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

local disabled_built_ins = {
  'gzip',
  'man',
  'matchit',
  'matchparen',
  'shada_plugin',
  'tarPlugin',
  'tar',
  'zipPlugin',
  'zip',
  'netrwPlugin',
  'netrw',
}
for i, v in ipairs(disabled_built_ins) do
  vim.g['loaded_' .. v] = 1
end

vim.cmd([[
  autocmd Filetype log if getfsize(@%) > 1000000 | setlocal syntax=OFF | endif
  au FocusGained * :checktime
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])

local M = {}
M.lazypath = vim.fn.stdpath('config') .. '/lazy/lazy.nvim'
M.root = vim.fn.stdpath('config') .. '/lazy'

local opts = {
  runtimepath = vim.opt.runtimepath:append(M.lazypath),
  laststatus = 0, -- Only last window
  cmdheight = 0, -- command-line
  showmode = false, -- Dont show mode since we have a statusline
  -- lazyredraw = true,
  scrolloff = 4, -- cursor 接近 buffer 顶部和底部时会尽量保持 n 行的距离
  sidescrolloff = 8,
  number = true, -- Print line number
  signcolumn = 'yes:1',
  termguicolors = true, -- True color support
  wrap = false, -- Disable line wrap
  tabstop = 2, -- length of an actual \t character
  expandtab = true, -- if set, only insert spaces; otherwise insert \t and complete with spaces
  shiftwidth = 0, -- 一级 indent 是多少 space. (0 for ‘tabstop’)
  softtabstop = 0, -- length to use when editing text (eg. TAB and BS keys). (0 for ‘tabstop’, -1 for ‘shiftwidth’)
  shiftround = true, -- round indentation to multiples of 'shiftwidth' when shifting text
  smartindent = true, -- Insert indents automatically
  cinoptions = vim.opt.cinoptions:append('g0'), -- C++ public等不额外产生indent
  synmaxcol = 200, -- don't syntax-highlight long lines
  ignorecase = true, -- Ignore case
  smartcase = true, -- Don't ignore case with capitals
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  completeopt = { 'menu', 'menuone', 'noselect' },
  autoread = true,
  guifont = 'InconsolataGo Nerd Font',
  shortmess = {
    t = true, -- truncate file messages at start
    A = true, -- ignore annoying swap file messages
    o = true, -- file-read message overwrites previous
    O = true, -- file-read message overwrites previous
    T = true, -- truncate non-file messages in middle
    f = true, -- (file x of x) instead of just (x of x
    F = true, -- Don't give file info when editing a file, NOTE: this breaks autocommand messages
    s = true,
    c = true,
    I = true,
    W = true, -- Don't show [w] or written when writing
  },
  timeout = true,
  timeoutlen = 500, -- the timeout when WhichKey opens is controlled by the vim setting timeoutlen.
}
for k, v in pairs(opts) do
  vim.opt[k] = v
end

return M
