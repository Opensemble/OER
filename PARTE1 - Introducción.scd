// =========================== INTRODUCCIÓN SUPERCOLLIDER

/*
SuperCollider 3 es un lenguaje interpretado de alto nivel basado en Smalltalk, implementado en C/C++.
Tiene influencias de Java y otros lenguajes, orientados a objetos y funcionales.

Esta construido en base a un modelo cliente/servidor. Los usuarios escriben "programas cliente" a traves de los cuales le envian instrucciones al servidor. Esta estructura permite que las comunicaciones no sean necesariamente locales, es decir, que no tengan que ocurrir exclusivamente en una misma máquina. Mientras cliente y servidor estén comunicados a través de una red, la distribución de mensajes puede realizarse de manera remota entre una o más computadoras. Incluso la máquina cliente y la máquina servidor pueden estar en distintos lugares del mundo. O en la misma máquina.

SC 3 es entonces la combinacion de 2 programas principales:

1. scsynth (SC-synthesizer)
Es el motor de síntesis (server), el que genera sonido.

2. sclang (SC-language)
Es el lenguaje (cliente) que utilizamos para comunicarnos con el server.
Realiza dos tareas: interpreta el lenguaje de programación SuperCollider y se comunica con el server via OSC (Open Sound Control).
A través del cliente enviamos instrucciones al server para que produzca sonido con las características que definimos desde el lenguaje.

Se pueden usar otros programas cliente, como PureData, Max/Msp, Python, Processing, Java, Open Frameworks. Básicamente, podemos usar cualquier programa que pueda enviar mensajes OSC. Sin embargo, sclang, el lenguaje desarrollado por James McCartney es por lejos el más poderoso para controlar el motor de síntesis.
*/

// para una descripcion más detallada (y con gráficos) de la estructura de cliente/servidor:
ClientVsServer // seleccione y presione [ctl+d](windows)/[cmd+d](mac) para acceder al gráfico.

//Client vs Server

// Se comunican usando OSC. Necesitamos saber la dir IP y el puerto
// por ejemplo 127.0.0.1  y   57110

// Toda la generacion de sonido sucede en el server y la mayoria del
// control sucede en el lenguaje SC (sclang) u otros lenguajes o interfaces
// que envian OSC al servidor. Otros clientes: Haskell, Python, Ruby, Processing, OF, etc

// Tenemos dos posibilidades cuando usamos una sola compu:
// localhost e internal
// El server internal es parte del mismo espacio de memoria del lenguaje
// El server localhost es un proceso separado corriendo en la misma maquina

// la variable s referencia al server

s.postln
s.addr
s.name
s.serverRunning
s.avgCPU

// iniciar y detener
s.boot
s.quit

//si queremos usar el internal, por defecto
s = Server.internal
Server.default = s
s.boot

//podemos crear nuestros propios servers para controlar por red

//por ahora usemos el server local, que es el default
Server.default = s = Server.local
s.boot

// =========================== PROGRAMACIÓN ORIENTADA A OBJETOS

/*
SuperCollider es un lenguaje de programacion orientado a objetos.

En SuperCollider todo es un objeto. Se pueden crear múltiples instancias de un objeto que pueden estar activas simultáneamente. Un objeto contiene datos sobre su estado, a los que llamamos variables. Las operaciones que realizamos sobre esos datos las llamamos métodos.
*/

// =========================== INTRO A SCLANG
/*
Utilizando el lenguaje de Supercollider crearemos las definiciones de síntesis (SynthDef), a través de las cuales definiremos cómo generar un sonido particular.

También usamos el cliente para programar en qué momento un sonido será ejecutado. El servidor recibirá estas instrucciones y sintetizará el audio.
*/

// =========================== BÁSICOS DEL LENGUAJE

/*
El lenguaje utiliza un editor de texto para escribir las instrucciones que enviará al server. Estas instrucciones, nuestro código, se guarda como un archivo de texto. Podemos también guardarlo como html, plain text (scd) y como archivo de clase (sc - utilizado para crear una Clase). El editor contiene las funciones básicas (copiar, pegar, buscar, reemplazar, etc), más algunas funciones específicas que nos ayudarán a programar con mayor facilidad.

Al arrancar SC, aparecerá la Post Window, una ventana en la que SC posteará información diversa, como los mensajes de error, resultados de nuestro código, lo que retorne una función, etc. Lo primero que vemos es el resultado de la inicialización del programa y de la compilación de sus librerias.
*/

// Qué es el IDE de SuperCollider? (Integrated Development Environment)
// Veamos la ayuda
SuperCollider IDE

