return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- Set the layout preset here
            preset = "modern", -- Options: "classic", "modern", "helix"

            -- You can also customize the layout behavior here
            layout = {
                spacing = 6, -- increase spacing between columns
                width = { min = 20, max = 50 },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
}
