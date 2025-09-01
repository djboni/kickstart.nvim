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

return {
  'akinsho/toggleterm.nvim',
  opts = {
    open_mapping = '<M-q>',
    direction = 'tab',
    size = function(term)
      if term.direction == 'horizontal' then
        return math.max(12, vim.o.lines * 0.5)
      elseif term.direction == 'vertical' then
        return math.max(40, vim.o.columns * 0.5)
      end
    end,
    on_create = function(term)
      -- Some keymaps, like <leader>lh, were not selecting the terminal and
      -- starting in insert mode.
      vim.api.nvim_set_current_win(term.window)
      vim.schedule(function()
        vim.cmd 'startinsert'
      end)
    end,
  },
}
