# MessageKit

***Easily extensible iOS message kit app. 
Reverse Engineered ChatGPT API by OpenAI***


## ChatGPT <img src="https://github.com/acheong08/ChatGPT/blob/main/logo.png?raw=true" width="15%"></img>

## Requirements

| Plugin | README |
| ------ | ------ |
| Language | Swift |
| UI Framework | UIKit |
| Chatbot API | ChatGPT by OpenAI |
| Xcode | 14.2 |
| Mac OS | 13.0.1 |


### Steps　

+ Signup in <https://openai.com/>, get your api key.
+ Replace `<your-open-ai-api-key>` with the api key generated in the project

```swift
    var headers: HTTPHeaders? {
        return ["Authorization" : "Bearer <your-open-ai-api-key>",
                "Content-Type"  : "application/json"]
    }
```
    
### Screenshots
                
<img src="MessageKit/MessageKit/Resources/Screenshots/screen-shot-1.png?raw=true" width="40%"></img>
<img src="MessageKit/MessageKit/Resources/Screenshots/screen-shot-2.png?raw=true" width="40%"></img>


> Note: Free Software.
> For queries: sureshkumar_durairaj@yahoo.in
