//
//  Created by Wang on 15/11/27.
//  Copyright (c) 2015 Wang. All rights reserved.
//

#import "PDKPin.h"

#import "PDKBoard.h"
#import "PDKCategories.h"
#import "PDKImageInfo.h"
#import "PDKUser.h"

@interface PDKPin()
@property (nonatomic, copy, readwrite) NSURL *url;
@property (nonatomic, copy, readwrite) NSString *descriptionText;

@property (nonatomic, strong, readwrite) PDKBoard *board;
@property (nonatomic, strong, readwrite) PDKUser *creator;
@property (nonatomic, strong, readwrite) NSDictionary *metaData;

@property (nonatomic, assign, readwrite) NSUInteger repins;
@property (nonatomic, assign, readwrite) NSUInteger likes;
@property (nonatomic, assign, readwrite) NSUInteger comments;

@end

@implementation PDKPin

static NSString *_clientRedirectURLString = nil;
static PDKUnauthPinCreationSuccess _pinSuccessBlock = NULL;
static PDKUnauthPinCreationFailure _pinFailureBlock = NULL;

static NSString * const kPDKPinterestAppPinItURLString = @"pinterestsdk.v1://pinit/";
static NSString * const kPDKPinterestWebPinItURLString = @"http://www.pinterest.com/pin/create/button/";

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super initWithDictionary:dictionary];
    if (self) {
        _url = [NSURL URLWithString:dictionary[@"link"]];
        _descriptionText = dictionary[@"note"];
        _board = [PDKBoard boardFromDictionary:dictionary[@"board"]];
        _creator = [PDKUser userFromDictionary:dictionary[@"creator"]];
        _metaData = dictionary[@"metadata"];
        
        _repins = [self.counts[@"repins"] unsignedIntegerValue];
        _likes = [self.counts[@"likes"] unsignedIntegerValue];
        _comments = [self.counts[@"comments"] unsignedIntegerValue];
    }
    return self;
}

+ (instancetype)pinFromDictionary:(NSDictionary *)dictionary
{
    return [[PDKPin alloc] initWithDictionary:dictionary];
}

+ (NSString *)clientRedirectURLString
{
    return _clientRedirectURLString;
}

+ (void)setClientRedirectURLString:(NSString *)clientRedirectURLString
{
    _clientRedirectURLString = clientRedirectURLString;
}

+ (PDKUnauthPinCreationSuccess)pinSuccessBlock
{
    return _pinSuccessBlock;
}

+ (void)setPinSuccessBlock:(PDKUnauthPinCreationSuccess)pinSuccessBlock
{
    _pinSuccessBlock = [pinSuccessBlock copy];
}

+ (PDKUnauthPinCreationFailure)pinFailureBlock
{
    return _pinFailureBlock;
}

+ (void)setPinFailureBlock:(PDKUnauthPinCreationFailure)pinFailureBlock
{
    _pinFailureBlock = [pinFailureBlock copy];
}

+ (void)pinWithImageURL:(NSURL *)imageURL
                   link:(NSURL *)sourceURL
     suggestedBoardName:(NSString *)suggestedBoardName
                   note:(NSString *)pinDescription
            withSuccess:(PDKUnauthPinCreationSuccess)pinSuccessBlock
             andFailure:(PDKUnauthPinCreationFailure)pinFailureBlock
{
    
    self.clientRedirectURLString = [NSString stringWithFormat:@"pdk%@", [PDKClient sharedInstance].appId];
    self.pinSuccessBlock = pinSuccessBlock;
    self.pinFailureBlock = pinFailureBlock;
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    if (appName.length <= 0){
        appName = @"LutMaar";
    }
    
    NSDictionary *params = @{@"client_id" : [PDKClient sharedInstance].appId,
                             @"image_url" : [imageURL absoluteString],
                             @"source_url" : [sourceURL absoluteString],
                             @"app_name" : appName,
                             @"suggested_board_name" : suggestedBoardName,
                             @"description" : pinDescription,
                             };
    
    // check to see if the Pinterest app is installed
    NSURL *pinitURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestAppPinItURLString, [params _PDK_queryStringValue]]];
#if TARGET_OS_IPHONE
    if ([[UIApplication sharedApplication] canOpenURL:pinitURL]) {
        [[UIApplication sharedApplication] openURL:pinitURL];
    } else {
        //open web pinit url
        NSDictionary *webParams = @{@"url": [sourceURL absoluteString],
                                    @"media": [imageURL absoluteString],
                                    @"description": pinDescription};
        NSURL *pinitWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestWebPinItURLString, [webParams _PDK_queryStringValue]]];
        [[UIApplication sharedApplication] openURL:pinitWebURL];
    }
#else
#endif
}

+ (void)callUnauthSuccess
{
    if (self.pinSuccessBlock) {
        self.pinSuccessBlock();
        self.pinSuccessBlock = nil;
    }
}

+ (void)callUnauthFailureWithError:(NSString *)error
{
    if (self.pinSuccessBlock) {
        PDKPinError errorCode = PDKPinErrorUnknown;
        if ([error isEqualToString:@"canceled"]) {
            errorCode = PDKPinErrorCanceled;
        }
        self.pinFailureBlock([NSError errorWithDomain:NSStringFromClass(self) code:errorCode userInfo:nil]);
        self.pinFailureBlock = nil;
    }
}

@end
