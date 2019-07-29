"add the plugin or wait until vimrc is finished loading
function s:AddPlugin(plugin)
	if v:vim_did_enter
		execute "doautocmd User PreLoad-" . a:plugin
		execute "packadd " . a:plugin
		execute "doautocmd User PostLoad-" . a:plugin
	else
		execute printf("autocmd VimEnter * call s:AddPlugin('%s')", a:plugin)
	endif
endfunction

" Load all plugins in pack/*/opt/ and exclude plugins in a:exclude
function packload#PackageAdd(...)
	if !exists('g:packload_excluded_packages')
		let g:packload_excluded_packages = []
	endif

	for package in a:000
		let l:package = globpath(&packpath, "pack/" . package)
		let l:plugins = glob(l:package . "/opt/*", 0, 1)

		"get the basename of the package
		let l:plugins = map(l:plugins, {_, val -> fnamemodify(val, ":t")})

		"don't include plugins in a:exclude
		let l:plugins = filter(l:plugins, {_, val -> index(g:packload_excluded_packages, val) == -1})

		for plugin in l:plugins
			call s:AddPlugin(plugin)
		endfor
	endfor
endfunction
