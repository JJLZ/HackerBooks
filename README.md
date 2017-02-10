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
En este caso escogí hacer una notificación para actualizar la selección de esta propiedad. A esta notificación se pueden suscribir más de un objecto (clase) en mi caso me interesaba que la clase Book y Library se enteran de este cambio (nota: al final desde Library también pude actualizar la propiedad para el libro seleccionado, entonces no me suscribí a esta notificación desde Book, pero nada quita que en otra parte de de la app este cambio pueda ser importante tenerlo en cuenta, por lo que la selección de la notificación sigue siendo justificado.)

##### Para que la tabla se actulice, usa el método **reloadData** de *UITableView*. Esto hace que la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el punto de vista del rendimiento? ¿Hay una forma alternativa? ¿Cuándo crees que vale la pena usarlo?
Cuando existen varios elementos en la tabla divididas en grupos (secciones), como es nuestro caso, el recargar toda la tabla no es lo más eficiente, ya que consume tiempo, recursos y puede bloquear un poco la interfaz. En este caso se debe recargar solo la sección que sabemos ha sufrido cambios (Favorite). Para esto se puede utilizar el método: *reloadSections(_:withRowAnimation:)* del *UITableView*.

##### Cuando el usuario cambia en la tabla el libro seleccionado, el PDFViewController debe actualizarse. ¿Cómo lo harías?
Se puede hacer mediante delegados o notificaciones. En este caso opte por la notificación porque es más fácil de implementar ya que hace lo que necesitamos con menos código.

##### ¿Qué funcionalidades le añadirías antes de subirla a la App Store?

##### Usando esta App como "plantilla", ¿qué otras versiones se te ocurren? ¿Algo que puedas monetizar?

### Comentarios finales: