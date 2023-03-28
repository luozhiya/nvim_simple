local bindings = require('module.bindings')

local M = {}
M.cached = {}

M.config = function(name)
  if vim.tbl_isempty(M.cached) then
    M.cached = {
      ['VonHeikemen/fine-cmdline.nvim'] = function() require('fine-cmdline').setup({ cmdline = { prompt = ' > ' } }) end,
      ['folke/tokyonight.nvim'] = function() vim.cmd([[colorscheme tokyonight]]) end,
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
        local opts = { extensions = { file_browser = { hijack_netrw = false } } }
        opts = vim.tbl_deep_extend('error', opts, bindings.telescope(telescope))
        telescope.setup(opts)
        telescope.load_extension('ui-select')
        telescope.load_extension('undo')
        telescope.load_extension('fzf')
        telescope.load_extension('frecency')
        telescope.load_extension('live_grep_args')
        telescope.load_extension('file_browser')
        telescope.load_extension('cmdline')
        telescope.load_extension('aerial')
        telescope.load_extension('projects')
      end,
      ['lewis6991/gitsigns.nvim'] = function() require('gitsigns').setup() end,
      ['akinsho/toggleterm.nvim'] = function()
        local opts = {}
        opts = vim.tbl_deep_extend('error', opts, bindings.toggleterm())
        require('toggleterm').setup(opts)
      end,
      ['nvim-tree/nvim-tree.lua'] = function()
        local opts = {
          sort_by = 'case_sensitive',
          sync_root_with_cwd = true,
          respect_buf_cwd = true,
          hijack_directories = { enable = true },
          update_focused_file = { enable = enable, update_root = true },
          actions = { open_file = { resize_window = false } },
          view = { adaptive_size = false, preserve_window_proportions = true },
        }
        opts = vim.tbl_deep_extend('error', opts, bindings.nvim_tree())
        require('nvim-tree').setup(opts)
        -- local nvim_tree_hydra = nil
        -- local nt_au_group = vim.api.nvim_create_augroup('NvimTreeHydraAu', { clear = true })
        -- local function spawn_nvim_tree_hydra()
        --   local hydraopts = {
        --     name = 'NvimTree',
        --     config = { color = 'pink', invoke_on_body = true, buffer = 0, hint = { position = 'bottom', border = 'rounded' } },
        --     mode = 'n',
        --     body = 'H',
        --   }
        --   hydraopts = vim.tbl_deep_extend('error', hydraopts, bindings.nvim_tree_hydra())
        --   nvim_tree_hydra = require('hydra')(hydraopts)
        --   nvim_tree_hydra:activate()
        -- end
        -- vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        --   pattern = '*',
        --   callback = function(opts)
        --     if vim.bo[opts.buf].filetype == 'NvimTree' then
        --       spawn_nvim_tree_hydra()
        --     else
        --       if nvim_tree_hydra then
        --         nvim_tree_hydra:exit()
        --       end
        --     end
        --   end,
        --   group = nt_au_group,
        -- })
      end,
      ['stevearc/dressing.nvim'] = function()
        require('dressing').setup({
          input = { enabled = true, prompt_align = 'center', relative = 'editor', prefer_width = 0.6, win_options = { winblend = 0 } }, -- Window transparency (0-100)
          select = { enabled = true, backend = { 'telescope', 'fzf_lua', 'fzf', 'builtin', 'nui' } },
        })
      end,
      ['ahmedkhalf/project.nvim'] = function() require('project_nvim').setup() end,
      ['kazhala/close-buffers.nvim'] = function() require('close_buffers').setup({}) end,
      ['nvim-lualine/lualine.nvim'] = function()
        local function lsp_active()
          local names = {}
          for _, client in pairs(vim.lsp.get_active_clients()) do
            table.insert(names, client.name)
          end
          return 'LSP<' .. table.concat(names, ', ') .. '>'
        end
        local function location() return string.format('%3d:%-2d ', vim.fn.line('.'), vim.fn.virtcol('.')) end
        local fileformat = { 'fileformat', icons_enabled = false }
        require('lualine').setup({ sections = {
          lualine_x = { lsp_active, 'encoding', fileformat, 'filetype' },
          lualine_z = { location },
        } })
      end,
      ['mrjones2014/legendary.nvim'] = function()
        local opts = { which_key = { auto_register = true } }
        opts = vim.tbl_deep_extend('error', opts, bindings.legendary())
        require('legendary').setup(opts)
      end,
      ['j-hui/fidget.nvim'] = function()
        vim.cmd([[highlight FidgetTitle ctermfg=110 guifg=#0887c7]])
        vim.cmd([[highlight FidgetTask ctermfg=110 guifg=#0887c7]])
        require('fidget').setup({ text = { done = ' ' }, window = { blend = 0 } })
      end,
      ['ray-x/lsp_signature.nvim'] = function() require('lsp_signature').setup({ hint_prefix = ' ' }) end,
      ['hrsh7th/nvim-cmp'] = function()
        local cmp = require('cmp')
        local opts = {
          sources = { { name = 'nvim_lsp' }, { name = 'buffer' }, { name = 'path' }, { name = 'luasnip' } },
          formatting = {
            fields = { 'kind', 'abbr', 'menu' },
            format = function(entry, vim_item)
              vim_item.menu = ({ nvim_lsp = '[LSP]', buffer = '[Buffer]', path = '[Path]', luasnip = '[Snippet]' })[entry.source.name]
              local max = 45
              local content = vim_item.abbr
              if #content > max then
                vim_item.abbr = vim.fn.strcharpart(content, 0, max) .. '…'
              else
                vim_item.abbr = content .. (' '):rep(max - #content)
              end
              return vim_item
            end,
          },
          snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
          completion = { completeopt = 'menuone, noinsert, noselect' },
          experimental = { ghost_text = true },
        }
        opts = vim.tbl_deep_extend('error', opts, bindings.cmp(cmp))
        cmp.setup(opts)
        require('luasnip').config.set_config({ history = true, updateevents = 'TextChanged, TextChangedI' })
        require('nvim-autopairs').setup()
        cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
        cmp.setup.cmdline('/', { mapping = cmp.mapping.preset.cmdline(), sources = { { name = 'buffer' } } })
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' },
            { name = 'cmdline', option = { ignore_cmds = { 'Man', '!' } } },
          }),
        })
        -- sync load luasnip cust ~600ms
        vim.loop.new_timer():start(3000, 0, vim.schedule_wrap(function() require('luasnip.loaders.from_vscode').load() end))
      end,
      ['kkharji/sqlite.lua'] = function()
        if require('base').is_windows() then
          local nvim = 'nvim.exe'
          vim.g.sqlite_clib_path = string.sub(vim.loop.exepath(nvim), 1, -(#nvim + 1)) .. 'sqlite3.dll'
        end
      end,
      ['nvim-neo-tree/neo-tree.nvim'] = function()
        vim.g.neo_tree_remove_legacy_commands = 1
        local opts = { async_directory_scan = 'never', log_level = 'trace', log_to_file = true, close_if_last_window = true, source_selector = { winbar = false, statusline = false } }
        opts = vim.tbl_deep_extend('error', opts, bindings.neotree())
        require('neo-tree').setup(opts)
      end,
      ['tanvirtin/vgit.nvim'] = function() require('vgit').setup() end,
      ['TimUntersberger/neogit'] = function() require('neogit').setup() end,
      ['glepnir/lspsaga.nvim'] = function() require('lspsaga').setup({ ui = { diagnostic = ' ' } }) end,
      ['folke/trouble.nvim'] = function() require('trouble').setup() end,
      ['lukas-reineke/indent-blankline.nvim'] = function() require('indent_blankline').setup() end,
      ['HiPhish/nvim-ts-rainbow2'] = function() require('nvim-treesitter.configs').setup({ rainbow = { enable = { 'c', 'cpp' }, query = 'rainbow-parens', strategy = require('ts-rainbow').strategy['local'] } }) end,
      ['p00f/godbolt.nvim'] = function()
        -- https://godbolt.org/api/compilers/
        -- https://godbolt.org/api/libraries/
        require('godbolt').setup({
          languages = {
            cpp = { compiler = 'g122', options = {} },
            c = { compiler = 'cg122', options = {} },
            -- any_additional_filetype = { compiler = ..., options = ... },
          },
          quickfix = {
            enable = false, -- whether to populate the quickfix list in case of errors
            auto_open = false, -- whether to open the quickfix list in case of errors
          },
          url = 'https://godbolt.org', -- can be changed to a different godbolt instance
        })
      end,
      ['glepnir/flybuf.nvim'] = function() require('flybuf').setup({}) end,
      ['sindrets/diffview.nvim'] = function() require('diffview').setup() end,
      ['rcarriga/nvim-notify'] = function()
        require('notify').setup()
        vim.notify = require('notify')
      end,
      ['folke/noice.nvim'] = function()
        require('noice').setup({
          lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
              ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
              ['vim.lsp.util.stylize_markdown'] = true,
              ['cmp.entry.get_documentation'] = true,
            },
          },
          -- you can enable a preset for easier configuration
          presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        })
      end,
    }
  end
  return M.cached[name]
end

return M
