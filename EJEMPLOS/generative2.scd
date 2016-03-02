(
var n = 20, baseFreq = 45.midicps;
var lsin, rsin, arg1, arg2, sig;
var bus, busIndex, scale, freq, freqIndex, amp;
var responder;

scale = Scale.nikriz.ratios * baseFreq;

bus = Bus.control( s, 2 * n  );
bus.setn( { 1.0.rand2 } ! ( 2 * n ) );
busIndex = bus.index;

freq = Bus.control( s, n );
freqIndex = freq.index;

responder = OSCFunc({ | id |
	freq.setAt( id[2] , scale.choose * 1.rrand( 3 ) );
},'/tr', s.addr);

CmdPeriod.doOnce { [ bus, freq, responder ].free; };

n.do {|i|
	freq.setn( { scale.choose  * rrand( 1, 3) } ! n );
	{
		#arg1, arg2 = In.kr( 2 * i +  busIndex, 2 );

		#lsin, rsin = SinOsc.kr( [ arg1, arg2 ], { 2.0.rrand(20.0) } ! 2  * [ arg2, arg1 ] );

		sig = Formant.ar(
			LFNoise0.kr( 0.05, 2.5, 7) * arg1,
			arg2,
			500.0.rrand(700)
		);

		ReplaceOut.kr( 2 * i  + busIndex, [ rsin, lsin ] );

		sig = Pluck.ar(
			BrownNoise.ar(0.5),
			sig,
			0.025,
			freq.kr( 1, i ).reciprocal,
			3.7
		) * 0.6;

		amp = Line.kr( dur: rrand( 1.0, 20.0) ) * max( 0, LFNoise1.kr( 0.05, 0.6, 0.4 ) ) ;
		sig =  sig * amp;
		SendTrig.kr( amp <= 0, i, i );

		Pan2.ar( sig, 0.8.rand2 )
	}.play
}
)
