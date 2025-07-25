# 🍽️ MealHunter

**MealHunter** 
is a SwiftUI-powered iOS app that lets users search, view, and save delicious recipes using the [TheMealDB](https://www.themealdb.com) API.
Whether you're looking for a quick meal based on ingredients or want a random surprise dish — MealHunter has you covered.
---
## 📸 Screenshots

**Search View**
| Main View | Search |
|--------------|----------------|
<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-07-25 at 17 54 35" src="https://github.com/user-attachments/assets/edc174c6-7f32-4230-acdd-0063bb70519e" />| <img width="1320" height="2868" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-07-25 at 17 55 03" src="https://github.com/user-attachments/assets/0eccab86-eeb2-4a9e-b567-4fb7bea2c67b" />

**Meal Detail View**
<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-07-25 at 17 54 45" src="https://github.com/user-attachments/assets/780df44d-9ccf-42ca-8dc4-34546095f5fe" />

**Favorites View**

<img width="1320" height="2868" alt="Simulator Screenshot - iPhone 16 Pro Max - 2025-07-25 at 17 54 39" src="https://github.com/user-attachments/assets/b2d02124-3c03-4cdb-bd11-6025d1d943e2" />
---

## 🚀 Features

- 🔍 Search meals by ingredient
- 🎲 Get a random meal with one tap
- ⭐ Save favorite meals locally
- 📺 Watch cooking videos via YouTube
- 📝 See detailed ingredients and instructions
- 💾 Persist favorites using SwiftData
- 📐 Built with MVVM and Dependency Injection
- 🧪 Includes unit tests with mock services

---

## 🧠 Architecture

MealHunter follows a clean MVVM architecture, with a clear separation of concerns:

- **Views**: SwiftUI interface — `SearchView`, `FavoritesView`, `MealDetailView`
- **ViewModels**: Handle business logic and async data loading
- **Models**: Represent data from the API — `MealSummary`, `APIMeal`, `MealDetail`
- **Services**: API communication — `APIService`, `MealAPIService`
- **Data Layer**: Local persistence using SwiftData + `FavoriteMeal`
- **DI**: Dependencies are injected using a custom `@Injected` property wrapper

---

## 🧰 Tech Stack

- Swift 5.9+
- SwiftUI
- SwiftData (local persistence)
- Async/Await concurrency
- MVVM pattern
- Dependency Injection
- URLSession & Decodable
- Unit Testing with mocks
