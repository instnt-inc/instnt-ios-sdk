


// BehavioSec IOS SDK
// Version: 3.0.1
// Copyright (c) 2021 BehavioSec. All rights reserved.



//
//  BehavioSecIOSSDK.h
//
//  Copyright © 2021 BehavioSec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "names.h"

#define BehavioSecIOSSDK COMPAT_CLASS_NAME(BehavioSecIOSSDK)

static const int INPUT_BUTTON = 1;
static const int DELETE_BUTTON = 2;
static const int CLEAR_BUTTON = 3;

static const int NORMAL_TARGET = 1;
static const int ANONYMOUS_TARGET = 2;
static const int MASKED_TARGET = 3;



@interface BehavioSecIOSSDK : NSObject

/*!
 * @brief callback for webviews
 */
@property(atomic) void (^ _Nonnull onLastDown)(NSTimeInterval); // come back here, webview is not allowed

+(nonnull instancetype)sharedIOSSDK;

/*!
 * @discussion feature bitmask for TMX integration
 */
-(void) setBitmask:(uint64_t) mask;

/*!
 * @discussion sets the window for the actual soft keyboard
 */
-(void) setUIRemoteKeyboardWindow:(UIWindow* _Nullable)window;

/*!
 * @discussion Delivers information if the ButtonSDK or KbdSDK is active
 */
-(BOOL)isBtnSdkOrKbdSDKActive;
/*!
 * @discussion Resets the information if the ButtonSDK or KbdSDK is active, to improve automatic decision process
 */
-(void)clearBtnSdkAndKbdSDKActive;

/*!
 * @discussion Prevent the SDK to fill in text into the registered Textfields.
 */
-(void) turnOffTextFieldFilling;

/*!
 * @discussion Register a button to be watched/sampled.
 */
-(void) registerButton:(nonnull UIButton*)inUIButton withButtonType:(int) inType andKey:(int)inKey;

/*!
 * @discussion Register a Target for button input.
 * @param inName The name of the target.
 * @param inAnonymous Specifies if the target should be anonymous. For anonymous targets no key codes are written to the collected data.
 */
-(void) registerBtnTargetWithID:(nonnull NSObject*) inID andName:(nonnull NSString*)inName isAnonymous:(BOOL)inAnonymous;

/*!
 * @discussion Register a Target for button input.
 * @param inName The name of the target.
 * @param inTargetType Specifies the type of the target: normal, anonymous or masked. For masked and anonymous targets no key codes are written to the collected data.
 */
-(void) registerBtnTargetWithID:(nonnull NSObject*) inID andName:(nonnull NSString*)inName andTargetType:(int)inTargetType;

/*!
 * @discussion Register a Target for button input.
 * @param inName The name of the target.
 * @param inTargetType Specifies the type of the target: normal, anonymous or masked. For masked and anonymous targets no key codes are written to the collected data.
 */
-(void)registerBtnTargetWithID:(nonnull NSObject*) inID andName:(nonnull NSString*)inName andTargetType:(int)inTargetType hideNativeKbd:(bool)inHideKbd;

/*!
 * @discussion Register an UITextField as target for keyboard input.
 * @param inName The name of the target.
 * @param inAnonymous Specifies if the target should be anonymous. For anonymous targets no key codes are written to the collected data.
 */
-(void) registerKbdTargetWithID:(nonnull UITextField*) inID andName:(nonnull NSString*)inName isAnonymous:(BOOL)inAnonymous;

/*!
 * @discussion Register an UITextField as target for keyboard input.
 * @param inName The name of the target.
 * @param inTargetType Specifies the type of the target: normal, anonymous or masked. For masked and anonymous targets no key codes are written to the collected data.
 */
-(void) registerKbdTargetWithID:(nonnull UITextField*) inID andName:(nonnull NSString*)inName andTargetType:(int)inTargetType;

/*!
 * @discussion Register an UITextField as target for keyboard input from the swizzled SDK. Only for internal use!
 * @param inName The name of the target.
 * @param inTargetType Specifies the type of the target: normal, anonymous or masked. For masked and anonymous targets no key codes are written to the collected data.
 */
-(void) registerKbdTargetWithIDFromSwizzledSDK:(nonnull UITextField*)inID isTemp:(BOOL)isTemp andName:(nonnull NSString*)inName andTargetType:(int)inTargetType;

/*!
 * @discussion Rename a target for keyboard input.
 * @param inName The name of the target.
 */
-(void) renameKbdTargetWithIDFromSwizzledSDK:(nonnull UIView*)inID andName:(nonnull NSString*)inName;

/*!
 * @discussion Register an UITextField as target for keyboard input.
 * @param inName The name of the target.
 * @param inAnonymous Specifies if the target should be anonymous. For anonymous targets no key codes are written to the collected data.
 * @param inClearWholeTarget Specifies if the whole target and its so far collected timing data will be cleared instead of deleting one single character by pressing the delete button.
 */
