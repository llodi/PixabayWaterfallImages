//
//  SettingsTableViewController.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIStepper *collumnCountOultlet;
@property (weak, nonatomic) IBOutlet UILabel *columnCountLabel;


- (IBAction)changeCollumnCount:(UIStepper *)sender;
- (IBAction)cleanCashe:(UIButton *)sender;

@end
