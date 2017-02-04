//
//  PixSearchedPhotos.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "PixSearchedPhotos.h"
#import "PixPhoto.h"

@implementation PixSearchedPhotos

- (instancetype) initFromDictionary: (NSDictionary *) dict {
    self = [super init];
    
    if(self) {
        _total = [[dict objectForKey:@"total"] integerValue];
        _totalHits = [[dict objectForKey:@"totalHits"] integerValue];
                
        NSArray *array = [dict objectForKey:@"hits"] ;
        
        if (array) {
            NSMutableArray *hitsArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < [array count]; i++) {
                NSDictionary *item = [array objectAtIndex: i];
                if (item) {
                    PixPhoto *photo = [[PixPhoto alloc] initFromDictionary:item];
                    [hitsArray addObject:photo];
                }
            }
            if ([hitsArray count]) {
                _hits = hitsArray;
            }
        }
        
        
    }
    return self;
}


@end
