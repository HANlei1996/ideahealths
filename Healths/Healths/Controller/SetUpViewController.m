//
//  SetUpViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetUpTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
@interface SetUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *setupImage;
@property (weak, nonatomic) IBOutlet UIButton *modificationBtn;
- (IBAction)modBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UITableView *SetUpTableView;
@property (strong, nonatomic) NSMutableArray *setupArr;
@property (strong,nonatomic) UIActivityIndicatorView *avi;
@property (strong,nonatomic)UserModel *user;
@end

@implementation SetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self naviConfig];
    //监听名为@"refreshSetup"的通知，监听到后执行refreshSetup方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSetup) name:@"refreshSetup" object:nil];
    [self arr];
  //  _setupArr = [[NSMutableArray alloc]initWithObjects:@{@"nicknameLabel":@"昵称",@"infoLabel":_user.nickname},@{@"nicknameLabel":@"性别",@"infoLabel":_user.gender},@{@"nicknameLabel":@"生日",@"infoLabel":_user.dob},@{@"nicknameLabel":@"身份证号码",@"infoLabel":_user.idCardNo}, nil];
    
    
        /*NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithObjectsAndKeys: @"昵称",@"nicknameLabel",_user.nickname,@"infoLabel",nil];
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithObjectsAndKeys: @"性别",@"nicknameLabel",_user.gender,@"infoLabel", nil];
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithObjectsAndKeys: @"生日",@"nicknameLabel",_user.dob,@"infoLabel", nil];
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithObjectsAndKeys: @"身份证号码",@"nicknameLabel",_user.idCardNo,@"infoLabel", nil];
        _setupArr = [[NSMutableArray alloc]initWithObjects:dict1,dict2,dict3,dict4,nil];*/
    
    
        
        
        
        
    
    _SetUpTableView.tableFooterView = [UIView new];
    [self setFootViewForTableView];
    [_SetUpTableView reloadData];
    //[self networkRequest];

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)arr{
    NSLog(@"东东是：%@",_user.dob);
    _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
    _setupArr = [[NSMutableArray alloc]initWithObjects:@{@"nicknameLabel":@"昵称",@"infoLabel":_user.nickname},@{@"nicknameLabel":@"性别",@"infoLabel":_user.gender},@{@"nicknameLabel":@"生日",@"infoLabel":_user.dob},@{@"nicknameLabel":@"身份证号码",@"infoLabel":_user.idCardNo}, nil];
    
}
//当前页面将要显示的时候，显示导航栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if ([Utilities loginCheck]) {
        //已登录
        _user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_setupImage sd_setImageWithURL:[NSURL URLWithString:_user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
    }else{
        _setupImage.image=[UIImage imageNamed:@"ic_user_head"];
        
    }
    
}
/*-(void)refreshNick{
    NSMutableDictionary * dict = _setupArr[0];
    NSLog(@"nsdictionary:%@",dict);
    NSString *string = [[StorageMgr singletonStorageMgr] objectForKey:@"NC"];
    NSLog(@"danli:%@",string);
    [dict setObject: string forKey:@"infoLabel"];
    [_SetUpTableView reloadData];
}
-(void)refreshXB{
    NSMutableDictionary * dict = _setupArr[1];
    NSLog(@"nsdictionary:%@",dict);
    NSString *string2 = [[StorageMgr singletonStorageMgr] objectForKey:@"XB"];
    NSLog(@"danli:%@",string2);
    [dict setObject: string2 forKey:@"infoLabel"];
    [_SetUpTableView reloadData];
}
-(void)refreshSR{
    NSMutableDictionary * dict = _setupArr[2];
    NSLog(@"nsdictionary:%@",dict);
    NSString *string3 = [[StorageMgr singletonStorageMgr] objectForKey:@"SR"];
    NSLog(@"danli:%@",string3);
    [dict setObject: string3 forKey:@"infoLabel"];
    [_SetUpTableView reloadData];
}
-(void)refreshSFZHM{
    NSMutableDictionary * dict = _setupArr[3];
    NSLog(@"nsdictionary:%@",dict);
    NSString *string4 = [[StorageMgr singletonStorageMgr] objectForKey:@"SFZHM"];
    NSLog(@"danli:%@",string4);
    [dict setObject: string4 forKey:@"infoLabel"];
    [_SetUpTableView reloadData];
}

*/


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
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem= leftBarItem;
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
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _setupArr.count;
}


//设置表格视图中每一组由多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetUpTableViewCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _setupArr[indexPath.section];
    
    cell.nicknameLabel.text = dict[@"nicknameLabel"];
    cell.infoLabel.text = dict[@"infoLabel"];
    return cell;
}

