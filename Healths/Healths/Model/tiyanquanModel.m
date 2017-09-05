//
//  tiyanquanModel.m
//  Healths
//
//  Created by admin on 2017/9/5.
//  Copyright © 2017年 com. All rights reserved.
//

#import "tiyanquanModel.h"

@implementation tiyanquanModel
-(id)initWithDictionary:(NSDictionary *)dict{
    self=[super init];
    if(self){
        _eName= [Utilities nullAndNilCheck:dict[@"eName"] replaceBy:@""];
        _eLogo= [Utilities nullAndNilCheck:dict[@"eLogo"] replaceBy:@""];
        _saleCount= [Utilities nullAndNilCheck:dict[@"saleCount"] replaceBy:@""];
        _orinPrice= [Utilities nullAndNilCheck:dict[@"orginPrice"] replaceBy:@""];
       _currentPrice= [Utilities nullAndNilCheck:dict[@"currentPrice"] replaceBy:@""];
        _rules= [Utilities nullAndNilCheck:dict[@"rules"] replaceBy:@"暂无"];
        _ePromot= [Utilities nullAndNilCheck:dict[@"ePromot"] replaceBy:@"暂无"];
        _efeature= [Utilities nullAndNilCheck:dict[@"eFeature"] replaceBy:@""];
        _beginDate= [Utilities nullAndNilCheck:dict[@"beginDate"] replaceBy:@""];
        _endDate= [Utilities nullAndNilCheck:dict[@"endDate"] replaceBy:@""];
        _userDate= [Utilities nullAndNilCheck:dict[@"useDate"] replaceBy:@""];
        _experienceQuantity= [Utilities nullAndNilCheck:dict[@"experienceQuantity"] replaceBy:@""];
        _eClubName= [Utilities nullAndNilCheck:dict[@"eClubName"] replaceBy:@""];
        _eAddress= [Utilities nullAndNilCheck:dict[@"eAddress"] replaceBy:@""];
        _longitude= [Utilities nullAndNilCheck:dict[@"longitude"] replaceBy:@""];
        _latityde= [Utilities nullAndNilCheck:dict[@"latitude"] replaceBy:@""];
        _clubTel= [Utilities nullAndNilCheck:dict[@"clubTel"] replaceBy:@""];
               
    
    
    }
    return self;
}

@end
