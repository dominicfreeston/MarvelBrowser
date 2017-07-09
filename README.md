# Marvel Browser

A demo application making use of the Marvel API.

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
