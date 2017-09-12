//
//  HomeViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "ClubDetailViewController.h"
#import "CardTableViewCell.h"
#import "SecuritiesDetailViewController.h"
@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger homePageNum;
    NSInteger isLastPage;
    NSInteger cityPageNum;
}
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong,nonatomic)NSMutableArray *Arr1;
@property (strong, nonatomic) NSMutableArray *Arr2;
@property (strong, nonatomic) NSMutableArray *experience;

@property (strong, nonatomic) UIActivityIndicatorView *avi;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _experience = [NSMutableArray new];
    
    _Arr2 = [NSMutableArray new];
    cityPageNum = 1;
    [self naviConfig];
    
    [self initializeData];
    //刷新指示器
    [self setRefreshControl];
    UIImage *img1=[UIImage imageNamed:@"AdDefault"];
    
    UIImage *img3=[UIImage imageNamed:@"app_logo"];
    _logoImage.animationImages=[NSArray arrayWithObjects:img1,img3, nil];
    _logoImage.animationDuration=5;
    [_logoImage startAnimating];//动画开始
    //    //创建一个刷新指示器放在tableview中
    //    UIRefreshControl *ref = [UIRefreshControl new];
    //    [ref addTarget:self action:@selector(refreshRequest) forControlEvents:UIControlEventValueChanged];
    //    ref.tag = 10001;
    
    //    [_homeTableView addSubview:ref];
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
//创建刷新指示器的方法
- (void)setRefreshControl{
    //已获取列表的刷新指示器
    UIRefreshControl *Ref = [UIRefreshControl new];
    [Ref addTarget:self action:@selector(Ref) forControlEvents:UIControlEventValueChanged];
    Ref.tag = 10001;
    [_homeTableView addSubview:Ref];
}
- (void)Ref{
    homePageNum = 1;
    [self cityRequest];
}
- (void)InitializeData{
    _avi = [Utilities getCoverOnView:self.view];
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
- (void)initializeData{
    _avi = [Utilities getCoverOnView:self.view];
    [self refreshRequest];
}
//下拉刷新
- (void)refreshRequest{
    homePageNum = 1;
    [self cityRequest];
    
    
    
}
- (void)cityRequest{
    [RequestAPI requestURL:@"/homepage/choice" withParameters:@{@"city":@"无锡",@"jing":@31.57,@"wei":@120.3,@"page":@(homePageNum),@"perPage":@14} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        [_avi stopAnimating];
        UIRefreshControl *ref = (UIRefreshControl *)[_homeTableView viewWithTag:10001];
        [ref endRefreshing];
        
        NSLog(@"responseObject: %@", responseObject);
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
        cell.distanceLabel.text = homeModel.distance;
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
        NSLog(@"experience = %@",experience[@"name"]);
        NSLog(@"experience = %@",experience[@"categoryName"]);
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
