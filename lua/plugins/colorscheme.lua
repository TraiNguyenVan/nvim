-- Extra colorschemes.
-- Kept `lazy = true`: they add nothing to startup, and still show up in the
-- <leader>uC picker because lazy.nvim exposes unloaded plugins' colors/ dirs.
return {
    -- Everforest -- green based, warm toned, soft contrast (vimscript, so
    -- options go through vim.g in `init`, which runs before the theme loads).
    {
        "sainnhe/everforest",
        lazy = true,
        init = function()
            vim.g.everforest_background = "medium" -- "hard" | "medium" | "soft"
            vim.g.everforest_better_performance = 1
        end,
    },

    -- Gruvbox -- the Lua port of the classic retro theme.
    -- `opts = {}` makes lazy.nvim run setup() before :colorscheme applies,
    -- which gruvbox.nvim requires for any config to take effect.
    {
        "ellisonleao/gruvbox.nvim",
        lazy = true,
        opts = {},
    },

    -- The declared default. This is what survives a restart (and the container).
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox",
        },
    },
}
