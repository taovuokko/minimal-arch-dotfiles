-- super key on Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 🛠️ Perusasetukset
vim.opt.number = true                   -- Näytä rivinumerot
vim.opt.expandtab = true                -- Käytä välilyöntejä tabien sijaan
vim.opt.tabstop = 4                     -- Tabit = 4 välilyöntiä
vim.opt.shiftwidth = 4                  -- Automaattinen sisennys = 4 välilyöntiä
vim.opt.smartindent = true              -- Älykäs sisennys
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Täydennysasetukset
vim.opt.clipboard = "unnamedplus"

-- 🛠️ Plugin manager: Lazy.nvim
local lazypath = vim.fn.stdpath("config") .. "/lazy"
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- 🔹 LSP ja auto-täydennys
  { "neovim/nvim-lspconfig" },   -- LSP-konfiguraatio
  { "hrsh7th/nvim-cmp" },        -- Autocomplete
  { "hrsh7th/cmp-nvim-lsp" },    -- LSP-integraatio

  -- 🔹 Navigointi ja tiedostohaku
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- 🔹 Autopairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup{}
    end,
  },

  -- 🔹 Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua" },
        highlight = { enable = true },
      })
    end,
  },

  -- 🔹 Formatter (clang-format for C/C++)
  {
    "mhartington/formatter.nvim",
    config = function()
      require("formatter").setup({
        filetype = {
          c = {
            function()
              return {
                exe = "clang-format",
                args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
                stdin = true,
              }
            end,
          },
          cpp = {
            function()
              return {
                exe = "clang-format",
                args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
                stdin = true,
              }
            end,
          },
        },
      })
    end,
  },

  -- 🔹 Statusrivi (lualine)
  { "nvim-lualine/lualine.nvim" },

  -- 🔹 Teema: catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.catppuccin_flavour = "mocha"
      vim.cmd("colorscheme catppuccin")
    end,
  },

  -- 🔹 Tiedostoselain (nvim-tree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup{}
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
    end,
  },


  -- 🔹 Toggleterm (parempi terminaali)
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup{
        open_mapping = false,  -- käytetään vain leader-keymappeja
        direction = "float",
      }
    end,
  },

  -- 🔹 Debuggeri: nvim-dap ja UI
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      dap.adapters.c = {
        type = 'executable',
        command = 'lldb-vscode', -- tai "gdb", jos käytät GDB:tä
        name = "lldb"
      }
      dap.configurations.c = {
        {
          name = "Launch",
          type = "c",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = true,
          args = {},
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- 🔹 Virheiden katselu (Trouble)
  {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    spec = {
      { "<leader>x", group = "Diagnostics" },
      { "<leader>t", group = "Terminal" },
      { "<leader>d", group = "Dashboard" },
      { "<leader>f", group = "Find" },
      { "<leader>c", group = "Config/Tools" },
      { "<leader>r", group = "Run/Compile" },
      { "<leader>l", group = "LSP" },
      { "<leader>p", group = "Projects" },
      { "<leader>w", proxy = "<c-w>", group = "Window Move" },
      { "<leader>db", desc = "Toggle Breakpoint" },
      { "<leader>dr", desc = "Debug Continue" },
      { "<leader>do", desc = "Step Over" },
      { "<leader>di", desc = "Step Into" },
      { "<leader>rr", desc = "Build & Run C" },
    },
  },
},
  -- 🔹 Projektituki
  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({})
      require("telescope").load_extension("projects")
    end,
  },

  -- 🔹 Startup-näkymä (alpha-nvim) ja NecroVim ASCII art
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      -- ASCII-logo NecroVimille
      dashboard.section.header.val = {
        [[  _        _______  _______  _______  _______            _________ _______ ]],
        [[ ( (    /|(  ____ \(  ____ \(  ____ )(  ___  )  |\     /|\__   __/(       )]],
        [[ |  \  ( || (    \/| (    \/| (    )|| (   ) |  | )   ( |   ) (   | () () |]],
        [[ |   \ | || (__    | |      | (____)|| |   | |  | |   | |   | |   | || || |]],
        [[ | (\ \) ||  __)   | |      |     __)| |   | |  ( (   ) )   | |   | |(_)| |]],
        [[ | | \   || (      | |      | (\ (   | |   | |   \ \_/ /    | |   | |   | |]],
        [[ | )  \  || (____/\| (____/\| ) \ \__| (___) |    \   /  ___) (___| )   ( |]],
        [[ |/    )_)(_______/(_______/|/   \__/(_______)     \_/   \_______/|/     \|]],
      }

      -- Asetetaan ASCII-logon väri punaiseksi
      dashboard.section.header.opts = {
        position = "center",
        hl = "Keyword",
      }

      -- Dashboardin painikkeet
      dashboard.section.buttons.val = {
        dashboard.button("e", "📂  Open File Explorer", ":NvimTreeToggle<CR>"),
        dashboard.button("f", "🔍  Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "🕘  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("c", "⚙️  Edit Config", ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "🚪  Quit", ":q<CR>")
      }

      alpha.setup(dashboard.config)
    end,
  },
})  -- <-- Tämä sulkee require("lazy").setup

-- 🛠️ LSP-asetukset (clangd C-kielelle)
-- Lataa lspconfig-moduuli
local lspconfig = require('lspconfig')

-- Aseta LSP-palvelin (esimerkiksi ccls tai clangd)
lspconfig.ccls.setup({
    init_options = {documentFormatting = true},
    settings = {
        rootMarkers = {".ccls", ".git/"},
        languages = {
            lua = {
                formatCommand = "lua-format -i",
                formatStdin = true
            }
        }
    }
})


-- 📝 Inline virheet ja hover-docit
vim.diagnostic.config({
  virtual_text = true,
  float = { border = "rounded" },
})
vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "LSP Hover" })

-- 🛠️ Autocompletion-asetukset
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

-- 🛠️ Parempi tiedostonavigointi (Telescope find_files)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" })

-----------------------------------------------------------
-- Uudet leader-key -pohjaiset komennot (ideat 1, 2, 3 ja 6)
-----------------------------------------------------------
-- 1️⃣ Terminaali leader-kombinaatiot
vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=float<CR>", { desc = "Toggle Float Terminal" })
vim.keymap.set("n", "<leader>th", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle Horizontal Terminal" })
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "Toggle Vertical Terminal" })

-- 2️⃣ Dashboard mapping
vim.keymap.set("n", "<leader>d", function()
  print("=== Dashboard ===")
  print("e: Explorer (NvimTree)")
  print("t: Terminal (float)")
  print("c: Edit config")
  print("q: Quit")
end, { desc = "Dashboard Info" })
vim.keymap.set("n", "<leader>de", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
vim.keymap.set("n", "<leader>dt", ":ToggleTerm direction=float<CR>", { desc = "Toggle Float Terminal" })
vim.keymap.set("n", "<leader>dc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit Config" })
vim.keymap.set("n", "<leader>dq", ":q<CR>", { desc = "Quit" })

-- 3️⃣ Automatisoidaan yleisiä tehtäviä
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save File" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit File" })
vim.keymap.set("n", "<leader>x", ":x<CR>", { desc = "Save and Quit" })
vim.keymap.set("n", "<leader>rf", ":source %<CR>", { desc = "Reload Current File" })
vim.keymap.set("n", "<leader>R", ":edit!<CR>", { desc = "Reset Changes" })

-- 6️⃣ Käyttömukavuuden lisäykset: Ikkunoiden välillä liikkuminen
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "Window Left" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "Window Down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "Window Up" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "Window Right" })

-----------------------------------------------------------
-- Loput alkuperäiset keymapit ja asetukset
-----------------------------------------------------------
-- 🛠️ Statusrivi päälle
require("lualine").setup()

-- 🛠️ Koodin automaattinen siistiminen tallennettaessa
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = {"*.c", "*.h"},
  callback = function() vim.cmd(":FormatWrite") end,
})

-- 🛠️ Shortcut C-koodin kääntämiseen ja ajamiseen (Build & Run)
vim.keymap.set("n", "<leader>rr", ":w<CR>:split | terminal gcc % -o %:r && ./%:r<CR>", { desc = "Build & Run" })

-- 🐞 DAP-debuggerin keymapit (leader-pohjaisesti)
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dr", function() require("dap").continue() end, { desc = "Debug Continue" })

-- 🏗 Projektivalinta (Telescope Project)
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Projects" })

