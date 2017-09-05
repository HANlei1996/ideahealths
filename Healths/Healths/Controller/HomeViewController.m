//
//  HomeViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeModel.h"
#import "UIImageView+WebCache.h"
#import "ClubDetailViewController.h"
@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger homePageNum;
    NSInteger isLastPage;
    NSInteger cityPageNum;
    BOOL homeLast;
    BOOL cityLast;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong, nonatomic) NSMutableArray *Arr2;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _Arr2 = [NSMutableArray new];
    [self naviConfig];
    
    [self cityRequest];
    
    //创建一个刷新指示器放在tableview中
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshRequest) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10001;
    [_homeTableView addSubview:ref];
    //    NSDictionary *dicA=@{ @"imgURL":@"http://7u2h3s.com2.z0.glb.qiniucdn.com/activityImg_2_0B28535F-B789-4E8B-9B5D-28DEDB728E9A",@"id":@"莫梵",@"distance":@80,@"address":@"无锡",@"name":@"体验劵",@"categoryName":@"综合卷",@"price":@"1"};
    //    NSMutableArray *array=[NSMutableArray arrayWithObjects:dicA,nil];
    //    for (NSDictionary *dict in array) {
    //
    //        //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dictionary转换成ActivityMode对象
    //        HomeModel *home=[[HomeModel alloc]initWithDictionary:dict];
    //        //将上述实例化好的ActivityModel对象插入_arr数组中
    //        [_Arr2 addObject:home];
    //}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 这个方法专门做导航条的控制
-(void)naviConfig{
    //设置导航条标题文字
    self.navigationItem.title=@"首页";
    //设置导航条的颜色（风格颜色）
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];
    //设置导航条的标题颜色
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName : [UIColor whiteColor] };
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden=NO;
    
    
    //设置是否需要毛玻璃效果
    self.navigationController.navigationBar.translucent=YES;
}
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshRequest];
}
//下拉刷新
- (void)refreshRequest{
    homePageNum = 1;
    
}
- (void)cityRequest{
    [RequestAPI requestURL:@"/homepage/choice" withParameters:@{@"city":@"无锡",@"jing":@31.57,@"wei":@120.3,@"page":@1,@"perPage":@2} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10002];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            [_avi stopAnimating];
            //将数据中的result拿出来放到字典中
            NSDictionary *result = responseObject[@"result"];
            //将上一步拿到的字典中的list数组提取出来
            NSArray *models = result[@"models"];
            
            
            cityLast = [result[@"isLastPage"] boolValue];
            
            
            //当页码为1的时候让数据先清空，再重新添加
            if (cityPageNum == 1) {
                [_Arr2 removeAllObjects];
                
            }
            //遍历list
            for (NSDictionary *dict in models) {
                //将遍历得来的字典转换为model
                HomeModel*homeModel = [[HomeModel alloc] initWithDictionary:dict];
                //将model存进全局数组
                
                [_Arr2 addObject:homeModel];
            }
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
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10002];
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
    return 1;
    
}


//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 350.f;
}
//每个细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeModel *homeModel = _Arr2[indexPath.row];
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    //    if (indexPath.row == 0) {
    
    //将http请求的字符串转换为NSURL
    NSURL *URL1=[NSURL URLWithString:homeModel.image];
    
    [cell.bigImageView sd_setImageWithURL:URL1 placeholderImage:[UIImage imageNamed:@"Home"]];
    
    cell.clubIdLabel.text = homeModel.clubid;
    cell.distanceLabel.text = homeModel.distance;
    cell.addressLabel.text = homeModel.clubaddress;
    
    
    return cell;
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
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断将要出现的细胞是不是当前最后一行
    if (indexPath.row == _Arr2.count - 1) {
        //当存在下一页的时候，页码自增，请求下一页数据
        if (!isLastPage) {
            homePageNum ++;
            //[self homeRequest];
        }
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"Detail1"]) {
        //当从列表页到详情页的这个跳转要发生的时候
        //1获取要传递到下一页的数据
        NSIndexPath *indexPath=[_homeTableView indexPathForSelectedRow];
        HomeModel *activity=_Arr2[indexPath.row];
        //2获取下一页的这个实例
        ClubDetailViewController *detailVC= segue.destinationViewController;
        //3吧数据 给下一页预备好的接收容器
        detailVC.detail=activity;
    }
}
@end
