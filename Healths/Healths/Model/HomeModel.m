//
//  HomeModel.m
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel
- (instancetype)initWithDict: (NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        self.hot = [Utilities nullAndNilCheck:@"hot" replaceBy:@""];
        self.upgraded = [Utilities nullAndNilCheck:@"upgraded" replaceBy:@""];
    }
    return self;
}
@end
