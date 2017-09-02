//
//  ClubDetailViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ClubDetailViewController.h"

@interface ClubDetailViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UILabel *clubAddress;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *membersCount;
@property (weak, nonatomic) IBOutlet UILabel *citeCount;
@property (weak, nonatomic) IBOutlet UILabel *coachCount;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
- (IBAction)imageBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *experienceCard;
@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *soldCount;

@end

@implementation ClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"会所信息";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=[UIColor brownColor];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)callBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"12365436789" otherButtonTitles:nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        
    }
    return;
}
- (IBAction)imageBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
@end
