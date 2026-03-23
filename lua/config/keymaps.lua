-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Dev-C++ Style: Compile and Run in a NEW terminal window with <F5>
vim.keymap.set("n", "<F5>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype
    local compiler = (file_type == "cpp") and "g++" or (file_type == "c") and "gcc" or nil

    if compiler then
        vim.cmd("write")
        local run_cmd = string.format(
            "%s '%s' -o '%s' && '%s'; rm -f '%s'; echo; echo '--------------------------------'; read -p 'Process finished. Press Enter to exit...' dummy",
            compiler, file, out, out, out
        )

        -- Check if ptyxis is available
        if vim.fn.executable("ptyxis") == 1 then
            -- Use external ptyxis terminal
            vim.fn.jobstart({ "ptyxis", "--", "bash", "-c", run_cmd }, { detach = true })
        else
            -- Fallback to toggleterm floating window
            local Terminal = require("toggleterm.terminal").Terminal
            local run_term = Terminal:new({
                cmd = run_cmd,
                direction = "float",
                close_on_exit = false,
                float_opts = {
                    border = "curved",
                },
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })
            run_term:toggle()
        end
    else
        print("Not a C/C++ file")
    end
end, { desc = "Compile and Run (Smart: ptyxis or toggleterm)" })

-- F6: Run in bottom split terminal
vim.keymap.set("n", "<F6>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype
    local compiler = (file_type == "cpp") and "g++" or (file_type == "c") and "gcc" or nil

    if compiler then
        vim.cmd("write")
        local run_cmd = string.format("%s '%s' -o '%s' && '%s'; rm -f '%s'", compiler, file, out, out, out)

        local Terminal = require("toggleterm.terminal").Terminal
        local run_term = Terminal:new({
            cmd = run_cmd,
            direction = "horizontal",
            close_on_exit = false,
            on_open = function(term)
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
        })
        run_term:toggle()
    else
        print("Not a C/C++ file")
    end
end, { desc = "Run in bottom terminal (F6)" })

-- F7: Debug mode with nvim-dap (fully automated)
vim.keymap.set("n", "<F7>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype
    local compiler = (file_type == "cpp") and "g++" or (file_type == "c") and "gcc" or nil

    if compiler then
        vim.cmd("write")
        local compile_cmd = string.format("%s '%s' -g -O0 -o '%s'", compiler, file, out)
        vim.fn.jobstart(compile_cmd, {
            stdout_buffered = true,
            on_exit = function(_, exit_code)
                if exit_code == 0 then
                    vim.schedule(function()
                        require("dap").continue()
                    end)
                else
                    vim.schedule(function()
                        print("Compilation failed with exit code: " .. exit_code)
                    end)
                end
            end,
        })
    else
        print("Not a C/C++ file")
    end
end, { desc = "Compile with -g -O0 and start debugging (F7)" })
