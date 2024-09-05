return {
  'LunarVim/bigfile.nvim',
  event = 'BufReadPre',
  opts = {
    filesize = 5, -- MiB
  },
  config = function(_, opts)
    require('bigfile').setup(opts)
  end,
}