//1.Hello World
"Hello World".postln;

//Tu primer onda sinusoidal: el Hello World de SC
//(alto volumen!)
//(bootear el server primero)
{SinOsc.ar}.play

//mas interesante
{SinOsc.ar(LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;

//consejo: tipear los ejemplos, no copiar y pegar, es una buena forma de ganar confianza en el lenguaje

// ================= SISTEMA DE AYUDA
/*
Para acceder al menu de ayuda principal use el menu de ayuda en la solapa de SC.

Tambien puede seleccionar el nombre de una clase y presionar command+d o control+d para acceder el archivo de ayuda de esa clase (si está disponible):
*/

SinOsc

// ================= COMENTARIOS

// la doble barra comenta una linea.

/* así se comenta un bloque de codigo,
ubicandolo entre barras y estrellas - rojo */


//Se pueden evaluar líneas de código incluso si el cursor esta sobre los comentarios

/* con [ctrl+/]  , se activa y desactiva esa linea como comentario */


// ================= COLORACION

Classes // azul
\symbols // verde
'symbols' // verde
"Strings" // gris
thisProcess // palabras clave reservadas tambien en azul - aunque no son comunes.
10.0 // numeros en magenta
SinOsc.new // métodos en negro
// comentarios en rojo

// ================= SHORTCUTS BASICOS

{SinOsc.ar(440, 0, 0.25)}.play;

// para evaluar una línea o un bloque de código
cmd Return // MacOSX
ctrl Return	// Windows
ctrl E	// Linux-gedit

// para detener la ejecución, o panic button
cmd+punto	//  MacOSX
ctrl+punto	// Windows
esc 		// Linux-gedit

// para acceder a los archivos de ayuda, seleccionar y presionar
cmd+d // MacOSX
ctrl+d // Windows
ctrl+u // Linux-gedit

// para borrar Post Window (la ventana de mensajes)
cmd+shift+p // MacOSX/Windows


// ================= EVALUACIÓN

/*Las líneas de codigo terminan en punto y coma.
El punto ('.') es el operador de mensajes.
Envía el mensaje ubicado a su derecha al objeto ubicado a su izquierda.
*/

"Soy una linea de codigo".postln;

// ================= PARÉNTESIS

//Los paréntesis encierran un bloque de código.
//Ubique el cursor en la parte externa de uno de ellos o haga doble-click sobre uno de ellos para seleccionar todo el código entre los paréntesis, y luego evalúe.

(    //comienza bloque

"Estoy dentro de un bloque".postln;
10 + 30

)   //termina bloque

// Siempre se retorna lo último evaluado en ese bloque de código. Aparecerá posteado en el intérprete.

// Una línea de código que no termine en punto y coma dará un error
(
"Estoy dentro de un bloque".postln
10 + 20;
)

// ================= VARIABLES

/* Las variables son espacios de memoria temporaria.
Cualquier letra sola en minúscula es una variable GLOBAL. Puede pensar en ellas como variables accesibles desde cualquier parte del código. Son útiles para ejemplos breves.

*CUIDADO*, la letra 's' es especial, ya que designa por default al Server.

Un bloque de código tambien ayuda a definir el alcance de las variables. Las variables se declaran al inicio del bloque y, por convención, las variables deben comenzar con minúscula. Podemos nombrar a las variables con cualquier nombre que se nos ocurra. Es de buena práxis nombrarlas de manera descriptiva de la clase de valor o dato que contendrá.

Por convencion, nombramos las variables con más de una palabra de esta manera:
variableConMuchasPalabras
variable_con_muchas_palabras
*/

(
var cifra; // con 'var' definimos una variable
cifra = 30;
"El valor de cifra es: ".post;
cifra.postln;
)

cifra; // esta variable esta FUERA del alcance del bloque de codigo

// ================= FUNCIONES

// Las Funciones aparecen entre {llaves}. Pueden tener argumentos y variables. A través de los argumentos, enviamos data desde afuera al interior de la funcion.

//Las funciones son objetos
a = {3 + 4};
a;
a.value;

(
var cuenta, resultado;

// con 'arg' definimos nuestros argumentos
cuenta = {arg val1 = 2, val2 = 1, val3;
	var val;
	val = (val1 * val2) + val3;
};

// El mensaje "value" le indica a una Funcion que ejecute su metodo de evaluación.
resultado = cuenta.value(2, 3, 4); // el orden de los valores se corresponde con el de los argumentos

//resultado.postln;
("El primer resultado da: " ++ resultado).postln;

resultado = cuenta.value(3, 4, 5); // la variable resultado se sobreescribe y se le asigna un nuevo valor

("El segundo resultado da: " ++ resultado).postln;

"SC siempre devuelve el ultimo objeto del bloque"
)

// NOTA: Hay mucho más sobre funciones

// ================= ORDEN DE EJECUCIÓN - PRECEDENCIA

//El código en SC es leído por el compilador de arriba-abajo, izquierda-derecha y, de haber código anidado, del interior al exterior. Pero ignora los espacios.

//Cuando combinamos mensajes y operaciones binarias, los mensajes tienen precedencia. Ej:

// 5 + 2.squared ,   primero se evalua 2.squared

//Se ignora la precedencia matemática
// Usamos paréntesis para forzar la precedencia:
(
var resultado;

resultado = 3 + 10 * 2;
"resultado es: ".post;
resultado.postln;

// Queremos que la multiplicación se evalúe antes que la suma
resultado = 3 + (10 * 2);
"resultado ahora es: ".post;
resultado.postln;
)

// =========================== Funciones con UGens

//La posición del mouse nos da el valor de frecuencia
{Pan2.ar(SinOsc.ar(MouseX.kr(440,880),0,0.1),0.0)}.play

// Una función más compleja
(
{
var n = 11; 	//probemos cambiar este valor por otros...
Resonz.ar(
	Mix.fill(n,{
		var freq = rrand(50, 560.3);
		var numcps = rrand(2, 20);
		Pan2.ar(Gendy1.ar(6.rand, 6.rand, 1.0.rand, 1.0.rand, freq, freq, 1.0.rand, 1.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
		}),
	MouseX.kr(100,2000),
	MouseY.kr(0.01,1.0)
	);
}.play
)

// MÁS SOBRE EL LENGUAJE:

Shortcuts //(keyboard shortcuts)
Syntax-Shortcuts // equivalencias sintácticas en el compilador
SymbolicNotations // Un catálogo de notación simbólica (usando símbolos en lugar de mensajes)
Literals // valores con una representación sintáctica directa


//5.Cambiando parámetros
// Un ejemplo. No trate de entendor todo. Simplemente disfrute del sonido y juegue con los números

{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.02)}.play;

//Cambiar los números y volver a evaluar. Uno a la vez. Explicar los cambios.
//Puede encontrar resultados sónicos interesantes incluso sin entender cada parámetro
// Resonant Low Pass Filter // Dust = pulsos aleatorios // Ruido LF, interpolación lineal

// Los archivos SC tienen extensión .scd por supercollider document. Hay otros con extensión .sc que veremos después (contienen definiciones de clases, SynthDefs, y otros).

//11. Grabar facilmente la salida de SC

//comenzar
s.record;

//hacer algunos sonidos, cuidado con el nivel de salida
{Saw.ar(LFNoise1.kr([2, 3]).range(500, 2000), LFPulse.kr([4, 5]))}.play

//parar
s.stopRecording;

//opcional: GUI con boton de record, volumen, mute
s.makeWindow;

//Para mas info, leer la ayuda de la clase Server, en la seccion "Recording Support"
Server

//12. Variables

//empiezan con minuscula
//pueden llevar numeros, underscore y mayusculas
//globales y locales

//GLOBALES: letras minusculas y las que empiezan con ~
// ya vimos que s esta reservada para el server
// detalles: las que empiezan con tilde son varialbes de entorno y las letras son variables de interprete. Mirar el capitulo 5 del SC Book sobre este tema

//LOCALES
//minusculas: cualquier nombre. Alcance y tiempo de vida limitados a bloque
//se declaran con la palabra clave var.  Se puede inicializar en la declaracion
var x = 5;

//otro ejemplo:

//Variables de entorno

~galaApples = 4;
~bloodOranges = 5;
~limes = 2;
~plantains = 1;

["Citrus", ~bloodOranges + ~limes];

["NonCitrus", ~plantains + ~galaApples];

// Variables locales, viven solo dentro del bloque de codigo
(
var apples = 4, oranges = 3, lemons = 8, bananas = 10;

["Citrus fruits", oranges + lemons].postln;
["NonCitrus fruits", bananas + apples].postln;
"End".postln;
)

~galaApples; // todavía existe
apples; // esta no

// Reasignación de variables
// Una práctica que puede confundir: la misma variables se usa en la expresión de reasignación:

x = 10
x = x + 1

// En programación el signo igual no es como la igualdad matemática donde x = x + 1 nunca puede ser verdad
