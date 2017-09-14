//
//  HomeModel.h
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property (strong,nonatomic) NSString *totalPage;//页面
@property (strong,nonatomic) NSString *clubid;//健身会所ID
@property (strong,nonatomic) NSString *image;//健身会所图片地址
@property (strong,nonatomic) NSString *clubname;//健身会所名称
@property (strong,nonatomic) NSString *clubaddress;//健身会所地址
@property (strong,nonatomic) NSString *distance;//健身会所与用户距离
@property (strong,nonatomic) NSString *securitiesid;//体验券ID
@property (strong,nonatomic) NSString *logo;//体验券图片地址
@property (strong,nonatomic) NSString *securitiesname;//体验券名称
@property (strong,nonatomic) NSString *categoryName;//体验券类型名称
@property (strong,nonatomic) NSString *price;//体验券价格
@property (strong,nonatomic) NSString *sellNumber;

@property (strong,nonatomic) NSArray *experience;
@property (strong,nonatomic) NSArray *experienceInfos;
@property(strong,nonatomic) NSString *clubLogo;
@property(strong,nonatomic) NSString *clubId;
@property(strong,nonatomic) NSString *clubName;
@property(strong,nonatomic) NSString *clubAddressB;
@property(strong,nonatomic) NSString *clubTel;
@property(strong,nonatomic) NSString *clubIntroduce;
@property(strong,nonatomic) NSString *clubTime;
@property(strong,nonatomic) NSString *clubMember;
@property(strong,nonatomic) NSString *clubSite;
@property(strong,nonatomic) NSString *clubPerson;
@property(strong,nonatomic) NSString *eId;
@property(strong,nonatomic) NSString *eLogo;
@property(strong,nonatomic) NSString *eName;
@property(strong,nonatomic) NSString *orginPrice;
@property(strong,nonatomic) NSString *saleCount;
@property(strong,nonatomic) NSString *clubJing;
@property(strong,nonatomic) NSString *clubWei;

-(id)initWithDict:(NSDictionary *)dict;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
