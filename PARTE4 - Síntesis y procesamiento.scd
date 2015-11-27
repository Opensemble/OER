//PARTE 4
//Síntesis y procesamiento de sonido

//24. Ugens

// Una unidad generadora o UGen, es un objeto que genera señales de control o señales de audio. Éstas se calculan en el server. Hay muchas clases de ugens, todas derivadas de la clase UGen. SinOsc y LFNoise0 son dos ejemplos. Para más detalles, mirar los archivos de ayuda:
Unit Generators and Synths
//y
Tour of UGens

// Cuando usamos Pbind el sonido default tipo piano era el resultado de combinar varias UGens. Pero Pbind no es una Unidad Generadora. Es una receta para eventos musicales (partitura). Tampoco el EventStreamPlayer es una UGen, es el ejecutante  (como un pianista). La UGen es el instrumento.

// Aprenderemos a combinar ugens para crear todo tipo de instrumentos electrónicos con sonidos sintetizados y procesados.

// 24.1 Control con el mouse: Theremin instantáneo

{SinOsc.ar(freq: MouseX.kr(100, 2500), mul: MouseY.kr(0, 1))}.play

//SinOsc, MouseX, MouseY son ugens. Las últimas dos capturan el movimiento del cursor en pantalla

// 24.2 Saw y Pulse; Plot y Scope

// Otras formas de onda y métodos para visualizarlas y compararlas
{SinOsc.ar}.plot
{LFPulse.ar}.plot

// Cuidado con el aliasing
{Saw.ar}.plot
{LFSaw.ar}.plot

// Ahora reescriba el theremin reemplazando con otras formas de onda y escuche las diferencias sonoras. Finalmente pruebe el método .scope y será capaz de ver una representación en tiempo real: se abre una ventana "Stethoscope", como un osciloscopio.

FreqScope.new; // analizador espectral

{Saw.ar(freq: MouseX.kr(100, 2500), mul: MouseY.kr(0, 1))}.scope(1, zoom:4),

//25. Tasa de Audio y tasa de Control.

// .ar y .kr son métodos de instanciación de una ugen.
// (ar = audio rate, kr = control rate)

// Las ugens que funcionan a tasa de control se usan para señales de baja frecuencia o de cambio lento (como una envolvente lineal). Producen un único sample por ciclo de control y por lo tanto usan menos recursos.

// Si la configuracion es de 44.1k, cuando enviamos el mensaje .ar a una UGen, le pedimos que genere 44100 numeros por segundo! (son muchos numeros).
// Escribimos {SinOsc.ar}.play en sclang, el cual se comunica con scsynth quien genera esos samples

// Cuando usamos .kr en lugar de .ar, el trabajo en el server tiene algunas diferencias:
// 1. el número de samples sera de 44100 / 64 = aprox 700. 64 es conocido como período de control.
// 2. la señal generada no se rutea a la salida de audio. En cambio suele ser usada para controlar otros parámetros. Como MouseX controlaba la frecuencia de SinOsc

// Entonces las UGens son generadores de números, muy rápidos. Algunos de estos números son señales de audio otras son señales de control.

// Pero qué números son estos? grandes, pequenos?  positivos, negativos?
// Son números muy pequeñoos entre 0 y 1 ó -1 y 1. Dependiendo de la categoria de Ugen. Ugen Unipolar: genera números entre 0 y 1. Ugen Bipolar: genera números entre -1 y 1

// 25.1 El método poll

// Podemos pedirle a SC que imprima algunos números por segundo

// Sin sonido porque usamos .kr
{SinOsc.kr(1).poll}.play;
{LFPulse.kr(1).poll}.play;

// El argumento 1 es la frecuencia: 1 cps
// .poll toma 10 numeros por segundo.
// RESPONDER: son señales unipolares o bipolares?

// Como usamos .ar, este generador de ruido de baja frecuencia esta enviando 44100 samples por segundo a la salida de audio. Cada sample con valor entre -1 y 1. Todo se calcula en el server.
{LFNoise0.ar(10).poll}.play

// Experimentar cambiando la frecuencia del generador de ruido y su interpolación

//26. Argumentos de UGen

MouseX  // usemos ctrl D para ver la ayuda
// Luego de la sección de descripcion, vemos los métodos de clases donde se explica cuáles son los argumentos que espera el método kr para esta clase particular.

// 27. Escalar rangos

