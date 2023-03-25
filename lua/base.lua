local M = {}

local cached = {}
M.cached = cached
M.installed = function(name)
  -- if vim.tbl_isempty(cached) then
  -- for _, plugin in pairs(require('module.plugins')) do
  -- table.insert(cached, plugin[1])
  -- end
  -- end
  -- return vim.tbl_contains(cached, name)
  return true
end

M.is_windows = function() return vim.loop.os_uname().sysname == 'Windows_NT' end
M.is_linux = function() return vim.loop.os_uname().sysname == 'Linux' end

-- cp from lazy.nvim util
function M.file_exists(file) return vim.loop.fs_stat(file) ~= nil end

-- cp from lazy.nvim util
function M.open(uri)
  local cmd
  if vim.fn.has('win32') == 1 then
    cmd = { 'explorer', uri }
    cmd = table.concat(cmd, ' '):gsub('/', '\\')
  elseif vim.fn.has('macunix') == 1 then
    cmd = { 'open', uri }
  else
    if vim.fn.executable('xdg-open') == 1 then
      cmd = { 'xdg-open', uri }
    elseif vim.fn.executable('wslview') == 1 then
      cmd = { 'wslview', uri }
    else
      cmd = { 'open', uri }
    end
  end
  local ret = vim.fn.jobstart(cmd, { detach = true })
  if ret <= 0 then
    local msg = {
      'Failed to open uri',
      ret,
      vim.inspect(cmd),
    }
    vim.notify(table.concat(msg, '\n'), vim.log.levels.ERROR)
  end
end

-- cf. lua/nvim-tree/actions/fs/copy-paste.lua
M.copy_to_clipboard = function(content)
  vim.fn.setreg('+', content)
  vim.fn.setreg('"', content)
  return vim.notify(string.format('Copied %s to system clipboard!', content), vim.log.levels.INFO)
end

M.copy_content = function()
  local text = vim.api.nvim_buf_get_text(0, 0, 0, -1, -1, {})
  return M.copy_to_clipboard(text)
end

M.get_current_buffer_name = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if bufname == '' then
    return false, '[No Name]'
  end
  return true, bufname
end

M.copy_path = function()
  local _, absolute_path = M.get_current_buffer_name()
  return M.copy_to_clipboard(absolute_path)
end

M.path_separator = function()
  local sep = vim.loop.os_uname().version:match('Windows') and '\\' or '/'
  if vim.fn.has('shellslash') == 1 then
    sep = '\\'
  end
  return sep
end

M.path_add_trailing = function(path)
  if path:sub(-1) == M.path_separator() then
    return path
  end
  return path .. M.path_separator()
end

M.path_relative = function(path, relative_to)
  local _, r = path:find(M.path_add_trailing(relative_to), 1, true)
  local p = path
  if r then
    -- take the relative path starting after '/'
    -- if somehow given a completely matching path,
    -- returns ""
    p = path:sub(r + 1)
  end
  return p
end

M.copy_relative_path = function()
  local has_name, absolute_path = M.get_current_buffer_name()
  if not has_name then
    return M.copy_to_clipboard(content)
  end
  local relative_path = M.path_relative(absolute_path, vim.fn.getcwd())
  return M.copy_to_clipboard(relative_path)
end

M.name = function()
  local has_name, absolute_path = M.get_current_buffer_name()
  if not has_name then
    return M.copy_to_clipboard(absolute_path)
  end
  local ts = string.reverse(absolute_path)
  local _, i = string.find(ts, '/')
  local fn = string.sub(absolute_path, -i + 1, -1)
  return fn
end

M.copy_name = function() return M.copy_to_clipboard(M.name()) end

M.copy_name_without_ext = function()
  local name = M.name()
  local ts = string.reverse(name)
  local _, i = string.find(ts, '.', 1, true)
  local fn = string.sub(name, 1, i)
  return M.copy_to_clipboard(fn)
end

M.copy_contain_directory = function()
  local _, absolute_path = M.get_current_buffer_name()
  local ts = string.reverse(absolute_path)
  local _, i = string.find(ts, M.path_separator())
  local fn = string.sub(absolute_path, 1, #ts - i + 1)
  return M.copy_to_clipboard(fn)
end

M.reveal_cwd_in_file_explorer = function() M.open(vim.fn.getcwd()) end

M.reveal_file_in_file_explorer = function()
  local has_name, absolute_path = M.get_current_buffer_name()
  if has_name then
    local _, absolute_path = M.get_current_buffer_name()
    local ts = string.reverse(absolute_path)
    local _, i = string.find(ts, M.path_separator())
    local fn = string.sub(absolute_path, 1, #ts - i + 1)
    M.open(fn)
  end
end

M.reveal_in_tree = function() require('nvim-tree.api').tree.find_file({ open = true, update_root = true }) end

return M
