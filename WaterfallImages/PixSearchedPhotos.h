//
//  PixSearchedPhotos.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PixSearchedPhotos : NSObject

@property (nonatomic) NSInteger total;
@property (nonatomic) NSInteger totalHits;

@property (strong,nonatomic) NSArray *hits;

- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
