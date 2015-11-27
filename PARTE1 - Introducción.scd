
// =========================== INTRODUCCION SUPERCOLLIDER
// Basado en material de Bruno Ruviaro, Nicolas Varchausky, Joshua Parmenter y Matias Zabaljauregui

/*
SuperCollider 3 es un lenguaje interpretado de alto nivel basado en Smalltalk, implementado en C/C++. Tiene influencias de Java y otros lenguajes orientados a objetos y funcionales.

Esta construido en base a un modelo cliente/servidor. Los usuarios escriben "programas cliente" a traves de los cuales le envian instrucciones al servidor. Esta estructura de cliente y servidor permite que las comunicaciones no sean necesariamente locales, es decir, que no tengan que ocurrir exclusivamente en una misma maquina. Mientras cliente y servidor esten comunicados a traves de una red, la distribucion de mensajes puede realizarse de manera remota entre una o mas computadoras. Incluso la maquina cliente y la maquina servidor puede estar distintos lugares del mundo.

SC 3 es entonces la combinacion de 2 programas principales:

1. scsynth
Es el motor de sintesis (server); el que genera sonido.

2. sclang
Es el lenguaje (cliente) que utilizamos para comunicarnos con el server. Realiza dos tareas: interpreta el lenguaje de programacion SuperCollider y se comunica con el server via OSC (Open Sound Control). A traves del cliente enviamos instrucciones al server para que produzca sonido con las caracterisitcas que definimos desde el lenguaje.

Se pueden usar otros programas cliente, como PureData, Max/Msp, Python, Processing, Java, Open Frameworks. Basicamente, podemos usar cualquier programa que pueda enviar mensajes OSC. Sin embargo, sclang, el lenguaje desarrollado por James McCartney es por lejos el mas poderoso para controlar el motor de sintesis.
*/

// para una descripcion mas detallada (y con graficos) de la estructura de cliente/servidor:
ClientVsServer // seleccione y presione cmd-d para acceder al grafico


// =========================== PROGRAMACION ORIENTADA A OBJETOS (OOP)

/*
La Programacion Orientada a Objetos hace hincapie en el manejo de estructuras de datos, y en una interfaz para acceder, setear y cambiar los datos que esas estructuras contienen.

SuperCollider es un lenguaje de programacion orientado a objetos. Piense en un objeto como en una herramienta con caracteristicas determinadas que puede realizar una serie de tareas especificas. En SuperCollider TODO es un objeto. Se pueden crear multiples instancias de un objeto que pueden estar activas simultaneamente. Un objeto contiene datos sobre su estado, a los que llamamos variables (que uno puede obtener y/o setear). Las operaciones que realizamos sobre esos datos las llamamos metodos. */

// =========================== INTRO A SCLANG: EL LENGUAJE DE SUPERCOLLIDER (CLIENTE)
/*
Utilizando el lenguaje de Supercollider crearemos las definiciones de sintesis (SynthDef), a traves de las cuales definiremos como generar un sonido particular.

Tambien usamos el cliente para programar en que momento un sonido particular sera ejecutado. El servidor recibira estas instrucciones y sintetizara el audio.
*/

// =========================== BASICOS DEL LENGUAJE

/* El lenguaje utiliza un editor de texto para escribir las instrucciones que enviara al server. Estas instrucciones, nuestro codigo, se guarda como un archivo de texto. Podemos tambien guardarlo como html, plain text (scd) y como archivo de clase (sc - utilizado para crear una Clase). El editor contiene las funciones basicas de cualquier procesador de textos (copiar, pegar, buscar, reemplazar, etc); mas algunas funciones especificas que nos ayudaran a programar con mayor facilidad.

Al arrancar SC, aparecera la Post Window, una ventana en la que SC posteara informacion diversa, como los mensajes de error, resultados de nuestro codigo, lo que retorne una funcion, etc. Lo primero que vemos es el resultado de la inicializacion del programa y de la compilacion de sus librerias.

*CONSEJO* A medida que nuestros codigos se vuelvan cada vez mas complejos y extensos, puede resultar util incluir mensajes de posteo que luego haran mas sencillo el debugging.
*/

