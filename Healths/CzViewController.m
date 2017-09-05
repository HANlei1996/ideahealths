//
//  CzViewController.m
//  练习2
//
//  Created by admin on 2017/8/31.
//  Copyright © 2017年 Education. All rights reserved.
//
#import "QZConditionFilterView.h"
#import "UIView+Extension.h"
#import "CzViewController.h"
#import "CzCollectionViewCell.h"
#import "CZModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CzViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
   
    NSArray *_selectedDataSource1Ary;
    NSArray *_selectedDataSource2Ary;
    NSArray *_selectedDataSource3Ary;
    BOOL page;
    BOOL perPage;
    QZConditionFilterView *_conditionFilterView;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property(nonatomic) BOOL delaysContentTouches;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)NSString * fId;
@end

@implementation CzViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
  [self naviConfig];
  //  [self homeRequest];
    
    self.navigationItem.title = @"发现";
    //导航条的颜色（风格颜色）
     self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]];
    //设置导航条标题颜色
    //self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  

    
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]];
     //   [self.navigationController.navigationBar setHidden:YES];
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
    // 设置初次加载显示的默认数据
    _selectedDataSource1Ary = @[@"全城"];
    _selectedDataSource2Ary = @[@"全部分类"];
    _selectedDataSource3Ary = @[@"按距离"];
    
    _conditionFilterView = [QZConditionFilterView conditionFilterViewWithFilterBlock:^(BOOL isFilter, NSArray *dataSource1Ary, NSArray *dataSource2Ary, NSArray *dataSource3Ary) {
        if (isFilter) {
            //网络加载请求 存储请求参数
            _selectedDataSource1Ary = dataSource1Ary;
            _selectedDataSource2Ary = dataSource2Ary;
            _selectedDataSource3Ary = dataSource3Ary;
        }else{
           
            _selectedDataSource1Ary = @[@"全城"];
            _selectedDataSource2Ary = @[@"全部分类"];
            _selectedDataSource3Ary = @[@"3"];
        }
        [self startRequest];
    }];
    _conditionFilterView.y += 64;
    
    _conditionFilterView.dataAry1 = @[@"全城",@"3km以内",@"2km以内",@"1km以内"];
    
    _conditionFilterView.dataAry2 = @[@"全部分类",@"动感单车",@"力量器械",@"瑜伽",@"有氧运动"];
  
    _conditionFilterView.dataAry3 = @[@"按距离",@"按人气"];
    
    
    [_conditionFilterView bindChoseArrayDataSource1:_selectedDataSource1Ary DataSource2:_selectedDataSource2Ary DataSource3:_selectedDataSource3Ary];
    
  [self.view addSubview:_conditionFilterView];
   // [self homeRequest];
    [self networkRequest];
   [self citynetwork];
 
    // Do any additional setup after loading the view.
}
- (void)startRequest
{
    
    NSString *source1 = [NSString stringWithFormat:@"%@",_selectedDataSource1Ary.firstObject];
    NSString *source2 = [NSString stringWithFormat:@"%@",_selectedDataSource2Ary.firstObject];
    NSString *source3 = [NSString stringWithFormat:@"%@",_selectedDataSource3Ary.firstObject];
    NSDictionary *dic = [_conditionFilterView keyValueDic];
    
    
    NSLog(@"\n第一个条件:%@\n  第二个条件:%@\n  第三个条件:%@\n",source1,source2,source3);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _arr.count;
    
    
}
//每组有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arr.count;
}


