//PARTE II
//PATTERNS

/*
Por qué usar Patterns?

Los pattens describen cálculos sin mostrar explícitamente cada paso realizado. Son una representación de alto nivel de una tarea computacional. Describen qué queremos hacer, en lugar de cómo lograrlo.
Son ideales para tareas que necesitan producir secuencias o streams (flujos) de información. Frecuentemente estos streams son de números, pero los patterns pueden generar cualquier tipo de objetos */

//13. La familia Pattern

Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play

//13.1 Introduciendo a Pbind

Pbind(\degree, 0).play;

// Toca Do central una vez por segundo.
// usando \degree:
// C, D, E, F, G...  se representan con námeros: 0, 1, 2, 3, 4...
// Se asume la escala de C mayor y se comienza desde 0 (do central).

// Cambiar el numero y evaluar.
// Se pueden elegir notas por debajo usando números negativos, por ej -2 nos da un La 3

//Ahora cambiamos la duración de las notas, usando el símbolo \dur

Pbind(\degree, 0, \dur, 0.5).play

//(Pronto las cosas se pondrán divertidas)

//13.2 Pseq

Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1), \dur, 0.2).play

//Pseq representa una secuencia. Recibe una lista y una cantidad de repeticiones.

a = Pseq([0,2,3,4,5],2).asStream;
a.next

//En lugar de proveer un único número fijo para el grado de la escala (como en el primer ejemplo), estamos usando un Pseq, una receta para una secuencia de números. Podemos extenderlo a duraciones:

Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 5), \dur, Pseq([0.2, 0.1, 0.1, 0.2, 0.2, 0.35], inf)).play;

// Repetimos el Pseq con alturas 5 veces. Reemplazamos la duración fija por otro Pseq que tiene 6 valores y una repetición infinita.

// Pbind detiene su ejecución luego de que el Pseq más corto haya terminado su trabajo
// Cuando proveemos secuencias de diferentes tamaños, Pbind las recicla como sea necesario.

//13.3 Es importante hacer el código mas legible
// Indentamos el Pbind. Incorporemos este hábito.
// Ahora tenemos que encerrarlo en un bloque de código porque ya no es una única línea

(
Pbind (
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 5),
	\dur, Pseq([0.2, 0.1, 0.1, 0.2, 0.2, 0.35], inf)
).play
)

// Preguntas:
//     . cambiar a 1 las repeticiones del segundo Pseq, qué sucede?
//     . cómo podemos hacer que este Pbind toque infinitamente?

//13.4 Cuatro formas de especificar altura

//figura : fig-piano-keyboard-degree-note-midinote-freq.png

// * Si prefiere usar alturas cromáticas, puede usar \note
//    el 0 es el DO central, pero los pasos son semitonos

// * Si prefiere usar numeración MIDI, utilizar el símbolo \midinote
//    (60 = DO central, 61 = C#, etc)

// * Si prefiere especificar frecuencias, directamente en Herz, use \freq

Pbind(\degree, 5).play;
Pbind(\note, 9).play;
Pbind(\midinote, 69).play;
Pbind(\freq, 440).play;

// Tener en cuenta los valores que usamos, según la forma de especificar altura.
// Valores max y min en la figura: valores_de_altura.

// Estos son eventos
().play;
(degree: 7).play;

// Podemos mirar la clase Event
Event

// Pbind es un pattern que genera un "stream de events".

//13.5 Más palabras claves: amplitud y legato
// dos nuevos símbolos: \amp y \legato

(
Pbind(
	\degree, Pseq([0, -1, 2, -3, 4, -3, 7, 11, 4, 2, 0, -3], 5),
	\dur, Pseq([0.2, 0.1, 0.1], inf),
	\amp, Pseq([0.7, 0.5, 0.3, 0.2], inf),
	\legato, 0.4
).play()
)

// Tomar este último Pbind como punto de partida para experimentar.
//Las amplitudes estan normalizadas, entre 0 y 1
//Legato funciona mejor entre 0.1 y 1

//Las duraciones estan en beats.
//El default es 1 beat por segundo (60 BPM)
//Pbind().play(TempoClock(120/60)) para cambiar el tempo
//Mirar: Clock, TempoClock, SystemClock y AppClock

// Recordar que podemos usar valores fijos, no es necesario usar expresiones como Pseq([0.2, 0.2, 0.2, ...], 100); ni siquiera Pseq([0.2], inf), simplemente 0.2.

//13.6 Prand
//En lugar de tocar la lista en secuencia, Prand toma un item al azar de la lista, cada vez.

(
Pbind(
	\degree, Prand([2, 3, 4, 5, 6], inf),
	\dur, 0.15,
	\amp, 0.2,
	\legato, 0.3
).play
)

// ahora probemos Prand en duraciones, amplitudes y legato

//13.7 Pwhite
// Un generador de números aleatorios con distribución uniforme (white noise).
// Por ejemplo: Pwhite(100, 500) nos da números aleatorios en ese rango

