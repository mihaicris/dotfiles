return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      treesitter.setup({
        incremental_selection = {
          enable = false,
          keymaps = {
            scope_incremental = "a",
            node_decremental = "z",
          },
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = false },
        ensure_installed = {
          "asm",
          "bash",
          "c",
          "clojure",
          "cmake",
          "cpp",
          "css",
          "csv",
          "d",
          "editorconfig",
          "git_config",
          "gitcommit",
          "gitignore",
          "html",
          "java",
          "javascript",
          "json",
          "kotlin",
          "latex",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "mermaid",
          "nix",
          "ruby",
          "rust",
          "swift",
          "vim",
          "yaml",
          "zig",
        },
        auto_install = true,
      })
    end,
  },
}
