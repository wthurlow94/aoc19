#!/usr/bin/tclsh

#global WIRES
global COLLISIONS
global wire1Points
global wire2Points
set fileId [open "input.txt"]
seek $fileId 0 start

# Need to use coordinates (x,y). Right will add to x, Left will subtract from x. Up will add to x, down will subtract from x.
#
# step through each wire one at a time. Move Wire 1. Move wire 2. Check collision? If yes - store coords in collisions. Continue. If no Continue.
#
#
# Once we have completed the wire movement, loop through our collisions. Calculate the total distance (x+y). If it's the shortest then store it. 
#
# Once we have completed the above loop, output the answer.
set wire1 [split [gets $fileId] ","]

set coords [list]
set x 0
set y 0


set wire1Pts(0,x) 0
set wire1Pts(0,y) 0
for {set i 0} {$i < [llength $wire1]} {incr i} {

	set instr [lindex $wire1 $i]
	switch [string range $instr 0 0] {
		{R} {set x [expr $x + [string range $instr 1 end]]}	
		{L} {set x [expr $x - [string range $instr 1 end]]}
		{D} {set y [expr $y - [string range $instr 1 end]]}
		{U} {set y [expr $y + [string range $instr 1 end]]}
	}
	
	
	set wire1Pts([expr $i + 1],x) $x
	set wire1Pts([expr $i + 1],y) $y
	#puts $wire1Pts([expr $i + 1],x)
	#puts $wire1Pts([expr $i + 1],y)

}

set wire2 [split [gets $fileId] ","]
set x 0
set y 0

set wire2Pts(0,x) 0
set wire2Pts(0,y) 0



for {set i 0} {$i < [llength $wire2]} {incr i} {

	set instr [lindex $wire2 $i]
	switch [string range $instr 0 0] {
		{R} {set x [expr $x + [string range $instr 1 end]]}	
		{L} {set x [expr $x - [string range $instr 1 end]]}
		{D} {set y [expr $y - [string range $instr 1 end]]}
		{U} {set y [expr $y + [string range $instr 1 end]]}
	}

	set wire2Pts([expr $i + 1],x) $x
	set wire2Pts([expr $i + 1],y) $y	
	
}

#foreach id [array names wire1Pts] {
#	puts "$id: $wire2Pts($id)"
#
#}
#set wire1 [split [gets $fileId] ","]

#puts "[expr [array size wire1Pts] / 2]"
for {set i 0} {$i < ([expr [array size wire1Pts] / 2]) - 1} {incr i} {
	set w1p1 "[concat $wire1Pts($i,x) $wire1Pts($i,y)]"
	set w1p2 "[concat $wire1Pts([expr $i + 1],x) $wire1Pts([expr $i + 1],y)]"
	puts $w1p1
	puts $w1p2
	puts $i
	for {set j 0} {$i < ([expr [array size wire2Pts] / 2]) - 1} {incr i} {
		set w2p1 "[concat $wire2Pts($i,x) $wire1Pts($i,y)]"
		set w2p2 "[concat $wire2Pts([expr $i + 1],x) $wire2Pts([expr $i + 1],y)]"
		puts $w2p1
		puts $w2p2	
		puts $j
		#if wire 1 y is fixed then we have a horizontal line, so we check the value of w2's y for intersect
		if {[lindex $w1p1 1] == [lindex $w1p2 1]} {
		
			set w1y [lindex $w1p1 1]
	

		#This is the Y Plane Window we have to pass through with w2
			set w2minY [expr min([lindex $w2p1 1],[lindex $w2p2 1])]
			set w2maxY [expr max([lindex $w2p1 1],[lindex $w2p2 1])]
		
			if {$w1y > $w2minY && $w1y < $w2maxY} {
	
				set COLLISIONS($i) [concat [lindex $w2p1 0] $w1y]
			}

		}
		# IF Wire 1 x is fixed then we have a vertical line, so we check the value of w2's x for intersect

		if {[lindex $w1p1 0] == [lindex $w1p2 0]} {
		
			set w1x [lindex $w1p1 0]
	

		#This is the X Plane Window we have to pass through with w2
			set w2minX [expr min([lindex $w2p1 0],[lindex $w2p2 0])]
			set w2maxX [expr max([lindex $w2p1 0],[lindex $w2p2 0])]
		
			if {$w1y > $w2minX && $w1y < $w2maxX} {
	
				set COLLISIONS($i) $w1x [concat [lindex $w2p1 1]]
			}

		}

	}

	
		
}




set ans 0
foreach id [array names COLLISIONS] {
	#puts $COLLISIONS($id)
	set val [expr abs([lindex $COLLISIONS($id) 0] + [lindex $COLLISIONS($id) 1])]
	if {$ans == 0 } {
		set ans $val
		continue;
	}

	if {$ans > $val} {
		set ans $val;
		continue;
	}


}

puts $ans




























