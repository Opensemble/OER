//PARTE 3
//Más acerca del lenguaje

// 16.Objetos, clases, mensajes, argumentos

// Todo en SC es un objeto. Incluso los números. Podemos requerir cierta info o acción por parte de un objeto enviándole un mensaje. Cuando escribimos 2.squared, el mensaje squared se le envía al objeto 2. El objeto ejecuta el método asociado.

// Las clases definen un tipo de objeto. Se ordenan en una jerarquía de clases. Es una forma de reutilizar clases definidas previamente.
// Ejemplos de jerarquías en carpeta de figuras

// La estructura básica de una expresión que involucra un objeto es RECEPTOR.MENSAJE(ARGUMENTOS)
// Identifiquemos cada elemento en el próximo ejemplo

[1, 2, 3, "wow"].reverse;
"hello".dup(4);
3.1415.round(0.1); // el primer punto pertenece al número decimal 3.1415
100.rand; // evaluar varias veces

// Encadenando mensajes
100.0.rand.round(0.01).dup(4);

//17. Notación de receptor, notación funcional

// Hay más de una forma de escribir expresiones en SC. La que vimos se llama notación de receptor: 100.rand. Lo mismo puede escribirse en notacion funcional rand(100)

// Ejemplos

5.dup(20);  // "número 5", duplicate 20 veces!
dup(5, 20); // duplicar al número 5, 20 veces

3.1415.round(0.1);
round(3.1415, 0.1);

// Es importante ser consistente, más allá del estilo que usemos. Una convención que se usa en el mundo SC es: las Clases se usan con notacion de receptor, por ejemplo: SinOsc.ar(440). En general, no veremos ar(SinOsc, 440).

// Ejercicio: escribir la siguiente sentencia usando notación funcional. 100.0.rand.round(0.01).dup(4)

// 18. Anidamiento (Nesting)
//El anidamiento es la práctica de incorporar llamadas a funciones o procedimientos, (unas) dentro de otras, mediante la inclusión de diversos niveles de paréntesis.

// Cuando el anidamiento tiene muchos niveles, podemos usar nuevas líneas e indentacion para mayor claridad. Cada nivel de indentación debería indicar un nivel de anidamiento.
//Podemos indentar automaticamente, seleccionando el codigo y Edit->Autoindent

// Identificar la estructura y los argumentos en el siguiente ejemplo

(
{
	CombN.ar(
		SinOsc.ar(
			midicps(
				LFNoise1.ar(3, 24,
					LFSaw.ar([5, 5.123], 0, 3, 80)
				)
			),
			0, 0.4
		),
		1, 0.3, 2)
}.play;
)

// De paso, presentamos la Ugen CombN
(
{Pan2.ar(
	CombN.ar(
		SinOsc.ar(440, 0, LFPulse.kr(0.2, 0, 0.01)),
		0.4, //max delay time, usado para inicializar el buffer
		0.2, //delay time, en segundos
		5,    // decay time: tiempo que tardan los ecos en caer 60dB.
		0.7, // mul: multiplica la salida
	)
	)
}.play
)

// Filtros Comb: "https://es.wikipedia.org/wiki/Filtro_comb"

// 19. Símbolos de cerramiento (enclosure)

// Hay 4 tipos de estos símbolos: (paréntesis) [corchetes] {llaves} y "comillas".
// Cada uno que se abre, debe cerrarse. Esto se llama balancing y SuperCollider nos ayuda a lograrlo.

// 19.1. Comillas

// Strings:
"lista de caracteres, incluyendo espcios" //.reverse

// Símbolos:
// Las comillas simples crean símbolos, tambien la barra invertida '\'.
// Un símbolo es un identificador (o nombre) único en todo el programa.
// Pueden usarse para representar valores constantes simbólicos, claves de diccionarios, etc.
// Los símbolos se representan sintácticamente como literales:
Literals

\unsimbolo  == 'unsimbolo'
\unsimbolo  === 'unsimbolo'  // identidad

"unstring" == "unstring"   // igualdad
"unstring" === "unstring"  // atención!

// Identidad es la propiedad de un objeto que lo lleva a distinguirse de otros. En muchos lenguajes de programación la identidad de un objeto esté determinada por la dirección de memoria en la que se encuentra el objeto, pero este comportamiento puede ser variado redefiniendo la identidad del objeto a otra propiedad."

// Sobre identidad, puede leer en:
//"https://es.wikipedia.org/wiki/Objeto_(programaci%C3%B3n)

// Los símbolos con espacios blancos deben ir entre comillas simples:
'foo bar'

// Un string puede convertirse en un Símbolo
"supercollider".scramble.asSymbol;

// 19.2 Paréntesis
// Se usan para:
//      - definir listas de argumentos: rrand(0,10)
//      - forzar la precedencia: 5 + (10 * 4)
//      - crear bloques de codigo

