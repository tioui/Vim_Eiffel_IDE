Vim_Eiffel_IDE
================

An Eiffel programming environment for Vim using the ISE EiffelStudio tools.

What you can do with it
-----------------------

* Editing Eiffel file with syntax highlighting
* Opening a project config file (.ecf).

***
    :EiffelOpen [the_file.ecf] [the_target]
    :EOpen [the_file.ecf] [the_target]
***

* Compiling a project from scratch (a project must be open)

***
    :EiffelRecompile
    :ERecompile
***

* Freezing a project (a project must be open)

***
    :EiffelFreeze
    :EFreeze
***

* Melting a project (a project must be open)

***
    :EiffelMelt
    :EMelt
***

* Quick Melting a project (a project must be open)

***
    :EiffelQuickMelt
    :EQuickMelt
***

* A quick on the fly compilation. Like a Quick melting, but keep the focus on 
the current source code. (a project must be open)

***
    :EiffelCompile
    :ECompile
    :EC
***

ToDo
----

* Class informations
    * Attributes
    * Clients
    * Deferred features
    * Descendants
    * Exported feature
    * Externals
    * Flat view
    * Flatshort view
    * Once routines and constants
    * Routines
    * Invariants
    * Creators
    * Short form
    * Suppliers
    * Text view
* Feature informations
    * Ancestors
    * Callers
    * Callees
    * Descendants
    * Flat view
    * Homonyms
    * Implementers
    * Text view
* Cluster informations
    * Classes in alphabetic order
    * Cluster hierarchy
    * Classes, Cluster by cluster
    * Indexing clauses of classes
* Vim environment
    * Feature and class browser (tree view like)
    * Modification since last compilation
    * Error and warning flags in code buffer.
    * Autocompletion
    * Running
    * Debug
    * Tests (autotest, statistics, etc.)


Eiffel related
--------------

* This project is base on the Vim-Eiffel project
    (https://github.com/eiffelhub/vim-eiffel)

* Eiffel Syntax: eiffel.vim
    This is modified version, the official syntax is maintained by Reimer Behrends 
    (http://www.cse.msu.edu/~behrends/vim/)
    It is also part of vim distrib

* Eiffel Indent: eiffel.vim
    It is also part of vim distrib (this new version will be part of next release of Vim)
    This version is the official version and is maintained by Jocelyn Fiat.

    (Previously maintained by David Clarke)

* Eiffel FtPlugin: eiffel.vim
    It contains mainly the setting for the plugin matchit.vim
	