(
Pbind(
	\freq, Pwhite(100, 500),
	\dur, Prand([0.15, 0.25, 0.3], inf),
	\amp, 0.23,
	\legato, Pwhite(0.1, 2)
).trace.play;
)

// Para generar floats con Pwhite: Pwhite(100, 500.0)
// Por ejemplo las amplitudes van de 0.0 hasta 1.0

// El mensaje trace imprime en la Post window los valores de cada evento. Útil para debug o entender lo que sucede.

// Repasamos la diferencia entre Prand y Pwhite

//Ejemplos y preguntas
// Escribimos una escala menor con \note
// [0, 2, 3, 5, 7, 8, 11, 12]
// C, D, Eb, F, G, Ab, B, C

// Cuántos eventos toca cada ejemplo?

// Pseq
(
Pbind(
\note, Pseq([0, 2, 3, 5, 7, 8, 11, 12], 4),
\dur, 0.15;
).play;
)

// Prand
(
Pbind(
\note, Prand([0, 2, 3, 5, 7, 8, 11, 12], 4),
\dur, 0.15;
).play;
)

// Pwhite
(
Pbind(
\note, Pseq([0, 2, 3, 5, 7, 8, 11, 12], 4),
\dur, Pwhite(0.15, 0.5);
).play;
)

//13.8 Expandiendo nuestro vocabulario de Patterns

//Ya sabemos especificar valores de alturas, duraciones, amplitudes y legato, y sabemos embeber otros patterns (Pseq, Prand, Pwhite) para generar cambios de parámetros interesantes.

//Los siguientes ejemplos introducen seis miembros más de la familia Pattern. Trataremos de entender cómo funcionan siguiendo estas estrategias:

// - analizar y describir la melodía que escuchamos
// - observar el nombre del pattern. Por ejemplo Pshuf
// - mirar los argumentos del pattern
// - usar .trace.play para ver los valores en los eventos
// - confirmar lo que suponemos con los archivos de ayuda usando [ctrl+D] sobre el nombre del pattern

// Pser
(
Pbind(
	\note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
	\dur, 0.35;
).play;
)

// Pxrand
(
p = Pbind(
    \note, Pxrand([0, 2, 3, 5, 7, 8, 11, 12], inf),
	\dur, 0.35;
).play;
)

// Pshuf
(
p = Pbind(
    \note, Pshuf([0, 2, 3, 5, 7, 8, 11, 12], 6),
	\dur, 0.30;
).play;
)

// Pslide
// 4 argumentos: list, repeats, length, step
(
Pbind(
	\note, Pslide([0, 2, 3, 5, 7, 8, 11, 12], 7, 3, 1),
	\dur, 0.35;
).play;
)

// Pseries
// 3 argumentos: start, step, length
(
Pbind(
    \note, Pseries(0, 2, 15),
	\dur, 0.25;
).play;
)

// Pgeom
// 3 argumentos: start, grow, length
(
Pbind(
	\note, Pseq([0, 2, 3, 5, 7, 8, 11, 12], inf),
	\dur, Pgeom(0.1, 1.1, 25);
).play;
)

// Pn
(
Pbind(
	\note, Pseq([0, Pn(2, 3), 3, Pn(5, 3), 7, Pn(8, 3), 11, 12], 3),
	\dur, 0.25;
).play;
)

// Practique con estos patterns. Pbind es como un score, con la ventaja de que no estamos limitados a escribir secuencias fijas de notas y duraciones: podemos describir procesos musicales dinamicos y parametrizables. Esto es una sencilla intro a la composicion algoritmica.

// La documentacion completa de patters llamada "A Practical Guide to Patterns" está disponible online:
Pattern Guide

// 14. Más trucos con patterns

// 14.1 Acordes
// Se escriben como listas de valores (Array) de altura
Array

(
Pbind(
	\note, Pseq([[0, 3, 7], [2, 5, 8], [3, 7, 10], [5, 8, 12]], 3),
	\dur, 0.30
).play;
)

// Técnica de Strum ("rasguear" el acorde)
(
Pbind(
	\note, Pseq([[-7, 3, 7, 10], [0, 3, 5, 8]], 2),
	\dur, 1,
	\legato, 0.4,
	\strum, 0.1 // probar 0, 0.1, 0.2, etc
).play;
)

// 14.2 Escalas
// Al usar \degree, podemos agregar otra linea con el símbolo \scale

(
Pbind(
	\scale, Scale.superLocrian,    //escala alterada o 7mo modo de melódica
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 1),
	\dur, 0.35;
).play;
)

// Evaluar este método para ver una lista de todas las escalas posibles
Scale.directory;

// Si necesitamos un grado cromático entre dos grados diatónicos, hacemos esto:
(
Pbind(
	\degree, Pseq([0, 1, 2, 3, 3.1, 4, 3.2], 1), //3.2 y 4 = enarmonía
).play;
)

