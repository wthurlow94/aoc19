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


proc pathFromNodeToCOM {node arr path} {

	upvar $arr a

	if {$a($node,parent) =="COM"} {
		return $path
	}
	

	return [pathFromNodeToCOM $a($node,parent) a [concat $path $a($node,parent)]]
}



proc getClosestSharedAncestor {path1 path2} {

	for {set i 0} {$i < [llength $path1]} {incr i} {
	puts [lindex $path1 $i]
		if {[lsearch $path2 [lindex $path1 $i]] > -1} {

			#the current record exists in the path so this is the closest ancestor
			return [lindex $path1 $i]

		}
	}
}


proc getShifts {node arr agg} {
	upvar $arr ar
	global ANC
#	puts "node: $node"
#	puts "parent: $ar($node,parent)"
	#if the parent of the node we are currently looking at is COM, then we return the value of count
	if {$ar($node,parent) == $ANC} {
			
		return $agg
	}	

	

	#if not then we traverse further up the tree
	return [getShifts $ar($node,parent) ar [incr agg]]


}



puts [set santocom [pathFromNodeToCOM $orbits(SAN,parent) orbits [list]]]

puts [set youtocom [pathFromNodeToCOM $orbits(YOU,parent) orbits [list]]]
global ANC
set ANC [getClosestSharedAncestor $youtocom $santocom]



puts [expr [getShifts $orbits(YOU,parent) orbits 1] + [getShifts $orbits(SAN,parent) orbits 1]]













# for each orbit we have, we need to track it back to C
#set indirects 0;
#set directs 0;
#foreach value [array names orbits] {
#	if {[string match "*,children" $value]} {
#		if {[llength $orbits($value)] > 1} {
#			foreach child $orbits($value) {
#	#			puts "child: $child"
#				incr indirects [getIndirects $child orbits 0]
#				incr directs;			
#			}		
#		} else {
#		
#	#		puts "value: $orbits($value)"
#			incr indirects [getIndirects $orbits($value) orbits 0]
##			incr directs
#		}
#	}
#}


#puts $indirects
#puts $directs

#set total [expr $indirects + $directs]

#puts $total


