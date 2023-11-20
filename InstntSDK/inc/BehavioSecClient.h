


// BehavioSec IOS SDK
// Version: 3.0.1
// Copyright (c) 2021 BehavioSec. All rights reserved.



#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "names.h"

#define BehavioSecFieldCallback         COMPAT_CLASS_NAME(BehavioSecFieldCallback)
#define BehavioSecConnector             COMPAT_CLASS_NAME(BehavioSecConnector)
#define BehavioCloudConnectorBuilder    COMPAT_CLASS_NAME(BehavioCloudConnectorBuilder)
#define BehavioCloudConnector           COMPAT_CLASS_NAME(BehavioCloudConnector)
#define BehavioSenseConnectorBuilder    COMPAT_CLASS_NAME(BehavioSenseConnectorBuilder)
#define BehavioSenseConnector           COMPAT_CLASS_NAME(BehavioSenseConnector)
#define BehavioCallbackConnectorBuilder COMPAT_CLASS_NAME(BehavioCallbackConnectorBuilder)
#define BehavioCallbackConnector        COMPAT_CLASS_NAME(BehavioCallbackConnector)
#define BehavioSecCollectorBuilder      COMPAT_CLASS_NAME(BehavioSecCollectorBuilder)
#define BehavioSecCollector             COMPAT_CLASS_NAME(BehavioSecCollector)
#define BehavioSecClient                COMPAT_CLASS_NAME(BehavioSecClient)

NS_ASSUME_NONNULL_BEGIN

/// This protocol provides methods to control the type and name that BehavioSec iOS SDK will use for the
/// text fields being tracked.
@protocol BehavioSecFieldCallback <NSObject>

@required

/// Returns the field type for the given UITextField.
/// Use "f" for Normal collection mode, or "fm" for Anonymous Masked collection mode.
/// If nil, or any other vaue is returned, the SDK will fallback on the text fields properties (secureTextEntry and textContentType),
/// and the info provided in behavioTrackingId attribute.
- (NSString *) getFieldType:(UITextField *)textField;

/// Returns the field name for the given UITextField.
/// If nil is returned, the SDK will use the naming provided via the behavioTrackingId attribute, or the text field
/// properties (acessibilityLabel or accessibilityIdentifier).
- (NSString *) getFieldName:(UITextField *)textField;

@end

@protocol BehavioSecConnector <NSObject>

@required
/// Sets a new journeyId for the connector, which will be used in the subsequent requests.
/// This method is called when using [BehavioSecClient setNewJourneyId] to set the journeyId,
/// but your connector may use a callback function instead to automatically retrieve the journeyId when needed.
- (void) setNewJourneyId:(NSString *)newJourneyId;
@required
/// This method sends the collected behavioral data.
/// It is called whenever a ViewController is removed from the view hierarchy, or when [BehavioSecClient sendData] is called.
- (void) sendData:(NSString *)timingData;
@required

@end

#ifndef BUILD_AS_MODULE
#endif

/** BEHAVIOSENSE CONNECTOR START */
/// BehavioSenseConnectorBuilder is used to build instances of BehavioSenseConnector.
@interface BehavioSenseConnectorBuilder : NSObject

/// Sets the BehavioSense backend URL.
@property(nonatomic, copy) NSString *url;
/// Sets the ID of the tenant (only applicable in a multi-tenant setup).
@property(nonatomic, copy) NSString *tenantId;
/// Enables the compression of collected timing data (disabled by default).
@property(nonatomic) BOOL compressData;
/// Sets the initial journeyId to be used with this connector.
/// Can be changed using [BehavioSecClient setNewJourneyId] whenever needed (e.g., after logout).
@property(nonatomic, copy) NSString *journeyId;

@end

/// BehavioSenseConnector is responsible of sending the collected behavioral data to BehavioSense's backend using the BindJourney workflow.
@interface BehavioSenseConnector : NSObject<BehavioSecConnector>

/// Returns an instance of BehavioSenseConnector created from the fields set on the builder.
+ (instancetype)withBuilder:(void (^)(BehavioSenseConnectorBuilder *))block;

@end
/** BEHAVIOSENSE CONNECTOR END */

/** BEHAVIOCALLBACK CONNECTOR START */
/// BehavioCallbackConnectorBuilder is used to build instances of BehavioCallbackConnector.
@interface BehavioCallbackConnectorBuilder : NSObject

@property(atomic, readwrite) void (^ callback)(NSString* _Nonnull timingData);

@end

/// BehavioCallbackConnector is responsible of sending the collected behavioral data to a callback.
@interface BehavioCallbackConnector : NSObject<BehavioSecConnector>

/// Returns an instance of BehavioCallbackConnector created from the fields set on the builder.
+ (instancetype)withBuilder:(void (^)(BehavioCallbackConnectorBuilder *))block;

@end
/** BEHAVIOCALLBACK CONNECTOR END */

@interface BehavioSecCollectorBuilder : NSObject

