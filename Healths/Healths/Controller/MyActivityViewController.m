//
//  MyActivityViewController.m
//  Healths
//
//  Created by 233 on 2017/9/11.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyActivityViewController.h"
#import "MyActivityTableViewCell.h"
#import "ActivityModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MyActivityViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger totalPage;
    
    NSInteger page;
    NSInteger perPage;
    
    BOOL isLastPage;
    
}
@property (weak, nonatomic) IBOutlet UITableView *MyActivityTableView;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *MyActivityArr;
@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化可变数组！！！
    _MyActivityArr = [NSMutableArray new];
    page = 1;
    perPage = 10;
    //去掉tableview底部多余的线
    _MyActivityTableView.tableFooterView = [UIView new];
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10005;
    [_MyActivityTableView addSubview:ref];
    //调用网络请求
    [self initializeData];
    
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

- (void)refreshPage{
    page = 1;
    [self request];
}

#pragma mark - request

- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshPage];
}
//网络请求
- (void)request{
    [_avi stopAnimating];
    UIRefreshControl *ref = [_MyActivityTableView viewWithTag:10005];
    [ref endRefreshing];
    NSDictionary *para = @{@"memberId":@2,@"page":@(page),@"perPage":@(perPage)};
    [RequestAPI requestURL:@"/eventOrder/my" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = [_MyActivityTableView viewWithTag:10005];
        [ref endRefreshing];
        NSLog(@"myActivity: %@", responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result=responseObject[@"result"];
            NSArray *models=result[@"models"];
            NSDictionary *pagingInfo= result[@"pagingInfo"];
            totalPage=[  pagingInfo [@"totalPage"]integerValue];
            if (page ==1) {
                //清空数组
                [_MyActivityArr removeAllObjects];
                
            }
            for (NSDictionary *dict in models) {
                
                //用ActivityModel类中定义的初始化方法initWithDictionary：将遍历得来的字典dictionary转换成ActivityMode对象
                ActivityModel *activityModel=[[ActivityModel alloc]initWithDictionary:dict];
                //将上述实例化好的ActivityModel对象插入_arr数组中
                [_MyActivityArr addObject:activityModel];
            }
            //刷新表格（重载数据）
            [_MyActivityTableView reloadData];
        }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:@"提示" onView:self];
        }
        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        [_avi stopAnimating];
        //业务逻辑失败的情况下
        [Utilities popUpAlertViewWithMsg:@"网络错误" andTitle:nil onView:self];
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
//设置表格视图一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _MyActivityArr.count;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyActivityCell" forIndexPath:indexPath];
    ActivityModel *activity = _MyActivityArr[indexPath.row];
    NSURL *url = [NSURL URLWithString:activity.imgUrl];
    [cell.huodongImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"Default"]];
    cell.hdmingchengLable.text = activity.name;
    cell.dingLable.text = [NSString stringWithFormat:@"顶:%ld",(long)activity.like];
    cell.caiLable.text = [NSString stringWithFormat:@"踩:%ld",(long)activity.unlike];
    cell.neirongLable.text = activity.address;
    return cell;
    
}
//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _MyActivityArr.count - 1) {
        if (page<totalPage) {
            page ++;
            [self request];
        }
    }
}

@end
