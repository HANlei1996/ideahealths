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
//@property (strong,nonatomic) NSArray *experience;
//-(instancetype)initWithdeDictionary:(NSDictionary *)dict;

-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
