# Relaxful

A REST API Client written in Objective-C and Swift for use with macOS, watchOS, iOS, and tvOS


## Use

Use this framework in your iOS, watchOS, tvOS, or macOS project.

### CocoaPods

Initialize your pod project using ```pod init```  

Install pod by adding line ``` ``` under each platform needed.

### Manually

Build each platform target in the project, right click on the  
framework for your platform in the 'Products' group and click 'Reveal in Finder'  
pull the framework from the 'iosuniversal' folder. 

## Swift

### Use Framework

Swift  
```swift
import Relaxful
```

Objective-C  
```objective-c
#import <Relaxful/RelaxfulClient.h>
```

### Make a Request

```swift
Relaxer().request("url", completion: { (response) in
    // process response
}) { (error) in
    // error           
}
```

### Request With Paramaters

```swift

```

### Validate a Response

Checks for invalid HTTP Response Codes  
Valid response codes are 200, 304, and 409

```swift
Relaxer().request("url", completion: { (response) in
   if(response.validate()) {
       // valid
   } else {
       // error
   }
}) { (error) in
    // error        
}
```

### Upload Request

```swift

```
