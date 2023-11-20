


// BehavioSec IOS SDK
// Version: 3.0.1
// Copyright (c) 2021 BehavioSec. All rights reserved.



//
//  names.h
//  TrustDefender
//
//  Created by Nick Blievers on 2/12/2015.
//  Copyright © 2015 ThreatMetrix. All rights reserved.
//

/**
 * IMPORTANT: This is the names.h file inside BHS repo and should be only used
 * by files in that repo.
 **/

#ifndef names_h
#define names_h

#define STRING(value) #value
#define STRING_VALUE(value) STRING(value)

#define TMX_NAME_PASTE2( a, b) a##b
#define TMX_NAME_PASTE( a, b) TMX_NAME_PASTE2( a, b)

#ifdef BUILD_AS_MODULE

#if (defined(TMX_PREFIX_NAME) && defined(NO_COMPAT_CLASS_NAME)) || !defined(TMX_PREFIX_NAME)
#define TMX_CLASS_PREFIX_NAME ComThreatMetrix
#define MODULE_INIT_METHOD_NAME initm
#else
#define TMX_CLASS_PREFIX_NAME TMX_PREFIX_NAME
#define MODULE_INIT_METHOD_NAME TMX_NAME_PASTE(TMX_PREFIX_NAME, initm)
#endif /* (defined(TMX_PREFIX_NAME) && defined(NO_COMPAT_CLASS_NAME)) || !defined(TMX_PREFIX_NAME) */

#define COMPAT_CLASS_NAME(x) TMX_NAME_PASTE(TMX_CLASS_PREFIX_NAME, x)

#else /* BUILD_AS_MODULE */

#define COMPAT_CLASS_NAME(x) x

#endif /* BUILD_AS_MODULE */

#ifndef HIDDEN_EXTERN
#ifdef __cplusplus
#define HIDDEN_EXTERN extern "C" __attribute__((visibility ("hidden")))
#else
#define HIDDEN_EXTERN extern __attribute__((visibility ("hidden")))
#endif
#endif /* HIDDEN_EXTERN */



#endif /* names_h */
