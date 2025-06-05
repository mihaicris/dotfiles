return {
  {
    'L3MON4D3/LuaSnip',
    lazy = false,
    config = function(opts)
      local luasnip = require('luasnip')
      luasnip.setup()
      require('luasnip.loaders.from_snipmate').load({ 
        paths = vim.fn.stdpath("config") .. "/snippets" 
      })
    end,
  },
}
