#!/usr/bin/tclsh
global ACCA
set ACCA 0
global ACCA2
set ACCA2 0
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]

seek $fileId 0 start
proc get_fuel {mass ACCA} {

	set fuel [expr floor([expr $mass /3]) - 2]
	if {$fuel <= 0} {
		
		return $ACCA
		

	}	

	set ACCA [expr $ACCA +$fuel]
	get_fuel $fuel $ACCA

}

while {1} {
	gets $fileId mass
	if {[eof $fileId]} {
		close $fileId
		break
	}
	
	#puts [get_fuel $mass $ACCA]
	set fuel [expr floor([expr $mass /3]) - 2]
	set ACCA2 [expr $ACCA2 + [get_fuel $mass $ACCA]]
	#puts $ACCA
	}

#	}


puts "final sum: [expr int($ACCA2)]"


proc get_fuel {mass ACCA} {

	set fuel [expr floor([expr $mass /3]) - 2]
	if {$fuel <= 0} {
		
		return $ACCA
		

	}	

	set ACCA [expr $ACCA +$fuel]
	get_fuel $fuel $ACCA

}





#close $fileId




