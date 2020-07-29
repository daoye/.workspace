" 默认情况下，在注释分隔符后添加空格
let g:NERDSpaceDelims = 1

" 使用紧凑语法进行美化多行注释
let g:NERDCompactSexyComs = 1

" 向左对其逐行注释
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" 添加您自己的自定义格式或覆盖默认值
let g:NERDCustomDelimiters = { 'cs': { 'left': '//' },'c': { 'left': '//' }  }

" 允许注释和反转空行（在注释区域时很有用）
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
