# SwiftPokeDex
# 📱 PokéDex Modern SwiftUI

A premium iOS application serving as an interactive Pokédex that consumes the **PokeAPI**. It is designed to production-grade standards, employing advanced concepts such as native concurrency, reactive local persistence, and a comprehensive suite of modern automated tests.

---

## 📸 Screenshots / UI Showcase

| List and filters (Sticky) | Detailed data sheet | Empty states and error handling |
|:---:|:---:|:---:|
| <img width="220" alt="Image" src="https://github.com/user-attachments/assets/c64c512b-4833-4b77-9e83-1939922697cc" /> | <img width="220" alt="Image" src="https://github.com/user-attachments/assets/c7fb20b3-51f1-4b9a-9574-4f117ed4fa09" /> | <img width="220" alt="Image" src="https://github.com/user-attachments/assets/ec105075-b699-46bb-b4c3-14c79a7e6d00" /> |

---

## 🚀 Key Features

* **Seamless Cross-Navigation**: Implementation of a **centralized Coordinator/Router** architecture using native `NavigationStack` and `NavigationPath`, enabling fluid navigation transitions between evolutions and a one-tap "Pop to Root" capability.
* **Sticky Filter Bar**: Optimized layout pinning interactive components (horizontal tags) beneath the search bar, decoupling them from the main list's scrolling behavior.
* **Reactive Local Persistence**: Management of persistent favorites via **SwiftData**, synchronizing disk storage (SQLite) with `@Query` macros for real-time UI updates.
* **Premium Statistical Charts**: Animated visualization of base Pokémon stats implemented with **SwiftCharts**, utilizing spring animations (`.spring`) at a stable 120 FPS.
* **Resilient State Handling**: Implementation of descriptive error states using **`ContentUnavailableView`** to handle network issues (featuring an atomic retry button) and empty favorites collections.
* **Skeleton (Shimmer) Effect**: A visually pleasing transition using a custom `ViewModifier` and infinite linear animations to replace traditional loading indicators.

---

## 🛠️ Technology Stack & Architecture

* **Language**: Swift 6 (Strict Concurrency Mode enabled).
* **Main Framework**: SwiftUI (Native support for iOS 17+).
* **Architecture**: MVVM-C (Model-View-ViewModel + Router/Coordinator).
* **Concurrency**: Modern (`async/await` and structured concurrency using `withThrowingTaskGroup` for parallel batch downloads).
* **Persistence**: SwiftData (Atomic contexts using `try modelContext.save()`).
* **Data Visualization**: SwiftCharts.

---

## 🧪 Software Quality & Testing

The project is safeguarded against regressions using the most modern testing frameworks in the Apple ecosystem. **Dependency Injection** is implemented via contracts (`APIServiceProtocol`) to ensure 100% deterministic tests without making actual network calls.

### 🧬 Unit Tests (**Swift Testing**)
* Coverage of asynchronous flows and formal error handling.
* **Parameterized tests (`arguments: [...]`)** to test multiple search scenarios within a single logical function.
* Thread isolation validation via strict synchronization on the `@MainActor`.

---

## 🔧 Installation instructions

1. Clone this repository:
   ```bash
   git clone https://github.com/usabalza/SwiftPokeDex
   ```
2. Open the `PokeDexApp.xcodeproj` or `PokeDexApp.xcworkspace` file in **Xcode** (Xcode 15 or later is required).
3. Select your preferred simulator running **iOS 17.0+** and press `Cmd + R` to run the app.
4. To run the full suite of unit and UI tests, press `Cmd + U`.

---

### 👨‍💻 Author

Developed by **Uziel Sabalza**
*   **LinkedIn:** [Uziel Sabalza](https://linkedin.com)
*   **Portfolio:** [Portafolio](https://yourwebsite.com)
*   **Email:** uziel.sabalza.dev@gmail.com
