#HackerBooks
### Presentación:
Esta es la aplicación de práctica desarrollada para el curso de Fundamentos iOS del KeepCoding® Startup Bootcamp Engineering Master IV.

### Respuestas a preguntas:

##### *JSONSerialization* devuelve un parámetro *Any* que puede contener tanto un *Array* de *Dictionary* como un *Dictionary*. Mira en la ayuda el método *type(of:)* y como usarlo para saber qué te han devuelto exactamente. ¿En qué otros modos podemos trabajar? ¿is, as?

En este caso utilice la siguiente aproximación:

~~~~
typealias JSONObject        = AnyObject
typealias JSONDictionary    = [String : JSONObject]
typealias JSONArray         = [JSONDictionary]

func loadJsonFileFrom(localUrl: URL) throws -> JSONArray {
    
    if let data = try? Data(contentsOf: localUrl),
        let maybeArray: Any = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) {
        
        if let array = (maybeArray as? NSArray) as Array? { // Es un array de diccionarios
            
            return (array as? JSONArray)!
            
        } else if let dic = (maybeArray as? NSDictionary) as Dictionary? { // Es un diccionario
            
            // metemos el diccionario dentro de un array antes de regresarlo
            let array: [JSONDictionary] = [dic as! JSONDictionary]
            
            return array
        } else {    // formato de json incorrecto
            
            throw HackerBooksErrors.wrongJSONFormat
        }
        
    } else {    // formato de json incorrecto
        throw HackerBooksErrors.wrongJSONFormat
    }
}
~~~~

Compruebo si lo que me regreso JSONSelialization es un array de diccionarios, si no lo es, compruebo si es un diccionario solitario; si lo es, lo meto dentro de un array como único elemento para poder regresar el tipo correcto en mi función. Si las dos cosas fallan, dor por hecho que estoy leyendo un archivo JSON con formato incorrecto. Hice la prueba enviandole un diccionario solicitado a esta función y todo OK.

##### Descarga el *JSON* y guárdalo en la carpeta *Documents* de tu *sandbox*. Haz lo mismo para las imágenes de portada y los pdf's. ¿Dónde guardarías estos datos?
Se utilizo la librería AsyncData para la descarga de las imágenes y los pdf's. Esta librería guarda y recupera lo descargado desde la carpeta "Cache" por lo que pude investigar, cosa que me parece lo correcto.

##### El ser o no favorito se indicará mediante una propiedad *isFavorite* de *Book* y esto se debe guardar en sistema de ficheros y recupear de alguna forma. ¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo?
El método seleccionado fue el de usar *UserDefaults* para guardar la selección. Se uso el *title.hashValue* como identificador único del libro para recuperar el setting posteriormente.

Tambien se pudo usar un *Dictionary* y guardarlo en un archivo *plist*. Tambien se pude usar *Core Data* para guardar la información en una base de datos del tipo *sqlite* (por ejemplo). Otra opción es implementar una clase con *NSCodig* para hacer el *archive* y *unarchive* de archivos serializables usando *NSData*.

##### Cuando cambia el valo de la propiedad *isFavorite* de un *Book*, la tabla deberá reflejar ese hecho. ¿Cómo lo harías? ¿Se te ocurre más de una forma de hacerlo? ¿Cuál the parece mejo? Explica tu elección.
En este caso escogí hacer una notificación para notificar el cambio de esta propiedad. A esta notificación se pueden suscribir más de un objecto (clase), en mi caso me interesa que el controlador LibraryViewController se entere de este cambio. La ventaja de escojer notificaciones en lugar de otros métodos (delegados, por ejemplo) es que en un momento dado, en otra parte de de la app este cambio pueda ser importante tenerlo en cuenta.

##### Para que la tabla se actulice, usa el método **reloadData** de *UITableView*. Esto hace que la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el punto de vista del rendimiento? ¿Hay una forma alternativa? ¿Cuándo crees que vale la pena usarlo?
Cuando existen varios elementos en la tabla divididas en grupos (secciones), como es nuestro caso, el recargar toda la tabla no es lo más eficiente, ya que consume tiempo, recursos y puede bloquear un poco la interfaz. En este caso se debe recargar solo la sección que sabemos ha sufrido cambios (Favorite). Para esto se puede utilizar el método: *reloadSections(_:withRowAnimation:)* del *UITableView*.

Nota: En este momento estoy utilizando *reloadData* en mi aplicación porque tengo problemas aún con los Dispatch Queue y aún no logro atinar sobre el uso correcto para poder habilitar el refresh con *reloadSections(_:withRowAnimation:)*.

##### Cuando el usuario cambia en la tabla el libro seleccionado, el PDFViewController debe actualizarse. ¿Cómo lo harías?
Se puede hacer mediante delegados o notificaciones. En este caso opte por la notificación porque es más fácil de implementar ya que hace lo que necesitamos con menos código.

##### ¿Qué funcionalidades le añadirías antes de subirla a la App Store?
Antes de subirlo a la App Store mejoraría el lector de PDF, porque utilice el *UIWebView*, que tiene una funcionalidad básica para la lectura de PDF's, sería ideal poder hacer anotaciones, marcación de texto, tener bookmarks para encontrar rápidamente información que el usuario le parezca relevante, continuar en la última página vista en cada book. Se requieren mejores imágnes para las portadas de los libros, un buen icono y la posibilidad de que de vez en vez se recargará el json file desde la web para ir agregando nuevas publicaciones, por ejemplo.

##### Usando esta App como "plantilla", ¿qué otras versiones se te ocurren? ¿Algo que puedas monetizar?

Se puede monetizar agregando publicidad. Por ejemplo que mostrará un ad de pantalla completa cada 10 min. con posibilidad de eliminarla pasando a la versión completa sin publicidad y con todas las extra features. Se pueden poner previews del libros nuevos con posibilidad de llevar al usuario a una tienda de libros (amazon o el propio iTunes book store) y ganar un poco de dinero usando links de afiliados de la tienda.

Tengo una idea de una app que sirva para descargar textos de temáticas interesantes y variadas. Cada texto sería enviado en dos idiomas (inglés y español, por ejemplo.) Entonces el usuario podrá empezar a leer el texto en el idioma de su preferencia y en un momento dado tener la posibilidad de comparar con el otro texto (del otro idioma). El objetivo es que estudiantes de un idioma puedan practicar la lectura y tener la traducción al instante para poder entender palabras u oraciones rápidamente. La monetización sería con publicidad como en el caso anterior y con posibilidad de suscribirse por una cuota mensual para recibir nuevos textos, de diferente nivel y temática, según lo prefiera lector.

Características extras pueden ser por ejemplo que el usuario pueda agregar flashcards de manera rápida para en un futuro repasar las palabras o frases que quisiera recordar y aprender. Las posibilidades son ilimitadas...
