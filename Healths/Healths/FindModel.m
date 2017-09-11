//
//  FindModel.m
//  Healths
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    self=[super init];
    if(self){
        self.name=[dict[@"clubName"] isKindOfClass:[NSNull class]] ?@"":dict[@"clubName"];
        self.image=[dict[@"clubLogo"] isKindOfClass:[NSNull class]] ? @"" : dict[@"clubLogo"] ;
        self.address=[Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
        self.distance=[Utilities nullAndNilCheck:dict[@"distance"] replaceBy:@""];
        self.clubid = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        
    }
    return self;
}
-(instancetype)initWithclubDictionary:(NSDictionary *)dict{
    self=[super init];
    if(self){
        self.fId=[dict[@"fId"] isKindOfClass:[NSNull class]] ?@"":dict[@"fId"];
        self.fName=[dict[@"fName"] isKindOfClass:[NSNull class]] ?@"":dict[@"fName"];
    }
    return self;
}
@end
