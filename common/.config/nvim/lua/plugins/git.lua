return {
    "lewis6991/gitsigns.nvim",
    opts = {
        signs = { add = { text = '┃' }, change = { text = '┃' } },
        on_attach = function(bufnr)
            local gs = require("gitsigns")
            vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
            vim.keymap.set("n", "]h", gs.next_hunk, { buffer = bufnr, desc = "Next hunk" })
            vim.keymap.set("n", "[h", gs.prev_hunk, { buffer = bufnr, desc = "Prev hunk" })
            vim.schedule(function() pcall(require("lualine").refresh) end)
        end,
    }
}
