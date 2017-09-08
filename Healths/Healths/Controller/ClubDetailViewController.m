//
//  ClubDetailViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "ClubDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeModel.h"
#import "DetailCardTableViewCell.h"
#import "SecuritiesDetailViewController.h"


@interface ClubDetailViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL isLastPage;
    NSInteger homePageNum;
}
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UITableView *experienceCardTableView;

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
@property(strong,nonatomic)NSMutableArray *arr1;
@property(strong,nonatomic)UIImageView *image;

@end

@implementation ClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _arr1 = [NSMutableArray new];
    // Do any additional setup after loading the view.
    [self networkRequest];
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
    //实例化一个button 类型为UIButtonTypeSystem
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //设置位置大小
    leftBtn.frame = CGRectMake(0, 0, 20, 20);
    //设置其背景图片为返回图片
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    //给按钮添加事件
    [leftBtn addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}

//自定的返回按钮的事件
- (void)leftButtonAction: (UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//键盘收回
- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //让根视图结束编辑状态达到收起键盘的目的
    [self.view endEditing:YES];
}

-(void)networkRequest{
    UIActivityIndicatorView *aiv=[Utilities getCoverOnView:self.view];
    /*if([Utilities loginCheck]){
     [parameters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"]forKey:@"memberId"];
     
     }*/
    NSLog(@"club id = %@",_detail.clubid);
    NSDictionary *parameter=@{@"clubKeyId":_detail.clubid};
    [RequestAPI requestURL:@"/clubController/getClubDetails" withParameters:parameter andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [aiv stopAnimating];
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            NSDictionary *result = responseObject[@"result"];
            NSArray *experienceInfos = result[@"experienceInfos"];
            for(NSDictionary *dict in experienceInfos){
                HomeModel *homeModel = [[HomeModel alloc]initWithDict:dict];
                [_arr1 addObject:homeModel];
            }
            _detail= [[HomeModel alloc]initWithDict:result];
            
            [self uiLayout];
            [_experienceCardTableView reloadData];
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
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString :_detail.clubLogo] placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    //[self addTapGestureRecognizer:_DetailView]
    _clubName.text = _detail.clubName;
    _clubAddress.text = _detail.clubAddressB;
    [_callBtn setTitle:[NSString stringWithFormat:@"%@",_detail.clubTel] forState:UIControlStateNormal];
    _contentTextView.text = _detail.clubIntroduce;
    _contentTextView.editable = NO;
    _time.text = _detail.clubTime;
    _membersCount.text = _detail.clubMember;
    _citeCount.text = _detail.clubSite;
    _coachCount.text = _detail.clubPerson;
    //    NSArray *experienceInfos = _detail.experienceInfos;
    //    for (NSDictionary *dict in experienceInfos) {
    //        NSLog(@"dict = %@",dict.allValues);
    //    }
    
    //NSDictionary *experienceInfos = experienceInfos[];
    
}
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arr1.count;
    
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel*model = _arr1[indexPath.section];
    DetailCardTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"card1cell" forIndexPath:indexPath];
    NSLog(@"%@,%@,%@,%@",model.orginPrice,model.eName,model.saleCount,model.eLogo);
   
        
    cell.experienceCard.text = model.eName;
    cell.price.text = [NSString stringWithFormat:@"%@ 元",model.orginPrice];
        cell.cardType.text = @"综合卷";
    cell.soldCount.text = [NSString stringWithFormat:@"已售:%@",model.saleCount];
    NSURL *URL2=[NSURL URLWithString:model.eLogo];
    [cell.experienceCardImageView sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"默认图"]];
    
    return cell;
}
//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        SecuritiesDetailViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"secur"];
        
        //purchaseVC.detail=_detail;
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"expId"];
        HomeModel *model = _arr1[indexPath.section];
        //NSDictionary *dict = model.experienceInfos[indexPath.row];
        
        [[StorageMgr singletonStorageMgr] addKey:@"expId" andValue:model.eId];
        
        [self.navigationController pushViewController:purchaseVC animated:YES];
        return;

    }
 
        
    
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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
        NSURL *URL = [NSURL URLWithString:_detail.clubLogo];
        //依靠SDWebImage来异步地下载一张远程路径中的图片并三级缓存在项目中，同时为下载的时间周期过程中设置一张临时占位图
        [_image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"01"]];
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



- (IBAction)callBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *callAction = [UIAlertAction actionWithTitle:_detail.clubTel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheetController addAction:cancelAction];
    [actionSheetController addAction:callAction];
    
    [self presentViewController:actionSheetController animated:YES completion:nil];
    
}
@end