// Que es el IDE de SuperCollider? (Integrated Development Environment)
// Veamos la ayuda
SuperCollider IDE


//1.Hello World
"Hello World".postln;

//Tu primer onda sinusoidal: el Hello World de SC

//alto volumen!
{SinOsc.ar}.play

//mas interesante
{SinOsc.ar(LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;

//consejo: tipear los ejemplos, no copiar y pegar, es una buena forma de ganar confianza en el lenguaje


// ================= SISTEMA DE AYUDA
/*
Para acceder al menu de ayuda principal use el menu de ayuda en la solapa de SC.

Tambien puede seleccionar el nombre de una clase y presionar command-d para acceder el archivo de ayuda de esa clase (si Esta disponible):
*/

SinOsc;

// ================= COMENTARIOS

// la doble barra comenta una linea.

/* asi se comenta un bloque de codigo,
ubicandolo entre barras y estrellas - rojo */


//Se pueden evaluar lineas incluso si el cursor esta sobre los comentarios

/* con [ctrl+/]  , se activa y desactiva esa linea como comentario */


// ================= COLORACION

Classes // azul
\symbols // verde
'symbols' // verde
"Strings" // gris
thisProcess // palabras clave reservadas tambien en azul - aunque no son comunes.
10.0 // numeros en magenta
SinOsc.new // metodos en negro
// comentarios en rojo!!!!

// ================= SHORTCUTS BASICOS

{SinOsc.ar(440, 0, 0.25)}.play;

// para evaluar una linea o un bloque de codigo
cmd Return // no confundir con 'return' - MacOSX
ctrl Return	// Windows
ctrl E	// Linux-gedit

// para detener la ejecucion, o panic button
cmd-punto	//  MacOSX
ctrl-punto	// Windows
esc 		// Linux-gedit

// para acceder a los archivos de ayuda, seleccionar y presionar
cmd+d // MacOSX
ctrl+d // Windows
ctrl+u // Linux-gedit

// para borrar Post Window (la ventana de mensajes)
cmd-shift-p // MacOSX/Windows


// para pegar nuestro codigo manteniendo la font y el tamano del destino: shift-alt-cmd+v

// para comentar y descomentar, seleccionar y presionar cmd-/


// ================= EVALUACION
/*Las lineas de codigo terminan en punto y coma.

El punto ('.') es el operador de mensajes. Envia el mensaje ubicado a su derecha al objeto ubicado a su izquierda.
*/

"Soy una linea de codigo".postln;

// ================= PARENTESIS

//Los parentesis encierran un bloque de codigo.
//Ubique el cursor en la parte externa de uno de ellos o haga doble-click sobre uno de ellos para seleccionar todo el codigo entre los parentesis y evalue todo el bloque presionando cmd-return.


(    //comienza bloque
"Estoy dentro de un bloque".postln;
10 + 30
)   //termina bloque

// Siempre se retorna lo ultimo evaluado en ese bloque de codigo. Aparecera posteado en el interprete.

// Una linea de codigo que no termine en punto y coma dara un error
(
"Estoy dentro de un bloque".postln
10 + 20;
)

// ================= VARIABLES
/* Las variables son espacios de memoria temporaria.
Cualquier letra sola en minuscula es una variable GLOBAL. Puede pensar en ellas como variables accesibles desde cualquier parte del codigo. Son utiles para ejemplos breves.

***CUIDADO***, la letra 's' es especial, ya que designa por default al Server.

Un bloque de codigo tambien ayuda a definir el alcance de las variables. Las variables se declaran al inicio del bloque de codigo y por convencion variables deben comenzar con minuscula. Podemos nombrar a las variables con cualquier nombre que se nos ocurra. Es de buena praxis nombrarlas de manera descriptiva de la clase de valor o dato que contendra.

Por convencion, nombramos las variables con mas de una palabra de esta manera:
variableConMuchasPalabras
variable_con_muchas_palabras
*/

(
var cifra; // con 'var' definimos una variable
cifra = 30;
"El valor de cifra es: ".post;
cifra.postln;
)

cifra; // esta variable esta FUERA del alcance del bloque de codigo por lo tanto tira un error.

// ================= FUNCIONES
// Las Funciones aparecen entre { } Pueden tener argumentos y variables. A traves de los argumentos, enviamos data desde afuera al interior de la Funcion.

(
var cuenta, resultado;
// con 'arg' definimos nuestros argumentos
cuenta = {arg val1=2, val2=1, val3;
	var val;
	val = (val1 * val2) + val3;
};

// El mensaje "value" le indica a una Funcion que ejecute su metodo de evaluacion.
resultado = cuenta.value(2, 3, 4); // el orden de los valores se corresponde con el de los argumentos
resultado.postln;
("El primer resultado da: " ++ resultado).postln;

resultado = cuenta.value(3, 4, 5); // la variable resultado se sobreescribe y se le asigna un nuevo valor
("El segundo resultado da: " ++ resultado).postln;
"SC siempre devuelve el ultimo objeto del bloque"
)

// NOTA: Hay mucho mas sobre Funciones

// ================= ORDEN DE EJECUCION - PRECEDENCIA
//El codigo en SC es leido por el compilador de arriba-abajo, izquierda-derecha y de haber codigo anidado, del interior al exterior. Pero ignora los espacios.

//Se ignora la precedencia matematica
//Cuando combinamos mensajes y operaciones binarias, los mensajes tienen precedencia. Ej:

// 5 + 2.squared ,   primero se evalua 2.squared

// Usamos parentesis para forzar la precedencia:
(
var resultado;
resultado = 3 + 10 * 2;
"resultado es: ".post;
resultado.postln;

// queremos que la multiplicacion se evalue antes que la suma
resultado = 3 + (10 * 2);
"resultado ahora es: ".post;
resultado.postln;
)

// =========================== Funciones con UGens

//La posicion del mouse nos da el valor de frecuencia
{Pan2.ar(SinOsc.ar(MouseX.kr(440,880),0,0.1),0.0)}.play

// Una funcion mas compleja
(
{
var n = 11; 	//probemos cambiar este valor por otros...
Resonz.ar(
	Mix.fill(n,{
		var freq=rrand(50,560.3);
		var numcps= rrand(2,20);
		Pan2.ar(Gendy1.ar(6.rand,6.rand,1.0.rand,1.0.rand,freq ,freq, 1.0.rand, 1.0.rand, numcps, SinOsc.kr(exprand(0.02,0.2), 0, numcps/2, numcps/2), 0.5/(n.sqrt)), 1.0.rand2)
		}),
	MouseX.kr(100,2000),
	MouseY.kr(0.01,1.0)
	);
}.play
)

// =========================== MAS SOBRE EL LENGUAJE

Shortcuts
Syntax-Shortcuts // para no tipear tanto
SymbolicNotations // Un catalogo de notacion simbolica (usando simbolos en lugar de mensajes)
Literals // values with a direct representation (ex: a 2 is a 2 is a 2)



//Documentacion basada en el tutorial de Bruno Ruviaro llamado
//"A Gentle Introduction to SuperCollider", 2014

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

// por defecto la variable s almacena al localhost

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



//5.Cambiando parametros
// Un ejemplo. No trate de entendor todo. Simplemente disfrute del sonido y juegue con los numeros

{RLPF.ar(Dust.ar([12, 15]), LFNoise1.ar([0.3, 0.2]).range(100, 3000), 0.02)}.play;

//Cambiar los numeros y volver a evaluar. Uno a la vez. Explicar los cambios.
//Puede encontrar resultados sonicos interesantes incluso sin entender cada parametro
// Resonant Low Pass Filter // Dust = pulsos aleatorios // Ruido LF, interpola lineal

// los archivos SC tienen extension .scd por supercollider document. Hay otros con extension .sc que veremos despues (contienen definiciones de clases, SynthDefs, y otros).



//11. Grabar facilmente la salida de SC

//comenzar
s.record;

//hacer algunos sonidos, ojo con el volumen
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

~galaApples; // todavia existe
apples; // esta no



//REASIGNACION DE VARIABLES
// una practica que puede confundirlos es cuando la variables misma
// se usa en la expresion de reasignacion

x = 10
x = x + 1

// en programacion el signo igual no es como la igualdad matematica donde x = x + 1 nunca puede ser verdad

