//
//  NSDictionary+HttpHelper.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "NSDictionary+HttpHelper.h"
#import "NSString+HttpUtils.h"

@implementation NSDictionary (HttpHelper)

- (NSString *)stringFromHttpParameters {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:self];
    NSMutableArray *stringParams = [[NSMutableArray alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *keyString = key;
        NSString *percentEscapedKey = [keyString URLEncoded];
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *numb = obj;
            if (numb) {
                NSString *str = [NSString stringWithFormat:@"%@=%@",percentEscapedKey,numb];
                [stringParams addObject:str];
                
            }
        } else {
            NSString *valueString = obj;
            NSString *percentEscapedValue = [valueString URLEncoded];
            if (percentEscapedValue) {
                NSString *str = [NSString stringWithFormat:@"%@=%@",percentEscapedKey,percentEscapedValue];
                [stringParams addObject:str];
            }
        }
        
    }];
    return [stringParams componentsJoinedByString:@"&"];
}

@end
