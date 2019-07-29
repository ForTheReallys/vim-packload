### Vim Package Loader

An extremely lightweight plugin for vim (not tested with neovim) that allows
you to load different packages (a group of plugins). Starting with Vim 8, vim
separates packages and plugins by pack/package/{start,opt}/plugin. Confusingly,
`:packadd plugin` is used to load a plugin, not a package.

Vim-package-loader gives the ability to load entire packages without specifying
each plugin.

Additionally, you can exclude a plugin when loading a package with the
`g:packload_excluded_plugins` option.

`g:packload_excluded_plugins` is simply a list of packages to exclude.

Example:

`let g:packload_excluded_plugins = ['nerdtree', 'YouCompleteMe']`

For example, use `:PackageAdd package1 package2 ...` to add all plugins under
pack/{package1,package2,...}/opt/

Upon loading a plugin, vim-package-loader triggers the `User` autocommands with
the event name PreLoad-{plugin} and PostLoad-{plugin} before and after loading
respectively.
