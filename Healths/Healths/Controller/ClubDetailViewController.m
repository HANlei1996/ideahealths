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
#import "tiyanquanModel.h"
#import "AddressViewController.h"


@interface ClubDetailViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>{
    BOOL isLastPage;
    NSInteger homePageNum;
}
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScorllView;

@property (weak, nonatomic) IBOutlet UITableView *experienceCardTableView;

@property (weak, nonatomic) IBOutlet UIImageView *activityImgView;

@property (weak, nonatomic) IBOutlet UILabel *clubName;
@property (weak, nonatomic) IBOutlet UIButton *callBtn;
- (IBAction)callBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *membersCount;
@property (weak, nonatomic) IBOutlet UILabel *citeCount;
@property (weak, nonatomic) IBOutlet UILabel *coachCount;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property(strong,nonatomic)NSMutableArray *arr1;
@property(strong,nonatomic)UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewH;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
- (IBAction)addressBtnAction:(UIButton *)sender forEvent:(UIEvent *)event;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property(strong,nonatomic) NSArray *arr;

@end

@implementation ClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arr1 = [NSMutableArray new];
    _experienceCardTableView.tableFooterView = [UIView new];
    // Do any additional setup after loading the view.
    [self networkRequest];
    [self naviConfig];
    [self refreshConfiguretion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 这个方法专门做导航条的控制
- (void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title = @"会所详情";
    //设置导航条的颜色（风格颜色）
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255.0 alpha:1.0]];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    //设置导航条上按钮的风格颜色
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}

//刷新
- (void)refreshConfiguretion{
    //初始化一个下拉刷新控件
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    
    refreshControl.tag = 10000;
    //设置标题
    NSString * title = @"加载中...";
    //创建属性字典
    NSDictionary *attrD = @{NSForegroundColorAttributeName : [UIColor grayColor]};
    //将文字和属性字典包裹成一个带属性的字符串
    NSAttributedString *attri = [[NSAttributedString alloc]initWithString:title attributes:attrD];
    refreshControl.attributedTitle = attri;
    //设置风格颜色为黑色（风格颜色：刷新指示器的颜色）
    refreshControl.tintColor = [UIColor blackColor];
    //设置背景颜色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //定义用户出发下拉事件执行的方法
    [refreshControl addTarget:self action:@selector(refreData:) forControlEvents:UIControlEventValueChanged];
    //将下拉刷新控件添加到activityView中（在tableView中，下拉刷新控件会自动放置在表格视图顶部后侧位置
    [self.detailScorllView addSubview:refreshControl];
    
}

- (void)refreData:(UIRefreshControl *)sender{
    //[self networkRequest];
    [self performSelector:@selector(endRefresh) withObject:nil afterDelay:2];
    
    
}

- (void)endRefresh{
    //在activityView中根据下标10000获得其子视图：下拉刷新控件
    UIRefreshControl *refresh = (UIRefreshControl *)[self.detailScorllView viewWithTag:10000];
    //结束刷新
    [refresh endRefreshing];
}

- (void)networkRequest{
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    /*if([Utilities loginCheck]){
     [parameters setObject:[[StorageMgr singletonStorageMgr] objectForKey:@"MemberId"]forKey:@"memberId"];
     
     }*/
    NSDictionary *parameter = @{@"clubKeyId":[[StorageMgr singletonStorageMgr] objectForKey:@"expId"]};
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
            _detail = [[HomeModel alloc]initWithDict:result];
            
            [self uiLayout];
            [_experienceCardTableView reloadData];
        }else{
            NSString *errorMsg = [ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [aiv stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"请保持网络连接畅通" andTitle:nil onView:self];
    }];
    
}

- (void)uiLayout{
    [_activityImgView sd_setImageWithURL:[NSURL URLWithString :_detail.clubLogo] placeholderImage:[UIImage imageNamed:@"默认图"]];
    _clubName.text = _detail.clubName;
    //_clubAddress.text = _detail.clubAddressB;
    [_addressBtn setTitle:_detail.clubAddressB forState:UIControlStateNormal];
    [_callBtn setTitle:[NSString stringWithFormat:@"%@",_detail.clubTel] forState:UIControlStateNormal];
    _contentTextView.text = _detail.clubIntroduce;
    _contentTextView.editable = NO;
    _textviewH.constant = self.contentTextView.contentSize.height + 40;
    _time.text = _detail.clubTime;
    _membersCount.text = _detail.clubMember;
    _citeCount.text = _detail.clubSite;
    _coachCount.text = _detail.clubPerson;
    
    
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
    DetailCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"card1cell" forIndexPath:indexPath];
    NSLog(@"%@,%@,%@,%@",model.orginPrice,model.eName,model.saleCount,model.eLogo);
    cell.experienceCard.text = model.eName;
    cell.price.text = [NSString stringWithFormat:@"%@ 元",model.orginPrice];
    cell.cardType.text = @"综合卷";
    cell.soldCount.text = [NSString stringWithFormat:@"已售:%@",model.saleCount];
    NSURL *URL2 = [NSURL URLWithString:model.eLogo];
    [cell.experienceCardImageView sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"默认图"]];
    _viewH.constant = (indexPath.section + 1) * 80.f;
    return cell;
}

//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        SecuritiesDetailViewController *purchaseVC = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"secur"];
        //purchaseVC.detail=_detail;
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"expId2"];
        HomeModel *model = _arr1[indexPath.section];
        //NSDictionary *dict = model.experienceInfos[indexPath.row];
        [[StorageMgr singletonStorageMgr] addKey:@"expId2" andValue:model.eId];
        [self.navigationController pushViewController:purchaseVC animated:YES];
        [_experienceCardTableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)addressBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
    AddressViewController *address = [Utilities getStoryboardInstance:@"Detail" byIdentity:@"address"];
    address.latitude = _detail.clubWei;
    address.longitude = _detail.clubJing;
    
    [self.navigationController pushViewController:address animated:YES];
}

- (IBAction)imageBtnAction:(UIButton *)sender forEvent:(UIEvent *)event {
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
        
      
    }
}
//大图的单击手势响应事件
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
    
}
@end
