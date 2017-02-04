//
//  PixPhoto.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PixPhoto : NSObject 

@property (nonatomic) NSInteger idPhoto;

//previewURL
@property (strong,nonatomic) NSString *previewURL;
//previewWidth
@property (nonatomic) NSInteger previewWidth;
//previewHeight
@property (nonatomic) NSInteger previewHeight;

@property (nonatomic) NSString *webformatURL;

//userImageURL
@property (strong,nonatomic) NSString *userImageURL;
//imageWidth
@property (nonatomic) NSInteger imageWidth;
//imageHeight
@property (nonatomic) NSInteger imageHeight;



- (instancetype) initFromDictionary: (NSDictionary *) dict;

@end
