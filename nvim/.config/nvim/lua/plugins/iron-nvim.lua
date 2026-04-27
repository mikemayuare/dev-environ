return {
  "Vigemus/iron.nvim",
  enabled = true,
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { "fish" },
          },
          -- Updated Python configuration below
          python = {
            command = function()
              -- Note: You MUST have the 'linux-cultist/venv-selector.nvim' plugin installed for this to work
              local venv_path = require("venv-selector").venv()
              local venv_name = ""

              if venv_path and venv_path ~= "" then
                venv_name = vim.fn.fnamemodify(venv_path, ":t")
              else
                venv_name = "Global Python"
              end

              print("Virtual environment activated: " .. venv_name)

              return {
                "ipython",
                "--no-autoindent",
                "-c",
                "import sys; print('========== iron.nvim REPL (quarto) =========='); print('Venv:', '"
                  .. venv_name
                  .. "'); print('Python:', sys.version.split()[0]); print('====================================')",
                "-i",
              }
            end,
            format = function(lines, extras)
              local result = common.bracketed_paste_python(lines, extras)
              local filtered = vim.tbl_filter(function(line)
                return not string.match(line, "^%s*#")
              end, result)

              -- Debug: print what's being sent
              vim.notify("Lines being sent:\n" .. vim.inspect(filtered), vim.log.levels.INFO)

              return filtered
            end,
            -- format = function(lines, extras)
            --   local result = common.bracketed_paste_python(lines, extras)
            --   local filtered = vim.tbl_filter(function(line)
            --     return not string.match(line, "^%s*#")
            --   end, result)
            --   return filtered
            -- end,
            block_dividers = { "# %%", "#%%" },
            -- env = { PYTHON_BASIC_REPL = "1" },
          },
          quarto = {
            command = function()
              local venv_path = require("venv-selector").venv()
              local venv_name = ""
              if venv_path and venv_path ~= "" then
                venv_name = vim.fn.fnamemodify(venv_path, ":t")
              else
                venv_name = "Global Python"
              end
              print("Virtual environment activated for quarto: " .. venv_name)
              return {
                "ipython",
                "--no-autoindent",
                "-c",
                "import sys; print('========== iron.nvim REPL =========='); print('Venv:', '"
                  .. venv_name
                  .. "'); print('Python:', sys.version.split()[0]); print('====================================')",
                "-i",
              }
            end,
            format = function(lines, extras)
              local result = {}
              table.insert(result, "%cpaste -q")
              for _, line in ipairs(lines) do
                if not string.match(line, "^%s*#") then
                  table.insert(result, line)
                end
              end
              table.insert(result, "--") -- IPython's cpaste terminator
              return result
            end,
            -- format = function(lines, extras)
            --   local result = common.bracketed_paste_python(lines, extras)
            --   return vim.tbl_filter(function(line)
            --     return not string.match(line, "^%s*#")
            --   end, result)
            -- end,
            block_dividers = { "# %%", "#%%" },
          },
          -- quarto = {
          --   command = { "ipython", "--no-autoindent" },
          --   format = common.bracketed_paste_python,
          -- },
        },
        repl_filetype = function(bufnr, ft)
          return ft
        end,
        dap_integration = true,
        repl_open_cmd = view.split.vertical.rightbelow("%40"),
      },
      keymaps = {
        toggle_repl = "<space>jr",
        restart_repl = "<space>jR",
        send_motion = "<space>js",
        visual_send = "<space>js",
        send_file = "<space>jf",
        send_line = "<space>jl",
        send_paragraph = "<space>jp",
        send_until_cursor = "<space>ju",
        send_mark = "<space>jm",
        send_code_block = "<space>jb",
        send_code_block_and_move = "<space>jn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>j<cr>",
        interrupt = "<space>j<space>",
        exit = "<space>jq",
        clear = "<space>kl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
      env = {
        BROWSER = "firefox",
      },
    })

    vim.keymap.set("n", "<space>jf", "<cmd>IronFocus<cr>", { desc = "Iron: Focus REPL" })
    vim.keymap.set("n", "<space>jh", "<cmd>IronHide<cr>", { desc = "Iron: Hide REPL" })
  end,
}
