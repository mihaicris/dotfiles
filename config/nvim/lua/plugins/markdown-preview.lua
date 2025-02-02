return {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function()
    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>m", "<cmd>MarkdownPreview<CR>", { desc = "Start Preview" })
  end,
}
