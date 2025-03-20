return {
  -- Terminal integrado no estilo VSCode (na parte inferior)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-`>]], -- Igual ao VSCode (Ctrl+`)
        direction = "horizontal", -- Terminal na parte inferior
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
      })
    end,
  },

  -- Melhor destaque de cores em códigos de cores
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  -- Destacar indentação
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      scope = { enabled = true },
    },
  },

  -- Destacar palavras iguais sob o cursor (como no VSCode)
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = { "lsp", "treesitter", "regex" },
        delay = 200,
        under_cursor = true,
      })
    end,
  },

  -- Extensão do gestor de projetos
  {
    "ahmedkhalf/project.nvim",
    opts = {
      detection_methods = { "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      show_hidden = false,
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Find projects" },
    },
  },

  -- Suporte a várias linguagens - configurações específicas
  -- Python
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "python",
          "rust",
          "go",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
          "yaml",
          "toml",
          "markdown",
          "dockerfile",
          "bash",
        })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                diagnosticMode = "workspace",
                inlayHints = {
                  variableTypes = true,
                  functionReturnTypes = true,
                },
              },
            },
          },
        },
        -- Rust
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
              inlayHints = {
                parameterHints = {
                  enable = true,
                },
                typeHints = {
                  enable = true,
                },
              },
            },
          },
        },
      },
    },
  },

  -- Suporte aprimorado para Rust
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      require("rust-tools").setup({
        tools = {
          runnables = {
            use_telescope = true,
          },
          inlay_hints = {
            auto = true,
            show_parameter_hints = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<leader>ca", require("rust-tools").hover_actions.hover_actions, { buffer = bufnr })
            vim.keymap.set("n", "<leader>cr", require("rust-tools").runnables.runnables, { buffer = bufnr })
          end,
        },
      })
    end,
  },

  -- Suporte GitHub Copilot (opcional)
  --  {
  --    "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --    event = "InsertEnter",
  --    config = function()
  --      require("copilot").setup({
  --        suggestion = {
  --          enable = true,
  --          auto_trigger = true,
  --          keymap = {
  --            accept = "<Tab>",
  --            next = "<M-]>",
  --            prev = "<M-[>",
  --            dismiss = "<C-]>",
  --          },
  --        },
  --      })
  --    end,
  -- },

  -- Status linha enriquecida com status do LSP e Git
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_c = {
          { "filename", path = 1 },
          { "diff", colored = true },
          { "diagnostics" },
        },
      },
    },
  },

  -- Barra de buffers aprimorada
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = true,
      },
    },
  },

  -- Keymaps personalizados no estilo VSCode para funcionalidades adicionais
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        ["<leader>t"] = { name = "+terminal" },
        ["<leader>tt"] = { "<cmd>ToggleTerm<CR>", "Toggle terminal" },
        ["<leader>tf"] = { "<cmd>ToggleTerm direction=float<CR>", "Float terminal" },
        ["<leader>tv"] = { "<cmd>ToggleTerm direction=vertical<CR>", "Vertical terminal" },
        ["<leader>th"] = { "<cmd>ToggleTerm direction=horizontal<CR>", "Horizontal terminal" },
      },
    },
  },
  -- Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio", -- Dependência necessária para o nvim-dap-ui
      "mfussenegger/nvim-dap-python", -- Para Python
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Configuração para Python
      require("dap-python").setup("python")

      -- Interface de usuário para debugging
      dapui.setup()

      -- Keymaps para debugger (estilo VSCode)
      vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

      -- Abrir UI de debug automaticamente
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
