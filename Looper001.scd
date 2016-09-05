//Looper
s.boot;

//Buffer
s.sendMsg(\b_alloc, 10, s.sampleRate*2);

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
//GROUPS
s.sendMsg(\g_new, 7000); //Index Group
s.sendMsg(\g_new, 7001, 3, 7000); //Record Group
s.sendMsg(\g_new, 7002, 3, 7001); //Play Group


s.sendMsg(\s_new, \phaseidx, 3000, 0, 7000, \buf, 10, \obs, 99); //index
s.sendMsg(\s_new, \recloop, 3001, 0, 7001, \buf, 10, \idxibs, 99);//recording synth
s.sendMsg(\s_new, \playloop, 3002, 0, 7002, \buf, 10, \idxibs, 99); //playback

s.sendMsg(\n_free, 3001);
s.sendMsg(\n_free, 3002);
s.queryAllNodes
s.meter

//RECORD INTO MULTIPLE BUFFERS

Play