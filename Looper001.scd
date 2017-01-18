//Looper
s.boot;

~tdur = 16;
~ntrk = 12;
//BUFFER
~ntrk.do{|ix| s.sendMsg(\b_alloc, ix, s.sampleRate* ~tdur)};
//GROUPS
s.sendMsg(\g_new, 3000); //Index Group
s.sendMsg(\g_new, 3001, 3, 3000); //Record Group
s.sendMsg(\g_new, 3002, 3, 3001); //Play Group
//SYNTH DEFS
SynthDef(\phaseidx, {
	arg buf, obs, trig=1, start=0, end=1, resetpos=0;
	var phase = Phasor.ar(trig, BufRateScale.kr(buf), start, end*BufFrames.kr(buf), resetpos);
	Out.ar(obs, phase);
}).add;
SynthDef(\playloop, {
	arg buf, idxibs, obs=0, loop=1, tr=1, rate=1, st=0, end=1, resetPos=0;
	var sig, idxin;
	idxin = In.ar(idxibs);
	sig = BufRd.ar(1, buf, idxin, loop);
	Out.ar(obs, sig);
}).add;
SynthDef(\recloop, {
	arg buf, idxibs, obs=0, ibs=0, loop=1, tr=1, rate=1, st=0, end=1, resetPos=0;
	var sig, in, idx;
	idx = In.ar(idxibs);
	in = SoundIn.ar(ibs);
	sig = BufWr.ar(in, buf, idx, loop);
}).add;
//RECORD FUNCTION - RECORD SYNTHS ON NODES 4000
~recstart = { |tnum|
	//read start phase
	//array of start stop times
	s.sendMsg(\s_new, \recloop, 3001, 0, 7001, \buf, 10, \idxibs, 99);//recording synth

};

s.sendMsg(\s_new, \phaseidx, 3000, 0, 7000, \buf, 10, \obs, 99); //index
s.sendMsg(\s_new, \recloop, 3001, 0, 7001, \buf, 10, \idxibs, 99);//recording synth
s.sendMsg(\s_new, \playloop, 3002, 0, 7002, \buf, 10, \idxibs, 99); //playback

s.sendMsg(\n_free, 3001);
s.sendMsg(\n_free, 3002);
s.queryAllNodes
s.meter

//RECORD INTO MULTIPLE BUFFERS

Play