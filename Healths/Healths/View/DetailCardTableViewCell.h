//
//  DetailCardTableViewCell.h
//  Healths
//
//  Created by admin on 2017/9/7.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *experienceCardImageView;
@property (weak, nonatomic) IBOutlet UILabel *experienceCard;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *soldCount;
@end
