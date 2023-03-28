local config = require('module.settings').config
return {
  -- Foundation
  { 'nvim-lua/plenary.nvim' },
  { 'kkharji/sqlite.lua', config = config('kkharji/sqlite.lua') },
  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' }, build = ':TSUpdate', config = config('nvim-treesitter/nvim-treesitter') },
  -- Telescope
  { 'nvim-telescope/telescope.nvim', cmd = { 'Telescope' }, config = config('nvim-telescope/telescope.nvim'), dependencies = { 'nvim-telescope/telescope-ui-select.nvim' } },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { 'debugloop/telescope-undo.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-file-browser.nvim' },
  { 'jonarrien/telescope-cmdline.nvim' },
  { 'stevearc/aerial.nvim', event = 'BufReadPost', config = config('stevearc/aerial.nvim') },
  { 'ahmedkhalf/project.nvim', event = 'BufReadPost', config = config('ahmedkhalf/project.nvim') },
  -- Completion
  { 'hrsh7th/nvim-cmp', event = { 'InsertEnter' }, config = config('hrsh7th/nvim-cmp'), dependencies = { 'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp' } },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip', dependencies = { 'saadparwaiz1/cmp_luasnip', 'rafamadriz/friendly-snippets' } },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'rafamadriz/friendly-snippets' },
  -- Git
  { 'lewis6991/gitsigns.nvim', event = 'BufReadPost', config = config('lewis6991/gitsigns.nvim') },
  { 'tanvirtin/vgit.nvim', config = config('tanvirtin/vgit.nvim') },
  { 'TimUntersberger/neogit', cmd = { 'Neogit' }, config = config('TimUntersberger/neogit') },
  { 'sindrets/diffview.nvim', cmd = { 'DiffviewOpen' }, config = config('sindrets/diffview.nvim') },
  -- Buffer
  { 'qpkorr/vim-bufkill', cmd = { 'BD' } },
  { 'moll/vim-bbye', cmd = { 'Bdelete' } },
  { 'kazhala/close-buffers.nvim', cmd = { 'BufferCloseOthers' }, config = config('kazhala/close-buffers.nvim') },
  { 'glepnir/flybuf.nvim', cmd = 'FlyBuf', config = config('glepnir/flybuf.nvim') },
  -- Key Management
  { 'folke/which-key.nvim', keys = { { ',' }, { 'g' } }, config = config('folke/which-key.nvim') },
  { 'mrjones2014/legendary.nvim', lazy = false, event = 'VeryLazy', config = config('mrjones2014/legendary.nvim'), dependencies = { 'folke/which-key.nvim' } },
  -- Appearance
  { 'anuvyklack/hydra.nvim' },
  { 'MunifTanjim/nui.nvim' },
  { 'stevearc/dressing.nvim', config = config('stevearc/dressing.nvim') },
  { 'j-hui/fidget.nvim', config = config('j-hui/fidget.nvim') },
  { 'nvim-lualine/lualine.nvim', enabled = false, event = 'VeryLazy', config = config('nvim-lualine/lualine.nvim') },
  { 'nvim-tree/nvim-tree.lua', cmd = { 'NvimTreeToggle', 'NvimTreeFindFile' }, config = config('nvim-tree/nvim-tree.lua') },
  { 'nvim-neo-tree/neo-tree.nvim', cmd = { 'Neotree' }, config = config('nvim-neo-tree/neo-tree.nvim') },
  { 'akinsho/toggleterm.nvim', cmd = { 'ToggleTerm' }, config = config('akinsho/toggleterm.nvim') },
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, config = config('folke/tokyonight.nvim') },
  { 'gosukiwi/vim-atom-dark' },
  { 'habamax/vim-habamax' },
  { 'rcarriga/nvim-notify', config = config('rcarriga/nvim-notify') },
  { 'folke/noice.nvim', config = config('folke/noice.nvim') },
  -- CmdLine
  { 'VonHeikemen/fine-cmdline.nvim', config = config('VonHeikemen/fine-cmdline.nvim'), cmd = { 'FineCmdline' } },
  -- Edit
  { 'tpope/vim-obsession', cmd = { 'Obsession' } },
  { 'windwp/nvim-autopairs' },
  { 'numToStr/Comment.nvim', keys = { { '<leader>cc' }, { '<leader>cb' } } },
  { 'fedepujol/move.nvim', cmd = { 'MoveLine', 'MoveBlock', 'MoveHChar', 'MoveHBlock' } },
  { 'ray-x/lsp_signature.nvim', enabled = false, config = config('ray-x/lsp_signature.nvim') },
  { 'glepnir/lspsaga.nvim', cmd = { 'Lspsaga' }, config = config('glepnir/lspsaga.nvim') },
  { 'folke/trouble.nvim', cmd = { 'TroubleToggle' }, config = config('folke/trouble.nvim') },
  { 'lukas-reineke/indent-blankline.nvim', event = { 'BufReadPost', 'BufNewFile' }, config = config('lukas-reineke/indent-blankline.nvim') },
  { 'HiPhish/nvim-ts-rainbow2', event = 'BufReadPost', config = config('HiPhish/nvim-ts-rainbow2') },
  { 'p00f/godbolt.nvim', ft = { 'c', 'cpp' }, config = config('p00f/godbolt.nvim') },
  -- LSP Core
  { 'neovim/nvim-lspconfig', event = 'InsertEnter', ft = { 'c', 'cpp', 'lua' }, config = require('module.lsp').setup, dependencies = { 'j-hui/fidget.nvim', 'ray-x/lsp_signature.nvim' } },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'p00f/clangd_extensions.nvim' },
  { 'folke/neodev.nvim' },
}
