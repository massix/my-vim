A plugin for using dscanner with vim.

Tested on Linux and Windows(see comment for windows)

Installation and Configuration
==============================
Put the autoload and ftplugin folders in your vim runtime path.

Compile dscanner and put it in your path, or set the global variable g:dscanner\_path to where you put dscanner.

If you need to use an include path, use the global variable g:dscanner\_includePath as a list of those paths.

Using on Windows
================
Under Linux, Dscanner reads /etc/dmd.conf to get the default include paths. The equivalent file in Windows - 'sc.ini' - does not have a fixed location, so you need to configure the import paths manually. You need the \src\phobos and \src\druntime\import folders from where you installed dmd. For example,
```
let g:dscanner_includePath=['C:\Program Files\dmd2\src\phobos','C:\Program Files\dmd2\src\druntime\import']
```
