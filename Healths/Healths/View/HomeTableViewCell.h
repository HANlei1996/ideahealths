//
//  HomeTableViewCell.h
//  Healths
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
