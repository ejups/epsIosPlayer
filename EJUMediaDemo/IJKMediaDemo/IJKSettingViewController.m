//
//  IJKSettingViewController.m
//  IJKMediaDemo
//
//  Created by Mark Wang on 20/03/2017.
//  Copyright © 2017 bilibili. All rights reserved.
//

#import "IJKSettingViewController.h"
#import "IJKAppDelegate.h"

@interface IJKSettingViewController ()

@end

@implementation IJKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.softDecode setOn:AppDelegateEntity.bSoftwareDecoder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSwitchDecoder:(UISwitch *)sender {
    
    AppDelegateEntity.bSoftwareDecoder = sender.isOn;
    
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