//19.3 Corchetes
// Definen una coleccion de objetos, llamados arreglos o Arrays. Un array puede contener cualquier tipo de objeto: strings, funciones, patterns. Los arreglos entienden mensajes como reverse, scramble, mirror. Se pueden realizar operaciones aritméticas sobre los arrays

[1, 2, 3, 4, "hello"].scramble;
[1, 2, 3, 4, "hello"].mirror; // crea un nuevo array palíndromo
[1, 2, 3, 4].reverse + 10;

// Convierte midi a frecuencias en Hz
[60, 62, 64, 65, 67, 69, 71].midicps.round(0.1);

// 19.4 Llaves
// Las llaves definen funciones. Las funciones encapsulan una tarea que puede ser reutilizada múltiples veces. Ejemplo:

exprand(1, 1000.0);
{exprand(1, 1000.0);}  // Cuál es la diferencia?

// Consideremos el siguiente código para entender la diferencia

// Compare:
~sillyRand = rrand(0, 10); // un número
~sillyRand.value; // evaluar múltiples veces

~sillyRand2 = {rrand(0, 10)}; // una función
~sillyRand2.value; // evaluar múltiples veces

// elige un número y lo duplica
rand(1000.0).dup(5);

// ejecuta la funcion 5 veces y guarda los resultados en un array
{rand(1000.0)}.dup(5);

// es similar a esto
[rand(1000.0), rand(1000.0), rand(1000.0), rand(1000.0), rand(1000.0)]

//20. Condicionales: if/else y case

//La sintaxis para el if/else: if(condition, {true action}, {false action})

if(10 > 50, {"verdadero"}, {"falso"});


// Mirar los shortcuts sintácticos para estructuras de control: Syntax Shortcuts

// Mover bloques fuera de la lista de argumentos
// En lugar de escribir:
if (x < 3, {\abc}, {\def});
// o
while({ a < b }, { a = a * 2 });

// Podemos escribir:
if (x < 3) {\abc} {\def}
// o
while { a < b } { a = a * 2 };

// Tabla de condicionales en la carpeta figuras
// Las últimas dos líneas muestran cómo escribir expresiones largas usando notación funcional y notación de receptor: (40.even).and(13.odd) y or(40 < 30, 13.odd)

//La clase Boolean explica las operaciones lógicas
//"Boolean is the superclass of True and False which are the concrete realizations. In code True and False are represented by the literal values true and false."

// Otra estructura de control es el CASE: define pares de funciones para ser evaluadas en orden, hasta que una de ellas retorna true

//case
//{test1}{action1}
//{test2}{action2}
//...
//{testN}{actionN};

// Ejemplo

~num = -2;

(
case
{~num == 0} {"WOW".postln}
{~num == 1} {"ONE!".postln}
{~num < 0} {"negative number!".postln}
{true} {"last case scenario".postln}; // La última línea es un default, que "ataja" todos los casos no contemplados
)

//Para más info, mirar el archivo de ayuda de
Control Structures

//21. Funciones
// "Una caja en la que entran datos y salen resultados"

f = { 2 + 2 }; // define the function
f.value; // pone la función a trabajar

//Usamos arg para especificar argumentos (parametros formales)
f = {arg a, b; ["a + b", a + b, "a x b", a * b].postln}; // define la función

//ahora podemos pasarle cualquier par de números como argumentos
f.value(3, 7);
f.value(10, 14);

// Ejemplo simple del tutorial ------------------------
// Use this function to decide how to spend your Summer days
(
~whatToDo = {
var today, dayName, actions;
	today = Date.getDate.dayOfWeek;
	dayName =
	case
	{today==0} {"Sunday"}
	{today==1} {"Monday"}
	{today==2} {"Tuesday"}
	{today==3} {"Wednesday"}
	{today==4} {"Thursday"}
	{today==5} {"Friday"}
	{today==6} {"Saturday"};
	actions = ["boomerang throwing", "arm wrestling", "stair climbing", "playing chess", "underwater hockey", "pea shooting", "a nap marathon"];
	"Ah, " ++ dayName ++ "...! " ++ "What a good day for " ++ actions.choose;
};
)

// Run it in the morning
~whatToDo.value;
//------------------------------------------------------------

// Otra forma de notacion para argumentos es encerrarlos entre barras verticales, por ejemplo {|a, b| a + b}  es lo mismo que {arg a, b; a + b}

// 22. Jugando con Arrays
// Cada vez que escribimos una coleccion de elementos entre corchetes, creamos una instancia de la clase Array
Array

// Manipulamos los arrays de varias maneras, por ejemplo

// Crea un array
a = [10, 11, 12, 13, 14, 15, 16, 17];

a.reverse;  // retrogradación
a.scramble; // desordena el array
a.choose;  // elige un elemento
a.size;	  // retorna el tamaño

a.at(0);   // retorna el item en una determinada posición
a[0]	;  // igual que el anterior
a.wrapAt(9); // devuelve el item en la posición, volviendo al comienzo si la posición es mayor a.size

