//
//  SearchedPhotosManager.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PixSearchedPhotos.h"


@interface SearchedPhotosManager : NSObject

+ (id)sharedManager;

- (void) initialPhotosWithDefaultCount: (NSNumber *) count
                        successHandler: (void(^) (PixSearchedPhotos *))success
                           failHandler: (void(^) (NSString *))fail ;

- (void) loadMorePhotosWithName: (NSString *) name
                      forPhotos: (PixSearchedPhotos *) photos
                      withCount: (NSNumber *) count
                       nextPage: (NSNumber *) page
                 successHandler: (void(^) (PixSearchedPhotos *))success
                    failHandler: (void(^) (NSString *))fail;

- (void) searchPhotosByName: (NSString *) name
           withDefaultCount: (NSNumber *) count
             successHandler: (void(^) (PixSearchedPhotos *))success
                failHandler: (void(^) (NSString *))fail;

@end
