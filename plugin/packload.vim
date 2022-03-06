function s:GetLoadType(eventName)
	if a:eventName =~# "^PreLoad-"
		return "PreLoad"
	elseif a:eventName =~# "^PostLoad-"
		return "PostLoad"
	endif

	return ""
endfunction

function s:CallAppropriateLoadFunction(eventName)
	let loadType = s:GetLoadType(a:eventName)
	if !strlen(loadType) | return | endif
	let plugin = matchstr(a:eventName, loadType . '-\zs.*')
	if !strlen(plugin) | return | endif

	let plugin = substitute(plugin, "-", "_", "g")
	let plugin = substitute(plugin, ".vim$", "", "g")
	let scriptName = printf("autoload/plugins/%s.vim", plugin)
	execute "runtime " . scriptName

	let l:functionName = printf("plugins#%s#%s", plugin, loadType)
	let l:LoadFunction = function(l:functionName)
	
	if exists("*l:LoadFunction")
		call l:LoadFunction()
	endif
endfunction

augroup Plugins
	autocmd!
	autocmd User * call s:CallAppropriateLoadFunction(expand("<afile>"))
augroup end

function s:Complete(A, L, P)
	let packages = globpath(&packpath, "pack/" . a:A . "*", 0, 1)
	let packages = filter(packages, {_, val -> isdirectory(val)})
	let packages = map(packages, {_, val -> fnamemodify(val, ":t")})
	return packages
endfunction

command! -nargs=+ -bang -complete=customlist,s:Complete PackageAdd
			\ call packload#PackageAdd("<bang>", [<f-args>])
