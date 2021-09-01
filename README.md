# InstntSDK

This documentation covers the basics of the Instnt iOS SDK. For a detailed overview of Instnt's functionality, visit the [Instnt documentation library](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)

## Requirements

| iOS  | Swift |
|------|-------|
| 11.0 |  5.0  |

## Rendering a Standard Signup Workflow with Instnt SDK

Instnt SDK can render a standard workflow that includes the following fields:
* Email Address
* First Name
* Surname
* Mobile Number
* State
* Street Address
* Zip code
* City
* Country
* Submit My Workflow Button

## Getting Started

Note that a Workflow ID is required in order to properly execute this function. For more information concerning Workflow IDs, please visit
[Instnt's documentation library.](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)

1. Create a form in the Instnt dashboard and get the Workflow ID.

2. Install InstntSDK through [CocoaPods](https://cocoapods.org) by adding the following line to your Podfile:

```ruby
  pod 'InstntSDK'
```

3. Implement the following code to present the form associated with the Workflow ID:

```swift
  import InstntSDK
  
  class ViewController: UIViewController {
      func showForm() {
        let formId = "v879876100000"
        Instnt.shared.setup(with: formId, isSandBox: true)
        Instnt.shared.delegate = self
        
        SVProgressHUD.show()
        Instnt.shared.showForm(from: self) { [weak self] (presented, message) in
            SVProgressHUD.dismiss()
            
            if !presented {
                self?.showError(message: message)
            }
        }
      }
  }
```

`isSandBox` contains the flags that determine whether to work with either the sandbox or the production server.
If `isSandBox` is true, the sandbox server is used, otherwise the implementation points to the production server by default. 

3. Collect data from the user. Alerts are shown if the user misses a field or enters incorrectly formatted data.

4. Implement the `InstntDelegate` Protocol:

```swift
  extension ViewController: InstntDelegate {
      func instntDidCancel(_ sender: Instnt) {
          showError(message: "Canceled By User!")
      }
      
      func instntDidSubmit(_ sender: Instnt, decision: String, jwt: String) {
          showError(message: decision)
      }
  }
```

When a user taps the `Submit` button on the Signup page, all data from the user is submitted. You can retrieve the submission result via the `InstntDelegate` functions below:

`instntDidCancel` is called when the user taps the Cancel button.
`instntDidSubmit` is called when the data is submitted successfully.
  - `decision`: Form submission result. One of the following three values is returned: `ACCPET`, `REJECT` and `REVIEW`
  - `jwt`: Instnt JWT token


## Custom Usage

InstntSDK provides the following two functions for submitting custom forms to Instnt's API.

```swift
func getFormCodes(_ completion: @escaping (([String: Any]?) -> Void))
func submitFormData(_ data: [String: Any], completion: @escaping (([String: Any]?) -> Void))
```

1. Call the `getFormCodes` function first to prepare form submission.
```swift
  import InstntSDK
  
  class ViewController: UIViewController {
      func getFormCodes() {
        let formId = "v879876100000"
        Instnt.shared.setup(with: formId, isSandBox: true)
       
        SVProgressHUD.show()
        Instnt.shared.getFormCodes() {(responseJSON) in
            SVProgressHUD.dismiss()
            
            print("respose=\(responseJSON)")
        }
      }
  }
```
If the request fails, `responseJSON` will be nil. If the request succeeeds, the response contains a form code.

2. Call `submitFormData` function with user data.
```swift
  class ViewController: UIViewController {
      //...
      func submitForm() {
        let formData: [String: Any] = ["field 1": "value 1", "field 2": "value 2"] // define custom data here
        SVProgressHUD.show()
        Instnt.shared.submitFormData() {(responseJSON) in
            SVProgressHUD.dismiss()
            
            print("respose=\(responseJSON)")
        }
      }
  }
```

 `responseJSON` will contain the form submission result.

