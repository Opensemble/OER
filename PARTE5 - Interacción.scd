// PARTE 5
// INTERACCIÓN

// 43. MIDI
// Los ejemplos asumen alguna familiaridad con el protocolo y dispositivos MIDI
// See the Using MIDI helpfile for practical considerations and techniques for using MIDI in SC.
Using MIDI

// Una forma rápida de contectar con todos los dispositivos disponibles SC
MIDIIn.connectAll;

//NOTE: For general programming, users should not use the MIDIIn class directly. See the MIDIFunc and MIDIdef classes for higher level event matching and more flexible handling of event handlers.
//Certain MIDI messages are supported only through MIDIIn. These are: sysex, sysrt, smpte.

// Forma rápida de ver todos los mensajes MIDI entrantes
MIDIFunc.trace(true);
MIDIFunc.trace(false); // detenerlo

//MIDIFunc y su subclase MIDIdef regsitran una o más funciones para responder a un mensaje MIDI entrante.

// Todos los mensajes CC recibidos
MIDIdef.cc(\someCC, {arg a, b; [a, b].postln});

// Leer sólo desde cc 7, canal 0
MIDIdef.cc(\someSpecificControl, {arg a, b; [a, b].postln}, ccNum: 7, chan: 0);

// SynthDef para pruebas
SynthDef("quick", {arg freq, amp; Out.ar(0, SinOsc.ar(freq) * Env.perc(level: amp).kr(2))}).add;

// Controlarlo desde un dispositivo MIDI
(
MIDIdef.noteOn(\someKeyboard, { arg vel, note;
	Synth("quick", [\freq, note.midicps, \amp, vel.linlin(0, 127, 0, 1)]);
});
)

// Creamos un pattern y lo disparamos desde nuestro controlador MIDI
(
a = Pbind(
	\instrument, "quick",
	\degree, Pwhite(0, 10, 5),
	\amp, Pwhite(0.05, 0.2),
	\dur, 0.1
);
)

// test
a.play;

// Trigger pattern from pad or keyboard
MIDIdef.noteOn(\someKeyboard, {arg vel, note; a.play});
MIDIdef.noteOn(\someKeyboard, {nil});

// Cómo manejamos mensajes note on y note off para notas sostenidas? La etapa de release de la ADSR de una nota en particular se dispara cuando soltamos la tecla correspondiente del controlador. Para poder hacer esto SC necesita conocer qué sinte se corresponde con cada tecla. Podemos usar un Array para este propósito.

// Un SynthDef con una envolvente ADSR
(
SynthDef("quick2", {arg freq = 440, amp = 0.1, gate = 1;
	var snd, env;
	env = Env.adsr(0.01, 0.1, 0.3, 2, amp).kr(2, gate);
	snd = Saw.ar([freq, freq*1.5], env);
	Out.ar(0, snd)
}).add;
)

// Controlarlo con MIDI
(
var noteArray = Array.newClear(128); // una posición por nota MIDI posible

MIDIdef.noteOn(\myKeyDown, {arg vel, note;
	noteArray[note] = Synth("quick2", [\freq, note.midicps, \amp, vel.linlin(0, 127, 0, 1)]);
	["NOTE ON", note].postln;
});

MIDIdef.noteOff(\myKeyUp, {arg vel, note;
	noteArray[note].set(\gate, 0);
	["NOTE OFF", note].postln;
});
)

// Asegurar las conexiones MIDI (MIDIIn.connectAll)

// quick2 usa una envolvente ADSR y gate es responsable por abrir y cerrar la envolvente.
// noteArray almacena las notas en ejecución. Los índices se corresponden con notas midi
// Cada vez que se presiona una tecla del teclado, se crea un nodo en el server y una referencia en el array
// cuando la tecla se suelta, se envía un mensaje al sinte apropiado
s.plotTree

// Sólo vimos como como leer midi desde SC. Para enviar midi desde SC mirar la ayuda de la clase:
MIDIOut

// Unlike MIDIIn, with MIDIOut you create an instance of the MIDIOut class with a port and uid. You can have multiple MIDIOut objects to send MIDI to different physical devices. (Many users have reported timing issues with MIDIOut).

//Ejemplo con Pattern
MIDIClient.init;    // if not already done

(
// tu dispositivo
var mOut = MIDIOut.newByName("LoopBe Internal MIDI", "LoopBe Internal MIDI").latency_(Server.default.latency);

p = Pbind(
    \type, \midi,
    \midicmd, \noteOn,
    \midiout, mOut,    // target
    \chan, 0,
	// degree se convierte a midinote, no a freq
	\degree, Pwhite(-7, 12, inf),
    \dur, Pwrand([0.25, Pn(0.125, 2)], [0.8, 0.2], inf),
    \legato, sin(Ptime(inf) * 0.5).linexp(-1, 1, 1/3, 3),
    \amp, Pexprand(0.5, 1.0, inf)
).play(quant: 1);
)

p.stop;

// 44. OSC
// Open Sound Control es una buena forma de comunicar aplicaciones en una computadora o diferentes computadoras en una red.

// El ejemplo muestra cómo enviar mensajes OSC desde un dispositivo a la notebook.
// En la computadora que recibe, evaluar este código:

(
OSCdef(
	key: \whatever,
	func: {arg ...args; ("RECIBIDO:" ++ args).postln},
	path: '/stuff')
)

// Con [ctrl+.] interrumpimos el OSCdef y no recibimos más mensajes

// 44.1 Enviar OSC desde otra computadora
// Necesitamos la dirección IP de la máquina que recibe los mensajes y luego evaluamos este código en la máquina que envía:

~destination = NetAddr("127.0.0.1", 57120);
~destination.sendMsg("/stuff", "HOLA", 4, 0.56);

// 44.2 Enviar OSC desde un dispositivo
// Instalar una app OSC, configurar dirección IP y puerto de nuestra computadora receptora (normalmente 57120).

// Verificamos conectividad
OSCFunc.trace

// Verificar el path exacto que la app usa para mandar OSC y definir el OSCdef de acuerdo a esto
(
OSCdef(
	key: \clave1,
	func: {Synth(\quick, [\freq, 440, \amp, 0.3])},
	path: '/cc/33'
)
);

(
OSCdef(
	key: \clave2,
	func: {Synth(\quick, [\freq, 880, \amp, 0.3])},
	path: '/cc/34'
)
)



