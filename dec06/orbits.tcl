#!/usr/bin/tclsh

set fileId [open "input.txt" r]

#set fileId [open "test.txt" r]

seek $fileId 0 start

while {1} {
        gets $fileId orbit
        if {[eof $fileId]} {
        close $fileId
        break
        }

	set left  [lindex [split $orbit ")"] 0]
	set right [lindex [split $orbit ")"] 1]
	
	if {$left == "COM"} {
		set orbits($left,parent) $left
	}

	set orbits($right,parent) $left

	if {[info exists orbits($left,children)]} {
		#puts $orbits($left,children)
		set orbits($left,children) [concat $orbits($left,children) $right]
	} else {
		set orbits($left,children) $right
	}
}


proc getIndirects {node arr agg} {
	upvar $arr a

	#if the parent of the node we are currently looking at is COM, then we return the value of count
	if {$a($node,parent) == "COM"} {
		
		return $agg
	}	

	

	#if not then we traverse further up the tree
	return [getIndirects $a($node,parent) a  [incr agg]]


}




# for each orbit we have, we need to track it back to C
set indirects 0;
set directs 0;
foreach value [array names orbits] {
	if {[string match "*,children" $value]} {
		if {[llength $orbits($value)] > 1} {
			foreach child $orbits($value) {
				puts "child: $child"
				incr indirects [getIndirects $child orbits 0]
				incr directs;			
			}		
		} else {
		
			puts "value: $orbits($value)"
			incr indirects [getIndirects $orbits($value) orbits 0]
			incr directs
		}
	}
}


puts $indirects
puts $directs

set total [expr $indirects + $directs]

puts $total


