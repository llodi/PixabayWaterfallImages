//
//  FullSizeImageViewController.h
//  WaterfallImages
//
//  Created by Ilya on 31.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PixPhoto.h"

@interface FullSizeImageViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
//@property (weak, nonatomic) UIImageView *photoImageView;
@property (strong, nonatomic) PixPhoto *photo;


@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapOutlet;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapOutlet;


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender;
- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender;



@end
