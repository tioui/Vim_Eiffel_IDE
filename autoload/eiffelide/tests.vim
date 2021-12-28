function! Valide_compilation(type)
	if !eiffelide#is_compilation_success()
		echoerr "The compilation " . type . " has fail!"
	endif
endfunction

function! Valide_informations(name)
	let project_path = eiffelide#project_path()
	call eiffelide#open_tools_window()
	silent execute "w " . project_path . "/test_result/" . a:name
	let compare = system("diff " . project_path . "/test_result/" . a:name . " " . project_path . "/test_result_cmp/" . a:name)
	if compare !=# ""
		echoerr "Error with " . a:name
	else
		call system("rm -f " . project_path . "/test_result/" . a:name)
	endif
	call eiffelide#return_to_saved_window()
endfunction

python3 import tests_python

function! eiffelide#tests#execute_python_side()
python3 << endpython
if i_eiffel_project:
	tests_python.execute(i_eiffel_project)
else:
	print("Error: Eiffel_Project (python side) is not initialized.")
endpython
endfunction

function! eiffelide#tests#execute()
	call system("rm -rf " . eiffelide#project_path() . "/test_result")
    call system("mkdir -p " . eiffelide#project_path() . "/test_result")

	" Compilation tests
	EiffelSystemCompile
	call Valide_compilation("EiffelSystemCompile")
	ESCompile
	call Valide_compilation("ESCompile")
	EiffelSystemRecompile
	call Valide_compilation("EiffelSystemRecompile")
	ESRecompile
	call Valide_compilation("ESRecompile")
	EiffelSystemFinalize
	call Valide_compilation("EiffelSystemFinalize")
	ESFinalize
	call Valide_compilation("ESFinalize")
	EiffelSystemFreeze
	call Valide_compilation("EiffelSystemFreeze")
	ESFreeze
	call Valide_compilation("ESFreeze")
	EiffelSystemMelt
	call Valide_compilation("EiffelSystemMelt")
	ESMelt
	call Valide_compilation("ESMelt")
	EiffelSystemQuickMelt
	call Valide_compilation("EiffelSystemQuickMelt")
	ESQuickMelt
	call Valide_compilation("ESQuickMelt")
	
	" Class tests
	EiffelClassFlat ANY
	call Valide_informations("EiffelClassFlat")
	ECFlat SORTED_STRUCT
	call Valide_informations("ECFlat")
	EiffelClassAncestors LINKED_LIST
	call Valide_informations("EiffelClassAncestors")
	ECAncestors CURSOR_TREE
	call Valide_informations("ECAncestors")
	EiffelClassAttributes CONSOLE
	call Valide_informations("EiffelClassAttributes")
	ECAttributes PATH
	call Valide_informations("ECAttributes")
	EiffelClassClients BOOLEAN
	call Valide_informations("EiffelClassClients")
	ECClients FILE_COMPARER
	call Valide_informations("ECClients")
	EiffelClassDeferred BAG
	call Valide_informations("EiffelClassDeferred")
	ECDeferred LIST
	call Valide_informations("ECDeferred")
	EiffelClassDescendants ANY
	call Valide_informations("EiffelClassDescendants")
	ECDescendants IO_MEDIUM
	call Valide_informations("ECDescendants")
	EiffelClassExported SED_META_MODEL
	call Valide_informations("EiffelClassExported")
	ECExported TEST_CASE
	call Valide_informations("ECExported")
	EiffelClassExternals SINGLE_MATH
	call Valide_informations("EiffelClassExternals")
	ECExternals FILE
	call Valide_informations("ECExternals")
	EiffelClassFlatShort REPEATABLE
	call Valide_informations("EiffelClassFlatShort")
	ECFlatShort INTERNAL
	call Valide_informations("ECFlatShort")
	EiffelClassFlatContract ASCII
	call Valide_informations("EiffelClassFlatContract")
	ECFlatContract STACK
	call Valide_informations("ECFlatContract")
	EiffelClassOnce DOUBLE_MATH
	call Valide_informations("EiffelClassOnce")
	ECOnce FORMAT_DOUBLE
	call Valide_informations("ECOnce")
	EiffelClassInvariants MANAGED_POINTER
	call Valide_informations("EiffelClassInvariants")
	ECInvariants MEMORY_STRUCTURE
	call Valide_informations("ECInvariants")
	EiffelClassRoutines OBJECT_GRAPH_MARKER
	call Valide_informations("EiffelClassRoutines")
	ECRoutines PLATFORM
	call Valide_informations("ECRoutines")
	EiffelClassCreators PLAIN_TEXT_FILE
	call Valide_informations("EiffelClassCreators")
	ECCreators RAW_FILE
	call Valide_informations("ECCreators")
	EiffelClassShort STORABLE
	call Valide_informations("EiffelClassShort")
	ECShort UTF_CONVERTER
	call Valide_informations("ECShort")
	EiffelClassContract ECMA_INTERNAL
	call Valide_informations("EiffelClassContract")
	ECContract ARRAY
	call Valide_informations("ECContract")
	EiffelClassSuppliers STORABLE
	call Valide_informations("EiffelClassSuppliers")
	ECSuppliers STREAM
	call Valide_informations("ECSuppliers")
	EiffelClassText REAL_64
	call Valide_informations("EiffelClassText")
	ECText GC_INFO
	call Valide_informations("ECText")

	" Feature tests
	EiffelFeatureAncestors LIST out
	call Valide_informations("EiffelFeatureAncestors")
	EFAncestors SAMPLE twin
	call Valide_informations("EFAncestors")
	EiffelFeatureCallers STRING_32 make
	call Valide_informations("EiffelFeatureCallers")
	EFCallers PATH_NAME extend
	call Valide_informations("EFCallers")
	EiffelFeatureCreators TO_SPECIAL area
	call Valide_informations("EiffelFeatureCreators")
	EFCreators EXCEPTION c_description
	call Valide_informations("EFCreators")
	EiffelFeatureAssigners CONSOLE last_real
	call Valide_informations("EiffelFeatureAssigners")
	EFAssigners RANDOM seed
	call Valide_informations("EFAssigners")
	EiffelFeatureCallees PROCEDURE apply
	call Valide_informations("EiffelFeatureCallees")
	EFCallees NUMERIC product
	call Valide_informations("EFCallees")
	EiffelFeatureCreations ACTIVE_LIST default_create
	call Valide_informations("EiffelFeatureCreations")
	EFCreations SED_SESSION_SERIALIZER make
	call Valide_informations("EFCreations")
	EiffelFeatureAssignees IDENTIFIED object_id
	call Valide_informations("EiffelFeatureAssignees")
	EFAssignees CHAIN start
	call Valide_informations("EFAssignees")
	EiffelFeatureDescendants ANY is_equal
	call Valide_informations("EiffelFeatureDescendants")
	EFDescendants COMPARABLE min
	call Valide_informations("EFDescendants")
	EiffelFeatureFlat FILE close
	call Valide_informations("EiffelFeatureFlat")
	EFFlat FUNCTION flexible_item
	call Valide_informations("EFFlat")
	EiffelFeatureHomonyms HASHABLE hash_code
	call Valide_informations("EiffelFeatureHomonyms")
	EFHomonyms SUBSET count
	call Valide_informations("EFHomonyms")
	EiffelFeatureImplementers BAG fill
	call Valide_informations("EiffelFeatureImplementers")
	EFImplementers INDEXABLE at
	call Valide_informations("EFImplementers")
	EiffelFeatureText MEMORY memory_map
	call Valide_informations("EiffelFeatureText")
	EFText CONSOLE read_stream_thread_aware
	call Valide_informations("EFText")
	EiffelSystemClasses
	call Valide_informations("EiffelSystemClasses")
	ESClasses
	call Valide_informations("ESClasses")

	echo "Tests done."
endfunction