{SinOsc.ar(freq: LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;

// Vamos por partes

{LFNoise0.kr(1).poll}.play; // LFNoise0 en acción
{LFNoise1.kr(10)}.plot(10) // plot
{LFNoise0.kr(1).range(500, 1500).poll}.play; // ahora con .range
{LFNoise0.kr(10).range(500, 1500).poll}.play; // y más rápido

// 27.1 Escalar con el metodo range

// .range toma la salida entre -1 y 1 y la escala a los valores que le demos.

// Para controlar una UGen tenemos que saber qué números aceptan sus parametros. Son frecuencias o amplitudes? o es el número de armónicos o el índice de modulación fm?

//Ejercicio: escriba una expresión que toque una onda sinusoidal, cuya frecuencia es controlada por un LFPulse a tasa de control. Luego escale la salida del LFPulse al rango que quiera escuchar.

//{LFPulse.kr(1, width: 0.2)}.plot(10)
//{SinOsc.ar(LFPulse.kr(1, width: 0.5).range(400, 500))}.play

// 27.2 Escalar con mul y add
// Ver figura

// Vemos la equivalencia con .range

// Esto:
{SinOsc.kr(1).range(100, 200).poll}.play;
// ...es lo mismo que esto:
{SinOsc.kr(1, mul: 50, add: 150).poll}.play;

// Esto:
{LFPulse.kr(1).range(100, 200).poll}.play;
// ...es lo mismo que esto:
{LFPulse.kr(1, mul: 100, add: 100).poll}.play;


//27.3 linlin y amigos

// Podemos usar los métodos linlin, linexp, explin y expexp. Convierten un rango lineal a otro lineal (linlin) o uno lineal a otro exponencial (linexp), etc

// Ejemplos:

// Una lista de números: (1..7)
a = [1, 2, 3, 4, 5, 6, 7];

// Escalamos a 0-127, lineal
a.linlin(1, 7, 0, 127).round(1);

// Escalamos a 0-127, exponencial. No usar cero para rangos exponenciales
a.linexp(1, 7, 0.01, 127).round(1);

// 28. Detener sintes individuales
(
a = { Saw.ar(LFNoise2.kr(8).range(1000, 2000), mul: 0.2) }.play;
b = { Saw.ar(LFNoise2.kr(7).range(100, 1000), mul: 0.2) }.play;
c = { Saw.ar(LFNoise0.kr(15).range(2000, 3000), mul: 0.1) }.play;
)

a = { Saw.ar(SinOsc.kr(1).range(1000, 2000), mul: 0.2) }.play;


// Detener
a.free;
b.free;
c.free;

//29. El mensaje "set"

// Los argumentos definidos en las funciones de síntesis son accesibles en tiempo real. Esto permite cambiar parametros al vuelo, mientras el sinte esta ejecutándose

x = {arg freq = 440, amp = 0.2; SinOsc.ar(freq, 0, amp)}.play;
x.set(\freq, 778);
x.set(\amp, 0.1);
x.set(\freq, 920, \amp, 0.2);
x.free;

// Es buena práctica de programación darle valores por defecto a los parámetros formales, de otra manera el sinte no sonará hasta que asignemos un valor apropiado a los parámetros no inicializados.

// 30. Buses de Audio

// Se usan para rutear señales de audio. Son similares a canales de una consola. SC tiene 128 canales de audio por defecto. También hay buses de control (más adelante los vemos).

// Con [ctrl+M] abrimos la ventana Meter
// Figura con buses y correspondencias

// Los buses de audio van de 0 a 127. Los primeros 8, de 0 a 7 se reservan para canales de salida de la placa de audio. Los próximos 8, de 8 a 15, se reservan para las entradas. Todos los demás, de 16 a 127, están libres para ser usados de cualquier forma, por ejemplo si queremos rutear audio de una UGen a otra.

// 30.1 Ugens de entrada y salida de audio: In / Out

// Evaluar este código

{Out.ar(1, SinOsc.ar(440, 0, 0.1))}.play; // canal derecho

// La UGen Out se encarga de rutear señales a buses específicos. El segundo argumento puede ser una combinacion de UGens. Cambiar el primer argumento entre 0 y 7 y verificar la actividad en los medidores.

// Veamos un ejemplo simple de cómo usar un bus para rutear una senal a un efecto

// Creamos el efecto
f = {Out.ar(0, BPF.ar(in: In.ar(55), freq: MouseY.kr(1000, 5000), rq: 0.1))}.play; //rq = (bandwidth/ cutoffFreq)

// Creamos la fuente
n = {Out.ar(55, WhiteNoise.ar(0.5))}.play;

//La primera línea de código define un Band Pass Filter, que toma audio del bus 55. La segunda línea envía la salida al bus 55
// Ruteo: ruido blanco --> bus 55 --> filtro --> salida de audio

// El orden de ejecución es importante. El ejemplo no funciona si evaluamos la fuente de audio antes que el efecto. Esto se estudiará mas adelante.

// Nota: Cuando escribimos {SinOsc.ar(440)}.play, SC realiza varias operaciones y traduce nuestra funcion a {Out.ar(0, ...)}.play

//31. Entrada de audio. Ejemplo con micrófono.

// El ejemplo que vemos debajo muestra como podemos acceder a la entrada de audio con la UGen SoundIn. También podriamos usar In.ar(8) para obtener sonido de la entrada.

// Cuidado con el acople. Usar auriculares
{SoundIn.ar(0)}.play; // equivalente a In.ar(8)

// Versión estéreo
{SoundIn.ar([0, 1])}.play; // toma la primer y segunda entrada

// Un poco de reverb
{FreeVerb.ar(SoundIn.ar([0, 1]), mix: 0.9, room: 0.9)}.play;

// 32. Expansión Multicanal

// Estudiar este código con la Meter Window abierta
{Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(0, 1, 10)))}.play

// Esto se llama expansión multicanal. Obtenemos 2 señales, al definir un argumento como array. Es una de las aplicaciones más poderosas de SC. El lenguaje crea dos copias de Saw, una con 440Hz enviada al bus 0 y otra con 570Hz enviada al bus 1. Si agregamos una frecuencia más a la lista, la manda al bus 2 (no la escuchamos en estéro)

