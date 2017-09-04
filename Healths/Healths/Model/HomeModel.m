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
        self.clubid = [Utilities nullAndNilCheck:dict[@"name" ] replaceBy:@""];
        //self.clubname = [Utilities nullAndNilCheck:dict[@"id" ] replaceBy:@""];
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
        self.clubaddress = [Utilities nullAndNilCheck:dict[@"address"] replaceBy:@""];
        
        self.distance = [Utilities nullAndNilCheck:dict[@"distance"]replaceBy:@""];
        //self.experience =dict[@"experience"];
        
        self.logo = [Utilities nullAndNilCheck:dict[@"logo"] replaceBy:@""];
        self.securitiesname = [Utilities nullAndNilCheck:dict[@"name"] replaceBy:@""];
        self.categoryName = [Utilities nullAndNilCheck:dict[@"categoryName"] replaceBy:@""];
        self.price = [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
        
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

@end
