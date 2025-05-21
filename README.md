# maternapp

## 🔑 Configuración de Firebase y Firma Digital

### 🏗️ Huella Digital (Keystore)
Para ejecutar el proyecto correctamente, cada desarrollador debe contar con una huella digital (keystore) específica. **Este archivo no se encuentra en el repositorio y cada desarrollador debe generarlo o recibirlo de un administrador del proyecto.**

Para verificar si tienes una huella digital configurada, revisa el archivo `gradle.properties` en la carpeta `android/`.

Si no tienes una huella digital válida, sigue estos pasos:
1. **Genera una nueva huella digital** con:
   ```sh
   keytool -genkey -v -keystore my-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias

## 🔥 Archivo `google-services.json`

El archivo `google-services.json` es necesario para la configuración de Firebase en el proyecto, pero **no está disponible en este repositorio**.  
Para obtenerlo, debes solicitarlo a los propietarios del proyecto y colocarlo en `android/app/` antes de ejecutar la aplicación.


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
