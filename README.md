# PruebaAlexCayetano

Explicación de la Arquitectura <br/>

Se realizo basando en el patron de diseño MVC

Que es MVC
=====================
Modelo-vista-controlador (MVC) es un patrón de arquitectura de software, que separa los datos y la lógica de negocio de una aplicación de su representación y el módulo encargado de gestionar los eventos y las comunicaciones. MVC propone la construcción de tres componentes distintos que son el modelo, la vista y el controlador

Porque se realizó MVC
=====================
Porque el proyecto no era tan grande, y a este nivel es escalable, mantenible.

Capas del Proyect
=====================
Controladores => Controllers <br>
Model         => Model<br>
View          => Storyboard<br>

Base Realtime
=====================
Se uso Firestore para agregar los posts a la BD

Storage - Firebase Storage
=========================
Firebase Storage para alamacenar las fotos en las nubes

Persistencia
============
Se creo la clase Session, la cual trabaja con UserDefaults para el manejo de sesiones de usuario.
