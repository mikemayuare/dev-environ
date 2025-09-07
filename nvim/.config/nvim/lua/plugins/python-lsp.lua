return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ruff for formatting and import sorting
        ruff = {
          -- Uses your global ~/.config/ruff/ruff.toml
        },
        -- pyright for type checking
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        -- pylsp for linting warnings + documentation
        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                -- Enable linting plugins for warnings
                pycodestyle = {
                  enabled = true,
                  maxLineLength = 88,
                  ignore = { "E501" }, -- Let ruff handle line length
                },
                mccabe = { enabled = true },
                pyflakes = { enabled = true },

                -- Keep documentation features
                jedi_hover = { enabled = true },
                jedi_signature_help = { enabled = true },
                jedi_completion = { enabled = true },

                -- Disable what pyright handles better
                jedi_references = { enabled = false },
                jedi_symbols = { enabled = false },

                -- Disable formatters (let ruff handle formatting)
                autopep8 = { enabled = false },
                yapf = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
