#This page contains all the History Cards that the user makes.

_**Prioridades:**
P0 ->Prioridad máxima
P1->Prioridad Normal P2->Prioridad Baja_


| **No** | **Titulo** | **Descripción** | **Prioridad** |
|:-------|:-----------|:-----------------|:--------------|
| 1 | Eliminación de Comentarios | El lenguaje de platillas soporta comentarios adecuadamente delimitados. Estos son ignorados por los lexers. | P0 |
| 2 | Lexer de primer nivel. | El analizador léxico(lexer) de primer nivel separa el código de HTML del código del lenguaje de plantillas. | P0 |
| 3 | Lexer de segundo nivel | El analizador léxico(lexer) de segundo nivel separa todos los tokens(elementos léxicos) del lenguaje de platillas y los clasifica en: enteros, flotantes, cadena de caracteres, identificadores y símbolos especiales. | P0 |
| 4 | Evaluador de expresiones|Las expresiones en el lenguaje de plantillas son evaluadas para producir un resultado que se despliega como parte de la salida junto con el código estático. Las expresiones pueden incluir literales y variables de sólo lectura (establecidas desde una lista de asociación).| P0 |
| 5 | Expresiones Aritméticas |Las expresiones aritméticas en el lenguaje de plantillas incluyen los siguientes operadores con una precedencia y asociatividad bien definida: suma, resta, multiplicación, división, residuo.| P0 |
| 6 | Expresiones Relacionales |Las expresiones relacionales en el lenguaje de plantillas incluyen los siguientes operadores con una precedencia y asociatividad bien definida: igual, diferente, menor,menor o igual,mayor, mayor o igual.|P0 |
| 7 | Expresiones Lógicas|Las expresiones lógicas en el lenguaje de plantillas incluyen los siguientes operadores con una precedencia y asociatividad bien definida: and, or, xor, not.|P0 |
| 8 | Expresiones con cadenas |Las expresiones con cadenas en el lenguaje de plantillas incluyen los siguientes operadores con una precedencia y asociatividad bien definida: longitud, concatenación, elemento en índice.|P0 |
| 9 | Expresiones con listas y diccionarios |Las expresiones con listas y diccionarios en el lenguaje de plantillas permiten obtener un elemento deseado usando una notación homogénea.|P0 |
| 10 | Servidor Web |El servidor de Web recibe peticiones GET solicitando contenido estático (html, txt, css, js, jpeg, png y gif). Si no encuentra el recurso solicitado, devuelve una página 404 (Not found).|P0 |
| 11 | Archivo de Configuración|Los detalles configurables del servidor de Web (número de puerto, directorio de archivos a servir, etc.) se leen de un archivo de configuración. Dicho archivo puede ser texto plano, XML, YAML, etc..|P0 |
| 12 | Método POST |El servidor de Web recibe peticiones usando el método POST. Si llega una petición que no sea GET o POST, el servidor devuelve una página 405 (Method Not Allowed) que incluye el encabezado Allow, y el cuerpo contiene un mensaje describiendo el error.|P0 |
| 13 | Controlador|El servidor de Web puede recibir peticiones especiales que identifican a un controlador. Un controlador es un programa en el lenguaje anfitrióny que posiblemente cede el flijo de ejecución a una plantilla. El controlador manda a la plantilla una lista de asociación con las variables/valores que se desan desplegar.|P0 |
| 14 | Parámetros|Los controladores reciben una lista de asociación con los parámetros de la petición (sin importar que sea GET o POST).|P0 |
| 15 | Encabezados|Los controladores reciben una lista de asociación con los encabezados de la petición. Así mismo, el controlador puede indicar los encabezados de una respuesta.|P0 |
| 16 | Ciclos |El lenguaje de plantillas incluye un mecanismo para incluir o no ciertos elementos condicionales.|P0 |
| 17 | Condicionales |El lenguaje de plantillas tiene un mecanismo para iterar facilmente sobre todos los elementos contenidos en una lista o diccionario.|P0 |