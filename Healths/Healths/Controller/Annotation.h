//
//  Annotation.h
//  Healths
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Annotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;


@end
