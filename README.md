# Notes for the Reviewer

- The project is compatible with Swift 5
- Committed Pods to Repository so the reviewer can just download project and run it in XCode 10.2.1 or later without needing to update a Pods.
- Used MVVM + Router pattern 
- Used RxSwift to support binding between View and View Model
- Used RxSwift Observable pattern at Network Layer too 
- Wrote a few unit-test using Quick and Nimble to demonstrate the usage of Dependency Injection Pattern that I used throughout the classes implementation
- Implemented Caching using FileStorage so once data is downloaded on the device then App will work offline too. I didn't think to use CoreData as Gist is a simple json file which can be stored as File rather than Relational Database.
- Used Alamofire Library to implement Network request to show my understanding of third-party libraries. I could have implemented without this library too.
