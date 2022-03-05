function s:PreLoad(eventName)
	let plugin = matchstr(a:eventName, 'PreLoad-\zs.*')
	let plugin = substitute(plugin, "-", "_", "g")
	if strlen(plugin)
		execute printf("silent! call plugins#%s#PreLoad()", plugin)
	endif
endfunction

function s:PostLoad(eventName)
	let plugin = matchstr(a:eventName, 'PostLoad-\zs.*')
	let plugin = substitute(plugin, "-", "_", "g")
	if strlen(plugin)
		execute printf("silent! call plugins#%s#PostLoad()", plugin)
	endif
endfunction

augroup Plugins
	autocmd!
	autocmd User * call s:PreLoad(expand("<afile>"))
	autocmd User * call s:PostLoad(expand("<afile>"))
augroup end

function s:Complete(A, L, P)
	let packages = globpath(&packpath, "pack/" . a:A . "*", 0, 1)
	let packages = filter(packages, {_, val -> isdirectory(val)})
	let packages = map(packages, {_, val -> fnamemodify(val, ":t")})
	return packages
endfunction

command! -nargs=+ -bang -complete=customlist,s:Complete PackageAdd
			\ call packload#PackageAdd("<bang>", [<f-args>])
