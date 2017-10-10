mdp

//TODO: try controller synthesis to optimize properties (including pareto properties)
//TODO: scale up the number of humans, robots, sites
//TODO: how do you allow for sites to do both change at the same time without doing an exhaustive creation of lines
//NOTE: when simulating you should only click an agents path once per time step. This is due to the fact you will be doing redundant steps if you click an agents movement multiple times in one time step

const int num_sites=2;
//time=0;

module Human
	h: [0..num_sites] init 0; // human position

	[] h=0 -> (h'=0);
	[] h=0 -> (h'=1);
	[s1_hg] h=0 -> (h'=1);
	[s1_h] h=0 -> (h'=1);
	[] h=0 -> (h'=2);
	[s2_hg] h=0 -> (h'=2);
	[s2_h] h=0 -> (h'=2);

	[] h=1 -> (h'=0);
	[] h=1 -> (h'=1);
	[s1_hg] h=1 -> (h'=1);
	[s1_h] h=1 -> (h'=1);
	[] h=1 -> (h'=2);
	[s2_hg] h=1 -> (h'=2);
	[s2_h] h=1 -> (h'=2);

	[] h=2 -> (h'=0);
	[] h=2 -> (h'=1);
	[s1_hg] h=2 -> (h'=1);
	[s1_h] h=2 -> (h'=1);
	[] h=2 -> (h'=2);
	[s2_hg] h=2 -> (h'=2);
	[s2_h] h=2 -> (h'=2);
endmodule

module UGV
	g: [0..num_sites] init 0; // ugv position

	[] g=0 -> (g'=0);
	[] g=0 -> (g'=1);
	[s1_hg] g=0 -> (g'=1);
	[] g=0 -> (g'=2);
	[s2_hg] g=0 -> (g'=2);

	[] g=1 -> (g'=0);
	[] g=1 -> (g'=1);
	[s1_hg] g=1 -> (g'=1);
	[] g=1 -> (g'=2);
	[s2_hg] g=1 -> (g'=2);

	[] g=2 -> (g'=0);
	[] g=2 -> (g'=1);
	[s1_hg] g=2 -> (g'=1);
	[] g=2 -> (g'=2);
	[s2_hg] g=2 -> (g'=2);
endmodule

module UAV
	a: [0..num_sites] init 0; // uav position

	[] a=0 -> (a'=0);
	[] a=0 -> (a'=1);
	[] a=0 -> (a'=2);

	[] a=1 -> (a'=0);
	[] a=1 -> (a'=1);
	[] a=1 -> (a'=2);

	[] a=2 -> (a'=0);
	[] a=2 -> (a'=1);
	[] a=2 -> (a'=2);
endmodule

module sites
	s1: [0..4] init 0;			//state of the site (0 unknown, 1 fire, 2 human, 3 fire+human, 4 nuteral)
	s2: [0..4] init 0; 			//state of the site (0 unknown, 1 fire, 2 human, 3 fire+human, 4 nuteral)

	[time1] s1=0 & (h=1 | a=1 | g=1) -> 0.25:(s1'=1) + 0.25:(s1'=2) + 0.25:(s1'=3) + 0.25:(s1'=4);
	[time1] s1=1 & h=1 & g=1 -> 0.5:(s1'=1) + 0.5:(s1'=4);
	[time1] s1=2 & h=1 -> 0.5:(s1'=2) + 0.5:(s1'=4);
	[time1] s1=3 & h=1 & g=1 -> 0.25:(s1'=1) + 0.25:(s1'=2) + 0.25:(s1'=3) + 0.25:(s1'=4);
	[time1] s1=3 & h=1 -> 0.5:(s1'=1) + 0.5:(s1'=3);

	[time2] s2=0 & (h=2 | a=2 | g=2) -> 0.25:(s2'=1) + 0.25:(s2'=2) + 0.25:(s2'=3) + 0.25:(s2'=4);
	[time2] s2=1 & h=2 & g=2 -> 0.5:(s2'=1) + 0.5:(s2'=4);
	[time2] s2=2 & h=2 -> 0.5:(s2'=2) + 0.5:(s2'=4);
	[time2] s2=3 & h=2 & g=2 -> 0.25:(s2'=1) + 0.25:(s2'=2) + 0.25:(s2'=3) + 0.25:(s2'=4);
	[time2] s2=3 & h=2 -> 0.5:(s2'=1) + 0.5:(s2'=3);

	// recycling loop for keeping times the same
	[time1] s1=0 -> true;
	[time1] s1=1 -> true;
	[time1] s1=2 -> true;
	[time1] s1=3 -> true;
	[time1] s1=4 -> true;

	[time2] s2=0 -> true;
	[time2] s2=1 -> true;
	[time2] s2=2 -> true;
	[time2] s2=3 -> true;
	[time2] s2=4 -> true;

	// finishing loop if site is nuteral
	//[] s1=4 | s2=4 -> true; 		// self-loop
	
	//call for agents
	[s1_hg] s1 = 1 | s1 = 3 -> true;	//call for agent human/UGV
	[s1_h] s1 = 2 | s1 = 3 -> true;		//call for agent human
	[s2_hg] s2 = 1 | s2 = 3 -> true;	//call for agent human/UGV
	[s2_h] s2 = 2 | s2 = 3 -> true;		//call for agent human

endmodule 

rewards "time1"
	[time1] true: 1;
endrewards
rewards "time2"
	[time2] true: 1;
endrewards

//rewards "total_movement"
//	true:1;
//endrewards



