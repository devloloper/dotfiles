return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fA", "<cmd>Telescope find_files no_ignore=true<cr>", desc = "Find All Files (incl. ignored)" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep (regex)" },
        { "<leader>fs", function()
            require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
        end, desc = "Grep String (literal)" },
        { "<leader>fw", function()
            require("telescope.builtin").grep_string()
        end, desc = "Grep word under cursor" },
        { "<leader>fW", function()
            require("telescope.builtin").live_grep({ default_text = vim.fn.expand("<cword>") })
        end, desc = "Live Grep (pre-filled with word)" },
        { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "Switch Buffers" },
        { "<C-e>", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    },
    config = function(_, opts)
        require("telescope").setup(opts)
        require("telescope").load_extension("fzf")
    end,
    opts = {
        pickers = {
            find_files = {
                hidden = true,
            },
        },
    }
}
