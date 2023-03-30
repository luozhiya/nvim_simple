local bindings = require('module.bindings')

local M = {}
M.cached = {}

M.config = function(name)
  if vim.tbl_isempty(M.cached) then
    M.cached = {
      ['nvim-treesitter/nvim-treesitter'] = function() require('nvim-treesitter.configs').setup({ ensure_installed = { 'cpp', 'c', 'lua', 'cmake', 'markdown', 'markdown_inline' } }) end,
      ['stevearc/aerial.nvim'] = function()
        local opts = { backends = { 'treesitter', 'lsp' }, layout = { max_width = { 60, 0.4 } } }
        opts = vim.tbl_deep_extend('error', opts, bindings.aerial())
        require('aerial').setup(opts)
      end,
      ['folke/which-key.nvim'] = function()
        local wk = require('which-key')
        wk.setup()
        bindings.wk(wk)
      end,
      ['nvim-telescope/telescope.nvim'] = function()
        local telescope = require('telescope')
        telescope.setup(bindings.telescope())
        telescope.load_extension('undo')
        telescope.load_extension('fzf')
        telescope.load_extension('frecency')
        telescope.load_extension('live_grep_args')
        telescope.load_extension('projects')
      end,
      ['lewis6991/gitsigns.nvim'] = function() require('gitsigns').setup() end,
      ['akinsho/toggleterm.nvim'] = function() require('toggleterm').setup(bindings.toggleterm()) end,
      ['nvim-tree/nvim-tree.lua'] = function()
        local opts = {
          sort_by = 'case_sensitive',
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          hijack_directories = { enable = false },
          update_focused_file = { enable = false, update_root = true },
          actions = { open_file = { resize_window = false } },
          view = { adaptive_size = false, preserve_window_proportions = true },
          git = { enable = false },
        }
        opts = vim.tbl_deep_extend('error', opts, bindings.nvim_tree())
        require('nvim-tree').setup(opts)
      end,
      ['stevearc/dressing.nvim'] = function()
        require('dressing').setup({
          input = { enabled = true, prompt_align = 'center', relative = 'editor', prefer_width = 0.6, win_options = { winblend = 0 } }, -- Window transparency (0-100)
          select = { enabled = true, backend = { 'builtin' } },
        })
      end,
      ['ahmedkhalf/project.nvim'] = function() require('project_nvim').setup() end,
      ['j-hui/fidget.nvim'] = function()
        vim.cmd([[highlight FidgetTitle ctermfg=110 guifg=#0887c7]])
        vim.cmd([[highlight FidgetTask ctermfg=110 guifg=#0887c7]])
        require('fidget').setup({ text = { done = ' ' }, window = { blend = 0 } })
      end,
      ['ray-x/lsp_signature.nvim'] = function() require('lsp_signature').setup({ hint_prefix = ' ' }) end,
      ['hrsh7th/nvim-cmp'] = function()
        local cmp = require('cmp')
        local opts = {
          sources = { { name = 'nvim_lsp' }, { name = 'path' } },
          snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        }
        opts = vim.tbl_deep_extend('error', opts, bindings.cmp(cmp))
        cmp.setup(opts)
        require('nvim-autopairs').setup()
        cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
          }),
        })
      end,
      ['kkharji/sqlite.lua'] = function()
        if require('base').is_windows() then
          local nvim = 'nvim.exe'
          vim.g.sqlite_clib_path = string.sub(vim.loop.exepath(nvim), 1, -(#nvim + 1)) .. 'sqlite3.dll'
        end
      end,
      ['HiPhish/nvim-ts-rainbow2'] = function() require('nvim-treesitter.configs').setup({ rainbow = { enable = { 'c', 'cpp' }, query = 'rainbow-parens', strategy = require('ts-rainbow').strategy['local'] } }) end,
      ['p00f/godbolt.nvim'] = function()
        require('godbolt').setup({
          languages = { cpp = { compiler = 'clangdefault', options = {} }, c = { compiler = 'cclangdefault', options = {} } }, -- vc2017_64
          url = 'http://localhost:10240', -- https://godbolt.org -- http://localhost:10240
        })
      end,
      ['nvim-pack/nvim-spectre'] = function() require('spectre').setup(bindings.spectre()) end,
    }
  end
  return M.cached[name]
end

return M
