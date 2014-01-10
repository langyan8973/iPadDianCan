//
//  LoginViewController.m
//  iPadDianCan
//
//  Created by 刘岩 on 13-8-19.
//  Copyright (c) 2013年 ztb. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        loginView=[[LoginView alloc] initWithFrame:CGRectMake(0, -0, 768, 960)];
        loginView.loginDelegate = self;
        [self.view addSubview:loginView];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSUserDefaults *ud=[NSUserDefaults standardUserDefaults];
    NSNumber *ridNum=[ud valueForKey:@"rid"];
    if (ridNum!=nil) {
        MainViewController *mainController=[[MainViewController alloc] init];
        [self.navigationController pushViewController:mainController animated:YES];
        [mainController release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoginDelegate
-(void)closeLoginView{
    MainViewController *mainController=[[MainViewController alloc] init];
    [self.navigationController pushViewController:mainController animated:YES];
    [mainController release];
}

-(void)dealloc{
    [loginView release];
    [super dealloc];
}

@end
