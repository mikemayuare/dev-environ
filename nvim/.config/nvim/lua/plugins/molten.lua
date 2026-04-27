return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    lazy = false,
    dependencies = {
      -- Optional but recommended: image rendering in the terminal
      -- Remove if you don't use image.nvim
      "3rd/image.nvim",
    },
    ft = { "python", "quarto", "markdown" },
    init = function()
      -- All molten config must go in init, not config,
      -- because it's a remote plugin and options are loaded at init time.

      -- Image rendering: "image.nvim" | "wezterm" | "none"
      vim.g.molten_image_provider = "image.nvim"

      -- Show output as virtual text below the cell (stays after cursor leaves)
      vim.g.molten_virt_text_output = true

      -- Shift virtual text up by 1 line (useful in markdown/quarto so it
      -- doesn't cover the closing ``` of a code fence)
      vim.g.molten_virt_lines_off_by_1 = true

      -- Max lines of virtual text output
      vim.g.molten_virt_text_max_lines = 20

      -- Don't auto-open the floating output window on cursor enter
      -- (virtual text is enough; open manually with <localleader>os)
      vim.g.molten_auto_open_output = false

      -- Wrap long output lines
      vim.g.molten_wrap_output = true

      -- Output window appearance
      vim.g.molten_output_win_max_height = 30
      vim.g.molten_output_win_border = { "", "━", "", "" }
      vim.g.molten_use_border_highlights = true

      -- Pad buffer with virtual lines so output window doesn't cover code
      vim.g.molten_output_virt_lines = true

      -- Poll kernel every 200ms for snappier updates (default 500)
      vim.g.molten_tick_rate = 200

      -- When "raise", commands won't auto-prompt for a kernel — lets
      -- other plugins (like quarto) handle that themselves via pcall
      vim.g.molten_auto_init_behavior = "raise"
    end,
    config = function()
      -- Auto-init kernel when opening a .ipynb (via jupytext or direct)
      -- Tries the notebook's own kernelspec name, then falls back to
      -- the active venv name (works with venv-selector.nvim)
      vim.api.nvim_create_autocmd("BufAdd", {
        pattern = "*.ipynb",
        callback = function(e)
          vim.schedule(function()
            local kernels = vim.fn.MoltenAvailableKernels()

            -- Try to read kernelspec from the notebook metadata
            local try_kernel_name = function()
              local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
              return metadata.kernelspec.name
            end

            local ok, kernel_name = pcall(try_kernel_name)

            if not ok or not vim.tbl_contains(kernels, kernel_name) then
              -- Fall back to active venv name (venv-selector.nvim)
              kernel_name = nil
              local venv = os.getenv("VIRTUAL_ENV")
              if venv then
                kernel_name = vim.fn.fnamemodify(venv, ":t")
              end
            end

            if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
              vim.cmd(("MoltenInit %s"):format(kernel_name))
            end

            -- Load saved outputs if they exist
            vim.cmd("MoltenImportOutput")
          end)
        end,
      })

      -- ─── Keymaps ────────────────────────────────────────────────────
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end

      -- Init / lifecycle
      map("n", "<localleader>mi", ":MoltenInit<CR>", "Molten: init kernel")
      map("n", "<localleader>mR", ":MoltenRestart!<CR>", "Molten: restart kernel (clear outputs)")
      map("n", "<localleader>mD", ":MoltenDeinit<CR>", "Molten: deinit kernel")

      -- Run code
      map("n", "<localleader>me", ":MoltenEvaluateOperator<CR>", "Molten: run operator")
      map("n", "<localleader>ml", ":MoltenEvaluateLine<CR>", "Molten: run line")
      map("n", "<localleader>mr", ":MoltenReevaluateCell<CR>", "Molten: re-run cell")
      map("v", "<localleader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", "Molten: run visual")

      -- Navigate cells
      map("n", "<localleader>mn", ":MoltenNext<CR>", "Molten: next cell")
      map("n", "<localleader>mp", ":MoltenPrev<CR>", "Molten: prev cell")

      -- Output window
      map("n", "<localleader>mo", ":MoltenShowOutput<CR>", "Molten: show output")
      map("n", "<localleader>mh", ":MoltenHideOutput<CR>", "Molten: hide output")
      map("n", "<localleader>ms", ":noautocmd MoltenEnterOutput<CR>", "Molten: enter output")
      map("n", "<localleader>md", ":MoltenDelete<CR>", "Molten: delete cell")
      map("n", "<localleader>mI", ":MoltenInterrupt<CR>", "Molten: interrupt kernel")
      map("n", "<localleader>mP", ":MoltenImagePopup<CR>", "Molten: image popup")

      -- Save / load outputs
      map("n", "<localleader>mS", ":MoltenSave<CR>", "Molten: save outputs")
      map("n", "<localleader>mL", ":MoltenLoad<CR>", "Molten: load outputs")
      map("n", "<localleader>mE", ":MoltenExportOutput!<CR>", "Molten: export to ipynb")
    end,
  },
}
