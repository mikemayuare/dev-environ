local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("all", {
  s("tri", {
    t('"""'),
    t({ "", "" }), -- new line
    i(0), -- cursor will land here
    t({ "", '"""' }),
  }),
})
