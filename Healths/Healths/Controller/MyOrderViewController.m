//
//  MyOrderViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderTableViewCell.h"
#import "OrderModel.h"
@interface MyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSInteger flag;
    
    NSInteger pageNum;
    NSInteger pageSize;
    
    BOOL isLastPage;

}
@property (weak, nonatomic) IBOutlet UITableView *MyOrderTableViewCell;
@property (strong, nonatomic) UIActivityIndicatorView *avi;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) NSMutableArray *orderArr;

@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化可变数组！！！
    _orderArr = [NSMutableArray new];
    pageNum = 1;
    pageSize = 20;
    //去掉tableview底部多余的线
    _MyOrderTableViewCell.tableFooterView = [UIView new];
    UIRefreshControl *ref = [UIRefreshControl new];
    [ref addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventValueChanged];
    ref.tag = 10005;
    [_MyOrderTableViewCell addSubview:ref];
    //没有数据时显示的图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((UI_SCREEN_W - 100) / 2,_MyOrderTableViewCell.frame.origin.y + 100, 100, 100)];
    _imageView.image = [UIImage imageNamed:@"no_things"];
    [self.view addSubview:_imageView];
    
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
    pageNum = 1;
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
    UIRefreshControl *ref = [_MyOrderTableViewCell viewWithTag:10005];
    [ref endRefreshing];
    NSDictionary *para = @{@"memberId":@1,@"type":@0};
    [RequestAPI requestURL:@"/orderController/orderList" withParameters:para andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = [_MyOrderTableViewCell viewWithTag:10005];
        [ref endRefreshing];
        NSLog(@"order: %@", responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            NSDictionary *result = responseObject[@"result"];
            NSArray *list = result[@"list"];
            
            isLastPage = [result[@"isLastPage"] boolValue];
            
            if (pageNum == 1) {
                [_orderArr removeAllObjects];
            }
            
            for (NSDictionary *dict in list) {
                OrderModel *history = [[OrderModel alloc] initWithDict:dict];
                [_orderArr addObject:history];
            }
            
            if (_orderArr.count == 0) {
                _imageView.hidden = NO;
            }else{
                _imageView.hidden = YES;
            }
            
            
            
            [_MyOrderTableViewCell reloadData];
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
    return 40.f;
}
//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _orderArr.count;
}
//细胞长什么样
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell" forIndexPath:indexPath];
    return cell;
}
//设置每行高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.f;
}

//细胞选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//细胞将要出现时调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _orderArr.count - 1) {
        if (!isLastPage) {
            pageNum ++;
            [self request];
        }
    }
}

@end
