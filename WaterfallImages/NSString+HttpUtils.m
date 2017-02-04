//
//  NSString+HttpUtils.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "NSString+HttpUtils.h"
#import <Foundation/Foundation.h>

@implementation NSString (HttpUtils)

- (NSString*)URLEncoded {
    NSString *unreservedChars = [[NSString alloc] initWithFormat:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~"];
    NSCharacterSet *unreservedCharset = [NSCharacterSet characterSetWithCharactersInString:unreservedChars];
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:unreservedCharset];
    if ([encodedString isKindOfClass:[NSString class]]) {
        return encodedString;
    } else {
        return self;
    }
}


@end
