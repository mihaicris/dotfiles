return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Optional configurations
     
      -- Automatically authenticate Copilot
      vim.defer_fn(function()
        vim.cmd("Copilot auth")
      end, 100) -- Add a small delay to ensure it initializes properly
    end,  
  },
}


