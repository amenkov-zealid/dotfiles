-- Catppuccin (mocha), matching the tmux theme. No separator glyphs between
-- sections, to match tmux's "basic" window style (plain colored blocks).
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
    },
  },
  { "LazyVim/LazyVim", opts = { colorscheme = "catppuccin" } },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
    },
  },
}
