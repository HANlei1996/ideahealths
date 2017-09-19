//
//  SecuritiesDetailViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "SecuritiesDetailViewController.h"
#import "PayViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "tiyanquanModel.h"
#import "AddressViewController.h"

@interface SecuritiesDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

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
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property(strong,nonatomic) NSArray *arr;
@end

@implementation SecuritiesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    [self networkRequest];
    [self refreshConfiguretion];
    
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
//刷新
-(void)refreshConfiguretion{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshContro=[[UIRefreshControl alloc]init];
    
    refreshContro.tag=10001;
    //设置标题
    NSString * title=@"加载中🐰";
    //创建属性字典
    NSDictionary *attrD=@{NSForegroundColorAttributeName : [UIColor grayColor]};
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attri=[[NSAttributedString alloc]initWithString:title attributes:attrD];
    refreshContro.attributedTitle=attri;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshContro.tintColor=[UIColor blackColor];
    //设置背景颜色
    refreshContro.backgroundColor=[UIColor groupTableViewBackgroundColor];
    //定义用户出发下拉事件执行的方法
    [refreshContro addTarget:self action:@selector(refreData:) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到activityView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置
    [self.scrollview addSubview:refreshContro];
    
}
-(void)refreData:(UIRefreshControl *)sender{
    //
    [self performSelector:@selector(end) withObject:nil afterDelay:2];
    
}

-(void)end{
    //在activityView中根据下标10001获得其子视图：下拉刷新控件
    UIRefreshControl *refresh=(UIRefreshControl *)[self.scrollview viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}

- (IBAction)ljxdBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {

    
    if([Utilities loginCheck]){
        if ([_xjLabel.text isEqualToString:@"0"]) {
            UIAlertController *alertView=[UIAlertController alertControllerWithTitle:@"支付成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                }];
            [alertView addAction:okAction];
         [self presentViewController:alertView animated:YES completion:nil];
            
            
        }else{
        PayViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"Purchase"];
        purchaseVC.detail=_detail;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        }
    }else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Sign" byIdentity:@"SignNavi"];

        [self presentViewController:signNavi animated:YES completion:nil];
        
    }

     
    

}
#pragma mark - request
-(void)networkRequest{
    
    UIActivityIndicatorView *aiv=[Utilities getCoverOnView:self.view];
       NSLog(@"mum=%@",[[StorageMgr singletonStorageMgr] objectForKey:@"expId2"]);
    [RequestAPI requestURL:@"/clubController/experienceDetail" withParameters:@{@"experienceId":[[StorageMgr singletonStorageMgr] objectForKey:@"expId2"]} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
       
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSDictionary *result= responseObject[@"result"];
            _detail=[[tiyanquanModel alloc]initWithDictionary:result];
    
            [self uiLayout];

            
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

-(void)uiLayout{
    [_tyjImage sd_setImageWithURL:[NSURL URLWithString :_detail.eLogo] placeholderImage:[UIImage imageNamed:@"默认图"]];
    _xjLabel.text=_detail.currentPrice;
    _yjLabel.text=[NSString stringWithFormat:@"%@元",_detail.orinPrice];
    [_addressBtn setTitle:_detail.eAddress forState:UIControlStateNormal];
    //_addressBtn.titleLabel.text=_detail.eAddress;
    _tykLabel.text=_detail.eName;
    _dmLabel.text=_detail.eClubName;
    _ysLabel.text=_detail.saleCount;
    _yxqLabel.text=_detail.beginDate;
    _endLabel.text=_detail.endDate;
    _sysjLabel.text=_detail.userDate;
    _sygzLbel.text=_detail.rules;
    _wstsLabel.text=_detail.ePromot;
    [_callBtn setTitle:[NSString stringWithFormat:@"%@",_detail.clubTel] forState:UIControlStateNormal];

}

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    NSString *string = _detail.clubTel;
    _arr =  [string componentsSeparatedByString:@","];
    // NSLog(@"数组里的是：%@",_arr);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // for(int i = 0 ; i < _arr.count ; i++){
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //  NSLog(@"点了第一个");
        // NSLog(@"%@",_arr[0]);
        //配置电话APP的路径，并将要拨打的号码组合到路径中
        NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[0]];
        
        UIWebView *callWebview =[[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        
        
    }];
    [alertController addAction:callAction];
    // }
    if(_arr.count == 2)
    {
        
        UIAlertAction *callAction = [UIAlertAction actionWithTitle:_arr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // NSLog(@"点了第二个");
            // NSLog(@"%@",_arr[1]);
            //配置电话APP的路径，并将要拨打的号码组合到路径中
            NSString *targetAppStr = [NSString stringWithFormat:@"tel:%@",_arr[1]];
            
            UIWebView *callWebview =[[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetAppStr]]];
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
            
            
        }];
        [alertController addAction:callAction];
        
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
        
  /*UIAlertAction *callAction = [UIAlertAction actionWithTitle:_detail.clubTel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //通话跳转
       // NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"%@", _detail.clubTel];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:callAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];*/
}
- (IBAction)addressAction:(UIButton *)sender forEvent:(UIEvent *)event {
   //_addressBtn.titleLabel.text=_detail.eAddress;
    AddressViewController *address=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"address"];
    address.latitude = _detail.latityde;
    address.longitude = _detail.longitude;
    address.dm=_detail.eClubName;
    [self.navigationController pushViewController:address animated:YES];
    //_addressBtn.titleLabel.text=_detail.eAddress;
    
}
@end
