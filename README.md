# Relaxful

A REST API Client written in Swift for use with macOS, watchOS, iOS, and tvOS


## Use

Use this framework in your iOS, watchOS, tvOS, or macOS project.

### CocoaPods

Initialize your pod project using ```pod init```  

Install pod by adding line ``` ``` under each platform needed.

### Manually

Build each platform target in the project, right click on the  
framework for your platform in the 'Products' group and click 'Reveal in Finder'  
pull the framework from the 'iosuniversal' folder. 

### Use Framework
  
```swift
import Relaxful
```

Relaxful does support HTTPS, if HTTP is used, be sure to  
set the AppTransportSecurity setting in your ```info.plist```.

### Make a Request

```swift
Relaxer().request("https://url.com", completion: { (response) in
    // process response
    print(response.text)
}) { (error) in
    // handle error           
}
```

### Request With Paramaters

```swift
Relaxer().request(.get, url: "https://url.com", body: ["param1":"someData"], headers: nil, completion: { (response) in
  // process response
  print(response.text)
}) { (error) in
  // handle error         
}
```

### Request With Headers

```swift
Relaxer().request(.get, url: "https://url.com", body: nil, headers: ["someHeader":"someHeaderData"], completion: { (response) in
  // process response
  print(response.text)
}) { (error) in
  // handle error         
}
```

### Validate a Response

Checks for invalid HTTP Response Codes  
Valid response codes are 200, 304, and 409

```swift
Relaxer().request("url", completion: { (response) in
   if(response.validate()) {
       // valid
       print(response.text)
   } else {
       // handle error
   }
}) { (error) in
    // handle error        
}
```

### JSON Object

```swift
Relaxer().request("url", completion: { (response) in
   if(response.validate()) {
       // valid
       if let jsonObject = response.jsonObject() {
          // parse json
       } else {
          // not a json object
       }
   } else {
       // handle error
   }
}) { (error) in
    // handle error        
}
```

### JSON Array

```swift
Relaxer().request("url", completion: { (response) in
   if(response.validate()) {
       // valid
       if let array = response.jsonArray() {
          for item in array {
            // parse json
          }
       } else {
          // not a json array
       }
   } else {
       // handle error
   }
}) { (error) in
    // handle error        
}
```

### Upload Request

You can pass params and headers the same as in an API Call.  

The ```data``` argument is a ```Data``` representation of your file.

```swift
Relaxer().upload(.post, url: "https://url.com", params: nil, headers: nil, fileKey: "images", fileName: "image.png", mime: "png", data: file, uploadDelegate: nil)
```

### Upload Delegate

To receieve notice of upload progress and if it completed with or without an error  
implement the ```UploadDelegate``` class.

```swift
 // progress update
 func uploadProgress(_ bytesSent:Int64, totalBytesSent:Int64, totalBytesExpectedToSend:Int64) {
    let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    // update progressView
    print("\(uploadProgress)")
 }
    
 // upload finished
 func uploadFinished(_ response:Response!, error:Error?) {
  if error != nil {
    // print error
  } else {
    // success
  }
 }
```

### Response

A response object contains properties and formatted data from
the API Call.

Note: all properties are optional except for 'status'.

Accessable Properties are:

- response, the URLResponse
- status, the HTTP Status
- text, the HTTP Body
- data, HTTP Body Data
- headers, the response headers
