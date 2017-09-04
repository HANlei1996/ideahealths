//
//  HomeModel.h
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
@property (strong,nonatomic) NSString *hot;
@property (strong,nonatomic) NSString *upgraded;
- (instancetype)initWithDict: (NSDictionary *)dict;
@end
