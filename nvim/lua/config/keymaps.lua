-- keymaps.lua
-- Atalhos de teclado inspirados no VSCode para LazyVim

return {
  -- Terminal
  { "<C-`>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal (VSCode style)" },
  { "<C-j>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal (alternative)" },

  -- File explorer
  { "<C-e>", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },

  -- File navigation
  { "<C-p>", "<cmd>Telescope find_files<CR>", desc = "Find files" },
  { "<C-f>", "<cmd>Telescope live_grep<CR>", desc = "Find text" },

  -- Editor actions
  { "<C-s>", "<cmd>w<CR>", desc = "Save file" },
  { "<C-q>", "<cmd>q<CR>", desc = "Quit" },
  { "<C-/>", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", desc = "Toggle comment" },

  -- Code actions
  { "<C-space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code actions" },
  { "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename symbol" },
  { "<C-k><C-i>", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Show hover info" },

  -- Multi-cursor (requer plugin 'mg979/vim-visual-multi')
  -- Nota: a funcionalidade real de multi-cursor requer plugin específico

  -- Debug
  { "<F5>", "<cmd>lua require'dap'.continue()<CR>", desc = "Debug: Start/Continue" },
  { "<F10>", "<cmd>lua require'dap'.step_over()<CR>", desc = "Debug: Step Over" },
  { "<F11>", "<cmd>lua require'dap'.step_into()<CR>", desc = "Debug: Step Into" },
  { "<F12>", "<cmd>lua require'dap'.step_out()<CR>", desc = "Debug: Step Out" },

  -- Split management
  { "<C-\\>", "<cmd>vsplit<CR>", desc = "Split vertically" },
  { "<C-=>", "<cmd>split<CR>", desc = "Split horizontally" },

  -- Navigation
  { "<A-up>", "<cmd>m .-2<CR>==", desc = "Move line up" },
  { "<A-down>", "<cmd>m .+1<CR>==", desc = "Move line down" },

  -- Buffers/tabs
  { "<C-Tab>", "<cmd>bnext<CR>", desc = "Next buffer" },
  { "<C-S-Tab>", "<cmd>bprevious<CR>", desc = "Previous buffer" },
  { "<C-w>", "<cmd>bdelete<CR>", desc = "Close buffer" },
}
