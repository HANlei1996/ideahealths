//
//  ClubDetailModel.h
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClubDetailModel : NSObject
@property(strong,nonatomic) NSString *clubLogo;
@property(strong,nonatomic) NSString *clubId;
@property(strong,nonatomic) NSString *clubName;
@property(strong,nonatomic) NSString *clubAddressB;
@property(strong,nonatomic) NSString *clubTel;
@property(strong,nonatomic) NSString *clubIntroduce;
@property(strong,nonatomic) NSString *clubTime;
@property(strong,nonatomic) NSString *clubMember;
@property(strong,nonatomic) NSString *site;



-(id)initWithDictionary:(NSDictionary *)dict;

@end
