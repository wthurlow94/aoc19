#!/usr/bin/tclsh

#global WIRES
global COLLISIONS
global wire1Points
global wire2Points
set fileId [open "input.txt"]
#set fileId [open "test.txt"]
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
set wire1Pts(0,step) 0
set acca 0
for {set i 0} {$i < [llength $wire1]} {incr i} {

	set instr [lindex $wire1 $i]
	switch [string range $instr 0 0] {
		{R} {set x [expr $x + [string range $instr 1 end]]}	
		{L} {set x [expr $x - [string range $instr 1 end]]}
		{D} {set y [expr $y - [string range $instr 1 end]]}
		{U} {set y [expr $y + [string range $instr 1 end]]}
	}
	set acca [expr $acca + [string range $instr 1 end]]
	
	set wire1Pts([expr $i + 1],x) $x
	set wire1Pts([expr $i + 1],y) $y
	set wire1Pts([expr $i + 1],step) $acca
	#puts $wire1Pts([expr $i + 1],y)
#puts "wire1Acca: $acca"
}

set wire2 [split [gets $fileId] ","]
set x 0
set y 0
set acca 0
set wire2Pts(0,x) 0
set wire2Pts(0,y) 0
set wire2Pts(0,step) 0


for {set i 0} {$i < [llength $wire2]} {incr i} {

	set instr [lindex $wire2 $i]
	switch [string range $instr 0 0] {
		{R} {set x [expr $x + [string range $instr 1 end]]}	
		{L} {set x [expr $x - [string range $instr 1 end]]}
		{D} {set y [expr $y - [string range $instr 1 end]]}
		{U} {set y [expr $y + [string range $instr 1 end]]}
	}
	set acca [expr $acca + [string range $instr 1 end]]
	set wire2Pts([expr $i + 1],x) $x
	set wire2Pts([expr $i + 1],y) $y	
	set wire2Pts([expr $i + 1],step) $acca
#puts "wire2Acca: $acca"
}


#foreach id [array names wire1Pts] {
#	puts "Wire 1 $id: $wire1Pts($id)"	
#}


#foreach id2 [array names wire2Pts] {
#	puts "Wire 2 $id2: $wire2Pts($id2)"	
#}



#set wire1 [split [gets $fileId] ","]
set w1p1 [list]
set w1p2 [list]
set COLLISIONS [list]
set STEPS [list]
set w2p1 [list]
set w2p2 [list]



