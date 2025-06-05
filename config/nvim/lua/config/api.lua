
function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local lines_count = vim.v.foldend - vim.v.foldstart + 1
  return "⯈ " .. vim.fn.trim(line) .. "  ─ " .. lines_count .. " lines"
end

-- Swift folding config with foldtext set
vim.api.nvim_create_autocmd("FileType", {
  pattern = "swift",
  callback = function()
    
    -- Match Folded color to Normal
    vim.api.nvim_set_hl(0, "Folded", {
      fg = vim.api.nvim_get_hl_by_name("Normal", true).foreground,
      bg = vim.api.nvim_get_hl_by_name("Normal", true).background,
    })

    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldenable = true
    vim.opt_local.foldcolumn = "1"
    vim.opt.foldtext = "v:lua.custom_fold_text"
  end,
})

