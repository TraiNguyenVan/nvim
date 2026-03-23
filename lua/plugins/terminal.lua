return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]], -- Vẫn giữ phím mặc định nếu cần
            shade_terminals = true,
            direction = "horizontal", -- Hoặc "float" nếu bạn muốn nó bay giữa màn hình
            close_on_exit = false, -- Giữ terminal lại để xem kết quả/lỗi
        })
    end,
}
