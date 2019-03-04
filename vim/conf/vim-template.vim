let g:templates_directory = ['~/.vim-template-extend']

let g:templates_user_variables = [
	\   ['NAMESPACE', 'GetNameSpace'],
	\ ]

function! GetNameSpace()
	return expand('%:p')
endfunction
