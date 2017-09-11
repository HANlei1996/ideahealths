//
//  SRViewController.m
//  Healths
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SRViewController.h"
#import "UserModel.h"
#import "SetUpTableViewCell.h"
#import "SetUpViewController.h"
@interface SRViewController ()
@property (weak, nonatomic) IBOutlet UITextField *SRtextField;
- (IBAction)SRAction:(UITextField *)sender forEvent:(UIEvent *)event;

- (IBAction)CancelAction:(UIBarButtonItem *)sender;
- (IBAction)DoneAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)SRSaveAction:(UIBarButtonItem *)sender;
@property(strong,nonatomic)NSArray *pickerArr;
@property (strong,nonatomic)UserModel *user;
@property (strong,nonatomic) UIActivityIndicatorView *avi;

@end

@implementation SRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _SRtextField.text=_user.dob;
    _pickerView.minimumDate = [NSDate date];
    _pickerView.backgroundColor = UIColorFromRGB(235, 235, 241);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 100, 255);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
    //为导航条左上角创建一个按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = left;

}
//用Model的方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SRAction:(UITextField *)sender forEvent:(UIEvent *)event {
    _toolBar.hidden=NO;
    _pickerView.hidden=NO;
}
- (IBAction)SRSaveAction:(UIBarButtonItem *)sender {
    NSString *sr=_SRtextField.text;
    //[[StorageMgr singletonStorageMgr]addKey:@"XB" andValue:xb];
    
    _avi=[Utilities getCoverOnView:self.view];
    
    //NSLog(@"%@",_user.nickname);
    
    NSDictionary *para = @{@"memberId":_user.memberId,@"birthday":sr};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //  NSDictionary *result= responseObject[@"result"];
            
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络请求失败😂" andTitle:nil onView:self];
    }];
    

}
- (IBAction)CancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;
}

- (IBAction)DoneAction:(UIBarButtonItem *)sender {
    NSDate *date = _pickerView.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *theDate = [formatter stringFromDate:date];
    _SRtextField.text = theDate;
    _toolBar.hidden = YES;
    _pickerView.hidden = YES;

}
@end
