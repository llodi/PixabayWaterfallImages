//
//  WaterfallImagesViewController.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "WaterfallImagesViewController.h"
#import "AppConstants.h"
#import "PhotoCollectionViewCell.h"
#import "ApiRequest.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SearchedPhotosManager.h"
#import "FullSizeImageViewController.h"

@interface WaterfallImagesViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) NSUserDefaults *defaults;
@property (nonatomic) NSInteger currentPage;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSString *searchedString;

@end

@implementation WaterfallImagesViewController


#define DEFAULT_PHOTO_COUNT 40
NSString *const PhotoCellId = @"PhotoCellId";
NSString *const ShowFullSizeImageId = @"showFullSizeImageId";


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupLayout];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.defaults setObject:DEFAULTS_KEY_LAST_SEARCHED_KEYWORD forKey:self.searchedString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark -  geters/seters

- (NSUserDefaults *)defaults {
    if(!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}

- (UIRefreshControl *)refreshControl {
    if(!_refreshControl) _refreshControl = [[UIRefreshControl alloc] init];
    return _refreshControl;
}

- (void) setSearchedString:(NSString *)searchedString {
    _searchedString = searchedString;
    _searchedPhotos = nil;
    [self searchPhotosWithCount:DEFAULT_PHOTO_COUNT];
    self.navigationItem.title = _searchedString;
}


# pragma mark -  funcs

- (void) initialSetup {
    [_collectionView addSubview:self.refreshControl];
    [_refreshControl addTarget:self action:@selector(handleUpdatePhotos:) forControlEvents:UIControlEventValueChanged];
    _currentPage = 1;
    
    NSString *savedSearchedString = [self.defaults stringForKey:DEFAULTS_KEY_LAST_SEARCHED_KEYWORD];
    if (savedSearchedString) {
        self.searchedString = savedSearchedString;
        self.searchField.text = savedSearchedString;
    }
}

- (void) setupLayout {
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)_collectionView.collectionViewLayout;
    
    double columnCount = [self.defaults doubleForKey:DEFAULTS_KEY_COLUMN_COUNT];
    if (columnCount) {
        layout.columnCount = (int)columnCount;
    } else {
        layout.columnCount = 3;
    }
    
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumColumnSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    _collectionView.collectionViewLayout = layout;
}

- (void) searchPhotosWithCount: (NSUInteger) count {
    SearchedPhotosManager *photosManager = [SearchedPhotosManager sharedManager];
    __weak typeof(self) weakSelf = self;
    [photosManager searchPhotosByName: _searchedString
                     withDefaultCount:@(count)
                       successHandler:^(PixSearchedPhotos * photos)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.searchedPhotos = photos;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
    } failHandler:^(NSString * error) {
        NSLog(@"Error %@", error);
    }];
}

- (void) loadMorePhotos {
    _currentPage++;
    SearchedPhotosManager *photosManager = [SearchedPhotosManager sharedManager];
    __weak typeof(self) weakSelf = self;
    
    [photosManager loadMorePhotosWithName: _searchedString
                                forPhotos:_searchedPhotos
                                withCount:@DEFAULT_PHOTO_COUNT
                                 nextPage:@(_currentPage)
    successHandler:^(PixSearchedPhotos * photos)
    {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.searchedPhotos = photos;
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.collectionView reloadData];
        });
    } failHandler:^(NSString * error) {
        NSLog(@"Error %@", error);
    }];
}

# pragma mark -  handlers

- (void) handleUpdatePhotos: (UIRefreshControl *)refreshControl {
    if([_searchedPhotos.hits count] > 0) {
        [self searchPhotosWithCount:[_searchedPhotos.hits count]];
    }
    [refreshControl endRefreshing];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([_searchedPhotos.hits count] > 0) {
        return [_searchedPhotos.hits count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier: PhotoCellId forIndexPath:indexPath];
    
    if ([_searchedPhotos.hits count] > 0) {
        cell.photo = [_searchedPhotos.hits objectAtIndex:[indexPath item]];
    }

    return cell;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_searchedPhotos.hits count] > 0) {
        NSInteger last = [_searchedPhotos.hits count] - 1;
        if ([indexPath item] == last) {
            [self loadMorePhotos];
        }
    }
}


#pragma mark -CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    PixPhoto *photo = [_searchedPhotos.hits objectAtIndex:[indexPath item]];
    if(photo) {
        return CGSizeMake((CGFloat)photo.previewWidth, (CGFloat)photo.previewHeight);
    }
    return CGSizeMake(80, 80);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    NSString *trimmedSearchedText = [textField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    self.searchedString = trimmedSearchedText;
    [self.defaults setObject:self.searchedString forKey: DEFAULTS_KEY_LAST_SEARCHED_KEYWORD];
    [self.defaults synchronize];
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ShowFullSizeImageId]) {
        FullSizeImageViewController *dvc = (FullSizeImageViewController *)[segue destinationViewController];
        PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)sender;
        dvc.photo = cell.photo;
    }
}

@end
