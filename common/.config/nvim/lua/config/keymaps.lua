-- lua/config/keymaps.lua

local map = vim.keymap.set

-- Split Navigation (Alt+Shift + hjkl)
map('n', '<M-H>', '<C-w>h', { desc = "Go to Left Window" })
map('n', '<M-J>', '<C-w>j', { desc = "Go to Lower Window" })
map('n', '<M-K>', '<C-w>k', { desc = "Go to Upper Window" })
map('n', '<M-L>', '<C-w>l', { desc = "Go to Right Window" })

-- Escape Hatch
map('i', 'jk', '<ESC>', { desc = "Escape" })
map('n', '<leader>ev', ":edit $MYVIMRC<CR>", { desc = "Edit Config" })

-- C++ Switch Header/Source
map('n', '<M-o>', '<cmd>ClangdSwitchSourceHeader<cr>', { desc = "Switch Source/Header" })

-- CMake (<leader>c)
map('n', '<leader>cp', '<cmd>CMakeSelectConfigurePreset<cr>', { desc = "Select Configure Preset" })
map('n', '<leader>cg', '<cmd>CMakeGenerate<cr>', { desc = "CMake Generate (re-configure)" })
map('n', '<leader>cb', '<cmd>CMakeBuild<cr>', { desc = "CMake Build" })
map('n', '<leader>ct', '<cmd>CMakeRunTest<cr>', { desc = "CMake Test" })
map('n', '<leader>cc', '<cmd>CMakeClean<cr>', { desc = "CMake Clean" })
map('n', '<leader>cs', '<cmd>CMakeStop<cr>', { desc = "Stop Active Build" })
map('n', '<leader>ci', '<cmd>CMakeStepOut<cr>', { desc = "Toggle CMake Console" })

-- Git (<leader>g)
map('n', '<leader>gb', '<cmd>Telescope git_branches<cr>', { desc = "Git Branches" })
map('n', '<leader>gs', '<cmd>Telescope git_status<cr>', { desc = "Git Status" })
map('n', '<leader>gl', '<cmd>Telescope git_commits<cr>', { desc = "Git Commits" })

-- Diagnostics
map('n', 'gl', vim.diagnostic.open_float, { desc = "Show Diagnostic" })
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- Move Lines
map('n', '<M-j>', '<cmd>m .+1<cr>==', { desc = "Move Line Down" })
map('n', '<M-k>', '<cmd>m .-2<cr>==', { desc = "Move Line Up" })
map('v', '<M-j>', ":m '>+1<cr>gv=gv", { desc = "Move Selection Down" })
map('v', '<M-k>', ":m '<-2<cr>gv=gv", { desc = "Move Selection Up" })

-- Buffer Management
map('n', '<leader>bd', '<cmd>bdelete<cr>', { desc = "Close Buffer" })
map('n', '<leader>bo', '<cmd>%bdelete|edit#|bdelete#<cr>', { desc = "Close Other Buffers" })