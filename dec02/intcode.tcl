#!/usr/bin/tclsh
global ACCA
set ACCA 0
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]

gets $fileId line
set command [split $line ","]


for {set i 0} {$i < [llength $command]} {incr i 4} {
	set opcode [lindex $command $i]
	set p1code [lindex $command [expr $i + 1]]
	set p2code [lindex $command [expr $i + 2]]
	set pos [lindex $command [expr $i + 3]]
	

	#puts "p1 code: $p1code"
	set p1 [lindex $command $p1code]
	#puts "p1: $p1"
	#puts "p2 code: $p2code"
	set p2 [lindex $command $p2code]
	#puts "p2: $p2"
	
	set result 0
	switch $opcode "1" {set result [expr $p1 + $p2]} "2" {set result [expr $p1 * $p2]} "99" {break} "default" {puts "unknown opcode error!"; return;}
	

	set command [lreplace $command $pos $pos $result]

	#puts "pos $i: [lindex $command $i]"

	#puts "pos [expr $i + 1]: [lindex $command [expr $i + 1]]"

	#puts "pos [expr $i + 2]: [lindex $command [expr $i + 2]]"

	#puts "pos [expr $i + 3]: [lindex $command [expr $i + 3]]"
	



}

puts "answer: [lindex $command 0]"





#close $fileId




