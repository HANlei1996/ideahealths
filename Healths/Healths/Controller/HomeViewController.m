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
@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger homePageNum;
    NSInteger isLastPage;
    NSInteger cityPageNum;
    BOOL homeLast;
    BOOL cityLast;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) NSMutableArray *Arr1;
@property (strong, nonatomic) NSMutableArray *Arr2;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self naviConfig];
    _Arr1 = [NSMutableArray new];
    //创建一个刷新指示器放在tableview中
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshRequest) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10004;
    [_homeTableView addSubview:ref];
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
- (void)homeRequest{
    [RequestAPI requestURL:@"/city/hotAndUpgradedList" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];
        
        NSLog(@"Object: %@", responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //将数据中的result拿出来放到字典中
            NSDictionary *result = responseObject[@"result"];
            //将上一步拿到的字典中的list数组提取出来
            NSArray *list = result[@"list"];
            homeLast = [result[@"isLastPage"] boolValue];
            
            //当页码为1的时候让数据先清空，再重新添加
            if (homePageNum == 1) {
                [_Arr1 removeAllObjects];
            }
            //遍历list
            for (NSDictionary *dict in list) {
                //将遍历得来的字典转换为model
                HomeModel *homeModel = [[HomeModel alloc] initWithDict:dict];
                //将model存进全局数组
                [_Arr1 addObject:homeModel];
            }
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
- (void)cityRequest{
    [RequestAPI requestURL:@"/homepage/choice" withParameters:@{@"city":@"无锡",@"jing":@31.57,@"wei":@120.3,@"page":@1,@"perPage":@2} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10002];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //将数据中的result拿出来放到字典中
            NSDictionary *result = responseObject[@"result"];
            //将上一步拿到的字典中的list数组提取出来
            NSArray *list = result[@"list"];
            cityLast = [result[@"isLastPage"] boolValue];
            
            //当页码为1的时候让数据先清空，再重新添加
            if (cityPageNum == 1) {
                [_Arr2 removeAllObjects];
            }
            //遍历list
            for (NSDictionary *dict in list) {
                //将遍历得来的字典转换为model
                HomeModel *homeModel = [[HomeModel alloc] initWithDict:dict];
                //将model存进全局数组
                [_Arr2 addObject:homeModel];
            }
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

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _Arr1.count;
    
}


//每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 300.f;
}
//每个细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    HomeModel *homeModel = _Arr1[indexPath.section];
    
    return cell;
}
//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断将要出现的细胞是不是当前最后一行
    if (indexPath.row == _Arr1.count - 1) {
        //当存在下一页的时候，页码自增，请求下一页数据
        if (!isLastPage) {
            homePageNum ++;
            //[self homeRequest];
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

@end
