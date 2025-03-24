-- keymaps.lua
-- Atalhos de teclado híbridos - VSCode + Vim/Neovim nativos

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Terminal (não conflita com o Vim)
map("n", "<C-`>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal (VSCode style)" })
map("n", "<C-j>", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal (alternative)" })

-- File explorer (não conflita com o Vim core)
map("n", "<C-e>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- File navigation (não conflita com o Vim core)
map("n", "<C-p>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<C-f>", "<cmd>Telescope live_grep<CR>", { desc = "Find text" })

-- Editor actions
-- NOTA: <C-s> sobrescreve o comportamento do CTRL-S no terminal (pausa output)
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
-- NOTA: <C-q> sobrescreve CTRL-Q do terminal (retoma output)
map("n", "<C-q>", "<cmd>q<CR>", { desc = "Quit" })
-- NOTA: Este não conflita com comandos nativos do Vim
map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, { desc = "Toggle comment" })

-- Code actions (não conflita com o Vim core)
map("n", "<C-space>", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code actions" })
map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
map("n", "<C-k><C-i>", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Show hover info" })

-- Debug (teclas de função não conflitam com o Vim)
map("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debug: Start/Continue" })
map("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debug: Step Over" })
map("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debug: Step Into" })
map("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debug: Step Out" })
map("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debug: Toggle Breakpoint" })
map(
  "n",
  "<leader>dB",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debug: Set conditional breakpoint" }
)
map("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<CR>", { desc = "Debug: Toggle UI" })

-- Split management
-- NOTA: <C-\> não conflita, mas <C-=> pode conflitar em alguns terminais
map("n", "<C-\\>", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<C-=>", "<cmd>split<CR>", { desc = "Split horizontally" })
-- Alternativas nativas do Vim: <C-w>v (split vertical) e <C-w>s (split horizontal)

-- Navigation
map("n", "<A-up>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("n", "<A-down>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("v", "<A-up>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
map("v", "<A-down>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

-- Buffers/tabs
map("n", "<C-Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<C-S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
-- NOTA: <C-w> é um prefixo muito importante no Vim para gerenciar janelas!
-- Recomendo usar outro atalho ou aprender o :bd do Vim
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
-- Para usar o atalho VSCode, descomente a linha abaixo, mas saiba que perde comandos Vim importantes
-- map("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- Alternativas Vim para navegação por buffers:
-- :bn ou :bnext - próximo buffer
-- :bp ou :bprevious - buffer anterior
-- :bd ou :bdelete - fechar buffer atual

-- Rust específico (usa o prefixo leader, não conflita)
map("n", "<leader>rr", "<cmd>RustRunnables<CR>", { desc = "Rust Runnables" })
map("n", "<leader>rt", "<cmd>RustTest<CR>", { desc = "Rust Test" })
map("n", "<leader>rm", "<cmd>RustExpandMacro<CR>", { desc = "Rust Expand Macro" })
map("n", "<leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Rust Open Cargo.toml" })
map("n", "<leader>rp", "<cmd>RustParentModule<CR>", { desc = "Rust Parent Module" })

-- Python específico (usa o prefixo leader, não conflita)
map("n", "<leader>pt", "<cmd>lua require('dap-python').test_method()<CR>", { desc = "Python Test Method" })
map("n", "<leader>pc", "<cmd>lua require('dap-python').test_class()<CR>", { desc = "Python Test Class" })
map("n", "<leader>ps", "<cmd>lua require('dap-python').debug_selection()<CR>", { desc = "Python Debug Selection" })

-- Adicionar alguns atalhos importantes do Vim para aprendizado:
-- Comentados por padrão, descomente à medida que for aprendendo
-- map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
