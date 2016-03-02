//redFrik - redo_minimalish sketch
(
s.waitForBoot{

	SynthDef(\p, {|out= 0, freq= 400, amp= 0.1, gate= 1, detune= 0|
		var env= EnvGen.ar(Env.perc(Rand(0.001, 0.01), LinRand(0.2, 0.4), amp, Rand(-9, -1)), doneAction:2);
		var snd= Mix(SinOsc.ar(freq+[0, detune*0.1], env*2pi));
		Out.ar(out, Pan2.ar(snd*env, Rand(-1, 1)));
	}).add;
	Ndef(\p, Pspawn(Pbind(\method,\par,\delta,1/8,\pattern,{Pbind(\instrument, \p, \dur,a=Pseq((1..9).sputter),\sustain,1/8/a,\degree,a,\detune,a)})));
	Ndef(\p).play(vol:0.5);

	Ndef(\t, {
		var mod= Saw.ar([3, 4], Saw.ar(1, 32, 128), Duty.ar(1, 0, flop(Dseq([0, 8, 1, 5])*[1, 4, 8])));
		var snd= SinOsc.ar(Saw.ar(2, 64, 99), mod)/9;
		CombN.ar(snd, 1/4, 1/4.125, SinOsc.kr(0.005, 1.5pi).range(0, 6));
	});
	Ndef(\t).play(vol:0.5);

	Routine.run({
		var cnt= 1;
		loop{
			var syn;
			cnt= cnt%8+1;
			syn= {
				var del= DelayN.ar(InFeedback.ar(0, 2)+(InFeedback.ar(100, 2)), 1, 1);
				SinOsc.ar(cnt*99+[0, 2], del[1..0])/4;
			}.play(outbus: 64);
			{syn.release(16)}.defer(9-cnt);
			wait(9-cnt);
		};
	});
	Ndef(\c, {InFeedback.ar(64, 2)}).play(vol:0.5);

	Ndef(\r, {
		var lfos= LFNoise1.ar(0.5!2);
		var snd= Crackle.ar(lfos.range(1.8, 1.98));
		Formlet.ar(snd, TExpRand.ar(200, 2000, lfos).lag(2), lfos.range(5e-4, 1e-3), 0.0012);
	});
	Ndef(\r).play(vol:0.25);

	Routine.run({
		loop{
			var syn= {
				var snd= Pluck.ar(Crackle.ar([1.9, 1.8]), Mix(Impulse.ar({5.linrand+1}!2, -0.125)), 0.05, 0.05.linrand);
				BPF.ar(snd, 2000.rand+100, 0.25.rrand(1.75));
			}.play(s, 62, 18);
			{syn.release(69)}.defer(18);
			wait(18);
		};
	});
	Ndef(\m, {InFeedback.ar(62, 2)*SinOsc.kr(0.006).range(0.25, 1)}).play(vol:0.5);

	NdefMixer(s);
	s.meter;
};
)