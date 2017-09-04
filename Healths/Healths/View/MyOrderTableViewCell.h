//
//  MyOrderTableViewCell.h
//  Healths
//
//  Created by 233 on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImage;
@property (weak, nonatomic) IBOutlet UILabel *tiyanLabel;
@property (weak, nonatomic) IBOutlet UILabel *dianmingLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end
