# RethinkTakeHome

---

## Description

This project is a Swift application built using SwiftUI and asynchronous network calls. The application fetches and displays users, posts, and comments from the JSONPlaceholder API in an expandable list format.

## Features

- Fetches data asynchronously from the network.
- Displays the data in an expandable list format.
- Can count the number of users, posts, and comments.
- Can refresh the data.
- Supports both real and mock network services for flexibility and testability.

## Usage

### Prerequisites

- Swift 5.5 or later
- Xcode 13 or later
- iOS 15 or later

### Installation

1. Clone this repository.
2. Open the `.xcodeproj` file in Xcode.
3. Choose the desired simulator or device.
4. Click on the play button to run the application.

## Documentation

Each Swift file in the project includes detailed comments explaining the purpose and functionality of the classes, structs, and methods defined within. Here's an overview of the primary components:

- `ContentView.swift`: The main view of the application. It displays a list of users, and for each user, their posts and comments can be expanded.

- `ExpandableItem.swift`: Represents an expandable item in the list, which could be a user, post, or comment. This class includes logic to fetch and manage child items.

- `ResourceRequest.swift`: A generic struct responsible for making network requests and decoding the received data into a specified Swift type.

- `NetworkService.swift`: A protocol that defines the requirements for a network service. There are two main implementations: `RealNetworkService` for real network calls, and `MockNetworkService` for testing.

- `UsersHandler.swift`, `PostsHandler.swift`, and `CommentsHandler.swift`: These classes handle fetching and storing users, posts, and comments respectively.

For a deeper understanding, refer to the comments in the individual files.

---

## Acknowledgements

- JSONPlaceholder API for providing a simple fake REST API for testing and prototyping.

---
