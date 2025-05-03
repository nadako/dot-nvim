-- Session management. This saves your session in the background,
-- keeping track of open buffers, window arrangement, and more.
-- You can restore sessions when returning through the dashboard.
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
    config = function(_, opts)
      require("persistence").setup(opts)

      -- FIXME: this does not work...
      Utils.on_load("overseer.nvim", function()
        local overseer = require("overseer")

        local function get_cwd_as_name()
          local dir = vim.fn.getcwd(0)
          return dir:gsub("[^A-Za-z0-9]", "_")
        end

        vim.api.nvim_create_autocmd("User", {
          desc = "Save overseer.nvim tasks on persistence.nvim session save",
          pattern = "PersistenceSavePre",
          callback = function()
            overseer.save_task_bundle(get_cwd_as_name(), nil, { on_conflict = "overwrite" })
          end,
        })

        vim.api.nvim_create_autocmd("User", {
          desc = "Remove all previous overseer.nvim tasks on persistence.nvim session load",
          pattern = "PersistenceLoadPre",
          callback = function()
            for _, task in ipairs(overseer.list_tasks({})) do
              task:dispose(true)
            end
          end,
        })

        vim.api.nvim_create_autocmd("User", {
          desc = "Load overseer.nvim tasks on persistence.nvim session load",
          pattern = "PersistenceLoadPost",
          callback = function()
            overseer.load_task_bundle(get_cwd_as_name(), { ignore_missing = true })
          end,
        })
      end)
    end
  },
}