// El 3.1 de degree significa un paso cromatico sobre el grado de la escala. En este caso F# sobre F.
// Como no especificamos una \scale, se asume Scale.major

// 14.3 Transposición
// Para transponer cromaticamente, usar el símbolo \ctranspose
// Funciona con \degree, \note y \midinote.

(
Pbind(
	\note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
	\ctranspose, 12, // una octava arriba (12 semitonos)
	\dur, 0.25;
).play;
)
// Note el uso de Pser

// 14.4 Microtonos
// Con \note y \midinote:

Pbind(\note, Pseq([0, 0.5, 1, 1.5, 1.75, 2], 1)).play;

Pbind(\midinote, Pseq([60, 69, 68.5, 60.25, 70], 1)).play;

// 14.5 Tempo
//  Los valores que le damos a la clave \dur están en número de beats, es decir: 1 = un beat, 0.5 = medio beat, etc
// Si no especificamos nada distinto, el tempo default es 60 BPM

// Vamos a crear un nuevo TempoClock para indicar un tempo distinto

(
Pbind(
	\degree, Pseq([0, 0.1, 1, 2, 3, 4, 5, 6, 7]),
	\dur, 1;
).play(TempoClock(120/60)); // 120 BPM dividido 60 es igual a 2 BPS
)

// De paso, note que no hay argumento de repeat en el ejemplo anterior. Por defecto el pattern toca la secuencia una vez
// Esto es una propiedad común en objetos de SC, si omitimos un argumento se usará un valor por defecto, como en nuestro primer ejemplo en el cual no especificamos valores de amplitud, duracion o legato. Incluso:

Pbind().play

// 14.6 Silencios

// El número dentro de Rest es la duración del silencio en beats. Los silencios pueden ir en cualquier parte en el Pbind, no sólo en la linea de \dur (pero la duración del evento-silencio seguirá estando definida por dur)

(
Pbind(
	\degree, Pwhite(0, 10),
	\dur, Pseq([0.1, 0.1, 0.3, 0.6, Rest(0.3), 0.25], inf);
).play;
)

Pbind(\note, Pseq([1, 2, 3, 4, 5, 6, 7], inf), \dur, Pseq([1, 1, Rest(2)], inf)).trace.play


// 14.7 Ejecutar dos o más Pbinds en simultáneo

// Los encerramos en un bloque de código

( // abre bloque
Pbind(
	\freq, Pn(Pseries(110, 111, 10)),
	\dur, 1/2,
	\legato, Pwhite(0.1, 1)
).play;

Pbind(
	\freq, Pn(Pseries(220, 222, 10)),
	\dur, 1/4,
	\legato, Pwhite(0.1, 1)
).play;

Pbind(
	\freq, Pn(Pseries(330, 333, 10)),
	\dur, 1/6,
	\legato, 0.1
).play;
) // cierra bloque

// Podemos usar Fork para "planificar" el lanzamiento de eventos
// Ejemplo básico de fork:
(
{
	"una cosa".postln;
	2.wait;
	"otra cosa".postln;
	1.5.wait;
	"finalmente...".postln;
}.fork;
)

// Un ejemplo con Pbinds:
(
t = TempoClock(76/60);
{
	Pbind(
		\note, Pseq([[4, 11], [6, 9]], 32),
		\dur, 1/6,
		\amp, Pseq([0.05, 0.03], inf)
	).play(t);

	2.wait;

	Pbind(
		\note, Pseq([[-25, -13, -1], [-20, -8, 4], \rest], 3),
		\dur, Pseq([1, 1, Rest(1)], inf),
		\amp, 0.1,
		\legato, Pseq([0.4, 0.7, \rest], inf)
	).play(t);

	2.75.wait;

	Pbind(
		\note, Pseq([23, 21, 25, 23, 21, 20, 18, 16, 20, 21, 23, 21], inf),
		\dur, Pseq([0.25, 0.75, 0.25, 1.75, 0.125, 0.125, 0.80, 0.20, 0.125, 0.125, 1], 1),
		\amp, 0.1,
		\legato, 0.5
	).play(t);
}.fork(t);
)

// Para ver métodos avanzados para ejecutar Pbinds simultaneos y en secuencia, estudiar Ppar y Pspawner. Para más información sobre fork, revisar la ayuda de Routine
Ppar
Pspawner
Routine

// 14.8 Usando variables
// Es recomendable almacenar las listas de valores en variables. Podemos reutilizarlas y hacer más legible nuestro código

// Vamos a usar c varias veces:
c = [0, 2, 3, 5, 7, 8, 11, 12];

// Usamos nuestra variable:
Pbind(\note, Pseq(c, 1), \dur, 0.15).play;
Pbind(\note, Prand(c, 6), \dur, 0.15).play;
Pbind(\note, Pslide(c, 5, 3, 1), \dur, 0.15).play;

