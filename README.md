# Instnt iOS SDK

This documentation covers the basics of the Instnt iOS SDK. iOS SDK provides functions and libraries for seamless integration with your front-end application. For a detailed overview of Instnt's functionality, visit the [Instnt documentation hub](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)
# Table of Contents

- [Prerequisites](#prerequisites)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Document verification](#document-verification)
    * [Document verification pre-requisites](#document-verification-pre-requisites)
    * [Document verifications steps](#document-verification-steps)
- [OTP verification](#otp-one-time-passcode)
    * [OTP workflow ](#otp-flow )
- [Submit form data](#submit-form-data)
- [Instnt delegate](#instnt-delegate)
- [Instnt object](#instnt-object)
- [Resource links](#resource-links)

# Prerequisites

* Sign in to your account on the Instnt Accept's dashboard and create a customer signup workflow that works for your company. Get the workflow ID. This ID is essential while integrating with Instnt SDK.
Refer [Quick start guide](https://support.instnt.org/hc/en-us/articles/4408781136909) and [Developer guide, ](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview) for more information.

* The integration of SDK depends on your workflow; read the [Instnt Accept integration process](https://support.instnt.org/hc/en-us/articles/4418538578701-Instnt-Accept-Integration-Process) to understand the functionalities provided by Instnt and how to integrate SDK with your application.

**Note:** Your implementation with Instnt's SDK may diverge from the integration shown in the sample app. Please get in touch with the Instnt support team for additional questions related to Integration.

# Requirements

| iOS  | Swift | Xcode |
|------|-------|-------
| 12+ |  5.0  | 11+    |

## Minimum Supported Devices
* iPhone 6 and 6plus

* iPad mini 4

* iPad Air 2

* iPad Pro (1st generation)

* iPad 5th generation

# Getting started

Instnt iOS SDK is comprised of iOS components and mechanisms to facilitate communication between your application, Instnt SDK, and Instnt's APIs.

Note that a **Workflow ID** is required to execute this function properly. For more information concerning Workflow IDs, please visit
[Instnt's documentation library.](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)

1. Create a workflow in the Instnt dashboard and get the Workflow ID.

2. Install InstntSDK through [CocoaPods](https://cocoapods.org) by adding the following line to your Podfile:

```ruby
  pod 'InstntSDK', :git => 'https://github.com/instnt-inc/instnt-ios-sdk.git'
```

## Initialize transaction

* Set your view controller as a delegate in your load function to instantiate the Instnt delegate.
``` swift
  Instnt.shared.delegate = self
```

* `import` the InstntSDK
```swift
import InstntSDK
```

* The first step is to begin a transaction and obtain a transaction id, which acts as a correlation key for a user signup session to interact with Instnt.

* See the following sample code to call the `setup` fuction:

**formKey** : workflowID

**endpoint**: production URL or sandbox URL

**completion block** : implement and pass a completeion block that checks if the initialization of a transaction is a success or not.

```swift
Instnt.shared.setup(with: formKey, endPOint: self.endPoint?.textField.text ?? "", completion: { result in
    SVProgressHUD.dismiss()
    switch result {
    case .success(let transactionID):
        ExampleShared.shared.transactionID = transactionID
        self.addResponse()
        self.getFormAfterSuccess()
        self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
    case .failure(let error):
        self.addResponse()
        self.lblView?.lblText.text = "Set up is failed with \(error.message ?? ""), please try again later"
    }
})

```

# Document verification 

Document verification feature comes into the picture if you have enabled it during the workflow creation in our dashboard.

When this feature is enabled, the physical capture and verification of selfies and Government-issued identification documents such as Passports and Driver's Licenses are available.

**Note:** Document Verification feature usage in your implementation via SDK requires a **License** **key**. Please contact the support at the email support@instnt.org for further assistance.
## Document verification pre-requisites

* iOS devices reasonably updated OS and a good camera are supported for document verification.

## Document verifications steps

1. The first step in document verification is to scan a document. Following is the sample code for scanning a document.

The document verification has an auto-upload feature which is turned on by default. It uploads the image to Instnt cloud storage once the image gets captured successfully.

```swift
Instnt.shared.scanDocument(instnttxnid: transactionID, licenseKey: self.licenseKey, from: self, settings: documentSettings)

```
**licenseKey:** License key

**UIViewController:** The document scan UIViewController

**documentSettings:** The document settings object, which has information such as document type, document side, and capture mode.

2. Next, upload the attachment. The upload attachment should be called for each side of the document, for example, the front and backside of a driver's license. You only need to take this step if you have autoUpload turned off (when you invoke scanDocument or scanSelfie methods)

The following sample code demonstrates the upload attachment process:

```swift
Instnt.shared.uploadAttachment(instnttxnid: transactionID, data: captureResult.selfieData, completion: { result in
    switch result {
    case .success(_):
        if captureResult.farSelfieData != nil {
            Instnt.shared.uploadAttachment(instnttxnid: transactionID, data: captureResult.selfieData, isFarSelfieData: true, completion:  { result in
                switch result {
                case .success():
                    self.verifyDocument()
                case .failure(let error):
                    SVProgressHUD.dismiss()
                    print("uploadAttachment error \(error.localizedDescription)")
                    self.instntDocumentScanError()
                }
            })
        } else {
            self.verifyDocument()
        }
        
    case .failure(let error):
        SVProgressHUD.dismiss()
        print("uploadAttachment error \(error.localizedDescription)")
        self.instntDocumentScanError()
    }
})
```

3. Next, verify the documents that were uploaded. Once all the documents are uploaded, call verifyDocuments function to verify the documents.

```swift
  Instnt.shared.verifyDocuments(instnttxnid: transactionID, completion: { result in
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
            switch result {
            case .success():
                self.instntDocumentVerified()
            case .failure(let error):
                self.showSimpleAlert("Document verification failed with error: \(error.message ?? "Technical Difficulties")", target: self)
            }
        }
    })
           
```

4. In the Instnt iOS SDK, we provide another functionality for selfie scan/capture. It is similar to the document scan and upload process. Pass the `UIViewController` type as the argument. It also takes a far Selfie as a second check but this can be disabled by setting farSelfie false as argument.

```swift
Instnt.shared.scanSelfie(from: self, instnttxnid: transactionID, farSelfie: self.isFarSelfie ?? false, isAutoUpload: self.isAutoUpload ?? true)
```

# OTP (One-Time Passcode)
OTP functionality can be enabled by logging in Instnt dashboard and enabling OTP in your workflow. Refer to the [OTP](https://support.instnt.org/hc/en-us/articles/4408781136909#heading-5) section of the Quickstart guide for more information.

## OTP flow
* User enters mobile number as part of the signup screen.
* Your app calls send OTP() SDK function and pass the mobile number.
* Instnt SDK calls Instnt API and returns the response upon successful OTP delivery.
* Your app shows the user a screen to enter the OTP code.
* User enters the OTP code which they received.
* Your app calls verify the OTP() SDK function to verify the OTP and pass mobile number and OTP code.
* Instnt SDK calls Instnt API and returns the response upon successful OTP verification.

Instnt SDK provides two [library functions](#library-functions) to enable OTP. we have also provided the sample code for the implementation.

1. sendOTP (mobileNumber)

```swift
Instnt.shared.sendOTP(instnttxnid: transactionID, phoneNumber: phone, completion: { result in
        SVProgressHUD.dismiss()
        switch result {
        case .success:
            ExampleShared.shared.formData["mobileNumber"] = self.phone?.textField.text
            ExampleShared.shared.formData["email"] = self.email?.textField.text
            guard let vc = Utils.getStoryboardInitialViewController("VerifyOTP") as? VerifyOTPVC else {
                return
            }
            vc.presenter?.phoneNumber = phone
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        case .failure( let error):
            if let vc = self.vc {
                self.vc?.showSimpleAlert(error.message ?? "Error getting the OTP", target: vc)
            }
        }
    })
```
2. verifyOTP(mobileNumber, otpCode)

```swift
Instnt.shared.verifyOTP(instnttxnid: transactionID, phoneNumber: phone, otp: otp, completion: { result in
        SVProgressHUD.dismiss()
        switch result {
        case .success:
            ExampleShared.shared.formData["otpCode"] = self.otp?.textField.text
            guard let vc = Utils.getStoryboardInitialViewController("Address") as? AddressVC else {
                return
            }
            self.vc?.navigationController?.pushViewController(vc, animated: true)
        case .failure(let error):
            if let vc = self.vc {
                self.vc?.showSimpleAlert(error.message ?? "Invalid OTP", target: vc)
            }
        }
    })
```
# Submit form data

After gathering all the relevant end-user information and processing the documents, you can submit all the data to Instnt via `submitData` function.

See the sample code of the implementation:

```swift
Instnt.shared.submitData(instnttxnid: transactionID, data: ExampleShared.shared.formData, completion: { result in
    SVProgressHUD.dismiss()
    switch result {
    case .success(let response):
        if response.success == true,
            let decision = response.decision,
            let jwt = response.jwt {
            self.instntDidSubmitSuccess(decision: decision, jwt: jwt)
        } else {
            if let msg = response.message {
                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT, message: msg))
            } else {
                self.instntDidSubmitFailure(error: InstntError(errorConstant: .error_FORM_SUBMIT))
            }
            
        }
    case .failure(let error):
        self.instntDidSubmitFailure(error: error)
    }
    
})
```

The completion block that is passed as an argument when submitdata fuction is called can be implemented as you want. 
The following parameter are returned:
- `decision`: Form submission result. One of the following three values is returned: `ACCPET`, `REJECT` and `REVIEW`
- `jwt`: Instnt JWT token


# Instnt delegate

Instnt SDK provides `InstntDelegate` which has the delegate fuctions as shown below. Implement the `InstntDelegate` Protocol:

```swift
public protocol InstntDelegate: NSObjectProtocol {

    func onDocumentScanFinish(captureResult: CaptureResult)
    func onDocumentScanCancelled(error: InstntError)
    
    func onSelfieScanCancelled()
    func onSelfieScanFinish(captureResult: CaptureSelfieResult)
    func onSelfieScanError(error: InstntError)
    
    func onDocumentUploaded(imageResult: InstntImageData, error: InstntError?)
}
```
- **onDocumentScanFinish:** This function is called when a document scan is successfully completed.

- **onDocumentScanCancelled:** This function is called when document scan is unsuccessful.

- **onSelfieScanCancelled:** This function is called when the selfie scan is canceled.

- **onSelfieScanFinish:** This function is called when the selfie scan is successfully completed.

- **onSelfieScanError:** This function is called when a selfie scan has an error.


# Instnt object

<table data-layout="default" data-local-id="1461e79a-6df4-4f4b-b7df-a9a072096fd3" class="confluenceTable"><colgroup><col style="width: 200.0px;"><col style="width: 400.0px;"><col style="width: 500.0px;"></colgroup><tbody><tr><th class="confluenceTh"><p><strong>Property</strong></p></th><th class="confluenceTh"><p><strong>Type</strong></p></th><th class="confluenceTh"><p><strong>Description</strong></p></th></tr>

<tr><td class="confluenceTd"><p>instnttxnid</p></td><td class="confluenceTd"><p>UUID</p></td><td class="confluenceTd"><p>Instnt Transaction ID</p></td></tr>

<tr><td class="confluenceTd"><p>formId</p></td><td class="confluenceTd"><p>string</p></td><td class="confluenceTd"><p>Instnt Form/Workflow ID. This ID is available in the Instnt dashboard, where you created a signup workflow.</p></td></tr>

<tr><td class="confluenceTd"><p>isOTPSupported</p></td><td class="confluenceTd"><p>boolean</p></td><td class="confluenceTd"><p>Checks whether Instnt Form/Workflow has OTP verification enabled</p></td></tr>

<tr><td class="confluenceTd"><p>isDocumentVerificationSupported</p></td><td class="confluenceTd"><p>boolean</p></td><td class="confluenceTd"><p>Checks whether Instnt Form/Workflow has document verification enabled</p></td></tr>
</tbody></table>

# Instnt functions

<table data-layout="default" data-local-id="1461e79a-6df4-4f4b-b7df-a9a072096fd3" class="confluenceTable"><colgroup><col style="width: 200.0px;"><col style="width: 400.0px;"><col style="width: 500.0px;"></colgroup><tbody><tr><th class="confluenceTh"><p><strong>Method</strong></p></th><th class="confluenceTh"><p><strong>Input Parameters</strong></p></th><th class="confluenceTh"><p><strong>Description</strong></p></th></tr>


<tr><td class="confluenceTd"><p> <a id="user-content-setup" class="anchor" aria-hidden="true" href="#setup">

setup
</p></td><td class="confluenceTd"><p>(with formId: String, endPOint: String, completion: @escaping(Result<String, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Initializes a user signup session.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-scanDocument" class="anchor" aria-hidden="true" href="#scanDocument">

scanDocument
</p></td><td class="confluenceTd"><p> (instnttxnid: transactionID, licenseKey: String, from vc: UIViewController, settings: DocumentSettings)</p></td><td class="confluenceTd"><p>Enables a document scan.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-scanSelfie" class="anchor" aria-hidden="true" href="#scanSelfie">

scanSelfie</p>
</p></td><td class="confluenceTd"><p>(from vc: UIViewController, instnttxnid: transactionID, farSelfie: bool)</p></td><td class="confluenceTd"><p> Enables a selfie scan/capture.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-uploadAttachment" class="anchor" aria-hidden="true" href="#uploadAttachment">

uploadAttachment
</p></td><td class="confluenceTd"><p>(instnttxnid: transactionID, data: Data, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Upload a document file to Instnt server.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-verifyDocuments" class="anchor" aria-hidden="true" href="#verifyDocuments">

verifyDocuments
</p></td><td class="confluenceTd"><p>(instnttxnid: transactionID, completion: @escaping(Result<Void, InstntError>) -> Void) </p></td><td class="confluenceTd"><p>Initiate document verification on Instnt server.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-submitData" class="anchor" aria-hidden="true" href="#submitData">

submitData
</p></td><td class="confluenceTd"><p>(instnttxnid: transactionID, data: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Submit the user entered data and the documents uploaded to the Instnt server and initiate customer approval process.</p></td></tr>

<tr><td class="confluenceTd"><p> <a id="user-content-sendOTP" class="anchor" aria-hidden="true" href="#sendOTP">
<p>
sendOTP
</p></td><td class="confluenceTd"><p>(instnttxnid: transactionID, phoneNumber: String, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Sends one-time password to the mobile number provided.</p></td></tr>

<tr><td class="confluenceTd"><p><a id="user-content-verifyOTP" class="anchor" aria-hidden="true" href="#verifyOTP">

verifyOTP

</p></td><td class="confluenceTd"><p>(instnttxnid: transactionID, phoneNumber: String, otp: String, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Verifies one-time password that was sent to the provided mobile number.</p></td></tr>

</tbody></table>

# Resource links
- [Quick start guide](https://support.instnt.org/hc/en-us/articles/4408781136909)
- [Developer guide](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)
- [Instnt API documentation](https://api.instnt.org/doc/swagger/)
- [Instnt documentation hub](https://support.instnt.org/hc/en-us)

# License

The instnt-iOS SDK is under MIT license.



