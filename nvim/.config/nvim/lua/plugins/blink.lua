return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<Tab>"] = { "accept", "fallback" },
      ["<CR>"] = { "fallback" }, -- make Enter insert newline normally
    },
  },
}
