#HackerBooks
### Presentación:
Esta es la aplicación de práctica desarrollada para el curso de Fundamentos iOS del KeepCoding® Startup Bootcamp Engineering Master IV.

### Respuestas a preguntas:

##### *JSONSerialization* devuelve un parámetro *Any* que puede contener tanto un *Array* de *Dictionary* como un *Dictionary*. Mira en la ayuda el método *type(of:)* y como usarlo para saber qué the han devuelto exactamente. ¿En qué otros modos podemos trabajar? ¿is, as?

##### Descarga el *JSON* y guárdalo en la carpeta *Documents* de tu *sandbox*. Haz lo mismo para las imágenes de portada y los pdf's. ¿Dónde guardarías estos datos?

##### El ser o no favorito se indicará mediante una propiedad *isFavorite* de *Book* y esto se debe guardar en sistema de ficheros y recupear de alguna forma. ¿Cómo harías eso? ¿Se te ocurre más de una forma de hacerlo?
El método seleccionado fue el de usar *UserDefaults* para guardar la selección. Se uso el *title.hashValue* como identificador único del libro para recuperar el setting posteriormente.

Tambien se pudo usar un *Dictionary* y guardarlo en un archivo *plist*. Tambien se pude usar *Core Data* para guardar la información en una base de datos del tipo *sqlite* (por ejemplo). Otra opción es implementar una clase con *NSCodig* para hacer el *archive* y *unarchive* de archivos serializables usando *NSData*.

##### Cuando cambia el valo de la propiedad *isFavorite* de un *Book*, la tabla deberá reflejar ese hecho. ¿Cómo lo harías? ¿Se te ocurre más de una forma de hacerlo? ¿Cuál the parece mejo? Explica tu elección.

##### Para que la tabla se actulice, usa el método **reloadData** de *UITableView*. Esto hace que la tabla vuelva a pedir datos a su dataSource. ¿Es esto una aberración desde el punto de vista del rendimiento? ¿Hay una forma alternativa? ¿Cuándo crees que vale la pena usarlo?

##### Cuando el usuario cambia en la tabla el libro seleccionado, el PDFViewController debe actualizarse. ¿Cómo lo harías?
Se puede hacer mediante delegados o notificaciones. En este caso opte por la notificación porque es más fácil de implementar ya que hace lo que necesitamos con menos código.

##### ¿Qué funcionalidades le añadirías antes de subirla a la App Store?

##### Usando esta App como "plantilla", ¿qué otras versiones se te ocurren? ¿Algo que puedas monetizar?

### Comentarios finales: