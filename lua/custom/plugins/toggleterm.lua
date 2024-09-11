-- Open terminal in different positions
vim.keymap.set('n', '<leader>lh', function()
  vim.cmd(':' .. vim.v.count1 .. 'ToggleTerm direction=horizontal')
end, { desc = 'ToggleTerm [H]orizontal' })
vim.keymap.set('n', '<leader>lv', function()
  vim.cmd(':' .. vim.v.count1 .. 'ToggleTerm direction=vertical')
end, { desc = 'ToggleTerm [V]ertical' })
vim.keymap.set('n', '<leader>lt', function()
  vim.cmd(':' .. vim.v.count1 .. 'ToggleTerm direction=tab')
end, { desc = 'ToggleTerm [T]ab' })

-- Run the last command in the terminal by simulating UP-ARROW and RETURN key
-- strokes. Be aware that the last command can be destructive.
vim.keymap.set('n', '<leader>lk', function()
  local UPARROW = '\x1B[A\n' -- <Up><Return>
  if vim.fn.has 'win32' == 1 then
    UPARROW = '\x1B[A\r'
  end
  vim.cmd(':' .. vim.v.count1 .. 'TermExec cmd="' .. UPARROW .. '"')
end, { desc = 'ToggleTerm run last [k]ommand' })

return {
  'akinsho/toggleterm.nvim',
  opts = {
    open_mapping = '<C-\\>',
    direction = 'tab',
    size = function(term)
      if term.direction == 'horizontal' then
        return math.max(12, vim.o.lines * 0.5)
      elseif term.direction == 'vertical' then
        return math.max(40, vim.o.columns * 0.5)
      end
    end,
    on_create = function(term)
      -- Force the first command to be nondestructive so <leader>lk is safer.
      vim.cmd ':TermExec cmd="clear"<CR>'
      -- Some keymaps, like <leader>lh, were not selecting the terminal and
      -- starting in insert mode.
      vim.api.nvim_set_current_win(term.window)
      vim.schedule(function()
        vim.cmd 'startinsert'
      end)
    end,
  },
}
