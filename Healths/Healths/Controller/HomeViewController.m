//
//  HomeViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "UIImageView+WebCache.h"
#import "ClubDetailViewController.h"
#import "CardTableViewCell.h"
#import "SecuritiesDetailViewController.h"
@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger homePageNum;
    NSInteger isLastPage;
    NSInteger cityPageNum;
    BOOL firstVisit;
    BOOL isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;





@property (strong,nonatomic)NSMutableArray *Arr1;
@property (strong, nonatomic) NSMutableArray *Arr2;
@property (strong, nonatomic) NSMutableArray *experience;
@property (strong,nonatomic) CLLocation *location;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong,nonatomic) CLLocationManager *locMgr;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _experience = [NSMutableArray new];
    
    
    cityPageNum = 1;
    [self naviConfig];
    //[self locationConfig];
    [self InitializeData];
    //刷新指示器
    [self refreshConfiguretion];
    UIImage *img1=[UIImage imageNamed:@"AdDefault"];
    
    UIImage *img3=[UIImage imageNamed:@"app_logo"];
    _logoImage.animationImages=[NSArray arrayWithObjects:img1,img3, nil];
    _logoImage.animationDuration=5;
    [_logoImage startAnimating];//动画开始
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
////每次将要来都这个页面的时候
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self locationStart];
//}
////每次到达这个页面的时候
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//}
////每次将要离开这个页面的时候
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_locMgr stopUpdatingLocation];
//}
////每次离开这个页面的时候
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    //获得当前页面的导航控制器所维系的关于导航关系的数组,判断该数组中是否包含自己来得知当前操作是离开打本页面还是退出被本页面
//    if(![self.navigationController.viewControllers containsObject:self])
//    {
//        //在这里释放所有监听（包括Action事件；protcol协议；Gesture手势；Notification通知...）
//        
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    [self.homeTableView addSubview:refreshContro];
    
}
-(void)refreData:(UIRefreshControl *)sender{
    //
    [self performSelector:@selector(end) withObject:nil afterDelay:2];
    
}

-(void)end{
    //在activityView中根据下标10001获得其子视图：下拉刷新控件
    UIRefreshControl *refresh=(UIRefreshControl *)[self.homeTableView viewWithTag:10001];
    //结束刷新
    [refresh endRefreshing];
}
- (void)InitializeData{
    _avi = [Utilities getCoverOnView:self.view];
//    firstVisit = YES;
    isLoading = NO;
    _Arr2 = [NSMutableArray new];
    [self cityRequest];
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"首页";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255.0 alpha:1.0]];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
        //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    
    
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}

//下拉刷新
- (void)refreshRequest{
    homePageNum = 1;
    [self cityRequest];
    
    
    
}
- (void)cityRequest{
    [RequestAPI requestURL:@"/homepage/choice" withParameters:@{@"city":@"无锡",@"jing":@120.3,@"wei":@31.57,@"page":@(homePageNum),@"perPage":@14} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];
        
        
        //NSLog(@"responseObject: %@", responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            
            
           
            
            //将数据中的result拿出来放到字典中
            NSDictionary *result = responseObject[@"result"];
            //将上一步拿到的字典中的list数组提取出来
            NSArray *models = result[@"models"];
            
            
            
            isLastPage = [result[@"pagingInfo"][@"totalPage"] integerValue];
            
            //当页码为1的时候让数据先清空，再重新添加
            if (homePageNum == 1) {
                [_Arr2 removeAllObjects];
                
            }
            //遍历list
            for (NSDictionary *dict in models) {
                //将遍历得来的字典转换为model
                HomeModel*homeModel = [[HomeModel alloc] initWithDictionary:dict];
                //将model存进全局数组
                [_Arr2 addObject:homeModel];
                //NSArray *array = homeModel.experience;
                //                for(NSDictionary *dict in array)
                //                {
                //                  HomeModel *homeModel1 = [[HomeModel alloc] initWithDictionary:dict];
                //                    [_experience addObject:homeModel1];
                //                }
                //                [_experience2 addObject:_experience];
                //experience 存的是每个会所的体验券字典，可能是一个也可能是多个
                
            }
            NSLog(@"%lu,%lu",(unsigned long)_Arr1.count,(unsigned long)_Arr2.count);
            
            //            for (NSDictionary *dedict in experience) {
            //                //将遍历得来的字典转换为model
            //                ExperienceModel *experienceModel = [[ExperienceModel alloc] initWithdeDictionary:dedict];
            //                //将model存进全局数组
            //
            //                [_Arr3 addObject:experienceModel];
            //            }
            
            
            
            //让tableview重载数据
            
            [_homeTableView reloadData];
        }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"操作失败" andTitle:@"提示" onView:self];
    }];
}
//一共多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _Arr2.count;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeModel *homeModel = _Arr2[section];
    return homeModel.experience.count + 1;
    
}



