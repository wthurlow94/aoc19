#!/usr/bin/tclsh
global ACCA
set ACCA 0


global initialprogram
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]
set input 0

gets $fileId line
set initialprogram [split $line ","]
close $fileId

set increment 1



proc getParam {code mode prog} {
	

	if {$mode == 0} {
		#position
		return [lindex $prog $code]
	
	} else {
 		#immediate
		return $code
	}


}


proc runProgram {signalinput phaseSetting} {
global initialprogram

set program $initialprogram
for {set i 0} {$i < [llength $program]} {incr i $increment} {
	
	set output [list]
	set operation [lindex $program $i]
	set opcode [string range $operation [expr [string length $operation] - 2] [string length $operation]]
	set modestring [string range $operation 0 [expr [string length $operation] -3]]
	#puts "iteration: $i"

	while {[string length $opcode] < 2} {
		set opcode [string cat "0" $opcode]
	}
#	puts $operation
#	puts $opcode
	
	switch $opcode {
			"01" {
				#Addition
			#	puts "addition"
				set increment 4


				# 3 modes

				set modes [split $modestring ""]
				while {[llength $modes] < 3} {
					set modes [linsert $modes 0 0]
				}
			
				set p1mode  [lindex $modes 2]
				set p2mode  [lindex $modes 1]

				#three parameters p1, p2, pos

				set p1code  [lindex $program [expr $i + 1]]
				set p2code  [lindex $program [expr $i + 2]]
				set poscode [lindex $program [expr $i + 3]] 


				set p1  [getParam $p1code $p1mode $program]
				set p2  [getParam $p2code $p2mode $program]


				# Add p1 and p2
				#
				set value [expr $p1 + $p2]

				#write to pos
				set program [lreplace $program $poscode $poscode $value]
			#	puts "wrote value $value at position $poscode"
				# three parameters: p1, p2, pos
			}
			"02" {
				#Multiplication
				set increment 4
			#	puts "multiplication"
				# 3 modes
				#
				set modes [split $modestring ""]
				while {[llength $modes] < 3} {
					set modes [linsert $modes 0 0]
				}
							
				set p1mode  [lindex $modes 2]
				set p2mode  [lindex $modes 1]
				

				#puts $p1mode
				#puts $p2mode
				#puts $posmode
				#three parameters p1, p2, pos
				
				set p1code  [lindex $program [expr $i + 1]]
				set p2code  [lindex $program [expr $i + 2]]
				set poscode [lindex $program [expr $i + 3]] 
				
				
				
				

				set p1  [getParam $p1code $p1mode $program]
				set p2  [getParam $p2code $p2mode $program]
				
				
				# Multiply p1 by p2
				#
				set value [expr $p1 * $p2]
			
				#write to pos
				set program [lreplace $program $poscode $poscode $value]
			#	puts "wrote value $value at position $poscode"			
			}
			"03" {
				#Write
				set increment 2
			#	puts "write"
			#	# one parameter - mode irrelevant
				#
				set parameter [lindex $program [expr $i + 1]]
				
				set program [lreplace $program $parameter $parameter $phaseSetting]
			#	puts "wrote value $input at position $parameter"
	#			puts "phaseSetting $phaseSetting"
				set phaseSetting $signalinput
	#			puts "phaseSetting $phaseSetting"
				}
			"04" {
				#Print
			#	puts "print"
				set increment 2
				# one parameter - mode relevant
				set modes [split $modestring ""]
				while {[llength $modes] < 1} {
					set modes [linsert $modes 0 0]
				}
			
				set mode [lindex $modes 0]
				set code [lindex $program [expr $i +1]]
				
				#puts "mode $mode"
				set print [getParam $code $mode $program]

		#		puts "output iteration: $i"
		#		puts $print
				break
			
				
			}
			"05" {
				#jump-if-true
				#set i --> value of p2
			#	puts "jump if true!"
				# two parameters 
				set modes [split $modestring ""]
				while {[llength $modes] < 2} {
					set modes [linsert $modes 0 0]
				}

				set p1mode [lindex $modes 1]
				set posmode [lindex $modes 0]

				set p1code [lindex $program [expr $i + 1]]
				set poscode [lindex $program [expr $i + 2]]

				set parameter [getParam $p1code $p1mode $program]
				set pos [getParam $poscode $posmode $program]
			#	puts $parameter
			#	puts $pos
				
				if {$parameter != 0} {
					set i $pos
					set increment 0
	#				puts $i
				} else {
					set increment 3
				}


			}
			"06" {
				#jump-if-false
			
				#set i --> value of p2
				#puts "jump if false!"
				# two parameters 
				set modes [split $modestring ""]
				while {[llength $modes] < 2} {
					set modes [linsert $modes 0 0]
				}

				set p1mode [lindex $modes 1]
				set posmode [lindex $modes 0]

				set p1code [lindex $program [expr $i + 1]]
				set poscode [lindex $program [expr $i + 2]]

				set parameter [getParam $p1code $p1mode $program]
				set pos [getParam $poscode $posmode $program]
			#	puts $parameter
			#	puts $pos
				
				if {$parameter == 0} {
					set i $pos
					set increment 0
	#				puts $i
				} else {
					set increment 3
				}

			}
			"07" {
				#less than
				set increment 4

				set modes [split $modestring ""]
				while {[llength $modes] < 3} {
					set modes [linsert $modes 0 0]
				}
							
				set p1mode  [lindex $modes 2]
				set p2mode  [lindex $modes 1]
				
				set p1code  [lindex $program [expr $i + 1]]
				set p2code  [lindex $program [expr $i + 2]]
				set poscode [lindex $program [expr $i + 3]] 
				
				set p1  [getParam $p1code $p1mode $program]
				set p2  [getParam $p2code $p2mode $program]

				if {$p1 < $p2} {
					set program [lreplace $program $poscode $poscode 1]
				} else {
					set program [lreplace $program $poscode $poscode 0]
				}


			}
			"08" {
				#equals
				set increment 4
	
				set modes [split $modestring ""]
				while {[llength $modes] < 3} {
					set modes [linsert $modes 0 0]
				}
							
				set p1mode  [lindex $modes 2]
				set p2mode  [lindex $modes 1]
				
				set p1code  [lindex $program [expr $i + 1]]
				set p2code  [lindex $program [expr $i + 2]]
				set poscode [lindex $program [expr $i + 3]] 
				
				set p1  [getParam $p1code $p1mode $program]
				set p2  [getParam $p2code $p2mode $program]

				if {$p1 == $p2} {
					set program [lreplace $program $poscode $poscode 1]
				} else {
					set program [lreplace $program $poscode $poscode 0]
				}


			}
			"99" {
				break
			}
			"default" { 
				puts "invalid opcode $opcode"
				exit
			}
		
		}
	}
	#output signal for next run
	return $print
}


