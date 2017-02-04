//
//  PixPhoto.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "PixPhoto.h"

@implementation PixPhoto

- (instancetype) initFromDictionary: (NSDictionary *) dict {
    self = [super init];
    
    if(self) {
        _idPhoto = [[dict objectForKey:@"id"] integerValue];
        
        _previewURL = [dict objectForKey:@"previewURL"];
        
        _previewWidth = [[dict objectForKey:@"previewWidth"] integerValue];
        _previewHeight = [[dict objectForKey:@"previewHeight"] integerValue];
        
        _webformatURL = [dict objectForKey:@"webformatURL"];
        
        _userImageURL = [dict objectForKey:@"userImageURL"];
        _imageWidth = [[dict objectForKey:@"imageWidth"] integerValue];
        _imageHeight = [[dict objectForKey:@"imageHeight"] integerValue];
    }
    return self;
}

@end
