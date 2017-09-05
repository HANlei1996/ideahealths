//
//  tiyanquanModel.h
//  Healths
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface tiyanquanModel : NSObject
@property(strong,nonatomic) NSString *eName;
@property(strong,nonatomic) NSString *eLogo;
@property(strong,nonatomic) NSString *saleCount;
@property(strong,nonatomic) NSString *orinPrice;
@property(strong,nonatomic) NSString *currentPrice;
@property(strong,nonatomic) NSString *rules;
@property(strong,nonatomic) NSString *ePromot;
@property(strong,nonatomic) NSString *efeature;
@property(strong,nonatomic) NSString *beginDate;
@property(strong,nonatomic) NSString *endDate;
@property(strong,nonatomic) NSString *userDate;
@property(strong,nonatomic) NSString *experienceQuantity;
@property(strong,nonatomic) NSString *eClubName;
@property(strong,nonatomic) NSString *eAddress;
@property(strong,nonatomic) NSString *longitude;
@property(strong,nonatomic) NSString *latityde;
@property(strong,nonatomic) NSString *clubTel;
-(id)initWithDictionary:(NSDictionary *)dict;
@end
