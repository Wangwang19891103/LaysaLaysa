//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//
@import Foundation;

@interface NSDictionary (PDKAdditions)

+ (NSDictionary *)_PDK_dictionaryWithQueryString:(NSString *)queryString;
- (NSString *)_PDK_queryStringValue;
- (NSDictionary *)_PDK_dictionaryByRemovingNulls;

@end

@interface NSString (PDKAdditions)

- (NSString *)_PDK_urlEncodedString;
- (NSString *)_PDK_urlDecodedString;

@end
