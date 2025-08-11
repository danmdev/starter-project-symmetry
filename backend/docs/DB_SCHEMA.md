
# Esquema de la colección "articles" en Firestore

Cada documento en la colección `articles` representa un artículo publicado en la app. A continuación se describen los campos principales:

| Campo         | Tipo        | Descripción                                      |
|-------------- |------------ |-------------------------------------------------|
| docId         | string      | ID único del documento (autogenerado por Firestore o asignado al editar) |
| title         | string      | Título del artículo                              |
| content       | string      | Contenido del artículo                           |
| urlToImage    | string      | URL de la imagen asociada (en Firebase Storage)  |
| publishedAt   | Timestamp   | Fecha de publicación                             |

Ejemplo de documento:

```json
{
	"docId": "abc123",
	"title": "Título de ejemplo",
	"content": "Este es el contenido del artículo...",
	"urlToImage": "https://firebasestorage.googleapis.com/v0/b/...",
	"author": "danielmoo",
	"publishedAt": "2025-08-10T12:34:56.789Z",
}
```
