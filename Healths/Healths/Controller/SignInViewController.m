//
//  SignInViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SignInViewController.h"
#import "UserModel.h"
@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordnameTextField;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
- (IBAction)signBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *signBtn;

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    [self uiLayout];

    // Do any additional setup after loading the view.
    _signBtn.enabled = NO;
    _signBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    
    
   // if (![[Utilities getUserDefaults:@"Username"] isKindOfClass:[NSNull class]] && [Utilities getUserDefaults:@"Username"] != nil) {
     //   _usernameTextField.text = [Utilities getUserDefaults:@"Username"];
    //}
    
    //添加事件监听当输入框的内容改变时调用textChange:方法
    [_usernameTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [_passwordnameTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)naviConfig{
    
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
    self.navigationItem.leftBarButtonItem = left;}

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
- (void)textChange: (UITextField *)textField{
    //当文本框中的内容改变时判断内容长度是否为0，是：禁用按钮   否：启用按钮
    if (_usernameTextField.text.length != 0 && textField.text.length != 0) {
        _signBtn.enabled = YES;
        _signBtn.backgroundColor = UIColorFromRGB(0, 122, 255);

        _signBtn.backgroundColor = UIColorFromRGB(20, 130, 255);

    }else{
        _signBtn.enabled = NO;
        _signBtn.backgroundColor = UIColorFromRGB(200, 200, 200);
    }
}

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
    //无输入异常的情况，开始正式执行登录接口
    [self readyForEncoding];

    
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
#pragma mark - request
-(void)readyForEncoding{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/login/getKey" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //[_avi stopAnimating];
            NSDictionary *result=responseObject [@"result"];
            NSString *exponent =result[@"exponent"];
            NSString *modulus =result[@"modulus"];
            //对内容进行MD5加密
            NSString *md5Str =[_passwordnameTextField.text getMD5_32BitString];
            [[StorageMgr singletonStorageMgr]addKey:@"Password"andValue:_passwordnameTextField.text];
            //用模数与指数对MD5加密过的密码进行加密
            NSString *rsaStr=[NSString encryptWithPublicKeyFromModulusAndExponent:md5Str.UTF8String modulus:modulus exponent:exponent];
            //加密完成执行登录接口
            [self signInWithEncryptPwd:rsaStr];
            
            
        }else{
            [_avi stopAnimating];
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
    }];
    
    
}
-(void)signInWithEncryptPwd:(NSString *)encryptPwd{
    [RequestAPI requestURL:@"/login" withParameters:@{@"userName":_usernameTextField.text,@"password":encryptPwd,@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            [[StorageMgr singletonStorageMgr]addKey:@"userName" andValue:_usernameTextField.text];
            [[StorageMgr singletonStorageMgr]addKey:@"password" andValue:encryptPwd];
            [[StorageMgr singletonStorageMgr]addKey:@"deviceId" andValue:[Utilities uniqueVendor]];
            NSDictionary *result=responseObject[@"result"];
            UserModel *user=[[UserModel alloc]initWithDictionary:result];
            //将登录获取的用户信息打包存取到单例化全局变量中
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            //单独将用户的id也存储进单例化全局变量中来作为用户是否已经登录的判断依据，同事也方便其他所有页面更快捷的使用用户id这个参数
            [[StorageMgr singletonStorageMgr ]addKey:@"MemberId" andValue:user.memberId];
            //  收起键盘
            [self.view endEditing:YES];
            //清空密码输入框里的内容
            _passwordnameTextField.text=@"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:_usernameTextField.text];
            //用MODEL的方式跳回上一页
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
        
    }];
}




@end