// Ayuda
"Multichannel Expansion"

// Además, podemos usar arreglos adicionales en otros argumentos de la misma UGen o en argumentos de otras Ugen de la misma función de grafo. SC genera sintes de acuerdo a esos valores.

// Por ejemplo, en el ejemplo anterior ambas señales hacen un fade in de 0 a 1 en 10 seg. Qué sucede si usamos esta variante?
{Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(1, 0, [2, 5])))}.play

// Ejercicio: una simulación de un "tono de ocupado" de un teléfono antiguo. Cómo logramos que el oscilador del canal derecho pulse 3 veces por segundo?

a = {Out.ar(0, SinOsc.ar(freq: [800, 880], mul: LFPulse.ar(2)))}.play;
a.free;

// 33. La clase Bus
// Un ejemplo que muestra todo lo aprendido recientemente

// Creamos una reverb. No escuchamos audio todavía
r = {Out.ar(0, FreeVerb.ar(In.ar(55, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;

// Ruteamos el tono de ocupado al bus de la reverb
a = {Out.ar(55, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;
a.free;

// Explicación: In.ar lee 2 buses desde el 55. FreeVerb se expande (como cualquier UGen) a dos canales y se envía las salidas a los buses 0 y 1.

// La eleccion del bus 55 fue arbitraria (entre 16 y 127). A medida que nuestros programas crecen en complejidad es poco conveniente mantener registro de los numeros de buses de forma manual.

// Creamos y alocamos el bus. Métodos de clase.
~myBus = Bus.audio(s, 2);

// El primer argumento de Bus.audio es s, que apunta al server. El segundo argumento indica la cantidad de buses que necesitamos alocar. Entonces referenciamos esos buses con un nombre apropiado, podría ser reverbBus o delayBus, etc.

// Métodos de instancia: index, rate, numChannels, free
~myBus.index
~myBus.numChannels

// Creamos la reverb que leerá del bus creado
r = {Out.ar(0, FreeVerb.ar(In.ar(~myBus, 2), mix: 0.5, room: 0.9, mul: 0.4))}.play;

// Ruteamos la fuente
b = {Out.ar(~myBus, SinOsc.ar([800, 880], mul: LFPulse.ar(2)))}.play;

// Liberamos recursos
r.free;
b.free;
~myBus.free;

// 34. Panning

// Ubicamos la señal en el espacio, estéreo o multicanal. Ejemplo de señal que se mueve en el estéreo.

// Pan2 devuelve un array con 2 "salidas"
p = {Pan2.ar(in: SinOsc.ar(880, 0, Pulse.ar(10, 0.5)), pos: SinOsc.kr(1/2), level: 0.2)}.play

p.free;

// El argumento pos espera un número entre -1 (izq) y 1  (der). Usamos una señal bipolar como SinOsc. Para configuraciones multicanal, mirar las clases Pan4 y PanAz. También hay plugins para Ambisonics.

// Aquí un ejemplo más elaborado. Una onda sierra pasa por un BPF de banda angosta (rq: 0.01). Responder las siguientes preguntas:

(
x = {
	var lfn = LFNoise2.kr(1);
	var saw = Saw.ar(
		freq: 30,
		mul: LFPulse.kr(
			freq: LFNoise1.kr(1).range(1, 10),
			width: 0.1));
	var bpf = BPF.ar(in: saw, freq: lfn.range(500, 2500), rq: 0.01, mul: 20);
	Pan2.ar(in: bpf, pos: lfn);
}.play;
)
x.free;

// Cómo se usa lfn las dos veces?
// Por qué se usa 20 en mul del BPF
// Qué parte del código controla el ritmo?
// ------
// Ayuda:
// Patch gráfico
//{Saw.ar(30, mul: LFPulse.kr(LFNoise1.kr(1).range(1,3), width:0.1))}.play


//35. Mix y Splay

// Podemos usar expansión multicanal para generar sonidos complejos, y luego mezclarlos nuevamente a mono o estéreo usando Mix o Splay

// 5 canales de salida (mirar la Meter Window )
a = {SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)}.play;
a.free;

// Los mezclamos mono
b = { Mix(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)) }.play;
b.free;

// Los mezclamos en estéreo
c = { Splay.ar(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1)) }.play;
c.free

// Un ejemplo más:
(
d = {arg fundamental = 110;
	var harmonics = [1, 2, 3, 4, 5, 6, 7, 8, 9]; // probar de a uno
	var snd = BPF.ar(
		in: Saw.ar(32, LFPulse.ar(harmonics, width: 0.1)),
		freq: harmonics * fundamental,
		rq: 0.01,
		mul: 20);
	Splay.ar(snd);
}.play;
)

d.set(\fundamental, 100); // probar otras fundamentales
d.free;

// Se ve la expansión en el último ejemplo? Guardamos el array en la variable harmonics. El bpf se expande a 9 canales, y antes del .play, Splay los mezcla estéreo distribuyendo los canales de manera uniforme de izquierda a derecha.

// Mix tiene otro método interesante: .fill. Crea un arreglo de sintes y los mezcla mono, todo en un único paso.

// Generador instantáneo de clusters
c = { Mix.fill(16, {SinOsc.ar(rrand(100, 3000), mul: 0.01)}) }.play;
c.free;

// Le damos el tamaño del array que queremos crear y una función que se usará para crear cada posición. El segundo ejemplo muestra un arg counter, como en Array.fill.

// Síntesis aditiva
(
n = { Mix.fill(32, {arg counter;
	var partial = counter + 1; // empezamos de 1, no queremos dc
	SinOsc.ar(partial * 440, mul: 1/partial) * 0.1
	})
}.play;

// Analizador espectral
FreqScope.new;
)
n.free;

// Nota: Suena muy distinto a esto? y si le agregamos parciales a la anterior?
{Saw.ar(440, 0.3)}.play
// la diente de sierra tiene todos los parciales. Energía: 1/n, n = nro de parcial

// 36. Reproducir un archivo de audio

// Podemos arrastrar el ícono al editor y nos devuelve el string con el path absoluto.

// Un buffer es un array de números en punto flotante disponible globalmente, almacenado en el server. Se usa más frecuentemente para almcenar audio.

// Carga el archivo en un buffer del server:
~buf1 = Buffer.read(s, "sounds/a11wlk01.wav"); // viene con SC

// Reproduce el buffer:
{PlayBuf.ar(1, ~buf1)}.play; // número de canales del buffer

// Información sobre el archivo:
[~buf1.bufnum, ~buf1.numChannels, ~buf1.path, ~buf1.numFrames];

//samples = frames * canales

// Cambiar la velocidad de reproducción con 'rate'
{PlayBuf.ar(numChannels: 1, bufnum: ~buf1, rate: 2, loop: 1)}.play; // al doble
{PlayBuf.ar(1, ~buf1, 0.5, loop: 1)}.play; // a la mitad
{PlayBuf.ar(1, ~buf1, Line.kr(0.5, 2, 10), loop: 1)}.play; // variable
{PlayBuf.ar(1, ~buf1, MouseY.kr(0.5, 3), loop: 1)}.play; // control por mouse

// Cambiar la dirección (reverse)
{PlayBuf.ar(1, ~buf1, -1, loop: 1)}.play; // reverso
{PlayBuf.ar(1, ~buf1, -0.5, loop: 1)}.play; // reverso y lento


//Ejemplo con patterns
(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

SynthDef(\stretchedFragments, { |out, bufnum, start, time = 1, stretch = 1, amp = 1, attack = 0.01, decay = 0.05|
    var    sig = PlayBuf.ar(1, bufnum, rate: stretch.reciprocal, startPos: start, doneAction:2);
    sig = PitchShift.ar(sig, pitchRatio: stretch)
        * EnvGen.kr(Env.linen(attack, time, decay), doneAction: 2);
    Out.ar(out, sig ! 2)
}).add;
)

(
TempoClock.default.tempo = 1;

p = Pbind(
    \instrument, \stretchedFragments,
    \bufnum, b,
    \start, Pwhite(0, (b.numFrames * 0.5).asInteger, inf),
    \delta, Pexprand(0.2, 1.5, inf),
    \time, Pkey(\delta),
    \stretch, Pexprand(1.0, 4.0, inf),
    \amp, 0.5,
    \attack, 0.1,
    \decay, 0.2
).play;
)

p.stop;
b.free;


// 37. Nodos de Synth
// Cada vez que creamos un sinte en SC, sabemos que se ejecuta en el server. Cada sinte en ejecución es representado por un nodo. Podemos observar este árbol de nodos con s.plotTree.

// abrimos la GUI
s.plotTree;
// instanciamos uno a uno y observamos el árbol de nodos:
w = { SinOsc.ar(60.midicps, 0, 0.1) }.play;
x = { SinOsc.ar(64.midicps, 0, 0.1) }.play;
y = { SinOsc.ar(67.midicps, 0, 0.1) }.play;
z = { SinOsc.ar(76.midicps, 0, 0.1) }.play;
w.free;
x.free;
y.free;
z.free;

// Ejecutar de nuevo los 4 sintes y probar [Ctrl+.]
// Cada sinte recibe un nombre temporario (como temp_101) y permanecen ejecutándose en el server incluso si sólo generan silencio (ceros). Por ejemplo:

x = {WhiteNoise.ar(Line.kr(0.2, 0, 2))}.play;
x.free;

// 37.1 doneAction: 2

// Hay una forma de hacer a los sintes más inteligentes en este sentido. Le pedimos a Line que notifique al sinte cuando haya terminado su trabajo, y éste se liberará automáticamente.

s.plotTree

{WhiteNoise.ar(Line.kr(0.2, 0, 2, doneAction: 2))}.play;
{PlayBuf.ar(1, ~buf1, doneAction:2)}.play;

//Ayuda sobre más doneActions:
"UGen done-actions"

// 38. Envolventes

// Env es la clase de objetos que usaremos para definir todo tipo de envolventes. Tiene muchos métodos útiles, y varios tipos de curvas. Pueden verse en la ayuda:
Env

// 38.1 Env.perc
// Un buen ejemplo para comenzar es una envolvente percusiva. Tiene 4 argumentos: attackTime, releaseTime, level, curve. Veamos algunas formas típicas:

Env.perc.plot; // argumentos por defecto
Env.perc(0.5).plot; // attackTime: 0.5
Env.perc(attackTime: 0.3, releaseTime: 2, level: 0.4).plot;
Env.perc(0.3, 2, 0.4, 3).plot; // curve, probar con números positivos y negativos: 0 significa líneas rectas.

// Ahora podemos conectarla con un sinte. Todo lo que hacemos es agregar la invocación al método .kr(doneAction: 2) luego de Env.perc. De hecho, podemos simplemente escribir .kr(2), ya que doneAction es el primer argumento del método de instancia Env.kr.

{PinkNoise.ar(Env.perc.kr(doneAction: 2))}.play;
{PinkNoise.ar(Env.perc(0.5).kr(doneAction: 2))}.play;
{PinkNoise.ar(Env.perc(0.3, 2, 0.4).kr(2))}.play;
{PinkNoise.ar(Env.perc(0.3, 2, 0.4, 5).kr(2))}.play;

// 38.2 Env.triangle
// Sólo toma 2 argumentos: duration y level.

// Mire:
Env.triangle.plot;
// Escuche:
{SinOsc.ar([440, 442], mul: Env.triangle.kr(2))}.play;

// Una envolvente puede ser un multiplicador en cualquier lugar de su código
{SinOsc.ar([440, 442]) * Env.triangle.kr(2)}.play;

// 38.3 Env.linen
// Describe una envolvente trapezoidal con ataque, sustain y release. También podemos especificar level y curve.


// Mire:
Env.linen(1, 2, 1, 0.2, \sin).plot //sin = segmentos con forma de S
// Escuche:
{SinOsc.ar([300, 350], mul: Env.linen(0.01, 2, 1, 0.2).kr(2))}.play;

// 38.4 Env.pairs
// Si necesita más flexibilidad, con Env.pairs se pueden tener envolventes de cualquier forma y duración. Toma 2  argumentos: un array de pares [tiempo, nivel] y un tipo de curva.

(
{
	var env = Env.pairs([[0, 0.0001], [0.4, 1], [1, 0.2], [1.1, 0.5], [2, 0.0001]], \exp);
	env.plot;
	SinOsc.ar([440, 442], mul: env.kr(2));
}.play;
)

// El array se interpreta de esta forma: En el momento 0, estar en nivel 0, en el momento 0.4 estar en nivel 1, etc

// 38.4.1 Envolventes, no sólo para amplitud
// Las envolventes son una manera de controlar cualquier parámetro de un sinte que se modifique en el tiempo. Es necesario escalar las envolventes a los rangos deseados. Por ejemplo:

(
{
	var freqEnv = Env.pairs([[0, 100], [0.4, 1000], [0.9, 400], [1.1, 555], [2, 440]], \lin);
	SinOsc.ar(freqEnv.kr, mul: 0.2);
}.play;
)

// Finalmente, la opción más flexible: ejemplo de Env con distintas curvas para cada segmento:
Env.new([0, 1, 0.9, 0], [0.1, 0.5, 1],[-5, 0, -5]).plot;


// 38.5 Envolventes ADSR

// Todas las envolventes vistas hasta ahora tienen algo en común: tienen una duración fija predefinida. En algunas situaciones, sin embargo, este tipo de envolventes no es adecuado. Por ejemplo, cuando usamos un controlador MIDI. El ataque de la nota se dispara cuando presionamos una tecla. El release es cuando soltamos la tecla. Pero la cantidad de tiempo que mantenemos la tecla presionada no puede anticiparse. Lo que necesitamos es una envolvente sostenida. Luego del tiempo de ataque, la envolvente mantiene la nota por una cantidad indefinida de tiempo y sólo dispara la porción de release luego de algún tipo de mensaje. Veamos una envolvente ASR y una ADSR

// ASR
// Tocar la nota
// attackTime: 0.5 seg, sustainLevel: 0.8, releaseTime: 3 seg
x = {arg gate = 1, freq = 440; SinOsc.ar(freq: freq, mul: Env.asr(0.5, 0.8, 3).kr(doneAction: 2, gate: gate))}.play;
// Detener la nota
x.set(\gate, 0); // alternativamente, x.release
x.release;

// ADSR (attack, decay, sustain, release)
// Tocar la nota:
(
d = {arg gates = 1;
	var snd, env;
	env = Env.adsr(0.01, 0.4, 0.7, 2);
	snd = Splay.ar(BPF.ar(Saw.ar((32.1, 32.2..33)), LFNoise2.kr(12).range(100, 1000), 0.05, 10));
	Out.ar(0, snd * env.kr(doneAction: 2, gate: gates));
}.play;
)

// Detener la nota:
d.release; // En este caso no responde, porque sólo funciona si el argumento es gate!
d.set(\gates, 0)

// si no usamos doneAction: 2, podemos abrirlo nuevamente.
s.plotTree
d.set(\gates, 1)

// Conceptos clave:
// attackTime: tiempo en segundos hasta alcanzar el pico
// decayTime: tiempo en segundos hasta alcanzar  la amplitud de sustain
// sustainLevel: amplitud, entre 0 y 1, a la que se sostiene la nota
// releaseTime: tiempo en segundos hasta alcanzar el cero (silencio)

// Estas envolventes necesitan una notificación para disparar la porción de ataque y disparar la porción de release. Esta notificación se llama gate. El gate le indica a la envolvente cuando empezar(1) y cuando terminar (0).

// Es necesario declarar un argumento que sirva de gate en nuestro sinte. Normalmente, por defecto, gate = 1 porque queremos que el sinte comience a sonar inmediatamente. Cuando queremos que el sinte se detenga, podemos invocar al método .release o .set(\gate, 0).

// 38.6 EnvGen
// Debemos saber que las expresiones para generar envolventes que vimos en esta sección son "atajos"

// Esto:
{ SinOsc.ar * Env.perc.kr(doneAction: 2) }.play;
// ... es lo mismo que esto:
{ SinOsc.ar * EnvGen.kr(Env.perc, doneAction: 2) }.play;

// EnvGen es la UGen que finalmente reproduce los breakpoints de la envolvente definida por Env. Podemos seguir usando los atajos pero es recomendable conocer ambas notaciones, ya que veremos ambas formas en mucho código.

// 39. Definición de Sintes

// Hasta ahora hemos creado y ejecutado sintes en un solo paso. Además el mensaje .set nos dió alguna flexibilidad para controlar al sinte en tiempo real. Sin embargo es más eficiente definir primero el sinte y luego crear tantas instancias como necesitemos. Se reducen mensajes de red y costo de cpu.

// 39.1 SynthDef y Synth

// SynthDef es la clase que usamos para "escribir el algoritmo" de un sinte. Luego podemos ejecutarlo con Synth

s.plotTree

// Definición del sinte
SynthDef("sinte1", {Out.ar(0, SinOsc.ar(770, 0, 0.2))}).add;
// Tocamos una nota instanciando un Synth
x = Synth("sinte1");
x.free;

// El segundo argumento de SynthDef es una función de grafo de UGens (UGen graph func). Notar el uso explícito de Out.ar para indicar el bus de salida. El mensaje .add agrega nuestro sinte a una colección de sintes conocidos por SC. Éste existirá hasta que cerremos el programa.

// Una vez que hemos creado una definición de sinte con SynthDef, podemos tocarlo con Synth: el primer argumento es el nombre del sinte, el segundo es un array con pares de argumentos y valores.

// Un ejemplo más flexible usando argumentos y una envolvente con liberación automática
(
SynthDef("sinte2",
	{arg freq = 440, amp = 0.1;
		var env = Env.perc(level: amp).kr(2);
		var snd = SinOsc.ar(freq, 0, env);
		Out.ar(0, snd);
	}
).add;
)

Synth("sinte2"); // using default values
Synth("sinte2", [\freq, 770, \amp, 0.2]);
Synth("sinte2", [\freq, 415, \amp, 0.1]);
Synth("sinte2", [\freq, 346, \amp, 0.3]);
Synth("sinte2", [\freq, rrand(440, 880)]);

// 39.2 Ejemplo

// Luego de que el SyntheDef es agregado, se usa un truco con un array para crear acordes de 6 notas con alturas y amplitudes aleatorias. Cada sinte es almacenado en una posición del array, por lo tanto podemos liberarlos individualmente.

// Creamos el SynthDef
(
SynthDef("wow", {arg freq = 60, amp = 0.1, gate = 1, wowrelease = 3;
	var chorus, source, filtermod, env, snd;
	chorus = freq * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1, 1.02);
	source = LFSaw.ar(chorus) * 0.5;
	filtermod = SinOsc.kr(1/16).range(1, 10);
	env = Env.asr(1, amp, wowrelease).kr(2, gate);
	snd = LPF.ar(in: source, freq: freq * filtermod, mul: env);
Out.ar(0, Splay.ar(snd))
}).add;
)

// Probamos el sinte con una nota
{Synth("wow", [\freq, rrand(40, 70).midicps, \amp, rrand(0.1, 0.5)])}.play

// Node Tree
s.plotTree;

// Crea un acorde de 6 notas
a = Array.fill(6, {Synth("wow", [\freq, rrand(40, 70).midicps, \amp, rrand(0.1, 0.5)])});

// Release de las notas, individualmente
a[0].set(\gate, 0);
a[1].set(\gate, 0);
a[2].set(\gate, 0);
a[3].set(\gate, 0);
a[4].set(\gate, 0);
a[5].set(\gate, 0);

// Avanzado: luego de disparar el acorde.
// Puede imaginarse qué está sucediendo?
SystemClock.sched(0,
	{a[5.rand].set(\freq, rrand(40, 70).midicps); rrand(3, 6)}
);

// Para ayudarnos a entender el ejemplo:

// El sonido resultante es la suma de 7 osciladores diente de sierra levemente desafinados que pasan por un filtro pasa bajos. Son creados usando expansión multicanal
// La variable chorus es la frecuencia multiplicada por LFNoise2.kr con expansión multicanal. 7 copias de LFNoise2 se crean a diferentes velocidades tomadas del array. La salida de cada LFNoise es escalada a un rango entre 1.0 y 1.02. Por ejemplo, para una freq de 60Hz, chorus resulta en una expresión como esta: 60 * [1.01, 1.009, 1.01, 1.02, 1.015, 1.004, 1.019], y estos número varían entre 1.0 y 1.02 a las frecuencias indicadas en el array [0.4, 0.5, 0.7, 1, 2, 5, 10]. El resultado final es una lista de 7 frecuencias siempre variando entre 60 y 61.2 (60 * 1.02). Esto nos da el efecto chorus.

// CUando usamos la variable chorus como la freq de LFSaw.ar, sucede una expansión multicanl y obtenemos 7 ondas diente de sierra con frecuencias diferentes pero cercanas.

// filtermod es un oscilador sinusoidal que se mueve muy lento (1 ciclo cada 16 segundos), con su salida escalada al rango 1..10. Se usará para modular la frecuencia de corte de todas las copias de LPF. Aquí no hay expansión multicanal, porque el argumento es escalar.

// snd almacena la salida del LPF, que toma como entrada a las diente de sierra. La frecuencia de corte no es fija, está dada por freq * filtermod. Por ejemplo, si freq = 60, la frecuencia de corte se mueve entre 60 y 600.

// LPF se expande a 7 copias y se les aplica env como multiplicador de salida. Finalmente, Splay toma este arreglo de 7 canales y lo mezcla a estéreo.

// 39.3 El detrás de escena del {}.play
// Cuando escribimos una sentencia tan sencilla como {SinOsc.ar}.play, SC crea un SynthDef temporario e inmediatamente lo ejecuta (por eso los nombres temp_01...)

// Cuando escribimos esto:
{SinOsc.ar(440)}.play;
// Supercollider hace esto:
{Out.ar(0, SinOsc.ar(440))}.play;
// Que a su vez se traduce en esto otro:
SynthDef("tempName", {Out.ar(0, SinOsc.ar(440))}).play;

// Todos son atajos de esta operación de dos pasos:
SynthDef("tempName", {Out.ar(0, SinOsc.ar(440))}).add;
Synth("tempName");

// 40. Pbind puede usar un SynthDef creado por nosotros
// Asumiendo que el sinte anterior todavía está cargado en memoria, probar el siguiente código:

(
Pbind(
	\instrument, "wow",
	\scale, Pstutter(8, Pseq([
		Scale.lydian,
		Scale.major,
		Scale.mixolydian,
		Scale.minor,
		Scale.phrygian], inf)),
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\dur, 0.2,
	\amp, Pwhite(0.5, 0.9),
	\wowrelease, 2,
	\legato, 0.1
).trace.play;
)

(
Pbind(
	\instrument, "wow",
	\degree, Pwhite(-7, 7),
	\dur, Prand([0.125, 0.25], inf),
	\amp, Pwhite(0.4, 0.8),
	\wowrelease, 1
).play;
)

// Al usar Pbind para tocar nuestros SynthDef, recordar los siguientes puntos:
// 1) usar la clave \instrument para indicar el nombre de nuestro sinte.
// 2) todos los argumentos de nuestro SynthDef son accesibles usándolos como claves del Pbind. Por ejemplo, wowrelease en el ejemplo anterior no es una clave concida por Pbind, por defecto
// Para poder usar las funciones de conversión de alturas de Pbind (\note, \midinote y \degree), asegurarnos que nuestro SynthDef tenga un argumento "freq" (tiene que ser escrito tal cual está entre comillas). Pbind hará las matemáticas por nostros
// Si usamos una envolvente sostenida, como Env.adsr, asegurarnos que nuestro sinte tiene un argumento "gate". Pbind lo usa para detener las notas en el momento correcto.
// Si no usamos una envolvente sostenida, debemos asegurarnos que nuestro SynthDef incluya un "doneAction: 2" en una UGen apropiada para liberar automáticamente el nodo del sinte en el servidor.

// Ejercicio: escribir uno o más Pbinds para tocar el sinte "pluck" escrito abajo. Para el argumento mutedString, usar valores entre 0.1 y 0.9. Crear un Pbind que toque una secuencia lenta de acordes. Arpegiar los acordes con \strum.

(
SynthDef("pluck", {arg amp = 0.1, freq = 440, decay = 5, mutedString = 0.1;
var env, snd;
env = Env.linen(0, decay, 0).kr(doneAction: 2);
snd = Pluck.ar(
        in: WhiteNoise.ar(amp),
        trig: Impulse.kr(0),
        maxdelaytime: 0.1,
        delaytime: freq.reciprocal,
        decaytime: decay,
        coef: mutedString);
    Out.ar(0, [snd, snd]);
}).add;
)

// Pdef, útil para Live Coding
(
Pdef(\x,
	Pbind(
		\instrument, "pluck",
		\degree, Prand((0..7), inf),
		\scale, Scale.lydian,
		\ctranspose, 3,
		\mutedString, 0.8,
		\dur, Prand([1/8, 1/6, 1/7], inf)
	)
).play();
)

// 41.Buses de Control

// Rutean señales de control. Los creamos y administramos de la misma forma que los buses de audio, usando .kr en lugar de .ar. SC tiene 4096 buses de control por defecto.

// Escribe una señal de control en el bus 55
{Out.kr(55, LFNoise0.kr(1))}.play;

// Lee la señal de control
{In.kr(55).poll}.play;

// Usando la clase Bus
~myControlBus = Bus.control(s, 1);
{Out.kr(~myControlBus, LFNoise0.kr(5).range(440, 880))}.play;
{SinOsc.ar(freq: In.kr(~myControlBus))}.play;

// El próximo ejemplo muestra una única señal usada para controlar dos sintes diferentes al mismo tiempo. En el sinte Blip se usa para controlar el número de armónicos entre 1 y 10. En el segundo sinte se escala para modular la frecuencia del oscilador Pulse.

// Crea el bus de control
~myControl = Bus.control(s, 1);

// Envía la señal de control al bus
c = {Out.kr(~myControl, Pulse.kr(freq: MouseX.kr(1, 10), mul: MouseY.kr(0, 1)))}.play;

// Sonidos controlados por mouse
(
{
	Blip.ar( // Band limited impulse oscillator.
		freq: LFNoise0.kr([1/2, 1/3]).range(50, 60),
		numharm: In.kr(~myControl).range(1, 10),
		mul: LFTri.kr([1/4, 1/6]).range(0, 0.1))
}.play;

{
	Splay.ar(
		Pulse.ar(
			freq: LFNoise0.kr([1.4, 1, 1/2, 1/3]).range(100, 1000)
			* In.kr(~myControl).range(0.9, 1.1),
			mul: SinOsc.ar([1/3, 1/2, 1/4, 1/8]).range(0, 0.03))
	)
}.play;

)

// Apagar la señal de control para comparar el audio
c.free;


// 41.1 asMap
// El método .asMap se usa para mapear directamente un bus de control en el nodo de un sinte que se está ejecutando. De esta forma no necesitamos In.kr en la definición del sinte.

// SynthDef
SynthDef("simple", {arg freq = 440; Out.ar(0, SinOsc.ar(freq, mul: 0.2))}).add;

// Buses de control
~oneBus = Bus.control(s, 1);
~anotherBus = Bus.control(s, 1);

// Señales de control
{Out.kr(~oneBus, LFSaw.kr(1).range(100, 1000))}.play;
{Out.kr(~anotherBus, LFSaw.kr(2, mul: -1).range(500, 2000))}.play;

// Una nota
x = Synth("simple", [\freq, 800]);
x.set(\freq, ~oneBus.asMap);
x.set(\freq, ~anotherBus.asMap);
x.free;

// 42. Orden de ejecución

// Buses de Audio
~fxBus = Bus.audio(s, 1);
~masterBus = Bus.audio(s, 1);

// SynthDefs
(
SynthDef("noise", {Out.ar(~fxBus, WhiteNoise.ar(0.5))}).add;
SynthDef("filter", {Out.ar(~masterBus, BPF.ar(in: In.ar(~fxBus), freq: MouseY.kr(1000, 5000), rq: 0.1))}).add;
SynthDef("masterOut", {arg amp = 1; Out.ar(0, In.ar(~masterBus) * amp)}).add;
)

// Node Tree window:
s.plotTree;

// (mirar Node Tree)
m = Synth("masterOut");
f = Synth("filter");
n = Synth("noise");

// Master volume
m.set(\amp, 0.1);

// Tenemos dos buses de audio y tres sintes: noise -> filter -> masterOut

// Los nodos Synth en la ventana Node Tree se calculan de arriba hacia abajo. El sinte más recientemente creado se agrega arriba de todo, por defecto.

// Si intentamos evaluar las líneas m, f y n en orden inverso, no tendremos sonido porque las señales se están calculando en el orden incorrecto.

// Para que esto sea más fácil, SC nos permite definir dónde ubicar los sintes en el árbol de nodos. Para esto se utilizan los argumentos target y addAction.

n = Synth("noise", addAction: 'addToHead');
m = Synth("masterOut", addAction: 'addToTail');
f = Synth("filter", target: n, addAction: 'addAfter');

// Ahora, sin importar en qué orden evaluamos las líneas, los nodos se ordenarán correctamente.

// 42.1 Grupos

// Cuando tenemos muchos sintes - algunos son fuente de sonido, otros procesadores de sonido - es buena idea organizarlos en grupos.

// Observar
s.plotTree;

// Buses de audio
~reverbBus = Bus.audio(s, 2);
~masterBus = Bus.audio(s, 2);

// Definimos los grupos
(
~sources = Group.new;
~effects = Group.new(~sources, \addAfter);
~master = Group.new(~effects, \addAfter);
)

// Ejecutamos todos los sintes simultáneamente
(
// Una fuente
{
	Out.ar(~reverbBus, SinOsc.ar([800, 890]) * LFPulse.ar(2) * 0.1)
}.play(target: ~sources);

// Otra fuente
{
	Out.ar(~reverbBus, WhiteNoise.ar(LFPulse.ar(2, 1/2, width: 0.05) * 0.1))
}.play(target: ~sources);

// Reverb
{
	Out.ar(~masterBus, FreeVerb.ar(In.ar(~reverbBus, 2), mix: 0.5, room: 0.9))
}.play(target: ~effects);

// Control de volumen con el mouse, en el master
{Out.ar(0, In.ar(~masterBus, 2) * MouseY.kr(0, 1))}.play(target: ~master);
)

// Para más información sobre orden de ejecución mirar la ayuda en:
Synth
Order of Execution
Group