// Otro ejemplo: una escala mayor ascendente y una descendete transpuesta
(
~scale = [0, 1, 2, 3, 4, 5, 6, 7];
~durs = [0.4, 0.2, 0.2, 0.4, 0.8, 0.2, 0.2, 0.4];

Pbind(
	\degree, Pseq(~scale),
	\dur, Pseq(~durs)
).play;

Pbind(
	\degree, Pseq(~scale.reverse + 7),
	\dur, Pseq(~durs)
).play;
)

// Ejercicio: agregar un Pbind más que toque la escala de otra manera. Usar las variables con otro pattern o multiplicar duraciones, etc.
//------------------------------------------------------------------

// 15. Comenzar y detener Pbinds independientes
// Una pregunta común, especialmente cuando el Pbind corre infinitamente con inf. Cómo puedo detener y comenzar Pbinds individuales?

// 15.1 Pbind como un score
// Pbind es una receta para producir sonidos. Un conjunto de instrucciones para realizar un pasaje musical. Necesitamos un ejecutante que lo interprete. Separemos estos componentes

// Definimos el score
(
p = Pbind(
	\midinote, Pseq([57, 62, 64, 65, 67, 69], inf),
	\dur, 1/7
); // Notar que no llamamos a .play
)

// Ahora pedimos que nuestro score sea ejecutado
p.play;


//15.2 EventStreamPlayer
// Al evaluar p.play, vemos en la post window un "EventStreamPlayer"

// Cada vez que llamamos .play en un Pbind, Supercollider crea un ejecutante que realiza esa acción. Un EventStreamPlayer es un pianista que se materializa frente a nosotros cada vez que lo invocamos con .play

// Sin embargo, hemos creado un "objeto anónimo". No podemos comunicarnos. Por este motivo no funciona p.stop

// El score no sabe comenzar o detenerse, es sólo una receta
// El ejecutante es el que sabe hacerlo, tenemos que hablar con el EventStreamPlayer. Le damos un nombre:

// Ejecutar una por una:
~myPlayer = p.play;
~myPlayer.stop;
~myPlayer.resume;
~myPlayer.stop.reset;
~myPlayer.start;
~myPlayer.stop;

// De esta forma podemos accceder al ejecutante para disparar o detener patterns individualmente

//15.3 Ejemplo

// Un ejemplo más elaborado. La melodia superior fue tomada del Album for the Youth de Tchaikovsky. La voz inferior fue agregada por el autor del tutorial (Rubiaro). Hay una partitura en la página 40

// Define el score
(
var myDurs = Pseq([Pn(1, 5), 3, Pn(1, 5), 3, Pn(1, 6), 1/2, 1/2, 1, 1, 3, 1, 3], inf) * 0.4;

~upperMelody = Pbind(
	\midinote, Pseq([69, 74, 76, 77, 79, 81, Pseq([81, 79, 81, 82, 79, 81], 2), 82, 81, 79, 77, 76, 74, 74], inf),
	\dur, myDurs
);

~lowerMelody = Pbind(
	\midinote, Pseq([57, 62, 61, 60, 59, 58, 57, 55, 53, 52, 50, 49, 50, 52, 50, 55, 53, 52, 53, 55, 57, 58, 61, 62, 62], inf),
	\dur, myDurs
);
)

// Tocar los dos en simultáneo:
(
~player1 = ~upperMelody.play;
~player2 = ~lowerMelody.play;
)
// Detenerlos por separado:
~player1.stop;
~player2.stop;

// Otros mensajes posibles
~player1.resume;
~player1.reset;
~player1.play;
~player1.start; // igual que .play


//primero: observemos el uso de variables. myDurs, es una variable local, solo necesaria al momento de definir el score

// segundo: notemos la separacion entre partituras y ejecutantes. Almacenamos partituras en ~upperMelody y ~lowerMelody. ~player1 y ~player2 almacenan los objetos EventStreamPlayer.

//EJEMPLO BAJO
(
SynthDef(\bass, { |freq = 440, gate = 1, amp = 0.5, slideTime = 0.17, ffreq = 1100, width = 0.15,
        detune = 1.005, preamp = 4|
    var    sig,
        env = Env.adsr(0.01, 0.3, 0.4, 0.1);
    freq = Lag.kr(freq, slideTime);
    sig = Mix(VarSaw.ar([freq, freq * detune], 0, width, preamp)).distort * amp
        * EnvGen.kr(env, gate, doneAction: 2);
    sig = LPF.ar(sig, ffreq);
    Out.ar(0, sig ! 2)
}).add;
)

//test:
//Synth(\bass, [\freq, 100]).play;

