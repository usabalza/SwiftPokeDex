# SwiftPokeDex
# 📱 PokéDex Modern SwiftUI

A premium iOS application serving as an interactive Pokédex that consumes the **PokeAPI**. It is designed to production-grade standards, employing advanced concepts such as native concurrency, reactive local persistence, and a comprehensive suite of modern automated tests.

---

## 📸 Screenshots / UI Showcase

| Listado y Filtros (Sticky) | Ficha Técnica Detalle | Estados Vacíos / Errores |
|:---:|:---:|:---:|
| <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/c64c512b-4833-4b77-9e83-1939922697cc" /> | <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/c7fb20b3-51f1-4b9a-9574-4f117ed4fa09" /> | <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/ec105075-b699-46bb-b4c3-14c79a7e6d00" /> |

---

## 🚀 Key Features

* **Seamless Cross-Navigation**: Implementation of a **centralized Coordinator/Router** architecture using native `NavigationStack` and `NavigationPath`, enabling fluid navigation transitions between evolutions and a one-tap "Pop to Root" capability.
* **Sticky Filter Bar**: Optimized layout pinning interactive components (horizontal tags) beneath the search bar, decoupling them from the main list's scrolling behavior.
* **Reactive Local Persistence**: Management of persistent favorites via **SwiftData**, synchronizing disk storage (SQLite) with `@Query` macros for real-time UI updates.
* **Premium Statistical Charts**: Animated visualization of base Pokémon stats implemented with **SwiftCharts**, utilizing spring animations (`.spring`) at a stable 120 FPS.
* **Resilient State Handling**: Implementation of descriptive error states using **`ContentUnavailableView`** to handle network issues (featuring an atomic retry button) and empty favorites collections.
* **Skeleton (Shimmer) Effect**: A visually pleasing transition using a custom `ViewModifier` and infinite linear animations to replace traditional loading indicators.

---

## 🛠️ Stack Tecnológico & Arquitectura

* **Lenguaje**: Swift 6 (Modo de Concurrencia Estricta habilitado).
* **Framework Principal**: SwiftUI (Soporte nativo para iOS 17+).
* **Arquitectura**: MVVM-C (Model-View-ViewModel + Router/Coordinator).
* **Concurrencia**: Moderna (`async/await` y estructurada mediante `withThrowingTaskGroup` para descargas masivas en paralelo).
* **Persistencia**: SwiftData (Contextos atómicos con `try modelContext.save()`).
* **Visualización de Datos**: SwiftCharts.

### Estructura del Proyecto (Screaming Architecture)
```text
📁 PokeDexApp
├── 📁 App            # Ciclo de vida raíz (@main) e inyección del Router Central
├── 📁 Network        # Cliente genérico desacoplado mediante Protocolos (SOLID)
├── 📁 Router         # Gestión declarativa de rutas (NavigationPath)
├── 📁 Shared         # Modelos compartidos persistentes (SwiftData)
├── 📁 Utils          # Vistas genéricas y modificadores reutilizables (Shimmer, Empty States)
├── 📁 Extensions     # Extensiones del sistema (Paletas de colores dinámicas por tipo)
└── 📁 Modules        # Encapsulación de código por pantallas (Módulo Autocontenido)
    ├── 📁 PokemonList   # Modelos, Views (optimizadas con @ViewBuilder) y ViewModels de la lista
    └── 📁 PokemonDetail # Ficha técnica densa dividida en Sub-Views con Aislamiento de Identidad
```

---

## 🧪 Calidad de Software & Testing

El proyecto se encuentra blindado contra regresiones utilizando los frameworks de pruebas más modernos del ecosistema Apple. Se implementa **Inyección de Dependencias** a través de contratos (`APIServiceProtocol`) para garantizar pruebas 100% deterministas sin llamadas reales a internet.

### 🧬 Pruebas Unitarias (**Swift Testing**)
* Cobertura de flujos asíncronos y captura formal de errores.
* **Tests Parametrizados (`arguments: [...]`)** para probar múltiples combinaciones del buscador en una sola función lógica.
* Validación de aislamiento de hilos mediante sincronización estricta en el `@MainActor`.

### 📱 Pruebas de Interfaz (**UI Tests / XCTest**)
* Simulación de flujos de usuario reales (Escritura, Taps, Desplazamientos).
* Navegación automatizada basada en **`accessibilityIdentifier`** para inmunidad ante cambios de diseño o internacionalización de textos.

---

## 🔧 Instrucciones de Instalación

1. Clona este repositorio:
   ```bash
   git clone https://github.com
   ```
2. Abre el archivo `PokeDexApp.xcodeproj` o `PokeDexApp.xcworkspace` en **Xcode** (Se requiere Xcode 15 o superior).
3. Selecciona tu simulador preferido con **iOS 17.0+** y presiona `Cmd + R` para ejecutar.
4. Para correr la suite completa de pruebas unitarias y de interfaz, presiona `Cmd + U`.

---

## ✒️ Autor

* **Tu Nombre** - *Desarrollador iOS* - [Tu LinkedIn](https://linkedin.com) | [Tu Portafolio Web](https://tu-web.com)

