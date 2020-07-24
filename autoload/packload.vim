"add the plugin or wait until vimrc is finished loading
function s:AddPlugin(load_now, plugin)
	if a:load_now || v:vim_did_enter
		" vim function names don't allow dash ('-')
		let l:file = substitute(a:plugin, "[\.-]", "_", "g")

		execute printf("runtime autoload/plugins/%s.vim", l:file)

		let l:PreLoad = function(printf("plugins#%s#PreLoad", l:file))
		let l:PostLoad = function(printf("plugins#%s#PostLoad", l:file))

		if exists("*l:PreLoad")
			call l:PreLoad()
		endif
		execute printf("packadd %s", a:plugin)
		if exists("*l:PostLoad")
			call l:PostLoad()
		endif
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
		let l:packagepath = globpath(&packpath, "pack/" . package)

		if !isdirectory(l:packagepath)
			execute printf("echoerr 'Cannot find package: %s'", package)
			continue
		endif

		let l:plugins = glob(l:packagepath . "/opt/*", 0, 1)

		"get the basename of the package
		let l:plugins = map(l:plugins, {_, val -> fnamemodify(val, ":t")})

		"don't include plugins in a:exclude
		let l:plugins = filter(l:plugins, {_, val -> index(g:packload_excluded_plugins, val) == -1})

		for plugin in l:plugins
			call s:AddPlugin(l:load_now, plugin)
		endfor
	endfor
endfunction
