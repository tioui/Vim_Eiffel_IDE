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

* Running and debugging (a project must be open)

***
	:ERun
***

* Edit a class (a project must be open)

***
	:EiffelClassEdit [CLASS_NAME]
	:ECEdit [CLASS_NAME]
***

Not that if the buffer in the current window has been modified, the command will fail. If you want to force to override use those command:

***
	:EiffelClassEditF [CLASS_NAME]
	:ECEditF [CLASS_NAME]
***

* Edit a class in a new horizontal split window (a project must be open)

***
	:EiffelClassEditSplit [CLASS_NAME]
	:ECEditSp [CLASS_NAME]
***

* Edit a class in a new vertical split window (a project must be open)

***
	:EiffelClassEditVSplit [CLASS_NAME]
	:ECEditVSp [CLASS_NAME]
***

* Edit a class in a new tab (a project must be open)

***
	:EiffelClassEditTab [CLASS_NAME]
	:ECEditTab [CLASS_NAME]
***

* Get a flat view of a class (a project must be open)

***
	:EiffelClassFlat [CLASS_NAME]
	:ECFlat [CLASS_NAME]
***

* Get the ancestors of a class (a project must be open)

***
	:EiffelClassAncestors [CLASS_NAME]
	:ECAncestors [CLASS_NAME]
***

* Get the attributes of a class (a project must be open)

***
	:EiffelClassAttributes [CLASS_NAME]
	:ECAttributes [CLASS_NAME]
***

* Get the clients of a class (a project must be open)

***
	:EiffelClassClients [CLASS_NAME]
	:ECClients [CLASS_NAME]
***

* Get deferred features of a class (a project must be open)

***
	:EiffelClassDeferred [CLASS_NAME]
	:ECDeferred [CLASS_NAME]
***

* Get the descendants of a class (a project must be open)

***
	:EiffelClassDescendants [CLASS_NAME]
	:ECDescendants [CLASS_NAME]
***

* Get the exported features of a class (a project must be open)

***
	:EiffelClassExported [CLASS_NAME]
	:ECExported [CLASS_NAME]
***

* Get the external features of a class (a project must be open)

***
	:EiffelClassExternals [CLASS_NAME]
	:ECExternals [CLASS_NAME]
***

* Get a flat short (contract) view of a class (a project must be open)

***
	:EiffelClassFlatShort [CLASS_NAME]
	:EiffelClassFlatContract [CLASS_NAME]
	:ECFlatShort [CLASS_NAME]
	:ECFlatContract [CLASS_NAME]
***

* Get once routines of a class (a project must be open)

***
	:EiffelClassOnce [CLASS_NAME]
	:ECOnce [CLASS_NAME]
***

* Get the invariants of a class (a project must be open)

***
	:EiffelClassInvariants [CLASS_NAME]
	:ECInvariants [CLASS_NAME]
***

* Get the routines of a class (a project must be open)

***
	:EiffelClassRoutines [CLASS_NAME]
	:ECRoutines [CLASS_NAME]
***

* Get the creators of a class (a project must be open)

***
	:EiffelClassCreators [CLASS_NAME]
	:ECCreators [CLASS_NAME]
***

* Get the short view (contract) of a class (a project must be open)

***
	:EiffelClassShort [CLASS_NAME]
	:EiffelClassContract [CLASS_NAME]
	:ECShort [CLASS_NAME]
	:ECContract [CLASS_NAME
***


* Get the Ancestors of a feature (a project must be open)

***
	:EiffelFeatureAncestors [CLASS_NAME] [feature_name]
	:EFAncestors [CLASS_NAME] [feature_name]
***

* Get all callers of a feature (a project must be open)

***
	:EiffelFeatureCallers [CLASS_NAME] [feature_name]
	:EFCallers [CLASS_NAME] [feature_name]
***

* Get creators that call a feature (a project must be open)

***
	:EiffelFeatureCreators [CLASS_NAME] [feature_name]
	:EFCreators [CLASS_NAME] [feature_name]
***

* Get assigners of a feature (a project must be open)

***
	:EiffelFeatureAssigners [CLASS_NAME] [feature_name]
	:EFAssigners [CLASS_NAME] [feature_name]
***

* Get all callees of a feature (a project must be open)

***
	:EiffelFeatureCallees [CLASS_NAME] [feature_name]
	:EFCallees [CLASS_NAME] [feature_name]
***

* Get all creations of a feature (a project must be open)

***
	:EiffelFeatureCreations [CLASS_NAME] [feature_name]
	:EFCreations [CLASS_NAME] [feature_name]
***

* Get assignees of a feature (a project must be open)

***
	:EiffelFeatureAssignees [CLASS_NAME] [feature_name]
	:EFAssignees [CLASS_NAME] [feature_name]
***

* Get descendants version of a feature (a project must be open)

***
	:EiffelFeatureDescendants [CLASS_NAME] [feature_name]
	:EFDescendants [CLASS_NAME] [feature_name]
***

* Get the flat view of a feature (a project must be open)

***
	:EiffelFeatureFlat [CLASS_NAME] [feature_name]
	:EFFlat [CLASS_NAME] [feature_name]
***

* Get homonyms of a feature (a project must be open)

***
	:EiffelFeatureHomonyms [CLASS_NAME] [feature_name]
	:EFHomonyms [CLASS_NAME] [feature_name]
***

* Get implementers of a feature (a project must be open)

***
	:EiffelFeatureImplementers [CLASS_NAME] [feature_name]
	:EFImplementers [CLASS_NAME] [feature_name]
***

* Get the text view of a feature (a project must be open)

***
	:EiffelFeatureText [CLASS_NAME] [feature_name]
	:EFText [CLASS_NAME] [feature_name]
***


ToDo
----

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
    * Tests (autotest, statistics, etc.)
	* Breakpoint in the environment


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
	
