" Initialize highlights
function! s:setup()
   let fg_target = 'red'

   let fg_current  = '#93a1a1'
   let fg_visible  = '#FFFFFF'
   let fg_inactive = '#93a1a1'

   let fg_modified = '#E5AB0E'
   let fg_special  = '#cb4b16'
   let fg_subtle   = '#cb4b16'

   let bg_current  = 'none'
   let bg_visible  = '#268bd2'
   let bg_inactive = '#eee8d5'

   "      Current: current buffer
   "      Visible: visible but not current buffer
   "     Inactive: invisible but not current buffer
   "        -Icon: filetype icon
   "       -Index: buffer index
   "         -Mod: when modified
   "        -Sign: the separator between buffers
   "      -Target: letter in buffer-picking mode
   call s:hi_all([
   \ ['BufferCurrent',        fg_current,  bg_current],
   \ ['BufferCurrentIndex',   fg_special,  bg_current],
   \ ['BufferCurrentMod',     fg_modified, bg_current],
   \ ['BufferCurrentSign',    fg_special,  bg_current],
   \ ['BufferCurrentTarget',  fg_target,   bg_current,   'bold'],
   \ ['BufferVisible',        fg_visible,  bg_visible],
   \ ['BufferVisibleIndex',   fg_visible,  bg_visible],
   \ ['BufferVisibleMod',     fg_modified, bg_visible],
   \ ['BufferVisibleSign',    fg_visible,  bg_visible],
   \ ['BufferVisibleTarget',  fg_target,   bg_visible,   'bold'],
   \ ['BufferInactive',       fg_inactive, bg_inactive],
   \ ['BufferInactiveIndex',  fg_subtle,   bg_inactive],
   \ ['BufferInactiveMod',    fg_modified, bg_inactive],
   \ ['BufferInactiveSign',   fg_subtle,   bg_inactive],
   \ ['BufferInactiveTarget', fg_target,   bg_inactive,  'bold'],
   \ ['BufferTabpages',       fg_special,  bg_inactive, 'bold'],
   \ ['BufferTabpageFill',    fg_inactive, bg_inactive],
   \ ])

   call s:hi_link([
   \ ['BufferCurrentIcon',  'BufferCurrent'],
   \ ['BufferVisibleIcon',  'BufferVisible'],
   \ ['BufferInactiveIcon', 'BufferInactive'],
   \ ['BufferOffset',       'BufferTabpageFill'],
   \ ])

   lua require'bufferline.icons'.set_highlights()
endfunc

function! s:fg(groups, default)
   for group in a:groups
      let hl = nvim_get_hl_by_name(group,   1)
      if has_key(hl, 'foreground')
         return printf("#%06x", hl.foreground)
      end
   endfor
   return a:default
endfunc

function! s:bg(groups, default)
   for group in a:groups
      let hl = nvim_get_hl_by_name(group,   1)
      if has_key(hl, 'background')
         return printf("#%06x", hl.background)
      end
   endfor
   return a:default
endfunc

function! s:hi_all(groups)
   for group in a:groups
      call call(function('s:hi'), group)
   endfor
endfunc

function! s:hi_link(pairs)
   for pair in a:pairs
      execute 'hi link ' . join(pair)
   endfor
endfunc

function! s:hi(name, ...)
   let fg = ''
   let bg = ''
   let attr = ''

   if type(a:1) == 3
      let fg   = get(a:1, 0, '')
      let bg   = get(a:1, 1, '')
      let attr = get(a:1, 2, '')
   else
      let fg   = get(a:000, 0, '')
      let bg   = get(a:000, 1, '')
      let attr = get(a:000, 2, '')
   end

   let has_props = v:false

   let cmd = 'hi ' . a:name
   if !empty(fg) && fg != 'none'
      let cmd .= ' guifg=' . fg
      let has_props = v:true
   end
   if !empty(bg) && bg != 'none'
      let cmd .= ' guibg=' . bg
      let has_props = v:true
   end
   if !empty(attr) && attr != 'none'
      let cmd .= ' gui=' . attr
      let has_props = v:true
   end
   " execute 'hi clear ' a:name
   if has_props
      execute cmd
   end
endfunc

call s:setup()
