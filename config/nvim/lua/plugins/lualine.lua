return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
        options = {
          theme = 'auto', -- Change to your preferred theme (e.g., 'tokyonight', 'onedark', etc.)
          section_separators = '' ,
          component_separators = '',
          disabled_filetypes = { "NvimTree", "lazy" }, -- Disable lualine for specific file types
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "filename" },
          lualine_c = { "branch", "diff", "diagnostics" },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "fugitive", "nvim-tree", "quickfix" }, -- Add extensions for specific integrations
      })
  end,
}
