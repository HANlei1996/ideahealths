//
//  CardTableViewCell.h
//  Healths
//
//  Created by admin on 2017/9/6.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *smallImageView;
@property (weak, nonatomic) IBOutlet UILabel *clubCardLabel;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@end
