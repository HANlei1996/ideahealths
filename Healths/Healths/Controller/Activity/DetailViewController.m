//
//  DetailViewController.m
//  练习2
//
//  Created by admin on 17/8/1.
//  Copyright © 2017年 Education. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PurchaseTableViewController.h"
@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *applyFeeLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyStateLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *issuerLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (strong, nonatomic) IBOutlet UIView *DetailView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *applyDueLbl;
- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyStartView;
@property (weak, nonatomic) IBOutlet UIView *applyDueView;
@property (weak, nonatomic) IBOutlet UIView *applyingView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLbl;
- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UIView *applyEndView;
@property (weak, nonatomic) IBOutlet UILabel *attendenceLbl;
@property(strong,nonatomic)NSMutableArray *arr1;
@property(strong,nonatomic)UIImageView *image;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self networkRequest];
    // Do any additional setup after loading the view.
    [self naviConfig];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=_activity.name;
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
-(void)networkRequest{
    UIActivityIndicatorView *aiv=[Utilities getCoverOnView:self.view];
    NSString *request=[NSString stringWithFormat:@"/event/%@",_activity.activityId];
    NSMutableDictionary *parameters=[NSMutableDictionary new];
    if([Utilities loginCheck]){
        [parameters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"]forKey:@"memberId"];
    
    }
    [RequestAPI requestURL:request withParameters:parameters andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSDictionary *result= responseObject[@"result"];
            _activity= [[ActivityModel alloc]initWithDetailDictionary:result];
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
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString :_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"默认图"]];
    //[self addTapGestureRecognizer:_DetailView]
    _applyFeeLbl.text=[NSString stringWithFormat:@"%@元",_activity.applyFee];
    _attendenceLbl.text=[NSString stringWithFormat:@"%@/%@",_activity.attendence,_activity.limitation];
    _typeLbl.text=_activity.type;
    _issuerLbl.text=_activity.issuer;
    _addressLbl.text=_activity.address;
    _contentLbl.text=_activity.content;
    [_phoneBtn setTitle:[NSString stringWithFormat:@"联系活动发布者：%@",_activity.phone] forState:UIControlStateNormal];
    NSString *dueTimeStr=[Utilities dateStrFromCstampTime:_activity.dueTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *startTimeStr=[Utilities dateStrFromCstampTime:_activity.startTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *endTimeStr=[Utilities dateStrFromCstampTime:_activity.endTime withDateFormat:@"yyyy-MM-dd HH:mm"];
    _timeLbl.text=[NSString stringWithFormat:@"%@~%@",startTimeStr,endTimeStr];
    self.applyDueLbl.text=[NSString stringWithFormat:@"报名截止时间(%@)",dueTimeStr];
    NSDate *now=[NSDate date];
    NSTimeInterval nowTime=[now timeIntervalSince1970InMilliSecond];
    
    //timeIntervalSince1970InMilliSecond
    _applyStartView.backgroundColor=[UIColor grayColor];
    if(nowTime >= _activity.dueTime){
        _applyDueView.backgroundColor=[UIColor grayColor];
        _applyBtn.enabled=NO;
        [_applyBtn setTitle:@"报名截止" forState:UIControlStateNormal];
        if(nowTime >= _activity.startTime){
            _applyingView.backgroundColor=[UIColor grayColor];
            if(nowTime >= _activity.endTime){
                _applyEndView.backgroundColor=[UIColor grayColor];
                
            }

        }
    }
    
    if(_activity.attendence >=_activity.limitation){
        _applyBtn.enabled =NO;
        [_applyBtn setTitle:@"活动满员" forState:UIControlStateNormal];
    }
    switch (_activity.status) {
        case 0:
        {
            
        _applyStateLbl.text=@"已取消";
      
        }
            break;
        case 1:
        {
            _applyStateLbl.text=@"待付款";
            [_applyBtn setTitle:@"去付款" forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            _applyStateLbl.text=@"已报名";
            [_applyBtn setTitle:@"已报名" forState:UIControlStateNormal];
            _applyBtn.enabled=NO;
        }
            break;
        case 3:
        {
            _applyStateLbl.text=@"退款中";
            [_applyBtn setTitle:@"退款中" forState:UIControlStateNormal];
             _applyBtn.enabled=NO;
        }
            break;
        case 4:
        {
            _applyStateLbl.text=@"已退款";
        }
            break;
            
        default:{
        _applyStateLbl.text=@"待报名";
        }
            break;
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

- (IBAction)applyAction:(UIButton *)sender forEvent:(UIEvent *)event {
    if([Utilities loginCheck]){
        PurchaseTableViewController *purchaseVC=[Utilities getStoryboardInstance:@"Details" byIdentity:@"Purchase"];
        
        purchaseVC.activity=_activity;
        [self.navigationController pushViewController:purchaseVC animated:YES];
        
        
        
    }else{
        UINavigationController *signNavi=[Utilities getStoryboardInstance:@"Sign" byIdentity:@"SignNavi"];
        [self presentViewController:signNavi animated:YES completion:nil];
    
    }
}

- (IBAction)callAction:(UIButton *)sender forEvent:(UIEvent *)event {
    //配置“电话”APP的路径，并将要拨打的号码组合到路径中
    NSString *targetAppStr=[NSString stringWithFormat:@"telprompt://%@",_activity.phone];
    
    NSURL *targetAppUrl=[NSURL URLWithString:targetAppStr];
    //从当前APP跳转到其他指定的APP中
    [[UIApplication sharedApplication] openURL:targetAppUrl];
}
//添加一个单击手势事件
- (void)addTapGestureRecognizer: (id)any{
    //初始化一个单击手势，设置它的响应事件为tapClick:
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    //用户交互启用
    _activityImgView.userInteractionEnabled = YES;
    //将手势添加给入参
    [any addGestureRecognizer:tap];
}
//小图单击手势响应事件
- (void)tapClick: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized){
        NSLog(@"你单击了");
        //拿到单击手势在_activityTableView中的位置
        //CGPoint location = [tap locationInView:_activityImageView];
        //通过上述的点拿到在_activityTableView对应的indexPath
        //NSIndexPath *indexPath = [_activityTableView indexPathForRowAtPoint:location];
        //防范式编程
        // if (_arr !=nil && _arr.count != 0){
        //根据行号拿到数组中对应的数据
        //  ActivityModel *activity = _arr[indexPath.row];
        //设置大图片的位置大小
        _image = [[UIImageView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        //用户交互启用
        _image.userInteractionEnabled = YES;
        //设置大图背景颜色
        _image.backgroundColor = [UIColor blackColor];
        //_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_activity.imgUrl]]];
        //将http请求的字符串转换为nsurl
        NSURL *URL = [NSURL URLWithString:_activity.imgUrl];
        //依靠SDWebImage来异步地下载一张远程路径中的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
        [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"aaa"]];
        //设置图片地内容模式
        _image.contentMode = UIViewContentModeScaleAspectFit;
        //[UIApplication sharedApplication].keyWindow获得窗口实例，并将大图放置到窗口实例上，根据苹果规则，后添加的控件会盖住前面添加的控件
        [[UIApplication sharedApplication].keyWindow addSubview:_image];
        UITapGestureRecognizer *zoomIVTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
        [_image addGestureRecognizer:zoomIVTap];
        
        // }
    }
}//大图的单击手势响应事件
- (void)zoomTap: (UITapGestureRecognizer *)tap{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        //把大图的本身东西扔掉
        [_image removeGestureRecognizer:tap];
        //把自己从父级视图中移除
        [_image removeFromSuperview];
        //彻底消失（这样就不会让内存滥用）
        _image = nil;
    }
}
@end