["wow", 99] ++ a; // concatenación
a ++ \hi;  // un símbolo es un único elemento
a ++ 'hi';
a ++ "hi"; // un string es una colección de caracteres

a.add(44);    // crea un nuevo array con el elemento al final
a.insert(5, "wow"); // retorna un nuevo array con el elemento insertado en la posición
a; // ninguna de las 2 operaciones anteriores modificaron el original

a.put(2, "oops"); // sobreescribe la posición con nuevo elemento
a.permute(3); // intercambia elementos entre posición 0 y 3
a.mirror;  // hace un palíndromo con el original y el retrogradado
a.powerset; // retorna todas las combinaciones posibles con los elementos (subconjuntos)

// Podemos usar aritmética con los arrays

[1, 2, 3, 4, 5] + 10;
[1, 2, 3, 4, 5] * 10;
([1, 2, 3, 4, 5] / 7).round(0.01); // paréntesis para forzar precedencia

x = 11; y = 12;
[x, y, 9] * 100;

// Sólo aplicar operaciones aritméticas a datos apropiados
[1, 2, 3, 4, "oops", 11] + 10;

//22.1 Creando nuevos Arrays

// Serie aritmética
Array.series(size: 6, start: 10, step: 3);

// Serie geométrica
Array.geom(size: 10, start: 1, grow: 2);

// Comparar:
Array.series(7, 100, -10);
Array.geom(7, 100, 0.9);

// El método .fill
Array.fill(10, "same"); //"same".dup(10)

// Comparar:
Array.fill(10, rrand(1, 10));
Array.fill(10, {rrand(1, 10)});

// La función puede tomar un argumento, que es un contador, con cualquier nombre.
Array.fill(10, {arg counter; counter * 10});

// Por ejemplo, generamos una lista de frecuencias armónicas:
Array.fill(10, {arg wow; wow + 1 * 440});

// .newClear
a = Array.newClear(7); // Crea un arreglo vacío
a[3] = "wow";

// 22.2 El signo de exclamacion

//30!4 crea un arreglo de 4 lugares y los llena con el numero 30

// Notación "shortcut":
30 ! 4;
"hello" ! 10;

// Es equivalente a esto
30.dup(4);
"hello".dup(10);

// o esto
Array.fill(4, 30);
Array.fill(10, "hello");

// 22.3 Un rango entre paréntesis, usando dos puntos

// Un shortcut para generar una serie
(50..79);

// Similar a esto:
series(50, 51, 79);

// o
Array.series(30, 50, 1);

// Para obtener un paso diferente de 1, podemos hacer
(50, 53 .. 79); // paso de 3

// Mismo resultado que:
series(50, 53, 79);
Array.series(10, 50, 3);

// 22.4 Iterar sobre un Array

// Usamos el método .do para realizar una acción sobre todos los elementos del array

~myFreqs = Array.fill(10, {rrand(440, 880)});

// Ahora realizamos una acción simple con cada elemento de la lista:
~myFreqs.do({arg item, count; ("Item " ++ count ++ " is " ++ item ++ " Hz. Closest midinote is " ++ item.cpsmidi.round).postln});

// La funcion puede tomar dos argumentos: el objeto y el índice. Los nombres pueden ser cualquiera, pero el orden importa: item, count.

// Si no necesitamos el contador, usamos un único argumento:
~myFreqs.do({arg item; {SinOsc.ar(item, 0, 0.1)}.play});
~myFreqs.do({arg item; item.squared.postln});

// Por supuesto, en el último caso es mejor hacer esto:
~myFreqs.squared;

// Explorar el metodo .collect de la clase abstracta Collection, que es similar a .do, pero retorna una nueva lista con los resultados obtenidos
[1, 2, 3, 4].collect({ arg item, i; item + 10 });

// 23 Obtener ayuda
// Se pueden evaluar los ejemplos directamente desde el archivo de ayuda.
// Hacemos doble click sobre una palabra, método o clase para seleccionarla y usamos [ctrl+D]
MouseX

// Si seleccionamos un metodo, nos será mostrada una lista de clases que entienden ese método. Por ejemplo:
scramble

// Otra forma de explorar la ayuda de SC son browse y search. Browse navega los archivos por categorias. Search busca palabras en el documento

// Al abrir parentesis para enviar argumentos en un mensaje, se muestra una tooltip help. por ejemplo

SinOsc.ar(

// Si no aparece, la llamamos con [ctrl] + [shift] + [space] y autocompletamos el argumento nombrado con [tab], despues de cada coma


//TIP: Crear una carpeta con tus propios archivos de ayuda personalizada. Cuando quieras recordar un nuevo truco o como funciona un objeto, escribir ejemplos, explicaciones, diagramas, etc. Puede ser util en un mes o en un anio.

//Los mismos archivos de ayuda pueden encontrarse online en http://doc.sccode.org