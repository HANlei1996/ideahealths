//
//  SignInViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordnameTextField;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)signBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(20, 100, 255);
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor blueColor] };
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
-(void)uiLayout{
    //判断是否存在用户名记忆体
    if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]]) {
        if ([Utilities getUserDefaults:@"Username"] != nil) {
            //将他显示在用户名输入框
            _usernameTextField.text=[Utilities getUserDefaults:@"Username"];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if (_usernameTextField.text.length==0) {
        [Utilities popUpAlertViewWithMsg:@"请输入你的手机号" andTitle:nil onView:self];
        return;
    }
    //判断某个字符串中是否每个字符都是数字
    NSCharacterSet *notDigits=[[NSCharacterSet decimalDigitCharacterSet]invertedSet];
    if ([_usernameTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound || _usernameTextField.text.length != 11) {
        [Utilities popUpAlertViewWithMsg:@"请输入有效的手机号码" andTitle:nil onView:self];
        return;
    }
    
    if (_passwordnameTextField.text.length==0) {
        [Utilities popUpAlertViewWithMsg:@"请输入密码" andTitle:nil onView:self];
        return;
    }
    if (_passwordnameTextField.text.length < 6 || _passwordnameTextField.text.length > 18) {
        [Utilities popUpAlertViewWithMsg:@"你输入的密码必须在6~18之间" andTitle:nil onView:self];
        return;
    }
    
    
}
//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}
//按return收回键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _usernameTextField || textField == _passwordnameTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}




@end
