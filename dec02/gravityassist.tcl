#!/usr/bin/tclsh
global ACCA
set ACCA 0
set fileId [open "input.txt" r]
#set fileId [open "test.txt" r]
set noun 0
set verb 0


gets $fileId line
set command [split $line ","]

while { $noun < 100} {
	puts $noun
	while {$verb < 100} {
		puts $verb
		set command [lreplace $command 1 2 $noun $verb]

		for {set i 0} {$i < [llength $command]} {incr i 4} {
			set opcode [lindex $command $i]
			set p1code [lindex $command [expr $i + 1]]
			set p2code [lindex $command [expr $i + 2]]
			set pos [lindex $command [expr $i + 3]]
			
			set p1 [lindex $command $p1code]
			set p2 [lindex $command $p2code]
	
			set result 0
			switch $opcode "1" {set result [expr $p1 + $p2]} "2" {set result [expr $p1 * $p2]} "99" {break} "default" {puts "unknown opcode error!"; return;}
	
			set command [lreplace $command $pos $pos $result]

		}


		puts [lindex $command 0]
		if {[lindex $command 0] == "19690720"} {
			close $fileId
			puts "answer: [expr 100 * $noun + $verb]"
			return
		}

		# reset input
		set command [split $line ","]
		set verb [expr $verb + 1]
		
	}
	set command [split $line ","]
	set noun [expr $noun + 1]
	set verb 0

		
}







#close $fileId