/// Sets the TMX sdk bitmask (default: NO).
@property(nonatomic) uint64_t bitmask;
/// Use masked mode (default: NO).
@property(nonatomic) BOOL useMaskedMode;
/// Use chunking mode (default: NO).
@property(nonatomic) BOOL useChunks;
/// Sets whether basic logging should be allowed (default: NO).
@property(nonatomic) BOOL allowLogging;
/// Sets whether exceptions should not be thrown (default: NO).
@property(nonatomic) BOOL catchAndLogExceptions;
/// Sets whether accessibility label or Id should be allowed to use as behavioTrackingId (default: NO).
@property(nonatomic) BOOL useAccessibilityLabelOrIdAsTrackingId;
/// Sets whether placeholder should be allowed to use as behavioTrackingId (default: NO).
@property(nonatomic) BOOL usePlaceholderAsTrackingId;
/// Sets whether touch data should be collected or not (default: YES).
@property(nonatomic) BOOL collectTouchData;
/// Sets whether legacy touch data (BehavioSense below 5.3) should be collected or not (default: NO).
@property(nonatomic) BOOL collectLegacyTouchData;

#ifndef BUILD_AS_MODULE
/// Sets whether data needed for the Device Detection module to work should be collected or not (default: YES).
@property(nonatomic) BOOL collectDeviceData;
/// Sets whether location data should be collected or not (default: YES).
@property(nonatomic) BOOL collectLocationData;
#endif

/// Sets whether context data should be collected or not (default: YES).
/// Context data contains additional device data that is not needed by the
/// Device Detection module but is useful for forensic analysis.
@property(nonatomic) BOOL collectContextData;
/// Sets whether raw data should be collected or not (default: NO).
/// Enabling this option will have a huge impact on the size of the data collected.
/// The additional information will not be processed by the BehavioSense backend.
/// Please enable this option only when requested by the BehavioSec Support Team.
@property(nonatomic) BOOL collectRawData;
/// Sets the ViewControllers where behavioral data will be collected
/// (use the ViewController name as in NSStringFromClass).
/// It is also possible to collect data in ViewControllers by setting the
/// user defined attribute 'behavioTrackingId' in the corresponding ViewController.
@property(nonatomic, copy) NSSet *includedViews;
/// Sets a list of ViewControllers where behavioral data won't be sent automatically.
/// By default, if a BehavioSecConnector is set, BehavioSecClient automatically sends
/// the behavioral data each time a ViewController is removed from the view hierarchy.
/// But there are some cases when you need to manually send the data.
/// In those cases, use this method to disable automatic sending for those activities to
/// avoid getting a second transaction when the view controller is removed.
/// (use the ViewController name as in NSStringFromClass)
@property(nonatomic, copy) NSSet *noSendingViews;
/// Sets the UITextField trackingIds where behavioral data will be collected in normal mode
@property(nonatomic, copy) NSSet *normalFields;
/// Sets the UITextField trackingIds where behavioral data will be collected in masked mode
@property(nonatomic, copy) NSSet *maskedFields;

#ifndef BUILD_AS_MODULE
/// Sets a BehavioSecConnector which will be responsible of sending the collected behavioral
/// data to the backend. If not set, behavioral data can be collected by the host app using [BehavioSecClient getData]
@property(nonatomic, retain, nullable) id<BehavioSecConnector> connector;
#endif

/// Sets a BehavioSecFieldCallback that will be used by the SDK to assign the type and name for each text field.
/// If not set, the SDK will fallback on information provided by the behavioTrackingId attribute, and the
/// text field properties.
@property(nonatomic, retain, nullable) id<BehavioSecFieldCallback> fieldCallback;

@end

@interface BehavioSecCollector:NSObject

@property(nonatomic, readonly) uint64_t bitmask;
@property(nonatomic, readonly) BOOL useMaskedMode;
@property(nonatomic, readonly) BOOL useChunks;
@property(nonatomic, readonly) BOOL allowLogging;
@property(nonatomic, readonly) BOOL catchAndLogExceptions;
@property(nonatomic, readonly) BOOL useAccessibilityLabelOrIdAsTrackingId;
@property(nonatomic, readonly) BOOL usePlaceholderAsTrackingId;
@property(nonatomic, readonly) BOOL collectTouchData;
@property(nonatomic, readonly) BOOL collectLegacyTouchData;

#ifndef BUILD_AS_MODULE
@property(nonatomic, readonly) BOOL collectDeviceData;
@property(nonatomic, readonly) BOOL collectLocationData;
#endif

@property(nonatomic, readonly) BOOL collectContextData;
@property(nonatomic, readonly) BOOL collectRawData;
@property(nonatomic, copy, readonly) NSSet *includedViews;
@property(nonatomic, copy, readonly) NSSet *noSendingViews;
@property(nonatomic, copy, readonly) NSSet *normalFields;
@property(nonatomic, copy, readonly) NSSet *maskedFields;

#ifndef BUILD_AS_MODULE
@property(nonatomic, retain, readonly, nullable) id<BehavioSecConnector> connector;
#endif

@property(nonatomic, retain, readonly, nullable) id<BehavioSecFieldCallback> fieldCallback;

+ (instancetype)withBuilder:(void (^)(BehavioSecCollectorBuilder *))block;

@end
 
@interface BehavioSecClient : NSObject

+ (void) startCollection:(UIApplication*)application withCollector:(BehavioSecCollector *)collector;
+ (void) startCollection:(UIApplication*)application withCollector:(BehavioSecCollector *)collector withViewController:(UIViewController *)view;
+ (void) stopCollection;

+ (void) sendData;
+ (NSString* _Nullable) getData;
+ (NSDictionary* _Nullable) getChunk;

+ (void) resetData;
+ (void) clearRegistrations;

+ (void) setNewJourneyId:(NSString*)journeyId;

@end


NS_ASSUME_NONNULL_END
