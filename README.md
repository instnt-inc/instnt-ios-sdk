# Instnt iOS SDK

This documentation covers the basics of the Instnt iOS SDK. Using iOS SDK provides functions and libraries for a seamless integration with your front-end application.For a detailed overview of Instnt's functionality, visit the [Instnt documentation library](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)


# Requirements

| iOS  | Swift |
|------|-------|
| 11.0 |  5.0  |


# Table of Contents

- [Prerequisites](#prerequisites)
- [Getting started](#getting-started)
- [Document verification](#document-verification)
    * [Document verification pre-requisites](#document-verification-pre-requisites)
    * [Document verifications steps](#document-verification-steps)
- [OTP verification](#otp-one-time-passcode)
    * [OTP workflow ](#otp-flow )
- [Submit form data](#submit-form-data)
- [Instnt delegate](#instnt-delegate)
- [Instnt object](#instnt-object)
- [Instnt functions](#instnt-functions)
- [Assertion Response Payload](#assertion-response-payload)
- [Resource links](#resource-links)

# Prerequisites

* Sign in to your account on the Instnt Accept's dashboard and create a customer signup workflow that works for your company. Get the workflow ID, this ID is important during the integration with Instnt SDK.
Refer [Quick start guide](https://support.instnt.org/hc/en-us/articles/4408781136909) and [Developer guide, ](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview) for more information.

* The integration of SDK depends on your workflow; read the [Instnt Accept integration process,](https://support.instnt.org/hc/en-us/articles/4418538578701-Instnt-Accept-Integration-Process) to understand the functionalities provided by Instnt and how to integrate SDK with your application.

**Note:** ** The sample code provided in this documentation is from the sample app provided with the SDK. You control the client implementation entirely; there is no hard and fast rule to follow the sample code-- the sample is for understanding purposes only. **


# Getting started

Instnt iOS SDK is comprised of iOS components and mechanisms to facilitate communication between your application, Instnt SDK, and Instnt's APIs.

Note that a **Workflow ID** is required in order to properly execute this function. For more information concerning Workflow IDs, please visit
[Instnt's documentation library.](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)

1. Create a workflow in the Instnt dashboard and get the Workflow ID.

2. Install InstntSDK through [CocoaPods](https://cocoapods.org) by adding the following line to your Podfile:

```ruby
  'InstntSDK', :path => '../'
```

## Initialize transaction

* Set your view controller as a delegate in your load function to instantiate the Instnt delegate.
``` swift
  Instnt.shared.delegate = self
```

* `import` the InstntSDK and CFDocumentscan.
```swift
import InstntSDK
import CFDocumentScanSDK
```

* To start interacting with Instnt, the first step is to begin a transactiona and obtain a transaction id , which acts as a corelation key for the user signup session.

* See the following sample code to call the `setup` fuction:

**formKey** : workflowID

**endpoint**: production URL or sandbox URL

**completion block** : implement a completeion block that checks if the initialization of a transaction is a success or not.

```swift
Instnt.shared.setup(with: formKey, endPOint: self.endPoint?.textField.text ?? "", completion: { result in
                    SVProgressHUD.dismiss()
                    switch result {
                    case .success(let transactionID):
                        self.addResponse()
                        self.getFormAfterSuccess()
                        self.lblView?.lblText.text = "Set up is succeded with transaction Id \(transactionID)"
                    case .failure(let error):
                        self.lblView?.lblText.text = "Set up is failed with \(error.localizedDescription), please try again later"
                    }
                })

```

# Document verification 

Document verification feature comes into the picture if you have enabled it during the workflow creation in our dashboard.

When this feature is enabled, the physical capture and verification of selfies and Government-issued identification documents such as Passports and Driver's Licenses are available.

Read the [Document Verification](https://support.instnt.org/hc/en-us/articles/4408781136909#heading-6) section of the Quickstart guide to understand better how to enable the feature.

## Document verification pre-requisites

* iOS and Android mobile devices with Chrome or Safari browsers are supported for document verification.

* Desktop devices (laptops, PCs) are unsupported due to the poor quality of embedded cameras and lack of gyroscopes for orientation detection. While the feature will work on devices running Chrome or Safari browsers, the experience can vary.

* Do not include HTML tags with IDs containing the prefix 'aid.' e.g. `<div id=’aidFooter’>` in your web app as this prefix is reserved to be used by the toolkit.

* Document verification requires end-to-end communication over SSL to get permission to use the device camera.

## Document verifications steps

1. First step in the process of documentation is to scan a document. Following is the sample code for scaning a document.

```swift
Instnt.shared.scanDocument(licenseKey: self.licenseKey, from: self, settings: documentSettings)

```
**licenseKey:** License key

**UIViewController:** The document scan UIViewController

**documentSettings:** The document settings object, which has information such as document type, document side, and capture mode.

Once the document scan is completed, 


2. Next, upload the attachment. The upload attachment should be called for each side of the document, for example, front and backside of a driver's licence.

Following sample code demonstrates the upload attachment process:

```swift
Instnt.shared.uploadAttachment(data: captureResult.selfieData, completion: { result in
            SVProgressHUD.dismiss()
            switch result {
            case .success(_):
                Instnt.shared.verifyDocuments(completion: { result in
                    switch result {
                    case .success():
                        self.instntDocumentVerified()
                    case .failure(let error):
                        self.showSimpleAlert("Documen verification failed with error: \(error.localizedDescription)", target: self)
                    }
                })
            case .failure(let error):
                print("uploadAttachment error \(error.localizedDescription)")
                self.instntDocumentScanError()
            }
        })
```

3. Next, verify the documents that were uploaded. Once all the documents are uploaded, call verifyDocuments fuction to verify the documents.

```swift
  Instnt.shared.verifyDocuments(completion: { result in
    switch result {
    case .success():
      self.instntDocumentVerified()
    case .failure(let error):
      self.showSimpleAlert("Documen verification failed with error: \(error.localizedDescription)", target: self)
    }
  })
           
```

4. In the Instnt iOS SDK we provide another fucntionality of selfie scan/capture. It is similar to the document scan and upload process. Pass the `UIViewController` as the argument.

```swift
Instnt.shared.scanSelfie(from: self)
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
* Instnt SDK calls Instnt API and returns the response upon successful OTP verification

Instnt SDK provides two [library functions](#library-functions) to enable OTP. we have also provided the sample code for the implementation.
1. sendOTP (mobileNumber)

```swift
Instnt.shared.sendOTP(phoneNumber: phone, completion: { result in
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
Instnt.shared.verifyOTP(phoneNumber: phone, otp: otp, completion: { result in
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
Instnt.shared.submitData(ExampleShared.shared.formData, completion: { result in
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
    func onSelfieScanFinish(captureResult: CFASelfieScanData)
    func onSelfieScanError(error: InstntError)
}
```
- **onDocumentScanFinish:** This fuction is called when document scan is successfully completed.

- **onDocumentScanCancelled:** This fuction is called when document scan is not successful.

- **onSelfieScanCancelled:** This fuction is called when selfie scan is cancelled.

- **onSelfieScanFinish:**This fuction is called when selfie scan is successfully completed.

- **onSelfieScanError:**This fuction is called when selfie scan is has a error.


# Instnt object

<table data-layout="default" data-local-id="1461e79a-6df4-4f4b-b7df-a9a072096fd3" class="confluenceTable"><colgroup><col style="width: 173.0px;"><col style="width: 121.0px;"><col style="width: 465.0px;"></colgroup><tbody><tr><th class="confluenceTh"><p><strong>Property</strong></p></th><th class="confluenceTh"><p><strong>Type</strong></p></th><th class="confluenceTh"><p><strong>Description</strong></p></th></tr>

<tr><td class="confluenceTd"><p>instnttxnid</p></td><td class="confluenceTd"><p>UUID</p></td><td class="confluenceTd"><p>Instnt Transaction ID</p></td></tr>

<tr><td class="confluenceTd"><p>formId</p></td><td class="confluenceTd"><p>string</p></td><td class="confluenceTd"><p>Instnt Form/Workflow ID</p></td></tr>

<tr><td class="confluenceTd"><p>otpVerification</p></td><td class="confluenceTd"><p>boolean</p></td><td class="confluenceTd"><p>Whether Instnt Form/Workflow has OTP verification enabled</p></td></tr>

<tr><td class="confluenceTd"><p>documentVerification</p></td><td class="confluenceTd"><p>boolean</p></td><td class="confluenceTd"><p>Whether Instnt Form/Workflow has document verification enabled</p></td></tr>
</tbody></table>

# Instnt functions

<table data-layout="default" data-local-id="1461e79a-6df4-4f4b-b7df-a9a072096fd3" class="confluenceTable"><colgroup><col style="width: 173.0px;"><col style="width: 71.0px;"><col style="width: 65.0px;"></colgroup><tbody><tr><th class="confluenceTh"><p><strong>Method</strong></p></th><th class="confluenceTh"><p><strong>Input Parameters</strong></p></th><th class="confluenceTh"><p><strong>Description</strong></p></th></tr>


<tr><td class="confluenceTd"><p>

## <font size="3">setup</font>
</p></td><td class="confluenceTd"><p>(with formId: String, endPOint: String, completion: @escaping(Result<String, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Initializes a user signup session.</p></td></tr>

<tr><td class="confluenceTd"><p>

## <font size="3">scanDocument</font>
</p></td><td class="confluenceTd"><p> (licenseKey: String, from vc: UIViewController, settings: DocumentSettings)</p></td><td class="confluenceTd"><p> </p></td><td class="confluenceTd"><p>This fuction enables the document scan.</p></td></tr>

<tr><td class="confluenceTd"><p>

## <font size="3">uploadAttachment</font>
</p></td><td class="confluenceTd"><p>(data: Data, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Upload a document file to Instnt server.</p></td></tr>

<tr><td class="confluenceTd"><p>

## <font size="3">verifyDocuments</font>
</p></td><td class="confluenceTd"><p>(completion: @escaping(Result<Void, InstntError>) -> Void) </p></td><td class="confluenceTd"><p>Initiate document verification on Instnt server.</p></td></tr>

<tr><td class="confluenceTd"><p>

## <font size="3">submitData</font>
</p></td><td class="confluenceTd"><p>(_ data: [String: Any], completion: @escaping(Result<FormSubmitResponse, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Submit the user entered data and the documents uploaded to the Instnt server and initiate customer approval process.</p></td></tr>

## <font size="3">sendOTP</font>

</p></td><td class="confluenceTd"><p>(phoneNumber: String, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Sends one-time password to the mobile number provided.</p></td></tr>
<tr><td class="confluenceTd"><p>

## <font size="3">verifyOTP</font>

</p></td><td class="confluenceTd"><p>(phoneNumber: String, otp: String, completion: @escaping(Result<Void, InstntError>) -> Void)</p></td><td class="confluenceTd"><p>Verifies one-time password that was sent to the provided mobile number.</p></td></tr>

<tr><td class="confluenceTd"><p>

## <font size="3">scanSelfie</p>
</p></td><td class="confluenceTd"><p>(from vc: UIViewController)</p></td><td class="confluenceTd"><p>Function that enables selfie scan.</p></td></tr>

</tbody></table>

# Assertion response payload

Now that you're connected to the sandbox environment, you can begin processing synthetic applicants provided to you by Instnt. The decisions applied to these synthetic applicants will be returned in the form of an assertion response payload that must be decrypted.

For more information concerning the decryption and analysis of the assertion response payload refer to the [Data Encryption and Decryption](https://support.instnt.org/hc/en-us/articles/360045168511) and [Getting and Analyzing the Assertion Response](https://support.instnt.org/hc/en-us/articles/360044671691) articles in the Developer Guide.

# Resource links
- [Quick start guide](https://support.instnt.org/hc/en-us/articles/4408781136909)
- [Developer guide](https://support.instnt.org/hc/en-us/articles/360055345112-Integration-Overview)
- [Instnt API endpoints](https://swagger.instnt.org/)
- [Instnt support](https://support.instnt.org/hc/en-us)

# License

The instnt-reactjs SDK is under MIT license.



