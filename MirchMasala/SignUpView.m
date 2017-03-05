//
//  SignUpView.m
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SignUpView.h"
#import "LoginVW.h"
#import "AppDelegate.h"


@interface SignUpView ()
@property AppDelegate *appDelegate;

@end

@implementation SignUpView
@synthesize userNameTxt,emailTxt,passwordTxt,confrimpasswordTxt;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [_UsernamView.layer setCornerRadius:25.0f];
    _UsernamView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _UsernamView.layer.borderWidth = 1.0f;
    [_UsernamView.layer setMasksToBounds:YES];
    
    [_emailView.layer setCornerRadius:25.0f];
    _emailView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _emailView.layer.borderWidth = 1.0f;
    [_emailView.layer setMasksToBounds:YES];
    
    [_passwordView.layer setCornerRadius:25.0f];
    _passwordView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _passwordView.layer.borderWidth = 1.0f;
    [_passwordView.layer setMasksToBounds:YES];
    
    [_confrimPasswordView.layer setCornerRadius:25.0f];
    _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    _confrimPasswordView.layer.borderWidth = 1.0f;
    [_confrimPasswordView.layer setMasksToBounds:YES];
    
    [_SignUpBtn.layer setCornerRadius:20.0f];
    [_SignUpBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SignUp_action:(id)sender
{
    if ([userNameTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([emailTxt.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([passwordTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else if ([confrimpasswordTxt.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter confrim password" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:emailTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![confrimpasswordTxt.text isEqualToString:passwordTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Confrim password do not match." delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self CallNormalSignup];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}
-(void)CallNormalSignup
{
    
}
- (IBAction)SignIn_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backBtn_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

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