#puts "[expr [array size wire1Pts] / 2]"
for {set i 0} {$i < ([expr [array size wire1Pts] / 3]) - 1} {incr i} {
	#puts $i
	set w1p1 [list "$wire1Pts($i,x)" "$wire1Pts($i,y)"]
	set w1p2 [list "$wire1Pts([expr $i + 1],x)" "$wire1Pts([expr $i + 1],y)"]
	set step1 $wire1Pts([expr $i],step)
	#puts "l1 steps $step1"
	for {set j 0} {$j < ([expr [array size wire2Pts] / 3]) - 1} {incr j} {
		set w2p1 [list "$wire2Pts($j,x)" "$wire2Pts($j,y)"]
		set w2p2 [list "$wire2Pts([expr $j + 1],x)" "$wire2Pts([expr $j + 1],y)"]
		set step2 $wire2Pts([expr $j],step)
	#	puts "l2 steps $step2"
	#	puts "([lindex $w2p1 0],[lindex $w2p1 1]) --> ([lindex $w2p2 0],[lindex $w2p2 1])" 
		#if the first line has a  y that  is fixed then we have a horizontal line, so we check the second lines Y interval to see if the fixed Y falls in that range - if it does then it's an intersect
		#? do we need to check the X falls within this bounday as well
		if {[lindex $w1p1 1] == [lindex $w1p2 1]} {
			#if wire 2 is also horizontal then skip as horizontal lines can't collide
			set w1minX [expr min([lindex $w1p1 0],[lindex $w1p2 0])]
			set w1maxX [expr max([lindex $w1p1 0],[lindex $w1p2 0])]
			set intersecty [lindex $w1p1 1]


		#This is the Y Plane Window we have to pass through with w2
			set w2minY [expr min([lindex $w2p1 1],[lindex $w2p2 1])]
			set w2maxY [expr max([lindex $w2p1 1],[lindex $w2p2 1])]
			
			# if our second line's X coord does not fall in the line then break
			if {[lindex $w2p1 0] > $w1maxX || [lindex $w2p1 0] < $w1minX} {
			#	puts "no intersect"
				continue
			}
			if {$intersecty > $w2minY && $intersecty < $w2maxY} {
				puts "Vertical Collision at Wire 1([lindex $w1p1 0],[lindex $w1p1 1]), ([lindex $w1p2 0],[lindex $w1p2 1]),and Wire2([lindex $w2p1 0],[lindex $w2p1 1]), ([lindex $w2p2 0],[lindex $w2p2 1])"
				
			#	puts "Intersect at ([lindex $w2p1 0],$intersecty)"
				set COLLISIONS [concat $COLLISIONS "[expr abs(( 0 - abs([lindex $w2p1 0])) + ( 0 - abs($intersecty)))]"]
	#			set STEPS [concat $STEPS [expr ($step1 + abs($intersecty)) + (abs($intersecty) + $step2)]]
				set x [expr $step2 + abs($intersecty - [lindex $w2p1 1])]
				set y [expr $step1 + abs([lindex $w2p1 0] - [lindex $w1p1 0])]
				set STEPS [concat $STEPS [expr $x + $y]]
		}

		}
		# IF Wire 1 x is fixed then we have a vertical line, so we check the value of w2's x for intersect

		if {[lindex $w1p1 0] == [lindex $w1p2 0]} {
		
	
			set w1minY [expr min([lindex $w1p1 1],[lindex $w1p2 1])]
			set w1maxY [expr max([lindex $w1p1 1],[lindex $w1p2 1])]
			set w1x [lindex $w1p1 0]

		# if our second line's y coord does not fall in the line then break
		if {[lindex $w2p1 1] > $w1maxY || [lindex $w2p1 1] < $w1minY} {
			#puts "no intersect"
			continue
		}



		#This is the X Plane Window we have to pass through with w2
			set w2minX [expr min([lindex $w2p1 0],[lindex $w2p2 0])]
			set w2maxX [expr max([lindex $w2p1 0],[lindex $w2p2 0])]
		
			if {$w1x > $w2minX && $w1x < $w2maxX} {
	
		#puts "Intersect at ($w1x,[lindex $w2p1 1])"
	
	puts "Horizontal Collision at Wire1:([lindex $w1p1 0],[lindex $w1p1 1]), ([lindex $w1p2 0],[lindex $w1p2 1]) and Wire2:([lindex $w2p1 0],[lindex $w2p1 1]), ([lindex $w2p2 0],[lindex $w2p2 1])"
				set COLLISIONS [concat $COLLISIONS "[expr abs(( 0 - abs($w1x)) + ( 0 - abs([lindex $w2p1 1])))]"] 
	#			puts "$step2 + abs($w1x - [lindex $w2p1 0])"
	#			puts "$step1 + abs([lindex $w2p1 1] - [lindex $w1p1 1])"

				set x [expr $step2 + abs($w1x - [lindex $w2p1 0])]
				set y [expr $step1 + abs([lindex $w2p1 1] - [lindex $w1p1 1])]
				set STEPS [concat $STEPS [expr $x + $y]]
}

		}

	}

	
		
}
puts [lsort $STEPS]
	
#set ans 0
#
#
#
#puts $COLLISIONS
#foreach id [array names COLLISIONS] {
	#puts "]"
#	set val [expr abs(( 0 - [lindex $COLLISIONS($id) 0]) + ( 0 - [lindex $COLLISIONS($id) 1]))]
#	puts $val
#	
#	if {$ans == 0 } {
#		set ans $val
		#continue;
	#}
##	if current answer is bigger than the answer we are looking at 
#	if {$ans > $val} {
#		set ans $val;
#		continue;
#	}
#

#}

#puts $ans




























