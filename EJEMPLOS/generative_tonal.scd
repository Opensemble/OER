(
	TempoClock.default.tempo = 1;

	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		\octave, 4,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..24)).asStream; // degrees
			var lenstr = Pseq([4,3],inf).asStream; // note length
			var buf = Array.fill(16,{List.new}); // record loop buffer
			var deg, len;

			len = lenstr.next;

			inf.do {

				var i = ev[\index];
				var n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1];
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace.play
)

(
// change the rules a bit

Pdef(\mol,
	Pbind(
		\index, Pseq((0..15),inf),
		\dur, 1/4,
		//\root, Pseq([2,0],inf),
		\mtranspose, Pseq([0,3,4,3],inf).stutter(8),
		\octave, 4,
		\scale, Scale.dorian,
		\do, Prout({ arg ev;
			var degstr = Pseq((0..13),inf).asStream;
			var lenstr = Pseq([3,8,2],inf).asStream;
			var buf = Array.fill(16,{List.new});
			var keep = 3; // max note per chord
			var deg, len;

			len = lenstr.next;

			inf.do {

				var i = ev[\index];
				var n;
				buf[i] = buf[i].keep(0-keep);
				n = buf[i];

				if(n.size != 0) {
					// previous note found, change note length
					len = lenstr.next;
				};

				deg = degstr.next;
				n.add([deg, len]);

				len.do {
					var i = ev[\index];
					var n = buf[i];

					if(n.size != 0) {
						ev[\degree] = n.flop[0];
						ev[\legato] = n.flop[1]/2;
						//ev[\legato] = 1;
					} {
						ev[\isRest] = true;
					};
					ev = deg.yield;
				};
			}
		}),
	).trace
).play;
)