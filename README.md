# SwiftPokeDex
# 📱 PokéDex Modern SwiftUI

A premium iOS application serving as an interactive Pokédex that consumes the **PokeAPI**. It is designed to production-grade standards, employing advanced concepts such as native concurrency, reactive local persistence, and a comprehensive suite of modern automated tests.

---

## 📸 Screenshots / UI Showcase

| Listado y Filtros (Sticky) | Ficha Técnica Detalle | Estados Vacíos / Errores |
|:---:|:---:|:---:|
| <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/c7fb20b3-51f1-4b9a-9574-4f117ed4fa09" /> | <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/ec105075-b699-46bb-b4c3-14c79a7e6d00" /> | <img width="1206" height="2622" alt="Image" src="https://github.com/user-attachments/assets/c64c512b-4833-4b77-9e83-1939922697cc" /> |

---

## 🚀 Características Clave

* **Navegación Cruzada Infinita**: Implementación de una arquitectura de **Coordinador/Router centralizado** mediante `NavigationStack` y `NavigationPath` nativos, permitiendo saltos de navegación fluidos entre evoluciones con la posibilidad de hacer *Pop to Root* con un solo clic.
* **Barra de Filtros Sticky**: Layout optimizado para fijar componentes interactivos (*Tags horizontales*) debajo del buscador, aislando el comportamiento del scroll del listado principal.
* **Persistencia Local Reactiva**: Gestión de favoritos persistentes mediante **SwiftData**, sincronizando el almacenamiento en disco duro (SQLite) con macros `@Query` para actualizaciones de la interfaz en tiempo real.
* **Gráficos Estadísticos Premium**: Visualización animada de las estadísticas base del Pokémon implementada con **SwiftCharts**, utilizando animaciones elásticas (`.spring`) a 120 FPS estables.
* **Manejo Resiliente de Estados**: Implementación de interfaces descriptivas ante fallos mediante **`ContentUnavailableView`** para mitigar errores de red (con botón de reintento atómico) y colecciones de favoritos vacías.
* **Efecto Esqueleto (Shimmer)**: Transición visual placentera a través de un `ViewModifier` personalizado y animaciones lineales infinitas que reemplazan los indicadores de carga tradicionales.

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

