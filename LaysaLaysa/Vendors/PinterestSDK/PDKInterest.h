//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

@import Foundation;

/**
 *  A class that represents an interest
 */
@interface PDKInterest : NSObject

/**
 *  The identifier of the interest
 */
@property (nonatomic, copy, readonly) NSString *identifier;

/**
 *  The name of the interest
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Given a dictionary of parsed JSON created a PDKInterest object
 *
 *  @param dictionary Dictionary of parsed JSON
 *
 *  @return A PDKInterest objecct
 */
+ (instancetype)interestFromDictionary:(NSDictionary *)dictionary;
@end
