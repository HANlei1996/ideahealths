//
//  FeedbackViewController.m
//  Health
//
//  Created by admin on 2017/9/1.
//  Copyright © 2017年 com. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *feedBackBarBtn;
- (IBAction)feedBackAction:(UIBarButtonItem *)sender;
@property (strong, nonatomic) UIActivityIndicatorView *avi;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
//网络请求
- (void)request{
    [_avi stopAnimating];
    NSDictionary *para = @{@"memberId":@2,@"message":_feedBackTextView.text};
    [RequestAPI requestURL:@"/clubFeedback" withParameters:para andHeader:nil byMethod:kPost andSerializer:kJson success:^(id responseObject) {
        [_avi stopAnimating];
        NSLog(@"feedback: %@", responseObject);
        if ([responseObject[@"resultFlag"] integerValue] == 8001) {
            //创建一个通知
            NSNotification *note = [NSNotification notificationWithName:@"refreshHome" object:nil userInfo:nil];
            //发送这个通知
            [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:note waitUntilDone:YES];
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

- (IBAction)feedBackAction:(UIBarButtonItem *)sender {
    [self request];
}
@end
