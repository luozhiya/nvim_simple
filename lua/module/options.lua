require('module.bindings')

vim.g.neovide_remember_window_size = true
vim.g.neovide_refresh_rate_idle = 240
vim.g.neovide_no_idle = true

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

local circle = ''
_G.modified_icon = function()
  return vim.bo.modified and circle or ''
end
local lsp_active = function()
  local clients = vim.lsp.buf_get_clients()
  local names = {}
  for _, client in pairs(clients) do
    table.insert(names, client.name)
  end
  return 'Lsp<' .. table.concat(names, ', ') .. '>'
end
_G.lsp_progress = function()
  local lsp = vim.lsp.util.get_progress_messages()[1]
  if lsp then
    local name = lsp.name or ''
    local msg = lsp.message or ''
    local percentage = lsp.percentage or 0
    local title = lsp.title or ''
    return string.format(' <%s: %s %s (%s%%) ', name, title, msg, percentage)
  else
    return lsp_active()
  end
  return ''
end

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
  guifont = 'InconsolataGo Nerd Font:h12',
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
  wildmode = 'full',
  title = true,
  titlestring = [[  %{v:lua.vim.fn.fnamemodify(v:lua.vim.fn.getcwd(), ":t")} %{v:lua.modified_icon()}]],
}
if require('module.base').is_windows() then
  circle = '*'
  opts.guifont = 'InconsolataGo Nerd Font:h16'
  opts.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')}) %{v:lua.lsp_progress()} %{v:lua.modified_icon()}]]
end
for k, v in pairs(opts) do
  vim.opt[k] = v
end

return M
