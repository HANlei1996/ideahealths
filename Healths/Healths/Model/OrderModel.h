//
//  OrderModel.h
//  Healths
//
//  Created by 233 on 2017/9/5.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject
@property (nonatomic) NSTimeInterval dingdanNum;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *tiyan;
@property (strong, nonatomic) NSString *mingzi;
@property (nonatomic) NSInteger *yuan;

- (instancetype)initWithDict: (NSDictionary *)dict;


@end