//每个细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeModel *homeModel = _Arr2[indexPath.section];
    if (indexPath.row == 0) {
        HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
        
        
        //将http请求的字符串转换为NSURL
        NSURL *URL1=[NSURL URLWithString:homeModel.image];
        
        [cell.bigImageView sd_setImageWithURL:URL1 placeholderImage:[UIImage imageNamed:@"Home"]];
        cell.clubIdLabel.text = homeModel.clubname;
        
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@米",homeModel.distance];
        cell.addressLabel.text = homeModel.clubaddress;
        return cell;
        
    }else{
        
        NSArray *experiences = homeModel.experience;
        for (NSDictionary *dict in experiences) {
            NSLog(@"dict = %@",dict.allValues);
        }
        CardTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cardcell" forIndexPath:indexPath];
        NSDictionary *experience = experiences[indexPath.row -1];
        //NSLog(@"indexp = %d",indexPath.row);
        
        NSURL *URL2=[NSURL URLWithString:experience[@"logo"]];
        [cell.smallImageView sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"默认图"]];
        cell.clubCardLabel.text = experience[@"name"];
        //NSLog(@"experience = %@",experience[@"name"]);
        //NSLog(@"experience = %@",experience[@"categoryName"]);
        cell.volumeLabel.text = [experience[@"categoryName"] isKindOfClass:[NSNull class]] ?@"综合卷" :experience[@"categoryName"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@元",experience[@"price"]];
        cell.soldLabel.text = [NSString stringWithFormat:@"已售:%@",experience[@"sellNumber"]];
        ;
        return cell;
    }
    
    //    }else{
    ////        ExperienceModel *experienceModel = _Arr3[indexPath.section];
    ////
    ////        cell.clubCardLabel.text = experienceModel.securitiesname;
    ////        cell.volumeLabel.text= experienceModel.categoryName;
    ////        cell.moneyLabel.text = experienceModel.price;
    ////        NSURL *URL2=[NSURL URLWithString:homeModel.logo];
    ////        [cell.smallImageView sd_setImageWithURL:URL2 placeholderImage:[UIImage imageNamed:@"Home"]];
    ////        return cell;
    //}
    
}

