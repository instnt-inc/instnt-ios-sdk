# SwiftyInstnt
This documentation covers the basics of Instnt's Swift SDK. For a detailed overview of Instnt's functionality, visit the [Instnt documentation library](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)

## Requirements

| iOS  | Swift |
|------|-------|
| 11.0 |  5.0  |

## Rendering a Standard Signup Workflow with Instnt Swift SDK

Instnt Swift SDK can render a standard workflow that includes the following fields:
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

2. Implement the following code to present the form associated with the Workflow ID
```swift
  class ViewController: UIViewController {
      func showForm() {
        let formId = "v879876100000"
        SwiftyInstnt.shared.setup(with: formId, isSandBox: true)
        SwiftyInstnt.shared.delegate = self
        
        SVProgressHUD.show()
        SwiftyInstnt.shared.showForm(from: self) { [weak self] (presented, message) in
            SVProgressHUD.dismiss()
            
            if !presented {
                self?.showError(message: message)
            }
        }
      }
  }
```

3. Collect data from the user. Alerts will be shown if the user misses a field or enters incorrectly formatted data.

4. Implement `SwiftyInstntDelegate` Protocol

```swift
  extension ViewController: SwiftyInstntDelegate {
      func swiftyInstntDidCancel(_ sender: SwiftyInstnt) {
          showError(message: "Canceled By User!")
      }
      
      func swiftyInstntDidSubmit(_ sender: SwiftyInstnt, decision: String, jwt: String) {
          showError(message: decision)
      }
  }
```

When a user taps the `Submit` button on the Signup page, all data from the user is submitted. You can retrieve the submission result via `SwiftyInstntDelegate` functions

`swiftyInstntDidCancel` is called when the user taps the Cancel button.
`swiftyInstntDidSubmit` is called when the data is submitted successfully.
  - `decision`: Form submission result. One of the following three values is returned: `ACCPET`, `REJECT` and `REVIEW`
  - `jwt`: Instnt JWT token
