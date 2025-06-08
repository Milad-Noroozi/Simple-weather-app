# 🌤️ Simple Weather App

A simple and elegant weather application built with Flutter. This app features a clean, glassmorphism-style UI that provides essential real-time weather information, including city name, current temperature, weather status, min/max temperatures, wind speed, humidity, and sunrise/sunset times.

The project fetches live data from the [OpenWeatherMap API](https://openweathermap.org/api) and demonstrates core Flutter concepts like state management (`setState`), API integration with the `Dio` package, and building dynamic user interfaces.

---

## 📱 Features

-   **Real-time Weather Data**: Fetches and displays live weather information for any searched city.
-   **Current Conditions**: Shows sky status (e.g., "Clear Sky", "Clouds"), current temperature, and daily high/low.
-   **Detailed Information**: Provides data on wind speed, humidity, and precise sunrise/sunset times.
-   **Glassmorphism UI**: A beautiful, modern interface with a blurred background effect.
-   **Hourly Forecast**: A horizontal `ListView` to display the weather forecast for the upcoming hours.
-   **Dynamic Data Handling**: Converts Unix timestamps to human-readable time and handles API data gracefully.

---

## 🧑‍💻 Tech Stack & Tools

-   **Core**: Flutter SDK, Dart
-   **State Management**: `setState` for simple, local state updates.
-   **Networking**: `Dio` package for making HTTP requests to the OpenWeatherMap API.
-   **Date Formatting**: `intl` package for converting timestamps into readable date/time formats.
-   **UI/Design**:
    -   Material Design
    -   `BackdropFilter` for the glassmorphism/blur effect.
    -   Key Widgets: `Scaffold`, `TextField`, `ListView.builder`, `Column`, `Row`, `Icon`, `Divider`.

---

## 🚀 Getting Started

To get a local copy up and running, follow these simple steps.

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Milad-Noroozi/Simple-weather-app.git](https://github.com/Milad-Noroozi/Simple-weather-app.git)
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd Simple-weather-app
    ```
3.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Run the app:**
    ```bash
    flutter run
    ```