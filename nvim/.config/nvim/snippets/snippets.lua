local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s("py", {
    t("```{python}"),
    t({ "", "" }), -- new line
    i(0), -- cursor will land here
    t({ "", "```" }),
  }),
}
