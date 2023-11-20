


// BehavioSec IOS SDK
// Version: 3.0.1
// Copyright (c) 2021 BehavioSec. All rights reserved.



//
//  BehavioUtils.h
//  BehavioSec iOS SDK
//
//  Created by Jorge Diez on 16/01/2023.
//  Copyright © 2023 BehavioSec. All rights reserved.
//

#ifndef BehavioUtils_h
#define BehavioUtils_h

#import <UIKit/UIKit.h>
#import "names.h"

#define BehavioUtils COMPAT_CLASS_NAME(BehavioUtils)

@interface BehavioUtils : NSObject

+ (NSString *)compress:(NSString *)data;
#ifndef BUILD_AS_MODULE
+ (NSString*) merge:(NSArray*)timingDataStrings replaceWithPageId:(NSString*)pageId splitKstData:(BOOL)splitKstData;
+ (NSString*) merge:(NSArray*)timingDataStrings replaceWithPageId:(NSString*)pageId;
#endif
@end

#endif /* BehavioUtils_h */
