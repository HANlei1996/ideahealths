//
//  ClubDetailModel.m
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ClubDetailModel.h"

@implementation ClubDetailModel
-(id)initWithDictionary:(NSDictionary *)dict{
    self=[super init];
    if(self){
        _clubLogo = [Utilities nullAndNilCheck:dict[@"clubLogo"] replaceBy:@""];
        _clubId = [Utilities nullAndNilCheck:dict[@"clubId"] replaceBy:@""];
        _clubName = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        _clubAddressB = [Utilities nullAndNilCheck:dict[@"clubAddressB"] replaceBy:@""];
        _clubTel = [Utilities nullAndNilCheck:dict[@"clubTel"] replaceBy:@"无"];
        _clubIntroduce = [Utilities nullAndNilCheck:dict[@"identificationcard"] replaceBy:@"暂无"];
        _clubTime = [Utilities nullAndNilCheck:dict[@"clubTime"] replaceBy:@""];
        _clubMember = [Utilities nullAndNilCheck:dict[@"clubMember"] replaceBy:@""];
        _site = [Utilities nullAndNilCheck:dict[@"site"] replaceBy:@""];
    }
    return self;
}

@end
