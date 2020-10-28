set ns [new Simulator -multicast on]
#Turn on Tracing
set tf [open output.tr w]
$ns trace-all $tf

# Turn on nam Tracing
set fd [open mcast.nam w]
$ns namtrace-all $fd

# Create nodes
#Group1
set n0 [$ns node]
$n0 color green
$n0 shape box
$ns at 0.0 "$n0 label Root"
set n1 [$ns node]
$n1 color green
$n1 shape hexagon
set n2 [$ns node]
$n2 color green
$n2 shape hexagon
set n3 [$ns node]
$n3 color green
$n3 shape hexagon
set n4 [$ns node]
$n4 color green
$ns at 0.0 "$n4 label Gateway"

#Group2
set n5 [$ns node]
$n5 color blue
$n5 shape box
$ns at 0.0 "$n5 label Root"
set n6 [$ns node]
$n6 color blue
$n6 shape hexagon
set n7 [$ns node]
$n7 color blue
$n7 shape hexagon
set n8 [$ns node]
$n8 color blue
$n8 shape hexagon
set n9 [$ns node]
$n9 color blue
$ns at 0.0 "$n9 label Gateway"

#Group3
set n10 [$ns node]
$n10 color red
$n10 shape box
$ns at 0.0 "$n10 label Root"
set n11 [$ns node]
$n11 color red
$n11 shape hexagon
set n12 [$ns node]
$n12 color red
$n12 shape hexagon
set n13 [$ns node]
$n13 color red
$n13 shape hexagon
set n14 [$ns node]
$n14 color red
$ns at 0.0 "$n14 label Gateway"

#Node Position
# Gateway Position
$n4 set X_ 10.0
$n4 set Y_ 200.0
$n4 set Z_ 0.0

$n9 set X_ 50.0
$n9 set Y_ 100.0
$n9 set Z_ 0.0

$n14 set X_ 90.0
$n14 set Y_ 100.0
$n14 set Z_ 0.0

#Group 1
$n1 set X_ 10.0
$n1 set Y_ 70.0
$n1 set Z_ 0.0

$n2 set X_ 10.0
$n2 set Y_ 50.0
$n2 set Z_ 0.0

$n3 set X_ -10.0
$n3 set Y_ 50.0
$n3 set Z_ 0.0

$n4 set X_ -10.0
$n4 set Y_ 70.0
$n4 set Z_ 0.0



# Create links with DropTail Queues
#Group1
$ns duplex-link $n0 $n1 1.5Mb 10ms DropTail
$ns duplex-link $n0 $n3 1.5Mb 10ms DropTail
$ns duplex-link $n3 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n1 $n2 1.5Mb 10ms DropTail
$ns duplex-link $n2 $n4 1.5Mb 10ms DropTail

#Group2
$ns duplex-link $n5 $n6 1.5Mb 10ms DropTail
$ns duplex-link $n5 $n7 1.5Mb 10ms DropTail
$ns duplex-link $n7 $n8 1.5Mb 10ms DropTail
$ns duplex-link $n8 $n6 1.5Mb 10ms DropTail
$ns duplex-link $n8 $n9 1.5Mb 10ms DropTail

#Group3
$ns duplex-link $n10 $n11 1.5Mb 10ms DropTail
$ns duplex-link $n10 $n12 1.5Mb 10ms DropTail
$ns duplex-link $n12 $n13 1.5Mb 10ms DropTail
$ns duplex-link $n13 $n11 1.5Mb 10ms DropTail
$ns duplex-link $n13 $n14 1.5Mb 10ms DropTail

#Link-Gateway-Together
$ns duplex-link $n4 $n9 15Mb 99ms DropTail
$ns duplex-link $n9 $n14 15Mb 99ms DropTail


$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n1 $n2 orient down
$ns duplex-link-op $n2 $n4 orient down
$ns duplex-link-op $n4 $n9 orient right
$ns duplex-link-op $n9 $n8 orient up
$ns duplex-link-op $n8 $n7 orient left
$ns duplex-link-op $n7 $n5 orient up
$ns duplex-link-op $n5 $n6 orient right
$ns duplex-link-op $n6 $n8 orient down
$ns duplex-link-op $n9 $n14 orient right
$ns duplex-link-op $n14 $n13 orient up
$ns duplex-link-op $n13 $n12 orient left
$ns duplex-link-op $n12 $n10 orient up
$ns duplex-link-op $n10 $n11 orient right
$ns duplex-link-op $n11 $n13 orient down





