//Looper
s.boot;
//Buffer
s.sendMsg(\b_allocRead, 0, "/Users/jyang/Downloads/audioEdit/Bounces/btfrttal.aif");

SynthDef(\playloop, {
	arg buf, obs=0, loop=1, tr=1, rate=1, st=0, end=1, resetPos=0;
	var sig, ph;
	ph = Phasor.ar(tr, BufRateScale.kr(buf), st, end*BufFrames.kr(buf), resetPos);
	sig = BufRd.ar(1, buf, ph, loop);
	Out.ar(obs, sig);
}).add;
SynthDef(\recloop, {
	arg buf, obs=0, ibs=0, loop=1, tr=1, rate=1, st=0, end=1, resetPos=0;
	var sig, ph, in;
	ph = Phasor.ar(tr, BufRateScale.kr(buf), st, end*BufFrames.kr(buf), resetPos);
	in = SoundIn.ar(ibs);
	sig = BufWr.ar([in, in], buf, ph, loop);
}).add;
//GROUPS
s.sendMsg(\g_new, 7000); //Record Group
s.sendMsg(\g_new, 7001, 3, 7000); //Play Group
s.sendMsg(\s_new, \playloop, 3001, 0, 7001, \buf, 0); //playback

s.sendMsg(\s_new, \recloop, 3002, 0, 7001, \buf, 0);//recording synth
s.sendMsg(\n_free, 3002);
s.queryAllNodes