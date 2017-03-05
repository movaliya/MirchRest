//
//  LoginVW.m
//  MirchMasala
//
//  Created by Mango SW on 04/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "LoginVW.h"
#import <QuartzCore/QuartzCore.h>
#import "SignUpView.h"

@interface LoginVW ()

@end

@implementation LoginVW

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    
    [_EmailView.layer setCornerRadius:25.0f];
    _EmailView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _EmailView.layer.borderWidth = 1.0f;
    [_EmailView.layer setMasksToBounds:YES];
    
    [_PasswordView.layer setCornerRadius:25.0f];
    _PasswordView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _PasswordView.layer.borderWidth = 1.0f;
    [_PasswordView.layer setMasksToBounds:YES];
    
    [_SignInBtn.layer setCornerRadius:20.0f];
    [_SignInBtn.layer setMasksToBounds:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SignIn_action:(id)sender {
}
- (IBAction)SignUp_action:(id)sender
{
    SignUpView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpView"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)ForgotPass_action:(id)sender {
}
- (IBAction)BackBtn_action:(id)sender {
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
