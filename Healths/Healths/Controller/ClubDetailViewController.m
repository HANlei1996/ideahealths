//
//  ClubDetailViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ClubDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ClubDetailViewController ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIView *detailView;


@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;

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
@property(strong,nonatomic)NSMutableArray *arr1;

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
        //配置“电话”APP的路径，并将要拨打的号码组合到路径中
        //NSString *targetAppStr=[NSString stringWithFormat:@"telprompt://%@",_activity.phone];
        
        //NSURL *targetAppUrl=[NSURL URLWithString:targetAppStr];
        //从当前APP跳转到其他指定的APP中
        //[[UIApplication sharedApplication] openURL:targetAppUrl];

    }
    return;
}
- (IBAction)imageBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    
    
    
}

-(void)addlongPress:(UITableView *)cell{
    //初始化一个长按手势，设置响应的事件为choose
    UILongPressGestureRecognizer *longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    //设置长按手势响应的时间
    longPress.minimumPressDuration=1.0;
    //将手势添加给cell
    [cell addGestureRecognizer:longPress];
    
}



//添加单击手势事件
-(void)addTap:(id)any{
    //初始化一个单击手势，设置响应事件为tapClick
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [any addGestureRecognizer:tap];
    
}



//单击手势响应事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    
    if (tap.state==UIGestureRecognizerStateRecognized) {
        
        
        
        //拿到长按手势在_activiyTableView中的位置
        CGPoint location=[tap locationInView:_detailView];
        //通过上述的点拿到现在_activiyTableView对应的indexPath
        // NSIndexPath *indexPath=[_DetailView indexPathForRowAtPoint:location];
        
        //防范
        if (_arr1 !=nil && _arr1.count !=0) {
            // ActivityModel *activity=_arr1[indexPath.row];
            //设置大图片的位置大小
            _activityImgView=[[UIImageView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            //用户交互启用
            _activityImgView.userInteractionEnabled=YES;
            _activityImgView.backgroundColor=[UIColor blackColor];
            //[_activityImgView sd_setImageWithURL:[NSURL URLWithString:_activity.imgUrl] placeholderImage:[UIImage imageNamed:@"aaa"]];
            //设置图片的内容模式
            _activityImgView.contentMode = UIViewContentModeScaleAspectFit;
            //获得窗口实例，并将大图放置到窗口实例上，根据苹果规则，后添加的空间会覆盖前添加的控件
            [[UIApplication sharedApplication].keyWindow addSubview:_activityImgView];
            UITapGestureRecognizer *zoomIVtap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomTap:)];
            [_activityImgView addGestureRecognizer:zoomIVtap];
        }
    }
    
}
-(void)zoomTap:(UITapGestureRecognizer *)tap{
    if (tap.state==UIGestureRecognizerStateRecognized) {
        //把大图本身的东西扔掉（大图的手势）
        [_activityImgView removeGestureRecognizer:tap];
        //把自己从视图上移除
        [_activityImgView removeFromSuperview];
        //让图片彻底消失（不会造成内存的滥用)
        _activityImgView=nil;
    }
    
}

@end
