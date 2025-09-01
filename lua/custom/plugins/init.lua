-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Disable intro message
vim.opt.shortmess:append 'I'

-- Relative line numbers
vim.opt.relativenumber = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 0

-- Indentation and tabs
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

-- Set spell checking
vim.opt.spelllang = 'en_us,pt_br'
vim.opt.spell = true

-- Highlight columns
vim.opt.colorcolumn = { 80 }

-- Custom change to Normal mode
vim.keymap.set('i', 'kj', '<Esc>', { desc = 'Exit insert mode' })

-- Custom save
vim.keymap.set('n', '<C-s>', ':w<Return>', { desc = 'Save' })
vim.keymap.set('i', '<C-s>', '<Esc>:w<Return>a', { desc = 'Save' })

-- Terminal keymaps
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  -- These two keymaps interfere with NeoVim open in a terminal inside NeoVim.
  --vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', opts)
  --vim.keymap.set('t', 'kj', '<C-\\><C-n>', opts)
  vim.keymap.set('t', '<C-h>', '<Cmd>wincmd h<CR>', opts)
  vim.keymap.set('t', '<C-j>', '<Cmd>wincmd j<CR>', opts)
  vim.keymap.set('t', '<C-k>', '<Cmd>wincmd k<CR>', opts)
  vim.keymap.set('t', '<C-l>', '<Cmd>wincmd l<CR>', opts)
  vim.keymap.set('t', '<C-w>', '<C-\\><C-n><C-w>', opts)
  vim.cmd 'startinsert'
end
vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

-- On Windows open Git-Bash instead of CMD
if vim.fn.has 'win32' == 1 then
  local myshell = 'C:\\Program Files\\Git\\bin\\bash.exe'
  --local myshell = 'C:\\Windws\\Sysnative\\wsl.exe'
  if vim.fn.executable(myshell) == 1 then
    vim.o.shell = '"' .. myshell .. '"'
    vim.o.shellslash = true
    vim.o.shellpipe = '|'
    vim.o.shellredir = '>'
    vim.o.shellquote = '"'
    vim.o.shellxquote = ''
    vim.o.shellcmdflag = '-c'
  end
end

-- Reopen files on the same line
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = { '*.*' },
  desc = 'Reopen files on the same line',
  callback = function()
    local filename = vim.fn.expand '%'
    if string.match(filename, '/COMMIT_EDITMSG$') then
      return
    elseif string.match(filename, '/git-rebase-todo$') then
      return
    elseif string.match(filename, '/addp-hunk-edit.diff$') then
      return
    end
    if vim.fn.line '\'"' > 1 and vim.fn.line '\'"' <= vim.fn.line '$' then
      vim.api.nvim_exec2('normal! g\'"', { output = false })
    end
  end,
})

-- Keep folds on save
vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
  pattern = { '*.*' },
  desc = 'Save view (folds), when closing file',
  command = 'mkview',
})
vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
  pattern = { '*.*' },
  desc = 'Load view (folds), when opening file',
  command = 'silent! loadview',
})

return {}
