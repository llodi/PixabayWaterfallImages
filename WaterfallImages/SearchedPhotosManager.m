//
//  SearchedPhotosManager.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "SearchedPhotosManager.h"
#import "AppConstants.h"
#import "ApiRequest.h"
#import "NSString+HttpUtils.h"

@implementation SearchedPhotosManager

+ (id)sharedManager {
    static SearchedPhotosManager *sharedManager_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager_ = [[self alloc] init];
    });
    return sharedManager_;
}

- (void) initialPhotosWithDefaultCount: (NSNumber *) count
                        successHandler: (void(^) (PixSearchedPhotos *))success
                           failHandler: (void(^) (NSString *))fail {
    
    NSDictionary *params = @{@"key": PIXABAY_APP_KEY,
                             @"q": @"funny",
                             @"image_type": PIXABAY_REQUEST_TYPE,
                             @"per_page": count};
    
    ApiRequest *req = [[ApiRequest alloc]
                       initWithUrl:PIXABAY_API_URL
                       andHttpMethod: HTTP_TYPE_GET
                       withParameters: params
                       successHandler:^(NSDictionary * dict)
    {
        PixSearchedPhotos *result = [[PixSearchedPhotos alloc] initFromDictionary:dict];
        success(result);
        
    } failHandler:^(NSString * error)   {
        NSLog(@"Error %@", error);
        fail(error);
    }];
    [req execute];
}

- (void) searchPhotosByName: (NSString *) name
           withDefaultCount: (NSNumber *) count
                        successHandler: (void(^) (PixSearchedPhotos *))success
                           failHandler: (void(^) (NSString *))fail {
    
    NSString *str = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSDictionary *params = @{@"key": PIXABAY_APP_KEY,
                             @"q": str,
                             @"image_type": PIXABAY_REQUEST_TYPE,
                             @"per_page": count};
    
    ApiRequest *req = [[ApiRequest alloc]
                       initWithUrl:PIXABAY_API_URL
                       andHttpMethod: HTTP_TYPE_GET
                       withParameters: params
                       successHandler:^(NSDictionary * dict)
                       {
                           PixSearchedPhotos *result = [[PixSearchedPhotos alloc] initFromDictionary:dict];
                           success(result);
                           
                       } failHandler:^(NSString * error)   {
                           NSLog(@"Error %@", error);
                           fail(error);
                       }];
    [req execute];
}

- (void) loadMorePhotosWithName: (NSString *) name
                      forPhotos: (PixSearchedPhotos *) photos
                      withCount: (NSNumber *) count
                        nextPage: (NSNumber *) page
                        successHandler: (void(^) (PixSearchedPhotos *))success
                           failHandler: (void(^) (NSString *))fail {
    
    NSString *str = [name stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSDictionary *params = @{@"key": PIXABAY_APP_KEY,
                             @"q": str,
                             @"image_type": PIXABAY_REQUEST_TYPE,
                             @"per_page": count,
                             @"page": page};
    
    ApiRequest *req = [[ApiRequest alloc]
                       initWithUrl:PIXABAY_API_URL
                       andHttpMethod: HTTP_TYPE_GET
                       withParameters: params
                       successHandler:^(NSDictionary * dict)
                       {
                           PixSearchedPhotos *result = [[PixSearchedPhotos alloc] initFromDictionary:dict];
                           
                           if (photos.hits) {
                               NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:photos.hits];
                               [newArray addObjectsFromArray:result.hits];
                               result.hits = newArray;
                           } 
                           
                           success(result);
                           
                       } failHandler:^(NSString * error)   {
                           NSLog(@"Error %@", error);
                           fail(error);
                       }];
    [req execute];
}

@end
