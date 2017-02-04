//
//  PhotoCollectionViewCell.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "PhotoCollectionViewCell.h"
#import "PixPhoto.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PhotoCollectionViewCell()

@end

@implementation PhotoCollectionViewCell

- (void) setPhoto: (PixPhoto *)photo {
    _photo = photo;
    [self updateUI];
}

- (void) updateUI {
    _photoImageView.image = nil;
    [_photoImageView sd_setImageWithURL:[[NSURL alloc] initWithString:_photo.previewURL]];
}

@end