//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 260.f;
    }else{
        CardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardcell"];
        HomeModel *homemodel = _Arr2[indexPath.section];
        CGSize maxSize = CGSizeMake(UI_SCREEN_W - 30, 1000);
        CGSize contentSize = [homemodel.securitiesname boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.clubCardLabel.font} context:nil].size;
        return contentSize.height + 80;
    }
    
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
       // ClubDetailViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"clubdetail"];
        
        //purchaseVC.detail=_detail;
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"expId"];
        HomeModel *model = _Arr2[indexPath.section];
        //NSDictionary *dict = model.experience[indexPath.row-1];
        
        [[StorageMgr singletonStorageMgr] addKey:@"expId" andValue:model.clubid];
        
        //[self.navigationController pushViewController:purchaseVC animated:YES];
        return;

    }
    if (indexPath.row >=1) {
        SecuritiesDetailViewController *purchaseVC=[Utilities getStoryboardInstance:@"Detail" byIdentity:@"secur"];

        //purchaseVC.detail=_detail;
        [[StorageMgr singletonStorageMgr] removeObjectForKey:@"expId2"];
        HomeModel *model = _Arr2[indexPath.section];
        NSDictionary *dict = model.experience[indexPath.row-1];
        
        [[StorageMgr singletonStorageMgr] addKey:@"expId2" andValue:dict[@"id"]];

        [self.navigationController pushViewController:purchaseVC animated:YES];
        return;
    }
    
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断将要出现的细胞是不是当前最后一行
    if (indexPath.row == _Arr2.count - 1) {
        //当存在下一页的时候，页码自增，请求下一页数据
        if (cityPageNum < isLastPage) {
            cityPageNum ++;
            [self cityRequest];
        }
    }
}
////定位失败时
//- (void)locationManager:(CLLocationManager *)manager
//       didFailWithError:(NSError *)error{
//    if (error) {
//        switch (error.code) {
//            case kCLErrorNetwork:
//                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"NetworkError", nil) andTitle:nil onView:self];
//                break;
//            case kCLErrorDenied:
//                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"GPSDisabled", nil) andTitle:nil onView:self];
//                break;
//            case kCLErrorLocationUnknown:
//                [Utilities popUpAlertViewWithMsg:NSLocalizedString(@"LocationUnkonw", nil) andTitle:nil onView:self];
//                break;
//                
//                
//            default:[Utilities popUpAlertViewWithMsg:NSLocalizedString(@"SystemError", nil) andTitle:nil onView:self];
//                break;
//        }
//    }
//}
////定位成功时
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation{
//    NSLog(@"纬度: %f",newLocation.coordinate.latitude);
//    NSLog(@"经度: %f",newLocation.coordinate.longitude);
//    _location = newLocation;
//    //用flag思想判断是否可以去根据定位拿到城市
//    if (firstVisit) {
//        firstVisit = !firstVisit;
//        
//        //根据定位拿到城市
//        [self getRegeoViaCoordinate];
//    }
//     [_locMgr stopUpdatingLocation];
//
//}
//-(void)getRegeoViaCoordinate{
//    //duration表示从now开始过三个sec
//    dispatch_time_t duration= dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
//    //用duration这个设置好的策略去做某些事
//    dispatch_after(duration,dispatch_get_main_queue(), ^{
//        //正式做事情
//        CLGeocoder *geo = [CLGeocoder new];
//        //方向地理编码
//        [geo reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//            
//                CLPlacemark *first = placemarks.firstObject;
//                NSDictionary *locDict = first.addressDictionary;
//                //NSLog(@"locDict = %@",locDict);
//                NSString *cityStr = locDict[@"City"];
//                //把city的市子去掉
//                cityStr = [cityStr substringToIndex:(cityStr.length - 1)];
//                [[StorageMgr singletonStorageMgr]removeObjectForKey:@"LocCity"];
//                //将定位到的城市保存进单例化全局变量
//                [[StorageMgr singletonStorageMgr] addKey:@"LocCity" andValue:cityStr];
////                if (![cityStr isEqualToString:_CityBtn.titleLabel.text]) {
////                    //将定位的城市和当前选则的城市不一样的时候去弹窗询问用户是否要切换城市
////                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"当前定位到的城市为%@,请问您是否需要切换" ,cityStr] preferredStyle:UIAlertControllerStyleAlert];
////                    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        //修改城市按钮标题
////                        [_CityBtn setTitle:cityStr forState:UIControlStateNormal];
////                        //修改用户选择的城市记忆体
////                        [Utilities removeUserDefaults:@"UserCity"];
////                        [Utilities setUserDefaults:@"UserCity" content:cityStr];
//                        //重新执行网络请求
//                        [self cityRequest];
////                    }];
////                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
////                    [alert addAction:yesAction];
////                    [alert addAction:noAction];
////                    [self presentViewController:alert animated:YES completion:nil];
//            
//        
//         
//        
//      
//        //关掉开关
//        }];
//        [_locMgr stopUpdatingLocation];
//    
//         
//         });
//}
//-(void)checkCityState:(NSNotification *)note{
//    NSString *cityStr = note.object;
//    
//    
//        
//        //修改用户选择的城市记忆体
//        [Utilities removeUserDefaults:@"UserCity"];
//        [Utilities setUserDefaults:@"UserCity" content:cityStr];
//        //重新执行网络请求
//        [self cityRequest];
//    
//}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"Detail1"]) {
//        //当从列表页到详情页的这个跳转要发生的时候
//        //1获取要传递到下一页的数据
//        NSIndexPath *indexPath=[_homeTableView indexPathForSelectedRow];
//
//        
//        HomeModel *activity=_Arr2[indexPath.section];
//        //2获取下一页的这个实例
//        ClubDetailViewController *detailVC= segue.destinationViewController;
//        //3吧数据 给下一页预备好的接收容器
//        detailVC.detail=activity;
//        
////     NSIndexPath *indexp=[_homeTableView indexPathForSelectedRow];
////        HomeModel *activi=_Arr2[indexp.row];
////        //2获取下一页的这个实例
////        SecuritiesDetailViewController *detail= segue.destinationViewController;
////        //3吧数据 给下一页预备好的接收容器
////        detail.deta=activi;
//
//    }
//}
         
@end
