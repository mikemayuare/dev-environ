return {
  { -- Quarto plugin for .qmd files
    "quarto-dev/quarto-nvim",
    dev = false,
    dependencies = {
      -- Properly define otter as a dependency plugin object
      {
        "jmbuhr/otter.nvim",
        opts = {
          lsp = {
            diagnostic_update_events = { "BufWritePost", "InsertLeave" },
          },
        },
      },
    },
    opts = {
      lspFeatures = {
        enabled = true,
        chunks = "all",
        languages = { "python" },
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
        default_method = "iron",
      },
    },
    config = function(_, opts)
      require("quarto").setup(opts)

      -- --- THE FIX FOR PYRIGHT & OTTER ---
      -- This tells Otter to automatically activate and pull in your LSPs (pyright, etc.)
      -- whenever you open a quarto file.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "quarto",
        callback = function()
          local otter = require("otter")
          -- Activates LSP for specified languages, fallback to global configs (like your pyright)
          otter.activate({ "python" }, true, true, nil)
        end,
      })
      -- ----------------------------------

      local runner = require("quarto.runner")
      vim.keymap.set("n", "<leader>ic", runner.run_cell, { desc = "run cell", silent = true })
      vim.keymap.set("n", "<leader>ia", runner.run_above, { desc = "run cell and above", silent = true })
      vim.keymap.set("n", "<leader>iA", runner.run_all, { desc = "run all cells", silent = true })
      vim.keymap.set("n", "<leader>il", runner.run_line, { desc = "run line", silent = true })
      vim.keymap.set("v", "<leader>i", runner.run_range, { desc = "run visual range", silent = true })
      vim.keymap.set("n", "<leader>iR", function()
        runner.run_all(true)
      end, { desc = "run all cells of all languages", silent = true })
      vim.keymap.set("n", "<leader>ip", function()
        vim.fn.jobstart("quarto preview " .. vim.fn.expand("%")) -- { detach = true })
      end, { desc = "start quarto preview" })
      vim.keymap.set("n", "<leader>ir", function()
        vim.cmd("!quarto render %")
      end, { desc = "render quarto document" })

      -- run cell and move to next
      local function run_cell_and_move_next()
        runner.run_cell()
        local cell_end = vim.fn.search("^```\\s*$", "W")
        if cell_end == 0 then
          return
        end
        local next_start = vim.fn.search("^```{", "W")
        if next_start ~= 0 then
          vim.cmd("normal! j")
        end
      end

      vim.keymap.set("n", "<leader>in", run_cell_and_move_next, { desc = "run cell and move to next", silent = true })
    end,
  },

  -- (Keep your img-clip and nabla plugins below as they are)
}