#nested fors phase setting
#	1st digit
#		2nd digit
#			3rd digit
#				4th digit
#					5digit
#
#		within the 5th digit loop
#			one more loop
#
#



## phase setting comes with 5 numbers
### need to try those numbers in all areas

# if we have 4,3,2,1,0 as input 
set storedAns 0;


#how do we re-arrange the phase setting list?
# we have 5 numbers 0-4
# we have 5 positions 0,1,2,3,4,5
# there are 120 possible strings
# 01...
# 01...
# 01...
# 01...
# 01...
# 6
# 02...
# 02...
# 02...
# 02...
# 02...
# 02...


proc permutations {list} {
    if {[llength $list] == 1} {
        return $list
    }
    set ret [list]
    set pitem [lindex $list end]
    set rest [permutations [lrange $list 0 end-1]]
    # Right now insert our item at every position in the list
    foreach item $rest {
        for {set i 0} {$i < [llength $item]} {incr i} {
            lappend ret [linsert $item $i $pitem]
        }
        lappend ret [concat $item $pitem]
    }
    return $ret
    }



set phaseCmds [permutations [list "0" "1" "2" "3" "4"]]



foreach phaseCmd $phaseCmds {
	set run1 [runProgram $input [lindex $phaseCmd 0]]
	set run2 [runProgram $run1 [lindex $phaseCmd 1]]
	set run3 [runProgram $run2 [lindex $phaseCmd 2]]
	set run4 [runProgram $run3 [lindex $phaseCmd 3]]
	set output [runProgram $run4 [lindex $phaseCmd 4]]
	
	puts "currentAns: $storedAns"
	puts "currentOutput: $output"
	if {$output > $storedAns} {
		set storedAns $output
	}
}
puts "answer: $storedAns"

