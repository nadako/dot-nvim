vim.cmd("language en_US")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("config.options")
require("config.autocmds")

_G.Utils = require("util")

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("nadako-setup", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
    require("util.format").setup()
    require("util.root").setup()
  end,
})

require("lazy").setup("plugins", {
  install = { colorscheme = { "kanagawa" } },
  checker = { notify = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
