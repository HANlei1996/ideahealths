//
//  MyViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "UserModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *MyTableView;
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImage;
@property (weak, nonatomic) IBOutlet UILabel *userLaber;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingUpBtn;
- (IBAction)settingAction:(UIBarButtonItem *)sender;
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event;

@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) NSArray *myArr;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _myArr = @[@{@"myIndenLabel":@"我的订单"},@{@"myIndenLabel":@"我的活动"},@{@"myIndenLabel":@"我的推广"},@{@"myIndenLabel":@"积分中心"},@{@"myIndenLabel":@"意见反馈"},@{@"myIndenLabel":@"关于我们"}];
    [self naviConfig];
    _MyTableView.tableFooterView = [UIView new];
}
//每次将要来都这个页面的时候
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([Utilities loginCheck]) {
        //已登录
        _loginBtn.hidden=YES;
        _userLaber.hidden=NO;
        UserModel *user=[[StorageMgr singletonStorageMgr]objectForKey:@"MemberInfo"];
        [_touxiangImage sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage:[UIImage imageNamed:@"ic_user_head"]];
        _userLaber.text= user.nickname;
        
    }else{
        //未登录
        _loginBtn.hidden=NO;
        _userLaber.hidden=YES;
        _touxiangImage.image=[UIImage imageNamed:@"ic_user_head"];
        _userLaber.text=@"游客";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    //self.navigationItem.title=@"活动列表";
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
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _myArr.count;
}

//设置表格视图中每一组由多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myInfoCell" forIndexPath:indexPath];
    //根据行号拿到数组中对应的数据
    NSDictionary *dict = _myArr[indexPath.section];
    cell.MyIdenLable.text = dict[@"myIndenLabel"];
    return cell;
}
//设置组的底部视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
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
        if ([Utilities loginCheck]) {
            switch (indexPath.section) {
                case 0:
                    [self performSegueWithIdentifier:@"wdjd" sender:self];
                    break;
                case 1:
                    [self performSegueWithIdentifier:@"hd" sender:self];
                    break;
                case 2:
                    [self performSegueWithIdentifier:@"wdhk" sender:self];
                    break;
                case 3:
                    break;
                case 4:
                    [self performSegueWithIdentifier:@"aaaa" sender:self];
                    break;
                default:
                    [self performSegueWithIdentifier:@"lxkf" sender:self];
                    break;
            }
        }else{
            
            UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Sign" byIdentity:@"SignNavi"];
            [self presentViewController:signNavi animated:YES completion:nil];
            
        }
    if (indexPath.section == 2){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"当前积分:2534" message:@"积分商城即将登陆，准备好了吗，亲？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        [self exit];
            
        }];
        [alert addAction:actionA];
        [self presentViewController:alert animated:YES completion:nil];
        [self requst];
    }
}
    
-(void)requst{
    _avi = [Utilities getCoverOnView:self.view];
    
    [RequestAPI requestURL:@"/score/memberScore" withParameters:@{@"memberId":@2} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"mypromotion:%@", responseObject);
        if ([responseObject[@"resultFlag"]integerValue]==8001) {
            NSDictionary *result =responseObject[@"2543"];
            UserModel *user=[[UserModel alloc]initWithDictionary:result];
            [[StorageMgr singletonStorageMgr]addKey:@"MemberInfo" andValue:user];
            [[StorageMgr singletonStorageMgr ]addKey:@"MemberId" andValue:user.credit];
        }
        else{
            [_avi stopAnimating];
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        [Utilities popUpAlertViewWithMsg:@"网络错误,请稍等再试" andTitle:@"提示" onView:self];
    }];
    
    
}



- (IBAction)settingAction:(UIBarButtonItem *)sender {
    if ([Utilities loginCheck]) {
      [self performSegueWithIdentifier:@"setup" sender:self];
        
    }else{
        
        [self performSegueWithIdentifier:@"sign" sender:self];
}
}
- (IBAction)loginAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [self performSegueWithIdentifier:@"sign" sender:self];

    
    
}
@end
