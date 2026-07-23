-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Dev-C++ Style: Compile and Run in a NEW terminal window with <F5>
vim.keymap.set("n", "<F5>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype

    local compiler, run_cmd
    if file_type == "cpp" then
        compiler = "g++"
        run_cmd = string.format(
            "%s '%s' -o '%s' && '%s'; rm -f '%s'; echo; echo '--------------------------------'; read -p 'Process finished. Press Enter to exit...' dummy",
            compiler, file, out, out, out
        )
    elseif file_type == "c" then
        compiler = "gcc"
        run_cmd = string.format(
            "%s '%s' -o '%s' && '%s'; rm -f '%s'; echo; echo '--------------------------------'; read -p 'Process finished. Press Enter to exit...' dummy",
            compiler, file, out, out, out
        )
    elseif file_type == "python" then
        run_cmd = string.format(
            "python '%s'; echo; echo '--------------------------------'; read -p 'Process finished. Press Enter to exit...' dummy",
            file
        )
    end

    if run_cmd then
        vim.cmd("write")
        if vim.fn.executable("ptyxis") == 1 then
            vim.fn.jobstart({ "ptyxis", "--", "bash", "-c", run_cmd }, { detach = true })
        elseif vim.fn.executable("kitty") == 1 then
            vim.fn.jobstart({ "kitty", "-e", "bash", "-c", run_cmd }, { detach = true })
        elseif vim.fn.executable("gnome-terminal") == 1 then
            vim.fn.jobstart({ "gnome-terminal", "--", "bash", "-c", run_cmd }, { detach = true })
        else
            local Terminal = require("toggleterm.terminal").Terminal
            local run_term = Terminal:new({
                cmd = run_cmd,
                direction = "float",
                close_on_exit = false,
                float_opts = { border = "curved" },
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })
            run_term:toggle()
        end
    else
        print("Not a C/C++/Python file")
    end
end, { desc = "Compile and Run (Smart: ptyxis or toggleterm)" })

-- F6: Run in bottom split terminal
vim.keymap.set("n", "<F6>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype

    local run_cmd
    if file_type == "cpp" then
        run_cmd = string.format("g++ '%s' -o '%s' && '%s'; rm -f '%s'", file, out, out, out)
    elseif file_type == "c" then
        run_cmd = string.format("gcc '%s' -o '%s' && '%s'; rm -f '%s'", file, out, out, out)
    elseif file_type == "python" then
        run_cmd = string.format("python '%s'", file)
    end

    if run_cmd then
        vim.cmd("write")
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
        print("Not a C/C++/Python file")
    end
end, { desc = "Run in bottom terminal (F6)" })

-- F7: Debug mode with nvim-dap (fully automated)
vim.keymap.set("n", "<F7>", function()
    local file = vim.fn.expand("%:p")
    local out = vim.fn.expand("%:p:r")
    local file_type = vim.bo.filetype

    if file_type == "cpp" or file_type == "c" then
        local compiler = (file_type == "cpp") and "g++" or "gcc"
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
    elseif file_type == "python" then
        vim.cmd("write")
        require("dap").continue()
    else
        print("Not a C/C++/Python file")
    end
end, { desc = "Compile with -g -O0 and start debugging (F7)" })
