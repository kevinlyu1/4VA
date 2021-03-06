mdp

// DISTANCE CONSTANTS
const int D01 = 2; // distance between site0 and site1
const int D02 = 3; // distance between site0 and site2
const int D12 = 4; // distance between site1 and site2

// SITES
const int N = 2; // number of sites
const int site0 = 0;
const int site1 = 1;
const int site2 = 2;

// TIMING CONSTANTS
const int Ch_MAX = 20; // max vlaue of clock_h
const int Ca_MAX = 20; // max vlaue of clock_a
const int Cg_MAX = 20; // max vlaue of clock_g

// SPEED CONSTANTS
const int Sh = 3; // human travel speed (time/distance)
const int Sa = 1; // UVA travel speed (time/distance)
const int Sg = 2; // UGV travel speed (time/distance)

// SITE INFORMATION
const int state0 = 0; // unknown
const int state1 = 1; // fire
const int state2 = 2; // human
const int state3 = 3; // fire+human
const int state4 = 4; // nuteral

//VALUABLES
const int valuables1_MAX = 1000;
const int valuables2_MAX = 500;

//DECAYS
const int decay1 = 1;
const int decay2 = 2;

// GLOBAL CLOCK
const int totClock_max = 50;

module timer
	totClock: [0..totClock_max] init 0;

	[time] totClock<totClock_max -> (totClock'=totClock+1);
endmodule

// main agent module
module human
	h: [0..N] init 0; // position of human (which site the agent is at)
	clock_h: [0..Ch_MAX] init 0; // clock of human (transition time needed for the agent)
	move_h: bool init false; // human moving (lock for agent movement)
//	totClock: [0..100] init 0;

	// time passage
	[time] clock_h>1 	& totClock<totClock_max-> (clock_h'=clock_h-1); // if agent is moving
	[time] clock_h=1 	& totClock<totClock_max-> (clock_h'=0) & (move_h'=false); // agent has stopped moving

	// human stays at the same site
	[] clock_h=0 & !move_h 	& totClock<totClock_max -> (clock_h'=1);

	// human movement between sites
	[human_0_1] h=site0 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site1) & (clock_h'=D01*Sh) & (move_h'=true);
	[human_0_2] h=site0 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site2) & (clock_h'=D02*Sh) & (move_h'=true);

	[human_1_0] h=site1 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site0) & (clock_h'=D01*Sh) & (move_h'=true);
	[human_1_2] h=site1 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site2) & (clock_h'=D12*Sh) & (move_h'=true);

	[human_2_0] h=site2 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site0) & (clock_h'=D02*Sh) & (move_h'=true);
	[human_2_1] h=site2 & clock_h=0 & !move_h 	& totClock<totClock_max -> (h'=site1) & (clock_h'=D12*Sh) & (move_h'=true);
endmodule

// uav agent
module uav = human [h=a, clock_h=clock_a, move_h=move_a, Ch_MAX=Ca_MAX, Sh=Sa,
			human_0_1=uav_0_1, human_0_2=uav_0_2, human_0_3=uav_0_3, human_0_4=uav_0_4, human_0_5=uav_0_5, human_0_6=uav_0_6, human_1_0=uav_1_0, human_1_2=uav_1_2, human_1_3=uav_1_3, human_1_4=uav_1_4, human_1_5=uav_1_5, human_1_6=uav_1_6,
			human_2_0=uav_2_0, human_2_1=uav_2_1, human_2_3=uav_2_3, human_2_4=uav_2_4, human_2_5=uav_2_5, human_2_6=uav_2_6, human_3_0=uav_3_0, human_3_1=uav_3_1, human_3_2=uav_3_2, human_3_4=uav_3_4, human_3_5=uav_3_5, human_3_6=uav_3_6,
			human_4_0=uav_4_0, human_4_1=uav_4_1, human_4_2=uav_4_2, human_4_3=uav_4_3, human_4_5=uav_4_5, human_4_6=uav_4_6, human_5_0=uav_5_0, human_5_1=uav_5_1, human_5_2=uav_5_2, human_5_3=uav_5_3, human_5_4=uav_5_4, human_5_6=uav_5_6,
			human_6_0=uav_6_0, human_6_1=uav_6_1, human_6_2=uav_6_2, human_6_3=uav_6_3, human_6_4=uav_6_4, human_6_5=uav_6_5]
endmodule

// ugv agent
module ugv = human [h=g, clock_h=clock_g, move_h=move_g, Ch_MAX=Cg_MAX, Sh=Sg,
			human_0_1=ugv_0_1, human_0_2=ugv_0_2, human_0_3=ugv_0_3, human_0_4=ugv_0_4, human_0_5=ugv_0_5, human_0_6=ugv_0_6, human_1_0=ugv_1_0, human_1_2=ugv_1_2, human_1_3=ugv_1_3, human_1_4=ugv_1_4, human_1_5=ugv_1_5, human_1_6=ugv_1_6,
			human_2_0=ugv_2_0, human_2_1=ugv_2_1, human_2_3=ugv_2_3, human_2_4=ugv_2_4, human_2_5=ugv_2_5, human_2_6=ugv_2_6, human_3_0=ugv_3_0, human_3_1=ugv_3_1, human_3_2=ugv_3_2, human_3_4=ugv_3_4, human_3_5=ugv_3_5, human_3_6=ugv_3_6,
			human_4_0=ugv_4_0, human_4_1=ugv_4_1, human_4_2=ugv_4_2, human_4_3=ugv_4_3, human_4_5=ugv_4_5, human_4_6=ugv_4_6, human_5_0=ugv_5_0, human_5_1=ugv_5_1, human_5_2=ugv_5_2, human_5_3=ugv_5_3, human_5_4=ugv_5_4, human_5_6=ugv_5_6,
			human_6_0=ugv_6_0, human_6_1=ugv_6_1, human_6_2=ugv_6_2, human_6_3=ugv_6_3, human_6_4=ugv_6_4, human_6_5=ugv_6_5]
endmodule

// main site module
module site_one
	s1: [0..4] init 0; //state of the site (0 unknown, 1 fire, 2 human, 3 fire+human, 4 nuteral)
//	valuables1: [0..valuables1_MAX] init 0;
	s1_finished: bool init false;

	[] s1=state0 & ((h=site1 & !move_h) | (a=site1 & !move_a) | (g=site1 & !move_g))	& totClock<totClock_max	-> 0.25:(s1'=state1) + 0.25:(s1'=state2) + 0.25:(s1'=state3) + 0.25:(s1'=state4) & (s1_finished' = true);
	[] s1=state1 & (h=site1 & !move_h)  & (g=site1 & !move_g) 				& totClock<totClock_max	-> 0.50:(s1'=state1) + 0.50:(s1'=state4) & (s1_finished' = true);
	[] s1=state2 & (h=site1 & !move_h) 							& totClock<totClock_max	-> 0.50:(s1'=state2) + 0.50:(s1'=state4) & (s1_finished' = true);
	[] s1=state3 & (h=site1 & !move_h) & (g=site1 & !move_g) 				& totClock<totClock_max	-> 0.25:(s1'=state1) + 0.25:(s1'=state2) + 0.25:(s1'=state3) + 0.25:(s1'=state4) & (s1_finished' = true);
	[] s1=state3 & (h=site1 & !move_h) & g!=site1 						& totClock<totClock_max	-> 0.50:(s1'=state1) + 0.50:(s1'=state3);
	[] s1=state4 										& totClock<totClock_max	-> (s1' = state4); // self-loop
endmodule

// duplicate site modules
module site_two = site_one[s1=s2, site1=site2, valuables1 = valuables2, valuables1_MAX = valuables2_MAX, s1_finished = s2_finished] endmodule

// counter for time
//rewards "time"
//	[time]true : 1;
//endrewards

rewards "damage_done"
	[time] s1_finished=false: decay1;
	[time] s2_finished=false: decay2;
//	[] s1_finished = true & -(decay1*totClock) < valuables1_MAX: ((decay1*totClock)+valuables1_MAX); 
//	[] s2_finished = true & -(decay2*totClock) < valuables2_MAX: ((decay2*totClock)+valuables2_MAX);
//	[] s1_finished = true & -(decay1*totClock) > valuables1_MAX-1: 0; // if the decay is more than the total number of valuables
//	[] s2_finished = true & -(decay2*totClock) > valuables2_MAX-1: 0; // if the decay is more than the total number of valuables
endrewards

rewards "visited"
	[time] totClock=totClock_max & s1=state4: 1;
	[time] totClock=totClock_max & s2=state4: 1;
endrewards

// finish state
label "done" = s1=4 & s2=4;
