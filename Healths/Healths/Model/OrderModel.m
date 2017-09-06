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
        self.dingdanNum = [[Utilities nullAndNilCheck:dict[@"dingdanNum"] replaceBy:0] integerValue];
        self.tiyan = [Utilities nullAndNilCheck:dict[@"tiyan"] replaceBy:@""];
        self.image = [Utilities nullAndNilCheck:dict[@"image"] replaceBy:@""];
        self.mingzi = [Utilities nullAndNilCheck:dict[@"mingzi"] replaceBy:@""];
        self.yuan = [[Utilities nullAndNilCheck:dict[@"yuan"] replaceBy:0]integerValue];
    }
    return self;
    
}

@end
