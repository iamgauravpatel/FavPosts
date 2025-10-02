# FavPosts
FavPots – A SwiftUI iOS app to browse, search, and favorite posts with SwiftData persistence and MVVM architecture.

---

## **Features**

- Fetch posts from API: `https://jsonplaceholder.typicode.com/posts`
- Display posts in a scrollable list
- Search posts by title with **debounced search**
- Inspect post details
- Mark/unmark posts as favorites
- View all favorites in a dedicated tab
- Pull-to-refresh functionality
- Alerts for favorite save failures
- Modern SwiftUI + SwiftData + MVVM architecture

---

## **Screenshots**

<p align="center">
  <img src="screenshots/posts_list.png" alt="Posts List" width="30%"/>
  <img src="screenshots/post_detail.png" alt="Post Detail" width="30%"/>
  <img src="screenshots/favorites.png" alt="Favorites" width="30%"/>
</p>

---

## **Architecture & Tech Stack**

- **SwiftUI** – UI framework
- **SwiftData** – Persistent storage for favorites
- **MVVM** – Model-View-ViewModel architecture
- **Combine** – For debouncing search and reactive updates
- **Async/Await** – For networking
- **JSONPlaceholder API** – Mock API for posts

---

## **Installation**

1. Clone the repository:

```bash
git clone https://github.com/iamgauravpatel/FavPosts.git
```

2. Open the project in Xcode:

```bash
cd FavPosts
open FavPosts.xcodeproj
```

3. Build & run on simulator or device.
