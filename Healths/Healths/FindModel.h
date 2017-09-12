//
//  FindModel.h
//  Healths
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
@property(strong,nonatomic)NSString *image;
@property(strong,nonatomic)NSString *address;
@property(strong,nonatomic)NSString *name;
@property(strong,nonatomic)NSString *distance;
@property(strong,nonatomic)NSString *fId;
@property(strong,nonatomic)NSString *fName;
@property (strong,nonatomic)NSString *clubid;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
-(instancetype)initWithclubDictionary:(NSDictionary *)dict;
@end
