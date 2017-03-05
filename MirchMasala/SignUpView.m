//
//  SignUpView.m
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "SignUpView.h"
#import "LoginVW.h"
#import "MirchMasala.pch"
#import "AFNetworking/AFNetworking.h"
#import "AFNetworking.h"
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
    
}

-(void)Callforregister
{
   /* "RESTAURANT": {"APIKEY":"JyxtfV8BnnvQgm5vJCtgOMfH3fJSf3JOs67xR5Y4"},
    "REQUESTPARAM":[
                    {
                        "MODULE":"action",
                        "METHOD":"authenticate",
                        "PARAMS":{
                            "EMAIL":"tareqmm@webkutir.net",
                            "PASSWORD":"20092015"*/
                            
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
 //   dic setObject:<#(nonnull id)#> forKey:<#(nonnull id<NSCopying>)#>
       
//    NSString *strUrl = [NSString stringWithFormat:@"%@v1/places",kBaseURL];
//    NSDictionary *dataDict = @{
//                               @"place[places_category_id]":strCategory,
//                               @"place[name]":strName,
//                               @"place[phone]":strPhoneNumber,
//                               @"place[email]":strEmail,
//                               @"place[location]":strAddress,
//                               @"place[description]":strDescription
//                               };
    
    [manager POST:@"" parameters:@"" success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict)
     {
        
         NSLog(@"Success");
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([error.localizedDescription isEqualToString:@"The request timed out."])
         {
            
         }
     }];
}


- (IBAction)Signin_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