(
TempoClock.default.tempo = 70/60;
p = Pxrand([
    Pbind(            // repeated notes
        \instrument, \bass,
        \midinote, 36,
        \dur, Pseq([0.75, 0.25, 0.25, 0.25, 0.5], 1),
        \legato, Pseq([0.9, 0.3, 0.3, 0.3, 0.3], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // octave jump
        \midinote, Pseq([36, 48, 36], 1),
        \dur, Pseq([0.25, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // tritone jump
        \midinote, Pseq([36, 42, 41, 33], 1),
        \dur, Pseq([0.25, 0.25, 0.25, 0.75], 1),
        \amp, 0.5, \detune, 1.005
    ),
    Pmono(\bass,        // diminished triad
        \midinote, Pseq([36, 39, 36, 42], 1),
        \dur, Pseq([0.25, 0.5, 0.25, 0.5], 1),
        \amp, 0.5, \detune, 1.005
    )
], inf).play(quant: 1);
)

p.stop;

//EJEMPLO 2 -- GUI -- MIDI   ------------------------------------------------------------------------

(
var    pattern = Pbind(
        \degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
            + Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
        \dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
    ),
    player, window;

window = Window.new("Pattern trigger", Rect(5, 100, 150, 100))
        // onClose is fairly important
        // without it, closing the window could leave the pattern playing
    .onClose_({ player.stop });
Button.new(window, Rect(5, 5, 140, 90))
    .states_([["Pattern GO"], ["Pattern STOP"]])
    .font_(Font.new("Helvetica", 18))
    .action_({ |button|
        if(button.value == 1 and: { player.isNil or: { player.isPlaying.not } }) {
            player = pattern.play;
        } {
            player.stop;
            button.value = 0;
        };
    });
window.front;
)

p.stop;

// EJEMPLO 3 -- DISPARA PATTERN POR AMPLITUD MIC   ------------------------------------------------------------------------
(
var    pattern = Pbind(
        \degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1, 1], inf), inf).fold(0, 14)
            + Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
        \dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
    ),
    player;

// Quicky GUI to tune threshold and decay times
~w = Window("threshold setting", Rect(15, 100, 300, 100))
    .onClose_({
        ~ampSynth.free;
        ~ampUpdater.free;
        ~oscTrigResp.free;
        player.stop;
    });
~w.view.decorator = FlowLayout(~w.view.bounds, 2@2, 2@2);
~ampView = EZSlider(~w, 295@20, "amplitude", \amp, labelWidth: 80, numberWidth: 60);
~ampView.sliderView.canFocus_(false).enabled_(false);
~ampView.numberView.canFocus_(false).enabled_(false);
StaticText(~w, 295@5).background_(Color.gray);
~threshView = EZSlider(~w, 295@30, "threshold", \amp, action: { |ez|
    ~ampSynth.set(\thresh, ez.value);
}, initVal: 0.5, labelWidth: 80, numberWidth: 60);
~decayView = EZSlider(~w, 295@30, "decay", #[0.1, 100, \exp], action: { |ez|
    ~ampSynth.set(\decay, ez.value);
}, initVal: 80.0, labelWidth: 80, numberWidth: 60);

~w.front;

~ampSynth = SynthDef(\ampSynth, { |inbus, thresh = 0.8, decay = 1|
    var    amp = Amplitude.kr(In.ar(inbus, 1), attackTime: 0.01, releaseTime: decay);
        // this trigger (id==0) is to update the gui only
    SendReply.kr(Impulse.kr(10), '/amp', amp);
        // this trigger gets sent only when amplitude crosses threshold
    SendReply.kr(amp >= thresh, '/amptrig');
}).play(args: [inbus: s.options.numOutputBusChannels, thresh: ~threshView.value, decay: ~decayView.value]);

~ampUpdater = OSCFunc({ |msg|
    defer { ~ampView.value = msg[3] }
}, '/amp', s.addr);

~oscTrigResp = OSCFunc({ |msg|
    if(player.isNil or: { player.isPlaying.not }) {
        player = pattern.play;
    } {
        player.stop;
    };
}, '/amptrig', s.addr);
)


//EJEMPLO SOLO RANDOM - RED DE FRASES    ------------------------------------------------------------------------

