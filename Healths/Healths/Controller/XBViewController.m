//
//  XBViewController.m
//  Healths
//
//  Created by admin on 2017/9/2.
//  Copyright © 2017年 com. All rights reserved.
//

#import "XBViewController.h"
#import "UserModel.h"
#import "SetUpTableViewCell.h"
#import "SetUpViewController.h"

@interface XBViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
- (IBAction)CancelAction:(UIBarButtonItem *)sender;
- (IBAction)DoneAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *XBSave;
@property(strong,nonatomic)NSArray *pickerArr;
@property (strong,nonatomic)UserModel *user;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)XBSaveAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *XBTextField;
- (IBAction)XBTextAction:(UITextField *)sender forEvent:(UIEvent *)event;

@end

@implementation XBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    // Do any additional setup after loading the view.
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _XBTextField.text=_user.gender;
    _pickerView.dataSource=self;
    _pickerView.delegate=self;
    
    _pickerArr=@[@"男",@"女"];
   
    //设置_pickerView选中行
    [_pickerView selectRow:2 inComponent:0 animated:NO];
    //刷新第一列
    [_pickerView reloadComponent:0];

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
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem= leftBarItem;

}
//用Model的方式返回上一页
- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}
// 多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component==0){
        
        return _pickerArr.count;
        
    }else{
        return 1;
    }
    
}
//每行的标题
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
        
        return  _pickerArr[row];
        
   
    
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return _pickerView.frame.size.width/4;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)CancelAction:(UIBarButtonItem *)sender {
    _toolBar.hidden=YES;
    _pickerView.hidden=YES;

}

- (IBAction)DoneAction:(UIBarButtonItem *)sender {
    //拿到某一种中选中的行号
    NSInteger row1=[_pickerView selectedRowInComponent:0];
        //根据上面拿到的行号。找到对应的数据（选中行的标题）
    NSString *title1=_pickerArr[row1];
    _XBTextField.text = title1;
    //把拿到的按钮显示在按钮上
   // [_XBTextField setTitle:[NSString stringWithFormat:@"%@",title1] forState:(UIControlStateNormal)];
    _toolBar.hidden=YES;
    _pickerView.hidden=YES;

}
- (IBAction)XBSaveAction:(UIBarButtonItem *)sender {
    NSString *xb=_XBTextField.text;
     //[[StorageMgr singletonStorageMgr]addKey:@"XB" andValue:xb];
    NSNumber *gender;
    if([xb isEqualToString:@"男"]){
        gender = @1;
    }else{
        gender = @2;
    }

    _avi=[Utilities getCoverOnView:self.view];
    
    //NSLog(@"%@",_user.nickname);
    
    NSDictionary *para = @{@"memberId":_user.memberId,@"gender":gender};
    [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
          //  NSDictionary *result= responseObject[@"result"];
            NSNotification *note = [NSNotification notificationWithName:@"refreshSetup" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];

            
            
           // [self dismissViewControllerAnimated:YES completion:nil];
            
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
//- (IBAction)XBTextAction:(UITextField *)sender forEvent:(UIEvent *)event {
   // _toolBar.hidden=NO;
   // _pickerView.hidden=NO;

//}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    _pickerView.hidden = NO;
    _toolBar.hidden = NO;
    return NO;
}@end
