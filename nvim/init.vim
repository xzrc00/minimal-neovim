set clipboard=unnamedplus
set fillchars+=eob:\ 

set number
highlight LineNr guifg=#c0c0c0

highlight StatusLine cterm=NONE guibg=NONE guifg=NONE
highlight Normal ctermbg=NONE guibg=NONE

" === Plugin-free Custom Dashboard (Truly Non-Editable) ===
if argc() == 0 && line2byte('$') == -1
  autocmd VimEnter * ++once call s:show_dashboard()

  function! s:show_dashboard() abort
    enew
    " Lock it down completely
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted
    setlocal readonly
    setlocal nomodifiable
    setlocal nomodified
    setlocal noundofile

    setlocal nonumber norelativenumber signcolumn=no nocursorcolumn
    setlocal cursorline

    " Redraw on resize
    autocmd WinResized <buffer> call s:center_dashboard()

    call s:center_dashboard()

    " === KEY MAPPINGS ===
nnoremap <silent><buffer><nowait> <leader>n :<C-u>enew<CR>
    nnoremap <silent><buffer><nowait> <leader>f :<C-u>echo "Find file not set up yet (needs Telescope or similar)"<CR>
    nnoremap <silent><buffer><nowait> <leader>r :<C-u>echo "Recent files not set up yet (needs Telescope or similar)"<CR>
    nnoremap <silent><buffer><nowait> <leader>c :<C-u>edit $MYVIMRC<CR>
    nnoremap <silent><buffer><nowait> <leader>q :<C-u>qa<CR>    " Prevent entering insert mode accidentally
    nnoremap <silent><buffer> i :<Nop>
    nnoremap <silent><buffer> a :<Nop>
    nnoremap <silent><buffer> o :<Nop>
    nnoremap <silent><buffer> O :<Nop>
    nnoremap <silent><buffer> A :<Nop>
    nnoremap <silent><buffer> I :<Nop>

    " Move cursor to first menu item
    call cursor(line('$') - len([
          \ '[n] New file ',
          \ '[f] Find file ',
          \ '[r] Recent files ',
          \ '[c] Edit config ',
          \ '[q] Quit Neovim ',
          \ '',
          \ 'Rice level: extreme | Plugins: zero'
          \ ]) + 1, 10)

    stopinsert
  endfunction

  function! s:center_dashboard() abort
    let header = [
          \ '                               __                ',
          \ '  ___     ___    ___   __  __ /\_\    ___ ___    ',
          \ ' / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ',
          \ '/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ',
          \ '\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\',
          \ ' \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/',
          \ '',
          \ '',
          \ ]

    let buttons = [
          \ '[n] New file     ',
          \ '[f] Find file    ',
          \ '[r] Recent files ',
          \ '[c] Edit config  ',
          \ '[q] Quit Neovim  ',
          \ '',
          \ 'Beauty | Minimalism',
          \ ]

    let content = header + buttons
    let total_lines = len(content)
    let win_height = winheight(0)
    let top_padding = max([0, (win_height - total_lines) / 2])
    let lines = repeat([''], top_padding) + content

    let win_width = winwidth(0)
    let max_content_width = max(map(copy(content), 'strdisplaywidth(v:val)'))

    if win_width <= max_content_width + 4
      call map(lines, {_, line -> line == '' ? '' : '  ' . line})
    else
      call map(lines, {_, line -> 
            \ line == '' ? '' : repeat(' ', (win_width - strdisplaywidth(line)) / 2) . line
            \ })
    endif

    " Fully clear and rewrite buffer
    setlocal modifiable          " Temporarily allow changes
    silent %delete _
    call setline(1, lines)
    redraw
    setlocal nomodifiable        " Lock it again
    setlocal nomodified
  endfunction
endif
