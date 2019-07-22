function s:Complete(A, L, P)
	let packages = globpath(&packpath, "pack/" . a:A . "*", 0, 1)
	let packages = filter(packages, {_, val -> isdirectory(val)})
	let packages = map(packages, {_, val -> fnamemodify(val, ":t")})
	return packages
endfunction

command! -nargs=+ -complete=customlist,s:Complete PackageAdd call packload#PackageAdd(<f-args>)
