// Guía de Patterns

// Los patterns describen cálculos sin mostrar explícitamente cada paso del algoritmo.Son representaciones de alto nivel de una tarea computacional. Al usar patterns, uno escribe qué se supone que suceda en lugar de cómo lograrlo.

// En SC, los patterns son ideales para tareas que necesiten producir secuencias o streams (flujos) de información. Frecuentemente son números, pero pueden ser cualquier tipo de objetos.

// Contemos desde 0 para arriba, sin saber hasta dónde llegaremos. Cada vez que pedimos un valor, nos devuelve el próximo. El primer caso usa la clase Routine porque es una estructura de control que puede interrumpir lo que está haciendo y recordar dónde estaba. Esto es un ejemplo de Stream. Podemos encontrar más sobre esto en "Understanding Streams, Patterns and Events")
Routine
Stream

(
a = Routine {
	var i = 0;

	loop {
		i.yield;
		i = i + 1;
	};

};
)

a.nextN(10);

// Usando otra estructura de control, nos queda una versión más corta:

(
a = Routine {
	(0..).do { |i|
		i.yield;
	}
};
)

a.nextN(10);

// Usando patterns, simplemente pedimos lo que queremos:

a = Pseries(0, 1, inf).asStream;

a.nextN(10);

// Ventajas: es más corto. Es código super testeado. Es más legible.
// Desventajas: es un nuevo vocabulario para aprender. Debemos aprender a combinarlos. Eventualmente tendremos que escribir comportamientos custom con Proutine.

// Pueden servir como un puente para representar concepciones musicales más directamente, con menos detalles de implementación.

// Patterns vs Streams
// Los patterns definen comportamiento, los streams lo ejecutan. El pattern es el plano de una construcción, el stream sigue el plan. El pattern no cambia, no tiene estado: stateless. El stream es quien tiene registro de en qué punto de la evaluación del pattern se encuentra.

// Por lo tanto, invocar el método .next en un pattern no tiene sentido. Usamos el método asStream para crear el stream de acuerdo a la especificación del pattern. El stream avanza a su próximo estado y devuelve su valor, cada vez que llamamos a next.

p = Pseries(0, 2, inf);

p.next;  // no sirve, nos devuelve siempre el pattern

q = p.asStream;

q.next; // devuelve el próximo valor


// Además, esta división de trabajo nos permite derivar todos los streams que necesitemos del mismo pattern.

r = p.asStream;

r.next;
q.next

[q.next, r.next]


// A continuación, estudiar los ejemplos de patterns presentados en:
// Pattern Guide 02: Basic Vocabulary
// Acá dejamos algunos ejemplos, de patterns que no vimos antes en el curso.

// Pwrand: selección aleatoria de acuerdo con las probabilidades ponderadas que le damos (como list.wchoose(weights)

// Estas probabilidades favorecen notas de la tríada mayor del primer grado de la escala
(
p = Pbind(
    \degree, Pwrand((0..7), [4, 1, 3, 1, 3, 2, 1].normalizeSum, inf),
    \dur, 0.25
).play;
)

//Place: intercala valores de los sub arrays

Place([0, [1, 2], [3, 4, 5]], 3).asStream.all;
--> [ 0, 1, 3, 0, 2, 4, 0, 1, 5 ]

// Si lo convertimos en una matriz y lo leemos verticalmente, los arreglos originales son claramente visibles:
Place([0, [1, 2], [3, 4, 5]], 3).clump(3).do(_.postln);

//Ppatlace: toma un valor de cada sub pattern en orden

// Ejercicio del Hanon

(
p = Pbind(
	\degree, Ppatlace([
		Pseries(0, 1, 8),
		Pseries(2, 1, 7)
	], inf),
	\dur, 0.25
).play;
)

// Ptuple: toma un valor de cada pattern y devuelve un array con esos valores

// Acordes: \degree recibe [7, 9, 4], luego [6, 7, 4], etc
(
p = Pbind(
    \degree, Ptuple([
        Pseries(7, -1, 8),
        Pseq([9, 7, 7, 7, 4, 4, 2, 2], 1),
        Pseq([4, 4, 4, 2, 2, 0, 0, -3], 1)
    ], 1),
    \dur, 1
).play;
)


