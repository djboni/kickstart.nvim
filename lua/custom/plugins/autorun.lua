-- Auto run helper.
--
-- Open a terminal and run the command once. Every time a write matches
-- the pattern the last command is executed again by writing "<Up><Return>"
-- (up arrow and return) in the terminal.
--
-- At any time you can go to the terminal and stop the current command with
-- Ctrl+C. You can also execute any command you want, including fixing
-- a bad command.
--
-- Example: `:AutoRun`
--          Pattern: `*.[ch]`
--          Command: `make && ./main`
local attach_to_buffer = function(pattern, command)
  local UPARROW = '\x1B[A' -- <Up>
  local RETURN = '\n' -- <Return>
  if vim.loop.os_uname().sysname == 'Windows_NT' then
    RETURN = '\r'
  end

  vim.cmd 'split'
  vim.cmd 'terminal'
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd 'wincmd p'
  -- Find the terminal's channel number with the buffer number
  local channr = -1
  local pidnr = -1
  for _, chan in ipairs(vim.api.nvim_list_chans()) do
    if chan.buffer == bufnr then
      channr = chan.id
      pidnr = vim.fn.jobpid(channr)
    end
  end
  vim.cmd 'sleep 100m'
  vim.api.nvim_chan_send(channr, command .. RETURN)

  vim.api.nvim_create_autocmd('BufWritePost', {
    group = vim.api.nvim_create_augroup('autorun-magic', { clear = true }),
    pattern = pattern,
    callback = function()
      local child_pids = vim.api.nvim_get_proc_children(pidnr)
      if #child_pids == 0 then
        --print("AutoRun: running last command...")
        vim.api.nvim_chan_send(channr, UPARROW .. RETURN)
      else
        --print("AutoRun: still running PID:")
        --vim.print(child_pids)
      end
    end,
  })
end

vim.api.nvim_create_user_command('AutoRun', function()
  print 'AutoRun starts now...'
  local pattern = vim.fn.input 'AuroRun Pattern: '
  local command = vim.fn.input 'AutoRun Command: '
  attach_to_buffer(pattern, command)
end, {})

return {}
