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
@synthesize Username_TXT,Email_TXT,Password_TXT,Confir_TXT;
- (void)viewDidLoad {
    [self Callforregister];
    [super viewDidLoad];
    [_UsernamView.layer setCornerRadius:25.0f];
    _UsernamView.layer.borderWidth = 1.0f;
    [_UsernamView.layer setMasksToBounds:YES];
    
    [_emailView.layer setCornerRadius:25.0f];
    _emailView.layer.borderWidth = 1.0f;
    [_emailView.layer setMasksToBounds:YES];
    
    [_passwordView.layer setCornerRadius:25.0f];
    _passwordView.layer.borderWidth = 1.0f;
    [_passwordView.layer setMasksToBounds:YES];
    
    [_confrimPasswordView.layer setCornerRadius:25.0f];
    _confrimPasswordView.layer.borderWidth = 1.0f;
    [_confrimPasswordView.layer setMasksToBounds:YES];
    
    //Disable Color and Image
    _emailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    _passwordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _PasswordImageVw.image=[UIImage imageNamed:@"DisablePassword"];
    _UsernamView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _UserImageVW.image=[UIImage imageNamed:@"DisableUser"];
    _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    _ConfrimPassImageVW.image=[UIImage imageNamed:@"DisablePassword"];
    
    [_SignUpBtn.layer setCornerRadius:20.0f];
    [_SignUpBtn.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SignUp_action:(id)sender

{
    if ([Username_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter username" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([Password_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else if ([Confir_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter confrim password" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![Confir_TXT.text isEqualToString:Password_TXT.text])
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

-(void)Secondmothod
{
    NSString *strdata =[NSString stringWithFormat:@"\n\"RESTAURANT\":{\"APIKEY\":\"%@\"},\n\"REQUESTPARAM\":[\n{\n\"MODULE\":\"%@\",\n\"METHOD\":\"%@\",\n\"PARAMS\":{\n\"EMAIL\":\"%@\",\n\"PASSWORD\":\"%@\"\n}\n}\n]",KAPIKEY,@"action",@"authenticate",@"tareqmm@webkutir.net",@"20092015"];
    // strdata = [strdata stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kBaseURL parameters:strdata success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict)
     {
         NSLog(@"===%@",responseDict);
         NSLog(@"Success");
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([error.localizedDescription isEqualToString:@"The request timed out."])
         {
             
         }
     }];
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
    
    
    NSString *EmailSre;
     NSString *PassStr;
    
    NSString *strdata =[NSString stringWithFormat:@"\n\"RESTAURANT\":{\"APIKEY\":\"%@\"},\n\"REQUESTPARAM\":[\n{\n\"MODULE\":\"%@\",\n\"METHOD\":\"%@\",\n\"PARAMS\":{\n\"EMAIL\":\"%@\",\n\"PASSWORD\":\"%@\"\n}\n}\n]",KAPIKEY,@"action",@"authenticate",EmailSre,PassStr];
    // strdata = [strdata stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    
    // manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:kBaseURL parameters:strdata success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict)
    {
    NSLog(@"===%@",responseDict);
    NSLog(@"Success");
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
    if ([error.localizedDescription isEqualToString:@"The request timed out."])
    {
    
    }
    }];
    
    /*
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //RESTAURANT DIC
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"JyxtfV8BnnvQgm5vJCtgOMfH3fJSf3JOs67xR5Y4" forKey:@"APIKEY"];
    NSArray *arr=[dic mutableCopy];
    
    NSMutableDictionary *RESTAURANTDic=[[NSMutableDictionary alloc]init];
    [RESTAURANTDic setObject:arr forKey:@"RESTAURANT"];
    
    
    
    // PARAM DIC
     NSMutableDictionary *emaildic=[[NSMutableDictionary alloc]init];
    [emaildic setObject:@"tareqmm@webkutir.net" forKey:@"EMAIL"];
    [emaildic setObject:@"20092015" forKey:@"PASSWORD"];
   
   
    
    NSMutableDictionary *moduledic=[[NSMutableDictionary alloc]init];
    [moduledic setObject:@"action" forKey:@"MODULE"];
    [moduledic setObject:@"authenticate" forKey:@"METHOD"];
    [moduledic setObject:emaildic forKey:@"PARAMS"];
    
    NSArray *param=[moduledic mutableCopy];
    NSMutableDictionary *Paramdic=[[NSMutableDictionary alloc]init];
    [Paramdic setObject:param forKey:@"REQUESTPARAM"];
    
    NSMutableArray *Mainarr=[[NSMutableArray alloc]init];
    [Mainarr addObject:RESTAURANTDic];
    [Mainarr addObject:Paramdic];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:Mainarr options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
    
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:kBaseURL parameters:jsonString success:^(AFHTTPRequestOperation *operation, NSDictionary *responseDict)
     {
        
         NSLog(@"Success");
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         if ([error.localizedDescription isEqualToString:@"The request timed out."])
         {
            
         }
     }];*/
}


- (IBAction)Signin_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _emailView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _EmailImageVW.image=[UIImage imageNamed:@"Emailicon"];
    }
    else if (textField == Password_TXT)
    {
        Password_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _passwordView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _PasswordImageVw.image=[UIImage imageNamed:@"PasswordIcon"];
    }
    else if (textField == Username_TXT)
    {
        Username_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _UsernamView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _UserImageVW.image=[UIImage imageNamed:@"UserIcon"];
    }
    else if (textField == Confir_TXT)
    {
        Confir_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        _ConfrimPassImageVW.image=[UIImage imageNamed:@"PasswordIcon"];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    
    
    
    if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _emailView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _EmailImageVW.image=[UIImage imageNamed:@"DisableEmail"];
    }
    else if (textField == Password_TXT)
    {
        Password_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _passwordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _PasswordImageVw.image=[UIImage imageNamed:@"DisablePassword"];
    }
    else if (textField == Username_TXT)
    {
        Username_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _UsernamView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _UserImageVW.image=[UIImage imageNamed:@"DisableUser"];
    }
    else if (textField == Confir_TXT)
    {
        Confir_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        _confrimPasswordView.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        _ConfrimPassImageVW.image=[UIImage imageNamed:@"DisablePassword"];
    }
    return YES;
}
@end
