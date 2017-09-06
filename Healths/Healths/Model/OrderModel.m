//
//  OrderModel.m
//  Healths
//
//  Created by 233 on 2017/9/5.
//  Copyright © 2017年 com. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.dingdanNum = [Utilities nullAndNilCheck:dict[@"orderNum"] replaceBy:0];
        self.tiyan = [Utilities nullAndNilCheck:dict[@"productName"] replaceBy:@""];
        self.image = [Utilities nullAndNilCheck:dict[@"imgUrl"] replaceBy:@""];
        self.mingzi = [Utilities nullAndNilCheck:dict[@"clubName"] replaceBy:@""];
        self.yuan = [[Utilities nullAndNilCheck:dict[@"donepay"] replaceBy:0]integerValue];
    }
    return self;
    
}

@end
