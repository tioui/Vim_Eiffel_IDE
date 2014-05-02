note
	description : "test_sample application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	SAMPLE

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
