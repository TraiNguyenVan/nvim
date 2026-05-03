return {
  -- nvim-nio (required dependency for nvim-dap-ui)
  "nvim-neotest/nvim-nio",

  -- nvim-dap (Debug Adapter Protocol client)
  "mfussenegger/nvim-dap",

  -- nvim-dap-ui (UI for nvim-dap)
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configure dap-ui
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "curved",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        layout = {
          positions = {
            sidebar = {
              open_on_start = true,
              size = 40,
              position = "right",
            },
          },
        },
      })

      -- Auto open/close dap-ui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Setup codelldb adapter (via Mason)
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args = { "--port", "${port}" },
        },
      }

      -- C/C++ launch configuration (single-file automation)
      local single_file_config = {
        {
          name = "Debug Single File",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.expand("%:p:r")
          end,
          cwd = "${fileDirname}",
          stopOnEntry = false,
          runInTerminal = false,
          args = {},
        },
      }

      -- ÉP BUỘC GHI ĐÈ: Xóa sạch các config cũ của LazyVim
      dap.configurations.cpp = single_file_config
      dap.configurations.c = single_file_config
      dap.configurations.rust = single_file_config

      -- Python debug configuration (single-file automation)
      dap.configurations.python = {
        {
          name = "Debug Single File",
          type = "python",
          request = "launch",
          program = function()
            return vim.fn.expand("%:p")
          end,
          cwd = "${fileDirname}",
          stopOnEntry = false,
          console = "integratedTerminal",
        },
      }
    end,
  },
}
