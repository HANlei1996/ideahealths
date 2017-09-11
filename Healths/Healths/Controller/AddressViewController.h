//
//  AddressViewController.h
//  Healths
//
//  Created by admin on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "Annotation.h"
@interface AddressViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate> {
    NSInteger count;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) UILabel *longitudeLabel;
@property (strong, nonatomic) UILabel *latitudeLabel;

@end