//每个细胞长什么样
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     CzCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
     CZModel *model = _arr[indexPath.item];
    cell.label1.text=model.name;
    cell.label2.text=model.address;
    cell.label3.text=model.distance;
    NSURL *URL=[NSURL URLWithString:model.image];
       [cell.image sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"Unknown"]];

    
    return cell;
}
/*- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
     [collectionView shouldSelectItemAtIndexPath:indexPath animated:YES];
    
 

}*/

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:
//(NSIndexPath *)indexPath{}
    
   



 
 
 -(void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{


 CzCollectionViewCell *cell = (CzCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
     self.collectionview.delaysContentTouches = false;
     [cell setBackgroundColor:[UIColor lightGrayColor]];
     
     
     
 }
 
- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
 {

 
 CzCollectionViewCell *cell = (CzCollectionViewCell*)[colView cellForItemAtIndexPath:indexPath];
 [cell setBackgroundColor:[UIColor clearColor]];
 
 }
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return self.view.frame.size.width/400;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake((self.view.frame.size.width-self.view.frame.size.width/200*3)/2,self.view.frame.size.width/2);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return self.view.frame.size.width/400;
}
- (void)naviConfig {
    //设置导航条标题文字
    self.navigationItem.title = @"发现";
    //导航条的颜色（风格颜色）
    // self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:100/255.0 blue:255/255.0 alpha:1.0]];
    //设置导航条标题颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    //设置导航条是否隐藏
    self.navigationController.navigationBar.hidden = NO;
}


 
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)homeRequest{
    [RequestAPI requestURL:@"/city/hotAndUpgradedList" withParameters:nil andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
       
        UIRefreshControl *ref = (UIRefreshControl *)[_collectionview viewWithTag:10001];
        [ref endRefreshing];
        
        
        if([responseObject[@"resultFlag"]integerValue] == 8001){
            //将数据中的result拿出来放到字典中
            NSDictionary *result = responseObject[@"result"];
            //将上一步拿到的字典中的list数组提取出来
            NSArray *list = result[@"list"];
            NSLog(@"%@",responseObject);
            //当页码为1的时候让数据先清空，再重新添加
                       //遍历list
                   }else{
            [Utilities popUpAlertViewWithMsg:@"请求发生了错误，请稍后再试" andTitle:@"提示" onView:self];
        }
    } failure:^(NSInteger statusCode, NSError *error) {
        
      
        
        [Utilities popUpAlertViewWithMsg:@"操作失败" andTitle:@"提示" onView:self];
    }];
}

*/




-(void)networkRequest{
NSString *request=@"/clubController/nearSearchClub";
   // NSDictionary *K=@{@"city":@"无锡 ",@"jing":@31.57,@"wei":@120.3,@"page":@(page),@"perPage":@(perPage),@"type":@0};
     UIActivityIndicatorView *aiv=[Utilities getCoverOnView:self.view];
    [RequestAPI requestURL:request withParameters:@{@"city":@"无锡",@"jing":@31.57,@"wei":@120.3,@"page":@1,@"perPage":@10,@"type":@0} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
      [aiv stopAnimating];
       
     UIRefreshControl *ref = (UIRefreshControl *)[_collectionview viewWithTag:10002];
       [ref endRefreshing];
        NSLog(@"%@",responseObject);
       if([responseObject[@"resultFlag"]integerValue] == 8001){
         NSDictionary *result=responseObject[@"result"];
           NSArray *models = result[@"models"];
           if (page == 1) {
               [_arr removeAllObjects];
           }
           
           for (NSDictionary *dict in models) {
               
               CZModel *Model = [[CZModel alloc] initWithDictionary:dict];
               
               [_arr addObject:Model];
               //NSLog(@"%@",Model.name);
           }
          
           
        
           [_collectionview reloadData];
           
       }else{
            NSString *errorMsg=[ErrorHandler getProperErrorString:[responseObject[@"resultFlag"]integerValue]];
            [Utilities popUpAlertViewWithMsg:errorMsg andTitle:nil onView:self];
            
       }

        
        
    } failure:^(NSInteger statusCode, NSError *error) {
        
        UIRefreshControl *ref = (UIRefreshControl *)[_conditionFilterView viewWithTag:10001];
        [ref endRefreshing];
        
        [Utilities popUpAlertViewWithMsg:@"操作失败" andTitle:@"提示" onView:self];
    }];

}


-(void)citynetwork{
    NSString *request=@"/clubController/getNearInfos";
    [RequestAPI requestURL:request withParameters:@{@"city":@"无锡"} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
       // NSLog(@"%@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];
    
}


/*-(void)net{
NSString *request=@"/homepage/choice";
    [RequestAPI requestURL:request withParameters:@{@"city":@"无锡",@"jing":@31.57,@"wei":@120.3,@"page":@1,@"perPage":@2} andHeader:nil byMethod:kGet andSerializer:kForm success:^(id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSInteger statusCode, NSError *error) {
        
    }];


}

*/
/*
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
}*/
@end
