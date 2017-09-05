//
//  CZModel.h
//  Healths
//
//  Created by admin on 2017/9/4.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZModel : NSObject
@property(strong,nonatomic)NSString *image;
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *distance;
-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end
