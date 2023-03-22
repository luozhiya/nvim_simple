local config = require('module.settings').config
return {
  -- Framework
  { 'nvim-lua/plenary.nvim' },
  { 'folke/tokyonight.nvim', lazy = false, priority = 1000, config = config('folke/tokyonight.nvim') },
  --- Treesitter
  { 'nvim-treesitter/nvim-treesitter', config = config('nvim-treesitter/nvim-treesitter') },
  --- Telescope
  { 'nvim-telescope/telescope.nvim', config = config('nvim-telescope/telescope.nvim') },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { 'debugloop/telescope-undo.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-file-browser.nvim' },
  { 'jonarrien/telescope-cmdline.nvim' },
  { 'ahmedkhalf/project.nvim', config = config('ahmedkhalf/project.nvim') },
  --- Completion
  { 'hrsh7th/nvim-cmp', config = config('hrsh7th/nvim-cmp') },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  --- Base
  { 'kkharji/sqlite.lua' },
  { 'anuvyklack/hydra.nvim' },
  { 'MunifTanjim/nui.nvim' },
  { 'stevearc/dressing.nvim', config = config('stevearc/dressing.nvim') },
  --- Git
  { 'lewis6991/gitsigns.nvim', config = config('lewis6991/gitsigns.nvim') },
  { 'akinsho/toggleterm.nvim', config = config('akinsho/toggleterm.nvim') },
  --- Buffer
  { 'qpkorr/vim-bufkill' },
  { 'moll/vim-bbye' },
  { 'kazhala/close-buffers.nvim', config = config('kazhala/close-buffers.nvim') },
  --- Key Management
  { 'folke/which-key.nvim', config = config('folke/which-key.nvim') },
  { 'mrjones2014/legendary.nvim', config = config('mrjones2014/legendary.nvim') },
  --- UI
  { 'stevearc/aerial.nvim', config = config('stevearc/aerial.nvim') },
  { 'j-hui/fidget.nvim', config = config('j-hui/fidget.nvim') },
  { 'nvim-lualine/lualine.nvim', config = config('nvim-lualine/lualine.nvim') },
  { 'nvim-tree/nvim-tree.lua', config = config('nvim-tree/nvim-tree.lua') },
  --- CmdLine
  { 'VonHeikemen/fine-cmdline.nvim', config = config('VonHeikemen/fine-cmdline.nvim'), cmd = { 'FineCmdline' } },
  { 'gelguy/wilder.nvim', config = config('gelguy/wilder.nvim') },
  --- Edit
  { 'tpope/vim-obsession' },
  { 'windwp/nvim-autopairs' },
  { 'numToStr/Comment.nvim', keys = { { '<leader>cc' }, { '<leader>cb' } } },
  { 'fedepujol/move.nvim', cmd = { 'MoveLine', 'MoveBlock', 'MoveHChar', 'MoveHBlock' } },
  { 'ray-x/lsp_signature.nvim', config = config('ray-x/lsp_signature.nvim') },

  -- LSP
  { 'neovim/nvim-lspconfig', config = require('module.lsp').setup },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'p00f/clangd_extensions.nvim' },
  { 'folke/neodev.nvim' },
}
