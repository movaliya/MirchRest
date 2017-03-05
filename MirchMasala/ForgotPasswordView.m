//
//  ForgotPasswordView.m
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ForgotPasswordView.h"
#import "AppDelegate.h"


@interface ForgotPasswordView ()
@property AppDelegate *appDelegate;

@end

@implementation ForgotPasswordView
@synthesize EmailTxt;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_EmailView.layer setCornerRadius:25.0f];
    _EmailView.layer.borderWidth = 1.0f;
    _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _emailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    [_EmailView.layer setMasksToBounds:YES];
    
    [_submitBtn.layer setCornerRadius:20.0f];
    [_submitBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SumbitBtn_action:(id)sender
{
    if ([EmailTxt.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:EmailTxt.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self callFroResetPassword];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)callFroResetPassword
{
    
}
- (IBAction)backBtn_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == EmailTxt)
    {
        EmailTxt.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _emailImageVW.image=[UIImage imageNamed:@"Emailicon"];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    if (textField == EmailTxt)
    {
        EmailTxt.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _EmailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _emailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    }
    return YES;
}

@end
