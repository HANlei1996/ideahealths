//
//  HomeViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"

@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger detailPageNum;
    NSInteger isLastPage;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) NSMutableArray *Arr1;
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
    detailPageNum = 1;
    
}
//- (void)homeRequest{
//    //获取token请求接口
//    NSString *token = [[StorageMgr singletonStorageMgr] objectForKey:@"token"];
//    NSArray *headers = @[[Utilities makeHeaderForToken:token]];
//    
//    NSDictionary *para = @{@"pageNum": @(detailPageNum),@"pageSize": @(pageSize),@"taskId":@(_taskModel.taskID)};
//    
//    [RequestAPI requestURL:@"/api/task/achieveDetail" withParameters:para andHeader:headers byMethod:kGet andSerializer:kForm success:^(id responseObject) {
//        
//        [_avi stopAnimating];
//        UIRefreshControl *ref = (UIRefreshControl *)[_taskDetailTableView viewWithTag:10004];
//        [ref endRefreshing];
//        
//        NSLog(@"detail: %@", responseObject);
//        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
//            NSDictionary *detail = responseObject[@"result"][@"detail"];
//            NSArray *list = detail[@"list"];
//            
//            isLastPage = [detail[@"isLastPage"] boolValue];
//            
//            if (detailPageNum == 1) {
//                
//                [_detailArr removeAllObjects];
//            }
//            
//            for (NSDictionary *dict in list) {
//                CustomModel *custom = [[CustomModel alloc] initWithDictForTaskDetail:dict];
//                [_detailArr addObject:custom];
//            }
//            
//            _taskNameLabel.text = _taskModel.taskName;
//            _numLabel.text = [NSString stringWithFormat:@"%lu/%ld/%ld", (unsigned long)_detailArr.count, (long)_taskModel.remainingCount, (long)_taskModel.total];
//            
//            //当数组没有数据时将图片显示，反之隐藏
//            if (_detailArr.count == 0) {
//                _detailNothingImg.hidden = NO;
//            }else{
//                _detailNothingImg.hidden = YES;
//            }
//            
//            //让tableview重载数据
//            [_taskDetailTableView reloadData];
//        }else{
//            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self onCompletion:^{
//            }];
//        }
//    } failure:^(NSInteger statusCode, NSError *error) {
//        [_avi stopAnimating];
//        UIRefreshControl *ref = (UIRefreshControl *)[_taskDetailTableView viewWithTag:10004];
//        [ref endRefreshing];
//        
//        [Utilities forceLogoutCheck:statusCode fromViewController:self];
//        
//    }];
//}

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
            detailPageNum ++;
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