// Números aleatorios y distribuciones de probabilidad
/*
Pwhite(lo, hi, length)
Produces length random numbers with equal distribution ('white' refers to white noise).

Pexprand(lo, hi, length)
Same, but the random numbers have an exponential distribution, favoring lower numbers. This is good for frequencies, and also durations (because you need more notes with a shorter duration to balance the weight of longer notes).

Pbrown(lo, hi, step, length)
Brownian motion. Each value adds a random step to the previous value, where the step has an equal distribution between -step and +step.

Pgbrown(lo, hi, step, length)
Brownian motion on a geometric scale. Each value multiplies a random step factor to the previous value.

Pbeta(lo, hi, prob1, prob2, length)
Beta distribution, where prob1 = α (alpha) and prob2 = β (beta).

Pcauchy(mean, spread, length)
Cauchy distribution.

Pgauss(mean, dev, length)
Guassian (normal) distribution.

Phprand(lo, hi, length)
Returns the greater of two equal-distribution random numbers.

Plprand(lo, hi, length)
Returns the lesser of two equal-distribution random numbers.

Pmeanrand(lo, hi, length)
Returns the average of two equal-distribution random numbers, i.e., (x + y) / 2.

Ppoisson(mean, length)
Poisson distribution.

Pprob(distribution, lo, hi, length, tableSize)
Given an array of relative probabilities across the desired range (a histogram) representing an arbitrary distribution, generates random numbers corresponding to that distribution.
*/

// Para ver una distribución, hacemos un histograma:

Pmeanrand(0.0, 1.0, inf).asStream.nextN(10000).histo(200, 0.0, 1.0).plot;


// Patterns personalizados
// Nos permiten introducir nuestra propia lógica

// Pfunc

