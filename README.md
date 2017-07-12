# Marvel Browser

A demo application making use of the Marvel API; a playground for exploring clean code and architecture (using [RxSwift](https://github.com/ReactiveX/RxSwift)).

### Goals

* Clean code and a scaleable, modular architecture. The usual.
* Performance and UX - clearer code is only good if the UI remains smooth.

### Setup

In order to compile and run the project, you will need a [Marvel Developer](https://developer.marvel.com/) account.

Add a `Config.swift` file to the root of your project and add the following:

```
let MARVEL_PUBLIC_KEY = "<YOUR_PUBLIC_KEY>"
let MARVEL_PRIVATE_KEY = "<YOUR_PRIVATE_KEY"
let MARVEL_BASE_URL = "https://gateway.marvel.com/"
```

You also need to have [CocoaPods](https://cocoapods.org/) installed and run

`pod install`

### Current Features

* A single scrollable list of all Marvel characters, lazy loaded as the user scrolls through the list.
* Offline support - further sessions first load data from disk and fall back onto the API if the data is not available.

### Next Steps

##### A real local database

Currently we just write previous responses to disk (see `MarvelCharactersDiskDataSource`), which works well enough but won't support more extended features, such as data sync and fast queries for specific characters.

##### Data Sync

Once we've downloaded the data, we never check with the server for updates, we just rely on the local cached data. This will be much more of a problem if we start displaying more details for each character, such as what comics they've appeared in.

##### Navigate to more details

Allow the user to tap on characters and view more details for that character. We can grow the concept of navigators introduced in `MarvelCharacterListViewNavigator` to support this.
