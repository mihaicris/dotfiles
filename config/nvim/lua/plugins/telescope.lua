return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
        ensure_installed = { "swift" }
    })

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files previewer=false<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {})
    keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {})
  end,
}
