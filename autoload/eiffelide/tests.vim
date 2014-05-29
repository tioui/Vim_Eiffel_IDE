function! Valide_compilation(type)
	if !eiffelide#is_success()
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

function! eiffelide#tests#execute()
	call system("rm -rf " . eiffelide#project_path() . "/test_result")
    call system("mkdir -p " . eiffelide#project_path() . "/test_result")
	EiffelCompile
	call Valide_compilation("EiffelCompile")
	ECompile
	call Valide_compilation("ECompile")
	EC
	call Valide_compilation("EC")
	EiffelRecompile
	call Valide_compilation("EiffelRecompile")
	ERecompile
	call Valide_compilation("ERecompile")
	EiffelFinalize
	call Valide_compilation("EiffelFinalize")
	EFinalize
	call Valide_compilation("EFinalize")
	EiffelFreeze
	call Valide_compilation("EiffelFreeze")
	EFreeze
	call Valide_compilation("EFreeze")
	EiffelMelt
	call Valide_compilation("EiffelMelt")
	EMelt
	call Valide_compilation("EMelt")
	EiffelQuickMelt
	call Valide_compilation("EiffelQuickMelt")
	EQuickMelt
	call Valide_compilation("EQuickMelt")
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
	echo "Tests done."
endfunction
