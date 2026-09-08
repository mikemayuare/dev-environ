return {
  {
    "3rd/image.nvim",
    build = false, -- prevent Lazy from building the rock when using magick_cli
    opts = {
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          floating_windows = true, -- recommended for render-markdown popups/floats
        },
      },
    },
  },
}
