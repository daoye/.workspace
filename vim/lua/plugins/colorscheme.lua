return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },

  -- one
  {
    "rakr/vim-one",
    lazy = true,
    name = "one",
  },

  -- gruvbox
  { "ellisonleao/gruvbox.nvim" },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = true,
        noice = true,
        mini = true,
        barbar = true,
        mason = true,
        mini = true,
        treesitter_context = true,
        leap = true,
      },
    },
  },
}
