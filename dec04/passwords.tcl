#!/usr/bin/tclsh

#set fileId [open "input.txt"]
#set fileId [open "test.txt"]
#seek $fileId 0 start

#set upper 677788

#set lower 677788
set upper 847060
set lower 372304
#
set pointer $lower
set counter 0
set validDupeVal 0
while {$pointer <= $upper } {
		

	set validDupeVal 0
	set currentDupeCounter 0
	set failedDupeVal 0
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
	#
	#	puts $i
	#	puts $charX
	#	puts $charY
		if {$charY < $charX} {
		 	set validDupeVal 0	
			break;	
		}

		if {$charY > $charX} {
	       
			if {$currentDupeCounter == 1} {
				set validDupeVal $charX
			}
			set currentDupeCounter 0
		}

				
		if {$charX == $charY} {
			incr currentDupeCounter 
			if {$i == [expr [string length $pointer] -2] && $currentDupeCounter == 1} {
				set validDupeVal $charX
			}
		}
			
	}


	if {$validDupeVal != 0} {
		incr counter
		puts $pointer
	}
			
	incr pointer
}


puts $counter
