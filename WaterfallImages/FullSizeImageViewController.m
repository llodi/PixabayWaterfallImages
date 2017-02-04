//
//  FullSizeImageViewController.m
//  WaterfallImages
//
//  Created by Ilya on 31.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "FullSizeImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface FullSizeImageViewController ()

@end

@implementation FullSizeImageViewController

CGFloat lastZoomScale = -1;

- (void)setPhoto:(PixPhoto *)photo {
    _photo = photo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.singleTapOutlet requireGestureRecognizerToFail:self.doubleTapOutlet];
    [self showHideNavBar];
    [self setupImageView];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateZoom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender {
    [self showHideNavBar];
}

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender {
    [self updateZoom];
}

- (void) setupImageView {
    NSURL *url = [[NSURL alloc]initWithString:_photo.webformatURL];
    __weak typeof(self) weakSelf = self;
    [self.photoImageView sd_setImageWithURL:url
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         __strong typeof(weakSelf) strongSelf = weakSelf;
         [strongSelf.photoImageView sizeToFit];
         strongSelf.scrollView.contentSize = strongSelf.photoImageView.image ? strongSelf.photoImageView.bounds.size : CGSizeZero;
         [strongSelf updateZoom];
         [strongSelf.spinner stopAnimating];
     }];
    
    if (self.photoImageView.image) [self.spinner stopAnimating];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    _scrollView.minimumZoomScale = 0.3;
    _scrollView.maximumZoomScale = 2.0;
    self.scrollView.contentSize = self.photoImageView.image ? self.photoImageView.bounds.size : CGSizeZero;;

}

- (void) showHideNavBar {
    if (self.navigationController.navigationBar.hidden) {
        self.navigationController.navigationBar.hidden = NO;
    } else {
        self.navigationController.navigationBar.hidden = YES;
    }
}


- (void) updateConstraints {
    float imageWidth = self.photoImageView.image.size.width;
    float imageHeight = self.photoImageView.image.size.height;
    
    float viewWidth = self.view.bounds.size.width;
    float viewHeight = self.view.bounds.size.height;
    
    // center image if it is smaller than screen
    float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.leftImageConstraint.constant = hPadding;
    self.rightImageConstraint.constant = hPadding;
    
    self.topImageConstraint.constant = vPadding;
    self.bottomImageConstraint.constant = vPadding;
    
    // Makes zoom out animation smooth and starting from the right point not from (0, 0)
    [self.view layoutIfNeeded];
}

- (void) updateZoom {
    float minZoom = MIN(self.view.bounds.size.width / self.photoImageView.image.size.width,
                        self.view.bounds.size.height / self.photoImageView.image.size.height);
    
    if (minZoom > 1) minZoom = 1;
    
    self.scrollView.minimumZoomScale = minZoom;
    
    if (minZoom == lastZoomScale) minZoom += 0.000001;
    
    lastZoomScale = self.scrollView.zoomScale = minZoom;
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        [self updateZoom];

        
    } completion:^(id  _Nonnull context) {
        
        [self updateZoom];
        
    }];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraints];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
