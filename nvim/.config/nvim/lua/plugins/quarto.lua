return {
  { -- Quarto plugin for .qmd files
    "quarto-dev/quarto-nvim",
    dev = false,
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "curly",
        languages = { "python", "r", "julia", "bash" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      codeRunner = {
        enabled = true,
        default_method = "iron", -- Using iron.nvim instead of slime
      },
    },
    dependencies = {
      -- For language features in code cells
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function(_, opts)
      require("quarto").setup(opts)

      -- Setup otter for embedded language support
      local otter = require("otter")

      -- Auto-activate otter when entering quarto files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "quarto", "markdown" },
        callback = function()
          otter.activate({ "python", "r", "julia", "bash" }, true, true, nil)
        end,
      })

      -- Quarto keybindings for running code
      local runner = require("quarto.runner")
      vim.keymap.set("n", "<leader>ic", runner.run_cell, { desc = "run cell", silent = true })
      vim.keymap.set("n", "<leader>ia", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<leader>iA", runner.run_all, { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<leader>il", runner.run_line, { desc = "run line", silent = true })
      vim.keymap.set("v", "<leader>i", runner.run_range, { desc = "run visual range", silent = true })

      -- Run all cells of all languages
      vim.keymap.set("n", "<leader>iR", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })

      -- Start quarto preview in browser (live preview server)
      vim.keymap.set("n", "<leader>ip", function()
        vim.fn.jobstart("quarto preview " .. vim.fn.expand("%"), { detach = true })
      end, { desc = "start quarto preview" })

      -- Render current document (execute all code once)
      vim.keymap.set("n", "<leader>ir", function()
        vim.cmd("!quarto render %")
      end, { desc = "render quarto document" })

      -- Keybinding to manually activate otter
      vim.keymap.set("n", "<leader>io", function()
        otter.activate({ "python", "r", "julia", "bash" }, true, true, nil)
      end, { desc = "activate otter for code chunks" })
    end,
  },
  { -- Paste images from clipboard or drag-and-drop
    "HakonHarnes/img-clip.nvim",
    event = "BufEnter",
    ft = { "markdown", "quarto", "latex" },
    opts = {
      default = {
        dir_path = "img",
      },
      filetypes = {
        markdown = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
        quarto = {
          url_encode_path = true,
          template = "![$CURSOR]($FILE_PATH)",
          drag_and_drop = {
            download_images = false,
          },
        },
      },
    },
    config = function(_, opts)
      require("img-clip").setup(opts)
      vim.keymap.set("n", "<leader>ii", ":PasteImage<cr>", { desc = "insert [i]mage from clipboard" })
    end,
  },
  { -- Preview LaTeX equations inline
    "jbyuki/nabla.nvim",
    keys = {
      { "<leader>qm", ':lua require"nabla".toggle_virt()<cr>', desc = "toggle [m]ath equations" },
    },
  },
}
