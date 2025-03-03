local vim = vim
local options = setmetatable({}, { __index = { global_local = {}, window_local = {} } })

local function bind_option(opts)
  for k, v in pairs(opts) do
    if v == true or v == false then
      vim.cmd("set " .. k)
    else
      vim.cmd("set " .. k .. "=" .. v)
    end
  end
end

function options:load_options()
  self.global_local = {}
  self.window_local = {}
  if vim.wo.diff then
    self.global_local = { foldmethod = "diff", diffopt = "context:0", foldlevel = 10, mouse = "a" }
    self.window_local = {
      -- foldmethod = "expr",
      cursorline = false,
      -- noreadonly = false;
    }
  else
    self.global_local = {
      ttyfast = true, -- Indicate fast terminal conn for faster redraw
      errorbells = false, -- No beeps
      hidden = true, -- Buffer should still exist if window is closed
      fileencoding = "utf-8", -- fenc
      mouse = "a",
      textwidth = 120, -- wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
      updatetime = 1000, -- Vim waits after you stop typing before it triggers the plugin is governed by the setting updatetime
      smartcase = true, -- ... but not it begins with upper case
      incsearch = true, -- Shows the match while typing
      hlsearch = true, -- Highlight found searches
      grepformat = "%f:%l:%m,%m\\ %f\\ match%ts,%f", -- "%f:%l:%c:%m";
      -- showcmd        = false;
      -- cmdheight = 0,
      splitbelow = true, -- Horizontal windows should split to bottom
      splitright = true, -- Vertical windows should be split to right
      backspace = "indent,eol,start", -- Makes backspace key more powerful.
      backup = true,
      writebackup = true,
      diffopt = "filler,iwhite,internal,algorithm:patience",
      completeopt = "menuone,noselect,noinsert", -- Show popup menu, even if there is one entry  menuone?
      autowrite = true, -- Automatically save before :next, :make etc.
      autoread = true, -- Automatically read changed files
      breakindent = true, -- Make it so that long lines wrap smartly
      smartindent = true, -- use intelligent indentation
      showmatch = true, -- highlight matching braces
      numberwidth = 3,
    }

    self.window_local = {
      foldmethod = "indent", -- indent? expr?  expr is slow for large files
      number = true,
      relativenumber = true,
      foldenable = true,
    }
  end
  local bw_local = {
    synmaxcol = 2000, -- handle long lines, esp html
    textwidth = 120,
    colorcolumn = "110", -- will reformat lines more than 120, but show ruler at 110
    wrap = true,
  }
  bind_option(bw_local)
  for name, value in pairs(self.global_local) do
    vim.o[name] = value
  end
  for name, value in pairs(self.window_local) do
    vim.wo[name] = value
  end

  vim.cmd("imap <M-V> <C-R>+") -- mac
  vim.cmd("imap <C-V> <C-R>*")
  vim.cmd('vmap <LeftRelease> "*ygv')
  vim.cmd("unlet loaded_matchparen")

  local global = require("core.global")
  local win = global.is_windows
  if not win then
    vim.g.python3_host_prog = "/usr/bin/python3"
  else
    vim.notify("pleas setup python3")
  end
  -- vim.g.python_host_prog = ""
end

options:load_options()

return options