(
// this SynthDef has a strong attack, emphasizing the articulation
SynthDef(\sawpulse, { |out, freq = 440, gate = 0.5, plfofreq = 6, mw = 0, ffreq = 2000, rq = 0.3, freqlag = 0.05, amp = 1|
    var sig, plfo, fcurve;
    plfo = SinOsc.kr(plfofreq, mul:mw, add:1);
    freq = Lag.kr(freq, freqlag) * plfo;
    fcurve = EnvGen.kr(Env.adsr(0, 0.3, 0.1, 20), gate);
    fcurve = (fcurve - 1).madd(0.7, 1) * ffreq;
    sig = Mix.ar([Pulse.ar(freq, 0.9), Saw.ar(freq*1.007)]);
    sig = RLPF.ar(sig, fcurve, rq)
        * EnvGen.kr(Env.adsr(0.04, 0.2, 0.6, 0.1), gate, doneAction:2)
        * amp;
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 128/60;

// Pmul does only one thing here: take ~amp from each event
// and replace it with ~amp * 0.4
p = Pmul(\amp, 0.4, Pfsm([
    #[0, 3, 1],        // starting places
    PmonoArtic(\sawpulse,
        \midinote, Pseq([78, 81, 78, 76, 78, 76, 72, 71, 69, 66], 1),
        \dur, Pseq(#[0.25, 1.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25], 1),
        \sustain, Pseq(#[0.3, 1.2, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2],1 ),
        \amp, Pseq(#[1, 0.5, 0.75, 0.5, 0.75, 0.5, 0.75, 0.5, 0.75, 0.5], 1),
        \mw, Pseq([0, 0.03, Pseq(#[0], inf)], 1)
    ), #[1, 2, 3, 4, 7],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([64, 66, 69, 71, 72, 73], 1),
        \dur, Pseq(#[0.25], 6),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.2, 0.3, 0.2], 1),
        \amp, Pseq(#[1, 0.5, 0.5, 0.5, 0.5, 0.5], 1),
        \mw, 0
    ), #[1, 1, 1, 1, 2, 2, 3, 3, 4, 4, 5],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([69, 71, 69, 66, 64, 69, 71, 69], 1),
        \dur, Pseq(#[0.125, 0.625, 0.25, 0.25, 0.25, 0.25, 0.25, 0.75], 1),
        \sustain, Pseq(#[0.2, 0.64, 0.2, 0.2, 0.2, 0.3, 0.3, 0.75], 1),
        \amp, Pseq(#[0.5, 0.75, 0.5, 0.5, 0.5, 1, 0.5, 0.5], 1),
        \mw, 0
    ), #[0, 1, 1, 1, 1, 3, 3, 3, 3, 5],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([72, 73, 76, 72, 71, 69, 66, 71, 69], 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.083, 0.083, 0.084, 0.25, 0.25, 0.25], 1),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.1, 0.07, 0.07, 0.2, 0.3, 0.2], 1),
        \amp, Pseq(#[1, 0.5, 0.5, 1, 0.3, 0.3, 0.75, 0.75, 0.5], 1),
        \mw, 0
    ), #[1, 1, 1, 1, 3, 3, 4, 4, 4],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([64, 66, 69, 71, 72, 73, 71, 69, 66, 71, 69, 66, 64, 69], 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.25, 0.125, 0.375, 0.166, 0.166, 0.168,
                0.5, 0.166, 0.166, 0.168, 0.5], 1),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.2, 0.14, 0.4, 0.2, 0.2, 0.2, 0.6, 0.2, 0.2, 0.2, 0.5],1),
        \amp, Pseq(#[0.5, 0.5, 0.6, 0.8, 1, 0.5, 0.5, 0.5, 0.5, 1,
            0.5, 0.5, 0.5, 0.45], 1),
        \mw, 0
    ), #[0, 1, 1, 1, 1, 3, 3, 5],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([72, 73, 76, 78, 81, 78, 83, 81, 84, 85], 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.25, 0.5, 0.5, 0.5, 0.5, 0.125, 1.125], 1),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.2, 0.95, 0.25, 0.95, 0.25, 0.2, 1.13], 1),
        \amp, Pseq(#[0.7, 0.5, 0.5, 0.5, 0.7, 0.5, 0.8, 0.5, 1, 0.5], 1),
        \mw, Pseq([Pseq(#[0], 9), 0.03], 1)
    ), #[6, 6, 6, 8, 9, 10, 10, 10, 10, 11, 11, 13, 13],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([83, 81, 78, 83, 81, 78, 76, 72, 73, 78, 72, 72, 71], 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25, 0.25,
                0.25, 2], 1),
        \sustain, Pseq(#[0.3, 0.3, 0.2, 0.3, 0.3, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2, 0.3, 2], 1),
        \amp, Pseq(#[0.5, 0.5, 0.5, 0.8, 0.5, 0.5, 0.5, 0.8, 0.5, 0.8, 0.5,
                1, 0.4], 1),
        \mw, Pseq([Pseq([0], 12), 0.03], 1)
    ), #[0, 7, 7, 7, 7, 7, 3, 3, 3, 3],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([69, 71, 72, 71, 69, 66, 64, 69, 71], 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.25, 0.166, 0.167, 0.167, 0.25, 0.25], 1),
        \sustain, Pseq(#[0.2, 0.2, 0.3, 0.2, 0.2, 0.2, 0.14, 0.3, 0.2], 1),
        \amp, Pseq(#[0.5, 0.5, 0.8, 0.5, 0.5, 0.5, 0.5, 0.8, 0.5], 1)
    ), #[3, 3, 3, 4, 4, 5],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([84, 85, 84, 84, 88, 84, 83, 81, 83, 81, 78, 76, 81, 83], 1),
        \dur, Pseq(#[0.125, 0.535, 0.67, 1.92, 0.25, 0.166, 0.167, 0.167,
                0.25, 0.25, 0.25, 0.25, 0.25, 0.25], 1),
        \sustain, Pseq(#[0.2, 3.12, 0.2, 0.2, 0.2, 0.2, 0.2, 0.15, 0.3, 0.2, 0.2, 0.2,
                0.3, 0.2], 1),
        \amp, Pseq(#[1, 0.8, 0.8, 0.8, 1, 1, 0.8, 0.8, 1, 0.8, 0.8, 0.8,
                1, 0.8], 1),
        \mw, Pseq([0, 0.005, 0.005, 0.06, Pseq(#[0], 10)], 1)
    ), #[10, 10, 10, 11, 11, 11, 11, 12, 12, 12],

        // same as #4, 8va
    PmonoArtic(\sawpulse,
        \midinote, Pseq(([64, 66, 69, 71, 72, 73, 71, 69, 66, 71, 69, 66, 64, 69]+12), 1),
        \dur, Pseq(#[0.25, 0.25, 0.25, 0.25, 0.125, 0.375, 0.166, 0.166, 0.168,
                0.5, 0.166, 0.166, 0.168, 0.5], 1),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.2, 0.14, 0.4, 0.2, 0.2, 0.2, 0.6, 0.2, 0.2, 0.2, 0.5],1),
        \amp, Pseq(#[0.5, 0.5, 0.6, 0.8, 1, 0.5, 0.5, 0.5, 0.5, 1,
            0.5, 0.5, 0.5, 0.45], 1),
        \mw, 0
    ), #[11, 11, 11, 11, 11, 12, 12],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([81, 84, 83, 81, 78, 76, 81, 83], 1),
        \dur, Pseq(#[0.25], 8),
        \sustain, Pseq(#[0.2, 0.3, 0.3, 0.2, 0.3, 0.2, 0.3, 0.2], 1),
        \amp, Pseq(#[0.5, 1, 0.5, 0.5, 0.6, 0.5, 0.8, 0.5], 1),
        \mw, 0
    ), #[0, 9, 9, 11, 11, 12, 12, 12, 12, 12],

        // same as #1, 8va
    PmonoArtic(\sawpulse,
        \midinote, Pseq(([64, 66, 69, 71, 72, 73]+12), 1),
        \dur, Pseq(#[0.25], 6),
        \sustain, Pseq(#[0.3, 0.2, 0.2, 0.2, 0.3, 0.2], 1),
        \amp, Pseq(#[1, 0.5, 0.5, 0.5, 0.5, 0.5], 1),
        \mw, 0
    ), #[6, 6, 8, 9, 9, 9, 9, 10, 10, 10, 10, 13, 13, 13],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([78, 81, 83, 78, 83, 84, 78, 84, 85], 1),
        \dur, Pseq(#[0.25, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 0.25, 1.75], 1),
        \sustain, Pseq(#[0.2, 0.3, 0.2, 0.2, 0.3, 0.2, 0.2, 0.3, 1.75], 1),
        \amp, Pseq(#[0.4, 0.8, 0.5, 0.4, 0.8, 0.5, 0.4, 1, 0.8], 1),
        \mw, Pseq([Pseq([0], 8), 0.03], 1)
    ), #[8, 13, 13],

    PmonoArtic(\sawpulse,
        \midinote, Pseq([88, 84, 83, 81, 83, 81, 78, 76, 81, 83], 1),
        \dur, Pseq(#[0.25, 0.166, 0.167, 0.167,
                0.25, 0.25, 0.25, 0.25, 0.25, 0.25], 1),
        \sustain, Pseq(#[0.2, 0.2, 0.2, 0.15, 0.3, 0.2, 0.2, 0.2,
                0.3, 0.2], 1),
        \amp, Pseq(#[1, 1, 0.8, 0.8, 1, 0.8, 0.8, 0.8,
                1, 0.8], 1),
        \mw, 0
    ), #[10]
], inf)).play;
)

p.stop;



// EJEMPLO RITMO BATERÍA ELECTRÓNICA              ------------------------------------------------------------------------

(
// this kick drum doesn't sound so good on cheap speakers
// but if your monitors have decent bass, it's electro-licious
SynthDef(\kik, { |basefreq = 50, ratio = 7, sweeptime = 0.05, preamp = 1, amp = 1,
        decay1 = 0.3, decay1L = 0.8, decay2 = 0.15, out|
    var    fcurve = EnvGen.kr(Env([basefreq * ratio, basefreq], [sweeptime], \exp)),
        env = EnvGen.kr(Env([1, decay1L, 0], [decay1, decay2], -4), doneAction: 2),
        sig = SinOsc.ar(fcurve, 0.5pi, preamp).distort * env * amp;
    Out.ar(out, sig ! 2)
}).add;

SynthDef(\kraftySnr, { |amp = 1, freq = 2000, rq = 3, decay = 0.3, pan, out|
    var    sig = PinkNoise.ar(amp),
        env = EnvGen.kr(Env.perc(0.01, decay), doneAction: 2);
    sig = BPF.ar(sig, freq, rq, env);
    Out.ar(out, Pan2.ar(sig, pan))
}).add;

~commonFuncs = (
        // save starting time, to recognize the last bar of a 4-bar cycle
    init: {
        if(~startTime.isNil) { ~startTime = thisThread.clock.beats };
    },
        // convert the rhythm arrays into patterns
    pbindPairs: { |keys|
        var    pairs = Array(keys.size * 2);
        keys.do({ |key|
            if(key.envirGet.notNil) { pairs.add(key).add(Pseq(key.envirGet, 1)) };
        });
        pairs
    },
        // identify rests in the rhythm array
        // (to know where to stick notes in)
    getRestIndices: { |array|
        var    result = Array(array.size);
        array.do({ |item, i|
            if(item == 0) { result.add(i) }
        });
        result
    }
);
)

(
TempoClock.default.tempo = 104 / 60;

~kikEnvir = (
    parent: ~commonFuncs,
        // rhythm pattern that is constant in each bar
    baseAmp: #[1, 0, 0, 0,  0, 0, 0.7, 0,  0, 1, 0, 0,  0, 0, 0, 0] * 0.5,
    baseDecay: #[0.15, 0, 0, 0,  0, 0, 0.15, 0,  0, 0.15, 0, 0,  0, 0, 0, 0],
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = ~getRestIndices.(~baseAmp);
        ~amp = ~baseAmp.copy;
        ~decay2 = ~baseDecay.copy;
            // if last bar of 4beat cycle, do busier fills
        if(beat16pos.inclusivelyBetween(12, 16)) {
            available.scramble[..rrand(5, 10)].do({ |index|
                    // crescendo
                ~amp[index] = index.linexp(0, 15, 0.2, 0.5);
                ~decay2[index] = 0.15;
            });
        } {
            available.scramble[..rrand(0, 2)].do({ |index|
                ~amp[index] = rrand(0.15, 0.3);
                ~decay2[index] = rrand(0.05, 0.1);
            });
        }
    }
);

~snrEnvir = (
    parent: ~commonFuncs,
    baseAmp: #[0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0] * 1.5,
    baseDecay: #[0, 0, 0, 0,  0.7, 0, 0, 0,  0, 0, 0, 0,  0.4, 0, 0, 0],
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = ~getRestIndices.(~baseAmp),
            choice;
        ~amp = ~baseAmp.copy;
        ~decay = ~baseDecay.copy;
        if(beat16pos.inclusivelyBetween(12, 16)) {
            available.scramble[..rrand(5, 9)].do({ |index|
                ~amp[index] = index.linexp(0, 15, 0.5, 1.8);
                ~decay[index] = rrand(0.2, 0.4);
            });
        } {
            available.scramble[..rrand(1, 3)].do({ |index|
                ~amp[index] = rrand(0.15, 0.3);
                ~decay[index] = rrand(0.2, 0.4);
            });
        }
    }
);

~hhEnvir = (
    parent: ~commonFuncs,
    baseAmp: 15 ! 16,
    baseDelta: 0.25 ! 16,
    addNotes: {
        var    beat16pos = (thisThread.clock.beats - ~startTime) % 16,
            available = (0..15),
            toAdd;
            // if last bar of 4beat cycle, do busier fills
        ~amp = ~baseAmp.copy;
        ~dur = ~baseDelta.copy;
        if(beat16pos.inclusivelyBetween(12, 16)) {
            toAdd = available.scramble[..rrand(2, 5)]
        } {
            toAdd = available.scramble[..rrand(0, 1)]
        };
        toAdd.do({ |index|
            ~amp[index] = ~doubleTimeAmps;
            ~dur[index] = ~doubleTimeDurs;
        });
    },
    doubleTimeAmps: Pseq(#[15, 10], 1),
    doubleTimeDurs: Pn(0.125, 2)
);


~kik = Penvir(~kikEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \kik,
            \preamp, 0.4,
            \dur, 0.25,
            *(~pbindPairs.value(#[amp, decay2]))
        ),
            // default Event checks \freq --
            // if a symbol like \rest or even just \,
            // the event is a rest and no synth will be played
        \freq, Pif(Pkey(\amp) > 0, 1, \rest)
    )
}), inf)).play(quant: 4);

~snr = Penvir(~snrEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \kraftySnr,
            \dur, 0.25,
            *(~pbindPairs.value(#[amp, decay]))
        ),
        \freq, Pif(Pkey(\amp) > 0, 5000, \rest)
    )
}), inf)).play(quant: 4);

~hh = Penvir(~hhEnvir, Pn(Plazy({
    ~init.value;
    ~addNotes.value;
    Pbindf(
        Pbind(
            \instrument, \kraftySnr,
            \rq, 0.06,
            \amp, 15,
            \decay, 0.04,
            *(~pbindPairs.value(#[amp, dur]))
        ),
        \freq, Pif(Pkey(\amp) > 0, 12000, \rest)
    )
}), inf)).play(quant: 4);
)

// stop just before barline
t = TempoClock.default;
t.schedAbs(t.nextTimeOnGrid(4, -0.001), {
    [~kik, ~snr, ~hh].do(_.stop);
});
