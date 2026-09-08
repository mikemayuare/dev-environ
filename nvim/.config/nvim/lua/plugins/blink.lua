return {
  "saghen/blink.cmp",
  dependencies = {
    "jmbuhr/otter.nvim",
  },
  opts = {
    keymap = {},
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      menu = { border = "single" },
      documentation = { window = { border = "single" } },
    },
    signature = {
      enabled = true,
      window = { border = "single" },
    },
  },
}
