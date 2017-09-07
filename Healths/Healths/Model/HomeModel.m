//
//  HomeModel.m
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.totalPage = [Utilities nullAndNilCheck:dict[@"totalPage"] replaceBy:@""];
        self.clubid = [Utilities nullAndNilCheck:dict[@"id" ] replaceBy:@""];
        self.clubname = [Utilities nullAndNilCheck:dict[@"name" ] replaceBy:@""];
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
        self.clubaddress = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"]replaceBy:@""];
        
        self.experience =[dict[@"experience"] isKindOfClass:[NSNull class]] ?@[ ]:      dict[@"experience"];
        
        self.logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
        self.securitiesname = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        self.categoryName = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        self.price = [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
        self.sellNumber = [Utilities nullAndNilCheck:dict[@"sellNumber"] replaceBy:@""];
    }
    return self;
}


//-(instancetype)initWithdeDictionary:(NSDictionary *)dict{
//    self = [super init];
//    if (self) {
//
//
//    }
//    return self;
//}
-(id)initWithDict:(NSDictionary *)dict{
    self=[super init];
    if(self){
        _clubLogo = [Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@""];
        _clubId = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        _clubAddressB = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
        _clubTel = [Utilities nullAndNilCheck:dict[@"clubTel"] replaceBy:@"无"];
        _clubIntroduce = [Utilities nullAndNilCheck:dict[@"clubIntroduce"] replaceBy:@"暂无"];
        _clubTime = [Utilities nullAndNilCheck:dict[@"clubTime"] replaceBy:@""];
        _clubMember = [Utilities nullAndNilCheck:dict[@"clubMember"] replaceBy:@""];
        _clubSite = [Utilities nullAndNilCheck:dict[@"clubSite"] replaceBy:@""];
        _clubPerson = [Utilities nullAndNilCheck:dict[@"clubPerson"] replaceBy:@""];
        _eId = [Utilities nullAndNilCheck:dict[@"eId"] replaceBy:@""];
        _eLogo = [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@""];
        _eName = [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@""];
        _orginPrice = [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
        _saleCount = [Utilities nullAndNilCheck:dict[@"saleCount"] replaceBy:@""];
        self.experienceInfos =[dict[@"experienceInfos"] isKindOfClass:[NSNull class]] ?@[ ]:      dict[@"experienceInfos"];
        
    }
    return self;
}

@end
