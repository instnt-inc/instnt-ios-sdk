


// BehavioSec IOS SDK
// Version: 3.0.1
// Copyright (c) 2021 BehavioSec. All rights reserved.



//
//  ObjC.h
//  BehavioSecIOSSDK
//
//  Copyright © 2021 BehavioSec. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BehavioCatchBlock_h
#define BehavioCatchBlock_h

@interface BehavioCatchBlock : NSObject
+ (BOOL)catchEx:(void(^)(void))tryBlock error:(__autoreleasing NSError **)error;
@end

#endif /* ObjC_h */
