//
//  JSONManager.h
//  LaysaLaysa
//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JSONManager : NSObject

+ (void)callJSONWithParamethers:(NSDictionary*)paramethers isNew:(BOOL) isNew;

+ (void)callHomePage;

+ (void)sendDeviceTokenToServer:(NSString*)deviceToken;

@end
