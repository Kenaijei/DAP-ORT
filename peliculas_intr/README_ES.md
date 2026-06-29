# Películas - Interactivas (PeliculasIntr)

Una aplicación Flutter que permite gestionar una lista de películas. Incluye películas hardcodeadas y la funcionalidad de agregar nuevas películas dinámicamente con un formulario completo. Replicando la estructura y diseño de la app original de Películas.

## Características Principales

### 🔐 Pantalla de Login
- Autenticación simple con credenciales predefinidas
- Credenciales: **admin / admin**
- Interfaz clara y atractiva

### 🎬 Pantalla de Películas
- **Películas Predefinidas**: 9 películas hardcodeadas listos para ver
- **Botón Agregar**: Acceso rápido mediante icono en la AppBar
- **Listado Dinámico**: Las películas se cargan en una lista interactiva
- **Información en Tarjeta**: Visualiza título, género, año, duración, rating y sinopsis

### ➕ Formulario de Agregar Películas
Diálogo interactivo con los siguientes campos:
- Título de la película
- Género
- Año de estreno
- Duración (ej: 2h 30m)
- Calificación (0-10)
- Director
- URL del Póster
- Descripción
- Selector de Color Acento (9 colores disponibles)

### 📄 Pantalla de Detalles
- Vista completa con imagen del póster
- Información estructurada en tarjetas
- Gradiente con el color acento de la película
- Botón para volver a la lista

### ✅ Validaciones
- Todos los campos son obligatorios
- Año debe ser un número válido
- Rating debe estar entre 0 y 10
- Mensajes de confirmación/error claros

## Estructura del Proyecto

```
lib/
├── main.dart                         # Punto de entrada
├── core/
│   └── router/
│       └── app_router.dart          # Configuración de rutas
├── entities/
│   └── movie.dart                   # Modelo de datos Movie
└── screens/
    ├── login_screen.dart            # Pantalla de autenticación
    ├── home_screen.dart             # Pantalla principal con lista
    ├── movie_details_screen.dart    # Pantalla de detalles
    └── add_movie_dialog.dart        # Diálogo para agregar películas
```

## Flujo de la Aplicación

1. **Login** → Inicia sesión con admin/admin
2. **Home** → Ve la lista de películas (9 predefinidas)
3. **Agregar** → Toca el botón "+" para abrir el formulario
4. **Detalles** → Toca cualquier película para ver todos los detalles
5. **Volver** → Regresa a la lista

## Cómo Usar

### Ejecutar la Aplicación
```bash
cd peliculas_intr
flutter pub get
flutter run
```

### Ingresar al Sistema
- Usuario: `admin`
- Contraseña: `admin`

### Agregar una Nueva Película
1. Toca el icono "+" en la esquina superior derecha
2. Completa todos los campos del formulario
3. Selecciona un color acento
4. Toca "Agregar"
5. ¡La película aparecerá en la lista!

### Ver Detalles de una Película
- Toca cualquier película en la lista
- Se abrirá una pantalla con toda la información
- Toca "Volver a la lista" para regresar

## Tecnologías Utilizadas

- **Flutter**: Framework móvil
- **go_router**: Sistema de rutas
- **Material Design 3**: Componentes visuales

## Dependencias

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^17.2.3
```

## Características Técnicas

- ✅ Sistema de rutas con go_router
- ✅ Estado dinámico con StatefulWidget
- ✅ Validación de formularios
- ✅ Manejo de errores de cargas de imágenes
- ✅ Diseño responsivo
- ✅ Interfaz moderna y amigable

## Películas Predefinidas

1. **Oppenheimer** - Drama histórico (2023)
2. **Interstellar** - Ciencia ficción (2014)
3. **Transformers** - Acción (2007)
4. **Transformers: Dark Of The Moon** - Acción (2011)
5. **Avatar** - Ciencia ficción (2009)
6. **Avatar: El camino del agua** - Ciencia ficción (2022)
7. **Avatar: Fire and Ash** - Ciencia ficción (2025)
8. **Project Hail Mary** - Ciencia ficción (2026)
9. **Nobody** - Acción y thriller (2021)

## Notas Importantes

- Las películas agregadas se guardan en memoria (durante la sesión)
- Al cerrar la app, se pierden los datos (no hay persistencia)
- Las URLs de imágenes deben ser URLs válidas accesibles desde internet
- Se mantiene el mismo diseño y paleta de colores de la app original

## Autor

Creada como versión mejorada de la app original "Películas" con funcionalidad interactiva.

---

**Disfruta gestionando tu catálogo de películas! 🎬**

