//
//  CollumnCountSettingsCell.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollumnCountSettingsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIStepper *stepperOutlet;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


- (IBAction)changeCollumnCount:(UIStepper *)sender;


@end
