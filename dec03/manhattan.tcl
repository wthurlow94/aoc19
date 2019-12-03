#!/usr/bin/tclsh

#global WIRES
global COLLISIONS

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
set wires [split [gets $fileId] ","]


set w1x 0
set w1y 0
set w2x 0
set w2y 0
#For every wire in $wires.
for {set i 0} {$i < [llength $wires]} {incr i} {
	set wire1 [lindex $wires $i]
	set wire2 [lindex $wires [expr $i + 1]]
	
	#wire 1
	
	switch -glob -- $wire1 \
		{R[0-9]*} {puts "R hit: $wireDir"}	
		{L[0-9]*} {}
		{D[0-9]*} {}
		{U[0-9]*} {}

	switch -glob -- $wire1 \
		{R[0-9]*} {set w1x [expr $w1x + [lrange $wire1 1 end]]} \
		{L[0-9]*} {set w1x [expr $w1x - [lrange $wire1 1 end]]} \
		{D[0-9]*} {set w1y [expr $w1y - [lrange $wire1 1 end]]} \
		{U[0-9]*} {set w1y [expr $w1y - [lrange $wire1 1 end]]} \
	
	switch -glob -- $wire2 \
		{R[0-9]*} {set w2x [expr $w2x + [lrange $wire2 1 end]]} \
		{L[0-9]*} {set w2x [expr $w2x - [lrange $wire2 1 end]]} \
		{D[0-9]*} {set w2y [expr $w2y - [lrange $wire2 1 end]]} \
		{U[0-9]*} {set w2y [expr $w2y - [lrange $wire2 1 end]]} \
	
#This won't work
# Need to build the first wire and then check each wire 2 movement to see if it falls between any two points of wire 1 - more complex
	if {$w1x == $w2x && $w1y == $w2y} {
		set COLLISONS [lappend COLLISIONS [expr $w1x ]]
	}






}

#}


