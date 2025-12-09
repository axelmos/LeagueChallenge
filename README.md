# League Challenge #
A small iOS application built to authenticate a user, fetch Posts and Users and display it using a clean and scalable architecture.

**Instructions:**

To run the app just unpack the provided .zip file, open `LeagueiOSChallenge.xcodeproj` and Run in the simulator.
There is no need to do any special step or configuration.

## Architecture: ##
For this challenge, I decided to build a **UIKit** application following a **lightweight MVVM + Coordinators** approach with a clean separation between:

* Presentation layer (Views + ViewModels)
* Domain / Business rules
* Data layer (APIClient)
* Navigation layer (Coordinators)

This structure ensures:

* ViewModels are fully testable and contain only state + business logic.
* Views react to ViewModel outputs.
* Coordinator manage navigation and lifecycle
* APIClient is easily mocked thanks to `APIClientProtocol`.
* MVVM reduces UIViewController complexity.

## Networking: ##

Networking uses a simple `APIClientProtocol` so the ViewModels never depend on the APIClient, only on its protocol. Making it easier to mock and test.

`APIClient` has a generic reusable method called fetch that wraps all GET requests in one reusable method.

I chose to do the API Calls using async/await because I think the code is self explanatory and simplier and it aligns with modern iOS Development and Concurrency.

## Unit Testing: ##

I wrote tests for all the view models and generated a `MockAPIClient` that implements `APIClientProtocol`.
Those tests includes Email validation, field mapping, successfull login, error handling, etc.

## Future Improvements ##

* Fetch users only once and cache
* `ImageLoader` -> Use `NSCache` and provide a cache limit
* Refactor `PostsListViewModel` so it uses the protocol instead of `APIClient` class
* Show an alert in login when the inputs are empty instead of blocking the login button
* Improve the design
* Implement pagination or infinite scrolling list for posts list
* Keep the apiKey in a `SessionManager` instead of `Coordinator`
* Write more Unit Tests and UI Tests.
* Eliminate `APIHelper` and `fetchUserToken` method, and refactor fetch method in `APIClient` to allow "Basic" "Authorization" so we can do the token fetching using the same generic fetch function that I use when fetching posts and users.
* Improve Error Handling
