//
//  SecuritiesDetailViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SecuritiesDetailViewController.h"
#import "PayViewController.h"
@interface SecuritiesDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *tyjImage;
@property (weak, nonatomic) IBOutlet UILabel *xjLabel;
@property (weak, nonatomic) IBOutlet UILabel *yjLabel;
- (IBAction)ljxdBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *dwLabel;
@property (weak, nonatomic) IBOutlet UILabel *tykLabel;
@property (weak, nonatomic) IBOutlet UILabel *dmLabel;
@property (weak, nonatomic) IBOutlet UILabel *ysLabel;
@property (weak, nonatomic) IBOutlet UILabel *yxqLabel;
@property (weak, nonatomic) IBOutlet UILabel *sysjLabel;
@property (weak, nonatomic) IBOutlet UILabel *sygzLbel;
@property (weak, nonatomic) IBOutlet UILabel *wstsLabel;
@end

@implementation SecuritiesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"体验卡信息";
    //设置导航条的颜色（风格颜色）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255.0 alpha:1.0]];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)ljxdBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
     PayViewController *purchaseVC=[Utilities getStoryboardInstanceByIdentity:@"Purchase"];
    //purchaseVC.activity=_activity;
    [self.navigationController pushViewController:purchaseVC animated:YES];
    
}
#pragma mark - request
-(void)networkRequest{
    UIActivityIndicatorView *aiv=[Utilities getCoverOnView:self.view];
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parameters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"]forKey:@"memberId"];
        
    }
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            // NSDictionary *result= responseObject[@"result"];
            // _activity= [[ActivityModel alloc]initWithDetailDictionary:result];
            // [self uiLayout];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}


@end
