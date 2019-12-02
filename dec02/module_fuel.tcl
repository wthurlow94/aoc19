#!/usr/bin/tclsh
global ACCA
set ACCA 0
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]

seek $fileId 0 start

#fileevent $fileId readable [list ReadLine $fileId]

#puts [gets $fileId]

#proc ReadLine {file} {

while {1} {
	gets $fileId mass
	if {[eof $fileId]} {
		close $fileId
		break
	}
#	puts $mass
	

	set fuel [expr floor([expr $mass /3]) - 2]
	set ACCA [expr $ACCA + $fuel]
	#puts $ACCA
	}

#	}


puts "final sum: [expr int($ACCA)]"

#close $fileId




