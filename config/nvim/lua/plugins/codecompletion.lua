return {
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      local opts = {
        -- Where to get completion results from
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = "luasnip" },
        }, {
            { name = "nvim_lsp" },
            { name = "buffer"},
            { name = "path" },
          }),
        mapping = cmp.mapping.preset.insert({
          -- Make 'enter' key select the completion
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          -- Super-tab behavior
          ["<Tab>"] = cmp.mapping(function(original)
            if cmp.visible() then
              cmp.select_next_item() -- run completion selection if completing
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump() -- expand snippets
            else
              original()      -- run the original behavior if not completing
            end
          end, {"i", "s"}),
          ["<S-Tab>"] = cmp.mapping(function(original)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.jump(-1)
            else
              original()
            end
          end, {"i", "s"}),
        }),
      }
      cmp.setup(opts)
    end,
  },
}