-(void) registerKbdTargetWithID:(nonnull UITextField *) inID andName:(nonnull NSString*)inName isAnonymous:(BOOL)inAnonymous andClearWholeTarget:(BOOL)inClearWholeTarget;

/*!
 * @discussion Register an UITextField as target for keyboard input.
 * @param inName The name of the target.
 * @param inTargetType Specifies the type of the target: normal, anonymous or masked. For masked and anonymous targets no key codes are written to the collected data.
 * @param inClearWholeTarget Specifies if the whole target and its so far collected timing data will be cleared instead of deleting one single character by pressing the delete button.
 */
-(void) registerKbdTargetWithID:(nonnull UITextField *) inID andName:(nonnull NSString*)inName andTargetType:(int)inTargetType andClearWholeTarget:(BOOL)inClearWholeTarget;

/*!
 * @discussion set current target
 */
-(void) setCurrentTargetID:(nullable NSObject*) inTargetID;

/*!
 * @discussion Get the version of the SDK.
 * @return The version string of the SDK.
 */
-(nonnull NSString*) getVersion;

/*!
 * @discussion Clear all timingdata only.
 */
-(void) clearTimingData;

/*!
 * @discussion Clear all timingdata, information, registrations and stop motion detection.
 */
-(void) clearRegistrations;

/*!
 * @discussion Start motion detection for gyro and acceleration.
 */
-(void) startMotionDetect;

/*!
 * @discussion Stop motion detection, is called on getSummary.
 */
-(void) stopMotionDetect;

-(void) addInformation:(nonnull NSString *)inInfoString withName:(nonnull NSString *)inInfoName;

/*!
 * @discussion To check if there are intersting data
 * @return The answer.
 */
-(BOOL) summaryContainsInterestingData;

/*!
 * @discussion Get the collected Data and stop motion detection without clearing timing data since 1.4.905. Call clearTimingData manually to clear the timing data.
 * @return The collected timing data as string.
 */
-(nonnull NSString*) getSummary;

/*!
 * @discussion Get the collected Data and stop motion detection without clearing timing data. Call clearTimingData manually to clear the timing data. If inCompressed is true, timing data will be compressed to be used together with the FLAG_COMPRESSED_DATA operator flag.
 * @return The collected timing data as string.
 */
-(nonnull NSString*) getSummary:(BOOL)inCompressed;

/*!
 * @discussion Get a chunk of collected Data without clearing timing data.
 * @return The collected timing data chunk as string.
 */
-(NSDictionary* _Nullable) getChunk:(BOOL)started isFirst:(BOOL)isFirst isLast:(BOOL)isLast withId:(long)viewId andCounter:(unsigned long)counter andBhsCounter:(NSMutableDictionary * _Nonnull)bhsCounter andMod:(unsigned long)mod;

/*!
 * @discussion Experimental, for test purpose only. Must be called immediately after first call of sharedIOSSDK.
 */
-(void) setShouldSendRawData:(BOOL) inShouldSendRawData;

-(void) setShouldCollectLegacyData:(BOOL) inShouldCollectLegacyData;

//TouchSDK
-(void)enableTouchSDKWithViewController:(nonnull UIViewController*)inViewController;
-(void)clearTouchSDKRef:(nonnull UIViewController*)vc;

#ifndef BUILD_AS_MODULE
//Device data (enabled by default)
-(void) collectDeviceData:(BOOL)enable;

//Location data (disabled by default)
-(void) collectLocationData:(BOOL)enable;
#endif

//Context data (enabled by default)
-(void) collectContextData:(BOOL)enable;

// experimental! methods to handle input from non UITextfields (NTF)
// added 19.03.2016 by JB
-(void)registerKeybdTargetNTF:(nonnull NSObject *)target withName:(nonnull NSString *)name isAnonymous:(BOOL)anonymous;
-(void)registerKeybdTargetNTF:(nonnull NSObject *)target withName:(nonnull NSString *)name andTargetType:(int)inTargetType;
-(void)keybdTargetTextChangedNTF:(nonnull NSObject *)target to:(nonnull NSString *)newText;
-(void)setCurrentKeybdTargetNTF:(nonnull NSObject *)target with:(nonnull NSString *)text;
-(void)setCurrentKeybdTargetNTF:(nonnull NSObject *)target with:(nonnull NSString *)text inputAccessoryView:(nullable UIView *)inputAccessoryView;

//depreciated methods in 1.5
///clear all timingdata and all registrations, information, stop motion detection
-(void) clear __attribute__((deprecated("this method is deprecated in BehavioSecIOSSDK version 1.5., use clearTimings and clearRegistrations instead")));
///clear all data, all registrations and text in registered Texfields, information, stop motion detection
-(void) clearAlsoTargets __attribute__((deprecated("this method is deprecated in BehavioSecIOSSDK version 1.5., clearing the taregts should be handled in your app")));

@end
