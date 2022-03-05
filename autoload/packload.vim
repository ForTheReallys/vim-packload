"add the plugin or wait until vimrc is finished loading
function s:AddPlugin(load_now, plugin)
	if a:load_now || v:vim_did_enter
		execute "silent doautocmd User PreLoad-" . a:plugin
		execute "packadd " . a:plugin
		execute "silent doautocmd User PostLoad-" . a:plugin
	else
		execute printf("autocmd VimEnter * call s:AddPlugin(1, '%s')", a:plugin)
	endif
endfunction

" Load all plugins in pack/*/opt/ and exclude plugins in a:exclude
function packload#PackageAdd(bang, packages)
	if !exists('g:packload_excluded_plugins')
		let g:packload_excluded_plugins = []
	endif

	let l:load_now = a:bang == "" ? 0 : 1

	for package in a:packages
		let l:package = globpath(&packpath, "pack/" . package)
		if l:package == ""
			continue
		endif
		let l:plugins = glob(l:package . "/opt/*", 0, 1)

		"get the basename of the package
		let l:plugins = map(l:plugins, {_, val -> fnamemodify(val, ":t")})

		"don't include plugins in a:exclude
		let l:plugins = filter(l:plugins, {_, val -> index(g:packload_excluded_plugins, val) == -1})

		for plugin in l:plugins
			call s:AddPlugin(l:load_now, plugin)
		endfor
	endfor
endfunction