#$ns duplex-link-op $n1 $n6 orient left
#$ns duplex-link-op $n1 $n7 orient left-up
#$ns duplex-link-op $n1 $n8 orient left-down

#$ns duplex-link-op $n2 $n10 orient right
#$ns duplex-link-op $n2 $n11 orient right
#$ns duplex-link-op $n10 $n9 orient right-down
# Routing protocol: say distance vector
#Protocols: CtrMcast, DM, ST, BST
#Dense Mode protocol is supported in this example
#set mproto BST

# Set two groups with group addresses


set group1 [Node allocaddr]
set mproto1 CtrMcast
set mrthandle1 [$ns mrtproto $mproto1 {}]
$mrthandle1 set_c_rp $n0

set group2 [Node allocaddr]
set mproto2 CtrMcast
set mrthandle2 [$ns mrtproto $mproto2 {}]
$mrthandle2 set_c_rp $n5

set group3 [Node allocaddr]
set mproto3 CtrMcast
set mrthandle3 [$ns mrtproto $mproto3 {}]
$mrthandle3 set_c_rp $n10

# UDP Transport agent for the traffic source for group1
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

# Transport agent for the traffic source for group2
set udp1 [new Agent/UDP]
$ns attach-agent $n5 $udp1
$udp1 set dst_addr_ $group2
$udp1 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

# Transport agent for the traffic source for group3
set udp2 [new Agent/UDP]
$ns attach-agent $n10 $udp2
$udp2 set dst_addr_ $group3
$udp2 set dst_port_ 0
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp2
# Create receiver to accept the packets

#Group1
set rcvr1 [new Agent/Null]
$ns attach-agent $n1 $rcvr1
$ns at 1.0 "$n1 join-group $rcvr1 $group1"
$ns attach-agent $n2 $rcvr1
$ns at 1.0 "$n2 join-group $rcvr1 $group1"
$ns attach-agent $n3 $rcvr1
$ns at 1.0 "$n3 join-group $rcvr1 $group1"
$ns attach-agent $n4 $rcvr1
$ns at 1.0 "$n4 join-group $rcvr1 $group1"

#Group2
set rcvr2 [new Agent/Null]
$ns attach-agent $n6 $rcvr2
$ns at 1.0 "$n6 join-group $rcvr2 $group2"
$ns attach-agent $n7 $rcvr2
$ns at 1.0 "$n7 join-group $rcvr2 $group2"
$ns attach-agent $n8 $rcvr2
$ns at 1.0 "$n8 join-group $rcvr2 $group2"
$ns attach-agent $n9 $rcvr2
$ns at 1.0 "$n9 join-group $rcvr2 $group2"

#Group3
set rcvr3 [new Agent/Null]
$ns attach-agent $n11 $rcvr3
$ns at 1.0 "$n11 join-group $rcvr3 $group3"
$ns attach-agent $n12 $rcvr3
$ns at 1.0 "$n12 join-group $rcvr3 $group3"
$ns attach-agent $n13 $rcvr3
$ns at 1.0 "$n13 join-group $rcvr3 $group3"
$ns attach-agent $n14 $rcvr3
$ns at 1.0 "$n14 join-group $rcvr3 $group3"




#The nodes are leaving the group at specified times
#$ns at 3.5 "$n7 join-group $rcvr6 $group2"
#$ns at 4.0 "$n5 leave-group $rcvr1 $group1"
#$ns at 4.5 "$n6 leave-group $rcvr2 $group1"
#$ns at 5.0 "$n7 leave-group $rcvr3 $group1"
#$ns at 5.5 "$n5 leave-group $rcvr4 $group2"
#$ns at 6.0 "$n6 leave-group $rcvr5 $group2"
#$ns at 6.5 "$n7 leave-group $rcvr6 $group2"

# Schedule events

$ns at 0.0 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"
$ns at 0.0 "$cbr2 start"
$ns at 9.5 "$cbr2 stop"
$ns at 0.0 "$cbr3 start"
$ns at 9.5 "$cbr3 stop"

#post-processing

$ns at 10.0 "finish"
proc finish {} {
  global ns tf
   $ns flush-trace
   close $tf
   exec nam mcast.nam &
   exit 0
}

$ns set-animation-rate 3.0ms
$ns run
