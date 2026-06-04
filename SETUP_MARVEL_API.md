# Configuración de Marvel API

## Pasos para obtener tus credenciales

1. **Ir al sitio de Marvel Developers**:
   - Visita: https://developer.marvel.com/
   - Haz clic en "Get a Key" (Obtener una clave)

2. **Crear una cuenta**:
   - Si no tienes cuenta, regístrate con tu email
   - Completa el formulario y acepta los términos

3. **Obtener las credenciales**:
   - Una vez registrado, irás al panel de control
   - Verás dos claves:
     - **Public Key**: La clave pública
     - **Private Key**: La clave privada

4. **Configurar el datasource**:
   - Abre el archivo: `lib/data/datasource/marvel_datasource.dart`
   - Busca las líneas:
     ```dart
     static const String _publicKey = 'tu_public_key_aqui';
     static const String _privateKey = 'tu_private_key_aqui';
     ```
   - Reemplaza los valores con tus credenciales reales:
     ```dart
     static const String _publicKey = 'abc123defg456';
     static const String _privateKey = 'xyz789uvw012';
     ```

## Ejecutar el proyecto

1. Instala las dependencias:
   ```bash
   flutter pub get
   ```

2. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## ¿Qué incluye la aplicación?

- **Grid de 2 columnas** que muestra los personajes de Marvel
- **Imagen del personaje** en la parte superior de cada tarjeta
- **Nombre y descripción** del personaje
- **Número de cómics** en los que aparece
- **Scroll infinito**: Carga más personajes al llegar al final
- **Pull to refresh**: Desliza hacia abajo para actualizar la lista
- **Manejo de errores**: Muestra mensajes de error si falla la conexión

## Requisitos

- Flutter SDK ^3.11.4
- Conexión a Internet

## Dependencias principales

- `http`: Para hacer peticiones HTTP a la API de Marvel
- `provider`: Para gestionar el estado de la aplicación
- `crypto`: Para generar el hash MD5 requerido por Marvel API

¡Disfruta la aplicación!
