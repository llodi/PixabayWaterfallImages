//
//  WaterfallImagesViewController.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PixSearchedPhotos.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface WaterfallImagesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UITextFieldDelegate>

@property (strong, nonatomic) PixSearchedPhotos *searchedPhotos;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@end
