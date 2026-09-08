return {
  "kitagry/bqls.nvim",
  enabled = false,
  ft = { "sql", "bigquery" },
  cmd = { "BqlsListJobHistory", "BqlsSave" },
  config = function()
    -- datasets
    require("bqls").setup({
      project_ids = { "fulfillment-dwh-production" },
    })

    -- billing
    if vim.fn.has("nvim-0.11") == 1 then
      vim.lsp.config("bqls", {
        settings = {
          project_id = "dhub-glovo",
          location = "US",
        },
        -- Disable formatting capabilities to prevent comment removal
        capabilities = {
          textDocument = {
            formatting = { enabled = false },
            rangeFormatting = { enabled = false },
          },
        },
      })
      vim.lsp.enable("bqls")
    else
      local status_ok, lspconfig = pcall(require, "lspconfig")
      if status_ok then
        lspconfig.bqls.setup({
          settings = {
            project_id = "dhub-glovo",
            location = "US",
          },
          -- Disable formatting capabilities to prevent comment removal
          capabilities = {
            textDocument = {
              formatting = { enabled = false },
              rangeFormatting = { enabled = false },
            },
          },
        })
      end
    end

    -- Toggle sidebar
    vim.keymap.set("n", "<leader>Bb", function()
      require("bqls").sidebar.toggle()
    end, { desc = "Toggle BigQuery Sidebar" })

    -- query menu
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "sql", "bigquery" },
      callback = function(ev)
        vim.keymap.set("n", "<leader>Bq", function()
          vim.lsp.buf.code_action()
        end, { buffer = ev.buf, desc = "Execute BigQuery Query" })
      end,
    })
  end,
}
