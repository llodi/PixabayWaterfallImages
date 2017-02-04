//
//  PhotoCollectionViewCell.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PixPhoto.h"

@interface PhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@property (strong, nonatomic) PixPhoto *photo;

@end
