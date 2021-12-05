
" let g:vimspector_enable_mappings = 'VISUAL_STUDIO'
let g:vimspector_enable_mappings = 'HUMAN'

" F5                            <Plug>VimspectorContinue When debugging, continue. Otherwise start debugging.
" F3                                <Plug>VimspectorStop Stop debugging.
" F4                             <Plug>VimspectorRestart Restart debugging with the same configuration.
" F6                               <Plug>VimspectorPause Pause debuggee.
" F9                    <Plug>VimspectorToggleBreakpoint Toggle line breakpoint on the current line.
" <leader>F9 <Plug>VimspectorToggleConditionalBreakpoint Toggle conditional line breakpoint or logpoint on the current line.
" F8               <Plug>VimspectorAddFunctionBreakpoint Add a function breakpoint for the expression under cursor
" <leader>F8                 <Plug>VimspectorRunToCursor Run to Cursor
" F10                           <Plug>VimspectorStepOver Step Over
" F11                           <Plug>VimspectorStepInto Step Into
" F12                            <Plug>VimspectorStepOut Step out of current function scope

let g:vimspector_install_gadgets = [ 'debugpy', 'vscode-node-debug2', 'netcoredbg' ]

nmap <Leader><F3> :VimspectorReset<CR>
xmap <Leader><F3> :VimspectorReset<CR>

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval

nmap <Leader><F10> <Plug>VimspectorRunToCursor
xmap <Leader><F10> <Plug>VimspectorRunToCursor

nmap <localleader><f11> <plug>vimspectorupframe
xmap <localleader><f12> <plug>vimspectordownframe

nmap <F2> :call vimspector#ClearBreakpoints()<CR>
xmap <F2> :call vimspector#ClearBreakpoints()<CR>

nmap <F7> :VimspectorMkSession<CR>
xmap <F7> :VimspectorMkSession<CR>

nmap <Leader><F7> :VimspectorLoadSession<CR>
xmap <Leader><F7> :VimspectorLoadSession<CR>
" autocmd WinEnter * silent! VimspectorLoadSession
" autocmd WinLeave * silent! VimspectorMkSession

" packadd! vimspector
