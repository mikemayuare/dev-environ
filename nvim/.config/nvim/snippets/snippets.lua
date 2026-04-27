local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Use ls.add_snippets to explicitly register the snippet for the "markdown" or "quarto" filetype.
-- Change "all" to "markdown" if you only want this in markdown files.
ls.add_snippets("all", {
  s("py", {
    -- Opening block
    t("```{python}"),

    -- Interactive Label
    t({ "", "#| label: " }),
    i(1, "fig-example"),

    -- Interactive Code Summary
    t({ "", '#| code-summary: "' }),
    i(2, "Description"),
    t('"'),

    -- Blank line and cursor position for code
    t({ "", "", "" }),
    i(0),

    -- Closing block
    t({ "", "```" }),
  }),
})

-- Returning true just to signal the file was sourced correctly
return true
