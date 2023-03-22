local config = require('module.settings').config
return {
  -- Framework
  { 'nvim-lua/plenary.nvim' },
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, config = config('folke/tokyonight.nvim') },
  --- Treesitter
  { 'nvim-treesitter/nvim-treesitter', event = 'BufReadPost', config = config('nvim-treesitter/nvim-treesitter') },
  --- Telescope
  { 'nvim-telescope/telescope.nvim', cmd = { 'Telescope' }, config = config('nvim-telescope/telescope.nvim') },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { 'debugloop/telescope-undo.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-file-browser.nvim' },
  { 'jonarrien/telescope-cmdline.nvim' },
  { 'stevearc/aerial.nvim', event = 'BufReadPost', config = config('stevearc/aerial.nvim') },
  { 'ahmedkhalf/project.nvim', event = 'BufReadPost', config = config('ahmedkhalf/project.nvim') },
  --- Completion
  { 'hrsh7th/nvim-cmp', event = 'BufReadPost', config = config('hrsh7th/nvim-cmp') },
  { 'hrsh7th/cmp-cmdline', event = { 'CmdlineEnter', 'InsertEnter' } },
  { 'hrsh7th/cmp-buffer', event = { 'CmdlineEnter', 'InsertEnter' } },
  { 'hrsh7th/cmp-path', event = { 'CmdlineEnter', 'InsertEnter' } },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  --- Base
  { 'kkharji/sqlite.lua', config = config('kkharji/sqlite.lua') },
  { 'anuvyklack/hydra.nvim' },
  { 'MunifTanjim/nui.nvim' },
  { 'stevearc/dressing.nvim', event = 'VeryLazy', config = config('stevearc/dressing.nvim') },
  --- Git
  { 'lewis6991/gitsigns.nvim', event = 'BufReadPost', config = config('lewis6991/gitsigns.nvim') },
  { 'tanvirtin/vgit.nvim', config = config('tanvirtin/vgit.nvim') },
  { 'TimUntersberger/neogit', cmd = { 'Neogit' }, config = config('TimUntersberger/neogit') },
  --- Buffer
  { 'qpkorr/vim-bufkill', cmd = { 'BD' } },
  { 'moll/vim-bbye', cmd = { 'Bdelete' } },
  { 'kazhala/close-buffers.nvim', cmd = { 'BufferCloseOthers' }, config = config('kazhala/close-buffers.nvim') },
  --- Key Management
  { 'folke/which-key.nvim', keys = { { ',' }, { 'g' } }, config = config('folke/which-key.nvim') },
  { 'mrjones2014/legendary.nvim', event = 'VeryLazy', config = config('mrjones2014/legendary.nvim') },
  --- UI
  { 'j-hui/fidget.nvim', config = config('j-hui/fidget.nvim') },
  { 'nvim-lualine/lualine.nvim', event = 'VeryLazy', config = config('nvim-lualine/lualine.nvim') },
  { 'nvim-tree/nvim-tree.lua', cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' }, config = config('nvim-tree/nvim-tree.lua') },
  { 'nvim-neo-tree/neo-tree.nvim', cmd = { 'Neotree' }, config = config('nvim-neo-tree/neo-tree.nvim') },
  { 'akinsho/toggleterm.nvim', cmd = { 'ToggleTerm' }, config = config('akinsho/toggleterm.nvim') },
  { 'nvim-tree/nvim-web-devicons' },
  --- CmdLine
  { 'VonHeikemen/fine-cmdline.nvim', config = config('VonHeikemen/fine-cmdline.nvim'), cmd = { 'FineCmdline' } },
  { 'gelguy/wilder.nvim', keys = { { '?' } }, config = config('gelguy/wilder.nvim') },
  --- Edit
  { 'tpope/vim-obsession', cmd = { 'Obsession' } },
  { 'windwp/nvim-autopairs' },
  { 'numToStr/Comment.nvim', keys = { { '<leader>cc' }, { '<leader>cb' } } },
  { 'fedepujol/move.nvim', cmd = { 'MoveLine', 'MoveBlock', 'MoveHChar', 'MoveHBlock' } },
  { 'ray-x/lsp_signature.nvim', config = config('ray-x/lsp_signature.nvim') },

  -- LSP
  { 'neovim/nvim-lspconfig', event = 'BufReadPost', ft = { 'c', 'cpp', 'lua' }, config = require('module.lsp').setup, dependencies = { 'j-hui/fidget.nvim', 'ray-x/lsp_signature.nvim' } },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'p00f/clangd_extensions.nvim' },
  { 'folke/neodev.nvim' },
}
