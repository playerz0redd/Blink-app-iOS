# 📍 Blink – iOS App for Friend Location Sharing

Blink — это SwiftUI-приложение для iOS, позволяющее отслеживать геопозицию друзей в реальном времени, отправлять запросы на добавление, управлять статусами дружбы, общаться в реальном времени и отображать настраиваемую карту с разными стилями.

![Swift](https://img.shields.io/badge/swift-5.9-orange)
![iOS](https://img.shields.io/badge/iOS-17%2B-lightgrey)
![SwiftUI](https://img.shields.io/badge/SwiftUI-Compatible-blue)

---

## 🔧 Функциональность

- 📡 **Отслеживание геолокации друзей** в реальном времени
- 🤝 **Запросы в друзья, принятие и отклонение**
- 🔐 **Авторизация и регистрация пользователей**
- 🗺️ **Карта с переключением стилей (Hybrid, Standard, Imagery)**
- ✍️ **Возможность общения в реальном времени**
- 🎨 **Анимированные вкладки и пользовательский UI**
- 💬 **Поиск друзей и отображение их статуса**

---

## 🧩 Архитектура

Проект реализован с использованием архитектуры **MVVM** с разделением по модулям:

- `Model` — структуры данных и API-модели
- `ViewModel` — бизнес-логика
- `View` — интерфейс на SwiftUI
- `Network` — WebSocket и HTTP взаимодействие
- `Modules` — отдельные компоненты

---

## 📦 Технологии

- Swift 5.9
- SwiftUI
- MapKit / CoreLocation
- Combine
- WebSocket (реализация через NetworkManager)
- MVVM + модульная структура

---

## 🖥️ Скриншоты

### Главный экран
<img src="screenshots/main-view.jpg" alt="Главный экран" width="300"/>

### Поиск людей
<img src="screenshots/find-people.jpg" alt="Поиск людей" width="300"/>

### Чаты
<img src="screenshots/chats.jpg" alt="Чаты" width="300"/>

### Сообщения
<img src="screenshots/messages.jpg" alt="Сообщения" width="300"/>

### Настройки
<img src="screenshots/settings.jpg" alt="Настройки" width="300"/>




## 👤 Автор

Created by [@playerz0redd](https://github.com/playerz0redd)
