#!/usr/bin/tclsh

#set fileId [open "input.txt"]
#set fileId [open "test.txt"]
#seek $fileId 0 start

set upper 667777
set lower 667777
#set upper 847060
#set lower 372304

set pointer $lower
set counter 0
set lastDupeVal 0
set lastFailedDupeVal 0
set hasValidDuplicate "false"
while {$pointer <= $upper } {
		
	#reset this flag at each password
	set lastDupeVal 0
	set hasValidDuplicate "false"
	#for each character in the pointer
	for {set i 0} {$i < [string length $pointer]-1} {incr i} {
		set charX [string index $pointer $i]
		set charY [string index $pointer [expr $i + 1]]


		# For each pair of characters
		# 1) Check to see if second char decreases - if it does then exit for loop immediately as this password will fail  
		#
		# 2) if the two characters match
		#
		# a) We need to check if this character has already had a duplicate
		# i) if it has then this is no longer a valid duplicate
		# ii) else the password has a valid duplicate 
		#
		#
		#puts $i
		#if second char < first char then we exit immediately as the string is invalid
		if {$charY < $charX} {
			#puts "FAIL"		 	
			set hasValidDuplicate "false"
			break;	
		}	


		if {$charX == $charY} {

			
			if {$charX == $lastDupeVal} {
				set hasValidDuplicate "false"
			} else {
				set hasValidDuplicate "true"
				set lastDupeVal $charX
			}



		}
	}
	
	if {$hasValidDuplicate == "true"} {
		puts $pointer
		incr counter
	}		
	incr pointer
}

puts $counter