(
var a, x;
a = Pfunc({ exprand(0.1, 2.0) + #[1, 2, 3, 6].choose }, { \reset.postln });
x = a.asStream;
x.nextN(20).postln;
x.reset;
)


// Proutine (Prout)

(
var a;
a = Prout({ loop { 1.yield; 2.yield; 7.yield; 10.do { 1.0.rand.yield } }});
a.asStream.nextN(100).plot;
)


// Qué es Pbind ?

// En sentido general, Pbind es simplemente una forma de darle nombres a los valores que entregan los patterns que vimos. Cuando le pedimos a un stream de Pbind su próximo valor, el resultado es un objeto Event. Es como un Dictionary (que es una superclase de Event). Un evento es un conjunto de pares "clave-valor".

e = (freq: 440, dur: 0.5);    // an Event

e.at(\freq)        // access a value by name
e[\freq]
e.freq        // See IdentityDictionary help for more on this usage

e.put(\freq, 880);    // Change a value by name
e[\freq] = 660;
e.freq = 220;

e.put(\amp, 0.6);    // Add a new value into the event
e.put(\dur, nil);    // Remove a value

// Un Pbind se define por una lista de pares: claves asociadas a patterns que proverán los valores para crear los eventos.

// Cuando los nombres asociados con los subpatterns de Pbind son también argumentos de un SynthDef, podemos tocar Synths con Pbind y alimentar sus entradas con diferentes valores en cada evento.

(
p = Pbind(
    \degree, Pseq(#[0, 0, 4, 4, 5, 5, 4], 1),
    \dur, Pseq(#[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1], 1)
).asStream;    // remember, you have to make a stream out of the pattern before using it
)

p.next(Event.new);    // shorter: p.next(())

// Output:
( 'degree': 0, 'dur': 0.5 )
( 'degree': 0, 'dur': 0.5 )
( 'degree': 4, 'dur': 0.5 )
( 'degree': 4, 'dur': 0.5 )

//NOTE: Dictionaries in SuperCollider are unordered collections. Even though Pbind processes its child streams in the order given, the results can display the keys and values in any order. This does not affect the behavior of playing Events, as we will soon see.


// A diferencia de los Dictionary, los eventos pueden reproducir sonido con .play

().play

// Cuando invocamos .play sobre un Pattern, se crea un objeto de clase EventStreamPlayer. Este objeto lee los evento uno a uno desde el stream creado a partir del pattern, y llama a play en cada evento. El valor delta en el evento determina cuantos beats debe esperar hasta el próximo evento. Play continúa hasta que el stream del pattern deja de producir eventos o invocamos a .stop en el EventStreamPlayer.

// Variante a Pbind: Pmono

Pbind toca notas separadas por defecto. A veces podemos necesitar un pattern que actúe como un sintetizador monofónico, donde sólo se ejecuta un único nodo Synth y se cambia sus valores con cada evento.

// Comparar estos sonidos: Pmono glisa de altura en altura, Pbind ataca cada nota

p = Pbind(\degree, Pwhite(0, 7, inf), \dur, 0.25, \legato, 1).play;
p.stop;

p = Pmono(\default, \degree, Pwhite(0, 7, inf), \dur, 0.25).play;
p.stop;


// Articular frases es posible encadenándo varios Pmono o usando PmonoArtic
PmonoArtic

// Los SynthDefs tienen entradas de Control (ver clase Control), usualmente definidas como argumentos a la función de Ugen. Por ejemplo, el SynthDef default (definido en Event.sc) define cinco entradas de control: out, freq, amp, pan y gate.

SynthDef(\default, { arg out=0, freq=440, amp=0.1, pan=0, gate=1;
    var z;
    z = LPF.ar(
            Mix.new(VarSaw.ar(freq + [0, Rand(-0.4,0.0), Rand(0.0,0.4)], 0, 0.3)),
            XLine.kr(Rand(4000,5000), Rand(2500,3200), 1)
        ) * Linen.kr(gate, 0.01, 0.7, 0.3, 2);
    OffsetOut.ar(out, Pan2.ar(z, pan, amp));
}, [\ir]);


// Cuando un evento toca un sinte, cualquier valor del evento con el mismo nombre que una entrada de control del SynthDef será pasado al nuevo sinte.

// Similar to Synth(\default, [freq: 293.3333, amp: 0.2, pan: -0.7])
(freq: 293.3333, amp: 0.2, pan: -0.7).play;

// Similar to Synth(\default, [freq: 440, amp: 0.1, pan: 0.7])
(freq: 440, amp: 0.1, pan: 0.7).play;

// No usar send o load con los SynthDefs; usar .add o .store en su lugar
// Para enviar sólo los valores relevantes al nuevo Synth, el Event necesita saber qué controles existen en el SynthDef. Esto se logra por medio de una biblioteca de descriptores para SynthDefs; el descriptor es un SynthDesc, y la biblioteca es un SynthDescLib.

// Los métodos .send, .load para comunicar un SynthDef al server no actualizan esta biblioteca, por lo tanto estos sintes no funcionarán con Pbind.

// Save into the library, write a .scsyndef file, and load it on the server
SynthDef(...).store;

// Save into the library and send the SynthDef to the server (no .scsyndef file)
// Make sure the server is booted before doing this
SynthDef(...).add;


// Eventos con Rest
// Los rests pueden darse en cualquier par key-value
// Un rest tiene una duración, ej Rest(0.5), si se usa en un stream de duración (\dur o \delta)

// La técnica "touches bloquées" de Ligeti puede escribirse de esta forma:

(
// first, pitches ascending by 1-3 semitones, until 2 octaves are reached
var    pitches = Pseries(0, Pconst(24, Pwhite(1, 3, inf)), inf).asStream.all,
        // randomly block 1/3 of those
    mask = pitches.scramble[0 .. pitches.size div: 3];

p = Pbind(
    \arpeg, Pseq(pitches[ .. pitches.size - 2] ++ pitches.reverse[ .. pitches.size - 2], inf),
        // if the note is found in the mask array, replace it with Rest
        // then that note does not sound
    \note, Pif(Pfunc { |event| mask.includes(event[\arpeg]) }, Rest, Pkey(\arpeg)),
    \octave, 4,
    \dur, 0.125
).play;
)

p.stop;


// Escribiendo SynthDefs para patterns
// Recordemos que los SynthDefs deben tener algunas características especiales para funcionar bien con patterns: Deben liberarse autmáticamente.

// El Evento espera que el sinte se libere automáticamente del server, al terminar su trabajo. Esto puede realizarse de varias formas: 1) una envolvente con gate que especifique doneAction: 2. Una envolvente con gate especifíca un nodo de release o usa alguna de las envolventes sostenidas predefinidas: Env.asr, Env.adsr, Env.dadsr. 2) Linen.kr, que es un shortcut para una envolvente lineal con gate. 3) Una envolvente con duración fija, sin gate.


// De palabras a frases.
// Patterns dentro de patterns.

// Cuando un list pattern (Pseq, Prand, etc) encuentra en su lista a otro pattern, el pattern interno es embebido en el stream. Es decir el pattern interno toma el control hasta que se queda sin valores. Luego el control retorna al patern externo. Esto es como llamar a una función desde otra función.

// Si un único pattern es como una palabra, un list pattern que usa otros patterns podría ser una frase u oración. Podemos alternar entre comportamientos deterministas o aleatorios.

// Scale segments, in the sequence: up, up, down (repeat)
(
TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pseq([
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(0, 7) }, 1, { rrand(4, 8) }),    // up (step = 1)
        Pseries({ rrand(7, 14) }, -1, { rrand(4, 8) })    // down (step = -1)
    ], inf),
    \dur, 0.125
).play;
)

p.stop;

// Los list patterns funcionan bien tanto con patterns de valores (como en el ejemplo anterior) como con patterns de eventos (como Pbind). Esto significa que podemos encadenar Pbinds como frases, como Pxrand([Pbind(), Pmono(), Pmono()...], inf).


// Shortcut para concatenar patterns. Igual que con arrays, podemos escribir pattern1 ++ pattern2 y será equivalente a Pseq([patter1, pattern2], 1)


// Algunas formas de encadenar patterns
// Secuencial (ej, Pseq)
// Aleatoria (ej, Pwrand)
// Indexada: los patrones pueden elegirse en orden arbitrario por índices:
Pindex y Pswitch

// scale degree segments, every fifth choice is odd-numbered only (descending)
(
var    n = 10,
    scaleSegments = Array.fill(n, { |i|
        if(i.odd) {
            Pseries(11, -1, rrand(5, 10))
        } {
            Pseries(rrand(-4, 4), 1, i+2)
        }
    });

TempoClock.default.tempo = 1;
p = Pbind(
    \degree, Pswitch(scaleSegments, Pseq([Pwhite(0, n-1, 4), Pwhite(0, n-1, 1).select(_.odd)], inf)),
    \dur, 0.125
).play;
)

p.stop;


//NOTA: select llamado sobre un pattern, devuelve un Pselect
Pselect

a = Pseq(#[1, 2, 3],inf).select({ arg item; item != 2 });
a.postln;
x = a.asStream;
9.do({ x.next.postln; });

// Otra forma de indexar: Finite State Machine (Pfsm, Pdfsm)
// Es una forma de asociar un item con sus posibles predecesores. Es más cercano a una gramática que la selección aleatoria pura. La implementación de Pfsm es una caso especial de cadena de Markov.

/*A finite state machine is a way of associating an item with its possible successors. It is closer to a "grammar" than purely random selection. Pfsm defines a finite state machine as a set of possible "entry points," followed by a list of the possible "states" of the machine and, for each state, a list of the possible states that may follow the current state. States may be single values or patterns, meaning that phrases can be linked to other phrases that "make sense" in succession (and unwanted transitions can be prevented).
If this sounds a bit like a Markov chain, that's because the Pfsm implementation is a special case of a Markov chain where there is an equal probability of choosing the next state from the valid successors. In a Markov chain, the probabilities are weighted according to analysis of a real-world data stream.
The Pfsm help file includes very good examples of organizing single values and pattern phrases. Also see Pattern Guide Cookbook 06: Phrase Network for an application of Pfsm to generate a corny jazz solo.
The name Pdfsm stands for "deterministic finite state machine," where there is no random selection.*/

// COMPLETAR
// Library of named sub-patterns
// Switching between patterns for individual values
// Related: Conditional patterns



// Operaciones (aritméticas y otras) sobre Patterns

// Algunas de estas operaciones son como las que aplicamos a los arreglos, pero hay una diferencia crítica. Los patterns son "lazy", evalúan un valor a la vez. Por ejemplo, multiplicar un pattern por un número  produce una Pbinop: binary operator pattern.

p = Pwhite(1, 5, inf) * 2;    // a Pbinop

p.operator    // == '*'
p.a        // == a Pwhite
p.b        // == 2

// Los patterns soportan todas las operaciones estándar: unarias (abs, reciproco, etc), binarias: (+, -, *, /, **, min, max, etc) y n-arias (clip, wrap, fold, linlin, linexp, etc).

// Random integers 1-5, multiplied by 1/4 gives multiples of 1/4 between 0.25 and 1.25
(Pwhite(1, 5, inf) * 0.25).asStream.nextN(10);

// Random integers 1-5, with the sign (positive or negative) randomly chosen
(Pwhite(1, 5, inf) * Prand(#[-1, 1], inf)).asStream.nextN(10);

// The resulting stream has two values, because the shorter operand stream has two values
(Pseq([10, 9, 8], 1) + Pseq([1, 2], 1)).do { |x| x.postln };


// Los patterns soportan el adverbio .x, es como un loop anidado: en streamA +.x streamB, el primer valor de streamA es sumado a cada valor de streamB en suceción, luego el segundo valor.. etc. Ver
Adverbs for Binary Operators

// Play a major-7th arpeggio, transposed to different scale degrees
// Pwhite is the transposer; Pseq is the chord
// The chord is like an "inner loop"
(
p = Pbind(
    \midinote, Pwhite(48, 72, inf) +.x Pseq(#[0, 4, 7, 11], 1),
    \dur, 0.125
).play;
)

p.stop;

// COMPLETAR:
// Operaciones de Colecciones sobre patterns
// Miscellaneous calculation patterns
// Calculations based on other event values



// Filter Patterns: Patterns Filtros
// Igual que las Ugens filtro modifican una señal de entrada, los patterns filtro modifican el stream de valores que entrega un pattern. Los pattern filtro toman al menos un pattern fuente que proveé los valores/eventos a ser filtrados. Las categorías se presentan en Pattern Guide 6.

// Patterns de repetición

// Pclutch(pattern, connected): si connected es falso, se repite el valor de patterns
Pclutch(Pseq([1, 2, 3, 4, 5], 3), Pseq([0, 0, 1, 0, 0, 0, 1, 1])).asStream.nextN(10);

// Pn(pattern, n): repite pattern, n veces
Pn(Pseq([2,3,4], 1), 5).asStream.all

// Pstutter(n, pattern): cada valor de patter se repite n veces. n es un pattern también.

// PdurStutter(n, pattern): el valor del pattern se divide por el número de repeticiones. Entonces el tiempo total para ciclo de repetición  es el valor de duración del pattern fuente.


// Ejemplos sonoros:

// play repeated notes with a different rhythmic value per new pitch
// using Pstutter
p = Pbind(
        // making 'n' a separate stream so that degree and dur can share it
    \n, Pwhite(3, 10, inf),
    \degree, Pstutter(Pkey(\n), Pwhite(-4, 11, inf)),
    \dur, Pstutter(Pkey(\n), Pwhite(0.1, 0.4, inf)),
    \legato, 0.3
).play;

p.stop;


// using Pfin / Pn
// Pn loops the Pbind infinitely
// Plazy builds a new Pbind for each iteration
// Pfin cuts off the Pbind when it's time for a new value

p = Pn(
    Plazy {
        Pbind(
            \degree, Pfin(rrand(3, 10), rrand(-4, 11)),
            \dur, rrand(0.1, 0.4)
        )
    },
    inf
).play;

p.stop;


// using Pclutch
// the rule is, when degree changes, dur should change also
// if Pdiff returns 0, degree has not changed
// so here, nonzero Pdiff values "connect" the clutch and allow a new dur to be generated
// otherwise the old one is held
p = Pbind(
    \degree, Pstutter(Pwhite(3, 10, inf), Pwhite(-4, 11, inf)),
    \dur, Pclutch(Pwhite(0.1, 0.4, inf), Pdiff(Pkey(\degree)).abs > 0),
    \legato, 0.3
).play;

p.stop;


// Patterns de interrupción o restricción
// En lugar de prolongar un stream por repetición, estos patterns usan diferentes métodos para detener un stream dinámicamente. Son especialmente útiles para modularizar la construcción de patterns. Una sección del código puede ser responsable por generar patterns numéricos o de eventos. Al usar patterns de interrupción, esa parte del código no tiene que saber cuántos eventos tocar o por cuanto tiempo. Pueden ser patterns infinitos. Otra parte del código puede tomar esta fuente y encerrarla en algunos de estos patterns para detenerlos basados en la condición apropiada.

// Pfin(count, pattern): retorna exactamente "count" valores del pattern. Luego se detiene.

// Pconst(sum, pattern, tolerance): entrega números hasta que la suma llega a un límite predefinido.

// Pfindur(dur, pattern, tolerance): Aplica el comportamiento de límite a los valores rítmicos de los eventos. El pattern corre hasta una duración específica. Esto es muy útil si uno conoce la longitud del gesto musical, pero no conoce la cantidad de eventos necesarios para llenar ese tiempo.

// Two variants on the same thing
// Use Pconst or Pfindur to create 4-beat segments with randomized rhythm
// Pconst and Pfindur both can ensure the total rhythm doesn't go above 4.0

p = Pn(Pbind(
        // always a low C on the downbeat
    \degree, Pseq([-7, Pwhite(0, 11, inf)], 1),
    \dur, Pconst(4, Pwhite(1, 4, inf) * 0.25)
), inf).play;

p.stop;

p = Pn(Pfindur(4, Pbind(
    \degree, Pseq([-7, Pwhite(0, 11, inf)], 1),
    \dur, Pwhite(1, 4, inf) * 0.25
)), inf).play;

p.stop;

// Psync(pattern, quant, maxdur, tolerance)
// Like Pfindur, but does not have a fixed duration limit. Instead, it plays until either it reaches maxdur (in which case it behaves like Pfindur, adjusting the last event so the total duration matches maxdur), or the pattern stops early and the last event is rounded up to the next integer multiple of quant. This is hard to explain; a couple of examples might make it clearer.

(
// in this case, the pattern stops by reaching maxdur
// elapsed time = 4
var    startTime;
p = (Psync(Pbind(
    \dur, 0.25,    // total duration = infinite
    \time, Pfunc { startTime = startTime ? (thisThread.clock.beats.debug("time")) }
), 1, 4) ++ Pfuncn({
    thisThread.clock.beats.debug("finish time");
    (thisThread.clock.beats - startTime).debug("elapsed");
    nil
}, 1)).play;
)

(
// in this case, the pattern stops itself before maxdur (4)
// the Pbind's duration (1.25) gets rounded up to 2 (next multiple of 1)
var    startTime;
p = (Psync(Pbind(
    \dur, Pn(0.25, 5),    // total duration = 0.25 * 5 = 1.25
    \time, Pfunc { startTime = startTime ? (thisThread.clock.beats.debug("time")) }
), 1, 4) ++ Pfuncn({
    thisThread.clock.beats.debug("finish time");
    (thisThread.clock.beats - startTime).debug("elapsed");
    nil
}, 1)).play;
)


// Patterns basados en el tiempo
// Aquí hablamos de "patterns de valores" que usan el tiempo como parte de sus cálculos. Los "patters de eventos" nos naturalmente controlados por el tiempo cuando se ejecutan sobre un reloj. Técnicamente es posibole requerir eventos de un stream de ventos sin ejecutarlo sobr un EventStreamPlayer, pero este no es el uso típico.

// La mayoría de estos eventos trabajan recordando el tiempo presente del reloj al momento en el que el pattern es embebido en un stream de valores.... SIGUE




