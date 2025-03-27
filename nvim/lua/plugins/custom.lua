return {
  -- Terminal integrado no estilo VSCode
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-/>]], -- Igual ao VSCode (Ctrl+`)
        direction = "horizontal",
        shade_terminals = true,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
      })
    end,
  },

  -- Destaque de cores em códigos de cores
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

  -- Destacar palavras iguais sob o cursor
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
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Cargo.toml" },
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

  -- Adicionar linguagens ao treesitter
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

  -- Configurações de LSP
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
                extraArgs = { "--", "-A", "clippy::wildcard_in_or_patterns" },
              },
              inlayHints = {
                parameterHints = {
                  enable = false,
                },
                typeHints = {
                  enable = false,
                },
              },
              procMacro = {
                enable = true,
              },
              cargo = {
                allFeatures = true,
              },
              diagnostics = {
                enable = true,
                experimental = {
                  enable = true,
                },
              },
            },
          },
          -- Configurações adicionais específicas de Rust
          on_attach = function(_, bufnr)
            -- Mapeamentos específicos para Rust
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
            vim.keymap.set("n", "<leader>cr", "<cmd>RustRunnables<CR>", { buffer = bufnr, desc = "Rust Runnables" })
            vim.keymap.set("n", "<leader>ch", "<cmd>RustHoverActions<CR>", { buffer = bufnr, desc = "Hover Actions" })
          end,
        },
      },
    },
  },

  -- Suporte aprimorado para Rust usando o plugin oficial
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
    end,
  },

  -- Plugin adicional para desenvolvimento Rust
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        popup = {
          autofocus = true,
        },
        null_ls = {
          enabled = true,
        },
      })
    end,
  },

  -- Melhorias para utilização com Python
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  -- Formatador para Python e outras linguagens
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black", "isort" },
        rust = { "rustfmt" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  -- Status linha enriquecida com informações de LSP e Git
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

  -- Keymaps personalizados para funcionalidades adicionais
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
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

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

  -- Ferramentas adicionais para Python (linting, formatação, etc.)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        -- Python
        "pyright",
        "black",
        "isort",
        "flake8",
        "mypy",
        "debugpy",
        -- Rust
        "rust-analyzer",
        -- Lua
        "stylua",
        -- Shell
        "shellcheck",
        "shfmt",
        -- Web
        "prettier",
      })
    end,
  },

  -- Adicionar múltiplos cursores (similar ao VSCode)
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },

  -- Configuração do tema
  { "folke/tokyonight.nvim", opts = { style = "moon" } },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Plugins Comnent
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Plugin telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
    end,
  },

  -- Plugin tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("neo-tree").setup({})
    end,
  },

  -- Autocomplet no TAB
  -- Configuração do blink.cmp com mapeamento condicional para o Tab
  {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab", -- Esta configuração permite Tab e Enter
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    opts_extend = { "sources.default" },
  },
}
