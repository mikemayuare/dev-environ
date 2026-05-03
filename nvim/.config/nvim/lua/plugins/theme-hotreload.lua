return {
    {
        name = "theme-hotreload",
        dir = vim.fn.stdpath("config"),
        lazy = false,
        priority = 1000,
        config = function()
            local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyReload",
                callback = function()
                    -- 1. Unload the theme config module
                    package.loaded["plugins.theme"] = nil

                    vim.schedule(function()
                        -- 2. CLEAR HIGHLIGHTS FIRST.
                        -- `highlight clear` resets `vim.o.background` to default.
                        -- We must do this before loading your new config so we don't overwrite your new settings.
                        vim.cmd("highlight clear")
                        if vim.fn.exists("syntax_on") == 1 then
                            vim.cmd("syntax reset")
                        end

                        -- 3. Now parse the new config
                        local ok, theme_spec = pcall(require, "plugins.theme")
                        if not ok then
                            return
                        end

                        local theme_plugin_name = nil
                        local colorscheme_name = nil

                        for _, spec in ipairs(theme_spec) do
                            if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
                                theme_plugin_name = spec.name or spec[1]
                            end
                            if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
                                colorscheme_name = spec.opts.colorscheme
                            end
                        end

                        if not colorscheme_name then
                            return
                        end

                        -- 4. Unload theme plugin modules (scorched earth)
                        if theme_plugin_name then
                            local plugin = require("lazy.core.config").plugins[theme_plugin_name]
                            if plugin then
                                -- Wipe old global variables (fixes Gruvbox/Everforest legacy settings)
                                for k, _ in pairs(vim.g) do
                                    if k:match("^" .. colorscheme_name) then
                                        vim.g[k] = nil
                                    end
                                end

                                local plugin_dir = plugin.dir .. "/lua"
                                require("lazy.core.util").walkmods(plugin_dir, function(modname)
                                    package.loaded[modname] = nil
                                    package.preload[modname] = nil
                                end)
                            end
                        end

                        -- 5. Load the colorscheme plugin
                        require("lazy.core.loader").colorscheme(colorscheme_name)

                        vim.defer_fn(function()
                            -- Apply the colorscheme
                            pcall(vim.cmd.colorscheme, colorscheme_name)

                            -- Reload transparency settings
                            if vim.fn.filereadable(transparency_file) == 1 then
                                vim.cmd.source(transparency_file)
                            end

                            -- Force UI plugins to recalculate
                            vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                            if package.loaded["lualine"] then
                                pcall(require("lualine").setup)
                            end

                            -- 6. FORCE CURSORLINE REDRAW
                            -- Loop through all open windows and toggle cursorline to bust the cache
                            for _, win in ipairs(vim.api.nvim_list_wins()) do
                                local has_cursorline = vim.api.nvim_get_option_value("cursorline", { win = win })
                                if has_cursorline then
                                    vim.api.nvim_set_option_value("cursorline", false, { win = win })
                                    vim.api.nvim_set_option_value("cursorline", true, { win = win })
                                end
                            end

                            -- Final redraw
                            vim.cmd("redraw!")
                        end, 10)
                    end)
                end,
            })
        end,
    },
}
