local completion = {}
local conf = require("modules.completion.config")
local filetypes = {
  "html",
  "css",
  "javascript",
  "java",
  "javascriptreact",
  "vue",
  "typescript",
  "typescriptreact",
  "go",
  "lua",
  "cpp",
  "c",
  "markdown",
  "makefile",
  "python",
  "bash",
  "sh",
  "php",
  "yaml",
  "json",
  "sql",
  "vim",
  "sh",
}

completion["neovim/nvim-lspconfig"] = {
  -- event = 'BufRead',
  config = conf.nvim_lsp,
  -- event = 'CursorHold',
  opt = true,
}
if load_coq() then
  completion["ms-jpq/coq_nvim"] = {
    -- opt = true,
    -- event = "InsertCharPre",
    after = { "coq.artifacts" },
    branch = "coq",
    setup = function()
      vim.g.coq_settings = { auto_start = false }
    end,
    config = function()
      vim.g.coq_settings = {
        auto_start = false,
        ["display.icons.mode"] = "short",
        ["display.pum.kind_context"] = { "", "" },
        ["display.pum.source_context"] = { "", "" },
        ["display.icons.spacing"] = 0,
      } -- ['display.pum.fast_close'] = false,
      if not load_coq() then
        return
      end
      vim.cmd([[COQnow]])
    end,
  }
  completion["ms-jpq/coq.thirdparty"] = {
    after = { "coq_nvim" },
    -- event = "InsertEnter",
    branch = "3p",
    config = function()
      require("coq_3p")({ { src = "nvimlua", short_name = "", conf_only = true } })
    end,
  }

  completion["ms-jpq/coq.artifacts"] = {
    -- opt = true,
    event = "InsertEnter",
    branch = "artifacts",
  }
end

-- loading sequence LuaSnip -> nvim-cmp -> cmp_luasnip -> cmp-nvim-lua -> cmp-nvim-lsp ->cmp-buffer -> friendly-snippets
completion["hrsh7th/nvim-cmp"] = {
  -- opt = true,
  -- event = "InsertEnter", -- InsertCharPre
  -- ft = {'lua', 'markdown',  'yaml', 'json', 'sql', 'vim', 'sh', 'sql', 'vim', 'sh'},
  after = { "LuaSnip" },
  requires = {
    { "hrsh7th/cmp-buffer", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-calc", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-path", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-cmdline", after = "nvim-cmp", opt = true },
    -- { "tzachar/cmp-tabnine", after = "nvim-cmp", run = "./install.sh", opt = true, config = conf.tabnine},
    -- { "hrsh7th/cmp-copilot", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-emoji", after = "nvim-cmp", opt = true },
    { plugin_folder() .. "cmp-treesitter", after = "nvim-cmp", opt = true },
    { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp", opt = true },
    { "f3fora/cmp-spell", after = "nvim-cmp", opt = true },
    { "octaltree/cmp-look", after = "nvim-cmp", opt = true },
    -- {"quangnguyen30192/cmp-nvim-ultisnips", event = "InsertCharPre", after = "nvim-cmp", opt=true },
    { "saadparwaiz1/cmp_luasnip", after = { "nvim-cmp", "LuaSnip" } },
    -- {"tzachar/cmp-tabnine", opt = true}
  },
  config = conf.nvim_cmp,
}

-- can not lazyload, it is also slow...
completion["L3MON4D3/LuaSnip"] = { -- need to be the first to load
  event = "InsertEnter",
  requires = { "rafamadriz/friendly-snippets", event = "InsertEnter" }, -- , event = "InsertEnter"
  config = function() require('modules.completion.luasnip') end,
}
completion["kristijanhusak/vim-dadbod-completion"] = {
  event = "InsertEnter",
  ft = { "sql" },
  setup = function()
    vim.cmd([[autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni]])
    -- vim.cmd([[autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })]])
    -- body
  end,
}

completion["nvim-telescope/telescope.nvim"] = {
  -- cmd = "Telescope",
  config = conf.telescope,
  setup = conf.telescope_preload,
  requires = {
    { "nvim-lua/plenary.nvim", opt = true },
    { "nvim-telescope/telescope-fzf-native.nvim", run = "make", opt = true },
    { "nvim-telescope/telescope-live-grep-args.nvim", opt = true },
    { "nvim-telescope/telescope-file-browser.nvim", opt = true },
  },
  opt = true,
}

completion["mattn/emmet-vim"] = {
  event = "InsertEnter",
  ft = {
    "html",
    "css",
    "javascript",
    "javascriptreact",
    "vue",
    "typescript",
    "typescriptreact",
    "scss",
    "sass",
    "less",
    "jade",
    "haml",
    "elm",
  },
  setup = conf.emmet,
}

-- note: part of the code is used in navigator
completion[plugin_folder() .. "lsp_signature.nvim"] = {
  opt = true,
  config = function()
    require("lsp_signature").setup({
      bind = true,
      -- doc_lines = 4,
      floating_window = true,
      floating_window_above_cur_line = true,
      hint_enable = true,
      fix_pos = false,
      -- floating_window_above_first = true,
      log_path = vim.fn.expand("$HOME") .. "/tmp/sig.log",
      debug = plugin_debug(),
      verbose = plugin_debug(),
      -- hi_parameter = "Search",
      zindex = 1002,
      timer_interval = 100,
      extra_trigger_chars = {},
      handler_opts = {
        border = "rounded", -- "shadow", --{"╭", "─" ,"╮", "│", "╯", "─", "╰", "│" },
      },
      max_height = 4,
      toggle_key = [[<M-x>]], -- toggle signature on and off in insert mode,  e.g. '<M-x>'
      -- select_signature_key = [[<M-n>]], -- toggle signature on and off in insert mode,  e.g. '<M-x>'
      select_signature_key = [[<M-c>]], -- toggle signature on and off in insert mode,  e.g. '<M-x>'
    })
  end,
}

completion["github/copilot.vim"] = {
  opt = false,
  setup = function()
    -- vim.api.nvim_set_keymap("n", "<C-=>", [[copilot#Accept("\<CR>")]], { silent = true, script = true, expr = true })
    -- vim.api.nvim_set_keymap("i", "<C-=>", [[copilot#Accept("\<CR>")]], { silent = true, script = true, expr = true })

    vim.g.copilot_filetypes = {
      ["*"] = true,
      gitcommit = false,
      NeogitCommitMessage = false,
    }
    vim.cmd([[
      imap <silent><script><expr> <C-j> copilot#Accept()
      let g:copilot_no_tab_map = v:true
      let g:copilot_assume_mapped = v:true
      let g:copilot_tab_fallback = ""
    ]])
  end,
}

return completion
