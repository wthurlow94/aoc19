#!/usr/bin/tclsh
global ACCA
set ACCA 0
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]
set input 1;

gets $fileId line
set program [split $line ","]
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

for {set i 0} {$i < [llength $program]} {incr i $increment} {
	set output [list]
	set operation [lindex $program $i]
	set opcode [string range $operation [expr [string length $operation] - 2] [string length $operation]]
	set modestring [string range $operation 0 [expr [string length $operation] -3]]
	puts "iteration: $i"

	while {[string length $opcode] < 2} {
		set opcode [string cat "0" $opcode]
	}
	puts $operation
	puts $opcode
	
	switch $opcode {
			"01" {
				#Addition
				puts "addition"
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
				puts "wrote value $value at position $poscode"
				# three parameters: p1, p2, pos
			}
			"02" {
				#Multiplication
				set increment 4
				
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
				puts "wrote value $value at position $poscode"			
			}
			"03" {
				#Write
				set increment 2
				# one parameter - mode irrelevant
				#
				set parameter [lindex $program [expr $i + 1]]
				
				set program [lreplace $program $parameter $parameter $input]
				puts "wrote value $input at position $parameter"
				}
			"04" {
				#Print
				set increment 2
				# one parameter - mode irrelevant
				set modes [split $modestring ""]
				while {[llength $modes] < 1} {
					set modes [linsert $modes 0 0]
				}
			
				set mode [lindex $modes 0]
				set code [lindex $program [expr $i +1]]
				puts "code $code"
				puts "mode $mode"
				set print [getParam $code $mode $program]
				
				
				
				
				if {$print != 0} {
					puts "output iteration: $i"
					puts $print
					exit
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
#	puts $increment
#	set p1code [lindex $program [expr $i + 1]]
#	set p2code [lindex $program [expr $i + 2]]
#	set pos [lindex $program [expr $i + 3]]
	

	#puts "p1 code: $p1code"
#	set p1 [lindex $command $p1code]
	#puts "p1: $p1"
	#puts "p2 code: $p2code"
#	set p2 [lindex $command $p2code]
	#puts "p2: $p2"
	
#	set result 0
#	switch $opcode "1" {set result [expr $p1 + $p2]} "2" {set result [expr $p1 * $p2]} "99" {break} "default" {puts "unknown opcode error!"; return;}
	

#	set command [lreplace $command $pos $pos $result]

	#puts "pos $i: [lindex $command $i]"

	#puts "pos [expr $i + 1]: [lindex $command [expr $i + 1]]"

	#puts "pos [expr $i + 2]: [lindex $command [expr $i + 2]]"

	#puts "pos [expr $i + 3]: [lindex $command [expr $i + 3]]"
	



}

#puts "answer: [lindex $command 0]"





#close $fileId




