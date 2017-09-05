//
//  CZModel.m
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "CZModel.h"

@implementation CZModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self=[super init];
    if(self){
self.name= self.name=[dict[@"clubName"] isKindOfClass:[NSNull class]] ?@"":dict[@"clubName"];
self.image=[dict[@"clubLogo"] isKindOfClass:[NSNull class]] ? @"" : dict[@"clubLogo"] ;
self.address=[Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
self.distance=[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
    }
    return self;
}
@end
