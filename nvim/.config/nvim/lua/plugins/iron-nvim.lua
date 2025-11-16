return {
  "Vigemus/iron.nvim",
  enabled = true,
  config = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")
    iron.setup({
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = { "fish" },
          },
          python = {
            command = { "ipython" },
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
            -- env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
          },
          -- Add quarto support - it uses Python's ipython
          quarto = {
            command = { "ipython" },
            format = common.bracketed_paste_python,
          },
        },
        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the
        -- language being used for the REPL.
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,
        -- Send selections to the DAP repl if an nvim-dap session is running.
        dap_integration = true,
        -- How the repl window will be displayed
        repl_open_cmd = view.split.botright(0.4),
      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        toggle_repl = "<space>jr", -- toggles the repl open and closed.
        restart_repl = "<space>jR", -- calls `IronRestart` to restart the repl
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
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      env = {
        BROWSER = "firefox", -- or your preferred browser
      },
    })
    -- iron also has a list of commands, see :h iron-commands for all available commands
    -- Place custom keymaps here as well
    vim.keymap.set("n", "<space>jf", "<cmd>IronFocus<cr>", { desc = "Iron: Focus REPL" })
    vim.keymap.set("n", "<space>jh", "<cmd>IronHide<cr>", { desc = "Iron: Hide REPL" })
  end,
}
