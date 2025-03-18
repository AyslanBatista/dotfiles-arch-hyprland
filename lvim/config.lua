-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- CONFIGURAÇÕES BÁSICAS
lvim.colorscheme = "lunar" -- Tema TokyoNight (variante storm)
vim.opt.relativenumber = true -- Números de linha relativos (facilita navegação)
vim.opt.cursorline = true -- Destaca a linha atual do cursor

-- CONFIGURAÇÕES DE APARÊNCIA E USABILIDADE
-- Melhor destacamento de sintaxe com Treesitter
lvim.builtin.treesitter.highlight.enabled = true
lvim.builtin.treesitter.ensure_installed = {
  "bash", "c", "lua", "python", "rust",
  "markdown", "yaml", "toml", "json"
}

-- Configuração da barra de status
lvim.builtin.lualine.options.theme = "lunar"
lvim.builtin.lualine.sections.lualine_c = {
  "filename", 
  {
    "diff",
    colored = true,
  }
}

-- Configurações de abas/buffers 
lvim.builtin.bufferline.options.separator_style = "slant"
lvim.builtin.bufferline.options.diagnostics = "nvim_lsp"

-- Explorador de arquivos com ícones melhores
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- PLUGINS ADICIONAIS ÚTEIS
lvim.plugins = {
  -- Destacar cores em códigos de cores (ex: #FF5500)
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  
  -- Destacar palavras iguais sob o cursor
  {
    "RRethy/vim-illuminate",
    config = function()
      require("illuminate").configure({
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
      })
    end,
  },
  
  -- Guias de indentação mais claros
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "┊" },
      scope = { enabled = true },
    },
  },
  
  -- Auto-pareamento aprimorado de parênteses, colchetes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },
}

-- CONFIGURAÇÕES PARA RUST
-- Apenas se você já tiver instalado o rust-analyzer
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

pcall(function()
  require("rust-tools").setup {
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
        require("lvim.lsp").common_on_attach(client, bufnr)
      end,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  }
end)

-- CONFIGURAÇÕES PARA PYTHON
-- Apenas se você já tiver instalado o pyright
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })

require("lvim.lsp.manager").setup("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        diagnosticMode = "workspace",
      },
    },
  },
})
