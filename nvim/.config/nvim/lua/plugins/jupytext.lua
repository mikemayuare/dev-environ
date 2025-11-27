return {
  "GCBallesteros/jupytext.nvim",
  opts = {
    custom_language_formatting = {
      python = {
        extension = "qmd",
        style = "quarto",
        force_ft = "quarto",
      },
      r = {
        extension = "qmd",
        style = "quarto",
        force_ft = "quarto",
      },
    },
  },
  config = function(_, opts)
    require("jupytext").setup(opts)

    -- Set jupytext to use global environment
    vim.g.jupytext_fmt_python_executable = vim.fn.expand("~/.config/nvim/nvim-venv/bin/python")

    -- Create new notebook command
    vim.api.nvim_create_user_command("NewNotebook", function(cmd_opts)
      local filename = cmd_opts.args
      if filename == "" then
        vim.notify("Usage: :NewNotebook <filename.ipynb>", vim.log.levels.ERROR)
        return
      end

      -- Ensure .ipynb extension
      if not filename:match("%.ipynb$") then
        filename = filename .. ".ipynb"
      end

      -- Create minimal notebook structure as properly formatted JSON
      local notebook_json = [[{
        "cells": [
          {
          "cell_type": "code",
          "execution_count": null,
          "metadata": {},
          "outputs": [],
          "source": []
          }
        ],
        "metadata": {
          "kernelspec": {
          "display_name": "Python 3",
          "language": "python",
          "name": "python3"
          },
          "language_info": {
          "name": "python",
          "version": "3.10.0"
          }
        },
        "nbformat": 4,
        "nbformat_minor": 5
        }]]

      -- Write the file
      vim.fn.writefile(vim.split(notebook_json, "\n"), filename)

      -- Open the file (jupytext will convert it)
      vim.cmd("edit " .. filename)
      vim.notify("Created new notebook: " .. filename, vim.log.levels.INFO)
    end, { nargs = 1, complete = "file" })
  end,
}
