//
//  SettingsTableViewController.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SettingsTableViewController ()

@property (weak, nonatomic) NSUserDefaults *defaults;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //title = @"Настройки";
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    double columnCount = [self.defaults doubleForKey:DEFAULTS_KEY_COLUMN_COUNT];
    if(columnCount) {
        _collumnCountOultlet.value = columnCount;
        _columnCountLabel.text = [NSString stringWithFormat:@"%1.0f", columnCount];
    } else {
        [_defaults setDouble:_collumnCountOultlet.value forKey: DEFAULTS_KEY_COLUMN_COUNT];
    }
}

- (NSUserDefaults *)defaults {
    if(!_defaults) _defaults = [NSUserDefaults standardUserDefaults];
    return _defaults;
}


- (IBAction)changeCollumnCount:(UIStepper *)sender {
    [_defaults setDouble:sender.value forKey: DEFAULTS_KEY_COLUMN_COUNT];
    _columnCountLabel.text = [NSString stringWithFormat:@"%1.0f", sender.value];
}

- (IBAction)cleanCashe:(UIButton *)sender {
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
}


@end