//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 5.f;
    }
    return 1.f;
}
//设置细胞高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.f;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消细胞的选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
        switch (indexPath.section) {
            case 0:
                [self performSegueWithIdentifier:@"SetUpToNC" sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:@"SetUpToXB" sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:@"SetUpToSR" sender:self];
                break;
                        default:
                [self performSegueWithIdentifier:@"SetUpToSFZHM" sender:self];
                break;
        }
    }

//设置tableview的底部视图
- (void)setFootViewForTableView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_W, 300)];
    view.backgroundColor = UIColorFromRGB(240, 235, 245);
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    exitBtn.frame = CGRectMake(0, 30, UI_SCREEN_W, 40.f);
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    //设置按钮标题的字体大小
    exitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
    [exitBtn setTitleColor:UIColorFromRGB(225.f, 0.f, 0.f) forState:UIControlStateNormal];
    exitBtn.backgroundColor = [UIColor whiteColor];
    [exitBtn addTarget:self action:@selector(exitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:exitBtn];
    
    [_SetUpTableView setTableFooterView:view];

}
//按钮的点击事件
- (void)exitAction: (UIButton *)button{
    //NSLog(@"%@", @"退出");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self exit];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:actionA];
    [alert addAction:actionB];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)exit{
    //UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Sign" byIdentity:@"SignNavi"];
    //[self presentViewController:signNavi animated:YES completion:nil];
[[StorageMgr singletonStorageMgr ]removeObjectForKey:@"MemberId"];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*UINavigationController *SignNavi=[Utilities getStoryboardInstance:@"SetUp" byIdentity:@"SignNavi"];
    [self presentViewController:SignNavi animated:YES completion:nil];*/
}

//设置组的底部视图颜色为透明
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(void)readyForEncoding{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/login/getKey" withParameters:@{@"deviceType":@7001,@"deviceId":[Utilities uniqueVendor]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            //[_avi stopAnimating];
            NSDictionary *result=responseObject [@"result"];
            NSString *exponent =result[@"exponent"];
            NSString *modulus =result[@"modulus"];
            NSString *string = [[StorageMgr singletonStorageMgr]objectForKey:@"Password"];
            //对内容进行MD5加密
            NSString *md5Str =[string getMD5_32BitString];
          //  [[StorageMgr singletonStorageMgr]addKey:@"Password"andValue:_passwordnameTextField.text];
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
    NSString *userName = [[StorageMgr singletonStorageMgr]objectForKey:@"userName"];
        NSString *deviceId = [[StorageMgr singletonStorageMgr]objectForKey:@"deviceId"];
    

    [RequestAPI requestURL:@"/login" withParameters:@{@"userName":userName,@"password":encryptPwd,@"deviceType":@7001,@"deviceId":deviceId} andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"responseObject:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            
            NSDictionary *result=responseObject[@"result"];
            UserModel *user=[[UserModel alloc]initWithDictionary:result];
            //将登录获取的用户信息打包存取到单例化全局变量中
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            //单独将用户的id也存储进单例化全局变量中来作为用户是否已经登录的判断依据，同事也方便其他所有页面更快捷的使用用户id这个参数
            [[StorageMgr singletonStorageMgr ]addKey:@"MemberId" andValue:user.memberId];
            //  收起键盘
            [self.view endEditing:YES];
            //清空密码输入框里的内容
           // _passwordnameTextField.text=@"";
            //记忆用户名
            [Utilities setUserDefaults:@"Username" content:userName];
            [self arr];
            [_SetUpTableView reloadData];
            //用MODEL的方式跳回上一页
            //[self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
        
    }];
}
-(void)refreshSetup{
    [self readyForEncoding];
}


- (IBAction)modBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
}
/*-(void)networkRequest{
 _avi=[Utilities getCoverOnView:self.view];
 
 //NSLog(@"%@",_user.nickname);
 
 NSDictionary *para = @{@"memberId":_user.memberId,@"name":_user.nickname};
 [RequestAPI requestURL:@"/mySelfController/updateMyselfInfos" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
 [_avi stopAnimating];
 NSLog(@"responseObject:%@",responseObject);
 if([responseObject[@"resultFlag"]integerValue] == 8001){
 //NSDictionary *result= responseObject[@"result"];
     
 
 
 
 [_SetUpTableView reloadData];
 
 }else{
 NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
 [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
 
 }
 } failure:^(NSInteger statusCode, NSError *error) {
 [_avi stopAnimating];
 //业务逻辑失败的情况下
 [Utilities popUpAlertViewWithMsg:@"网络请求失败😂" andTitle:nil onView:self];
 }];
 
 }*/
 


@end
