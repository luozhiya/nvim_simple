return {
  -- Framework
  { 'folke/tokyonight.nvim' },
  { 'stevearc/aerial.nvim' },
  { 'lewis6991/gitsigns.nvim' },
  { 'folke/which-key.nvim' },
  { 'akinsho/toggleterm.nvim' },
  { 'nvim-treesitter/nvim-treesitter' },
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope.nvim' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
  { 'debugloop/telescope-undo.nvim' },
  { 'nvim-telescope/telescope-frecency.nvim' },
  { 'nvim-telescope/telescope-live-grep-args.nvim' },
  { 'nvim-telescope/telescope-file-browser.nvim' },
  { 'nvim-tree/nvim-tree.lua' },
  { 'anuvyklack/hydra.nvim' },
  { 'stevearc/dressing.nvim' },
  { 'ahmedkhalf/project.nvim' },
  { 'kkharji/sqlite.lua' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-cmdline' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'windwp/nvim-autopairs' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'j-hui/fidget.nvim' },
  { 'MunifTanjim/nui.nvim' },
  { 'VonHeikemen/fine-cmdline.nvim' },

  -- Core Coding LSP/Complete
  { 'neovim/nvim-lspconfig' },
  { 'p00f/clangd_extensions.nvim' },
  { 'ray-x/lsp_signature.nvim' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'folke/neodev.nvim' },
}
