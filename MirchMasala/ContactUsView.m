//
//  ContactUsView.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ContactUsView.h"
#import "AppDelegate.h"

@interface ContactUsView ()
@property AppDelegate *appDelegate;

@end

@implementation ContactUsView
@synthesize UserName_TXT,Email_TXT,Message_TXT,Message_Icon,Message_View,email_View,Email_Icon,user_View,User_Icon,Submit_Btn;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    [email_View.layer setCornerRadius:25.0f];
    email_View.layer.borderWidth = 1.0f;
    [email_View.layer setMasksToBounds:YES];
    email_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    Email_Icon.image=[UIImage imageNamed:@"DisableEmail"];
    
    [user_View.layer setCornerRadius:25.0f];
    user_View.layer.borderWidth = 1.0f;
    [user_View.layer setMasksToBounds:YES];
    user_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    User_Icon.image=[UIImage imageNamed:@"DisableUser"];

    
    [Message_View.layer setCornerRadius:25.0f];
    Message_View.layer.borderWidth = 1.0f;
    [Message_View.layer setMasksToBounds:YES];
    Message_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
    Message_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    Message_Icon.image=[UIImage imageNamed:@"MessageIconDisable"];
    
    [Submit_Btn.layer setCornerRadius:20.0f];
    [Submit_Btn.layer setMasksToBounds:YES];
}
- (IBAction)Submit_action:(id)sender
{
    if ([Email_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else if ([UserName_TXT.text isEqualToString:@""])
    {
         [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter User Name" delegate:nil];
    }
    else if ([Message_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Message" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
                [self CallContactUsMethod];
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)CallContactUsMethod
{
    [KVNProgress show] ;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:UserName_TXT.text forKey:@"FULLNAME"];
    [dictInner setObject:Email_TXT.text forKey:@"EMAIL"];
    [dictInner setObject:Message_TXT.text forKey:@"MESSAGE"];
    
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"contactUs" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         NSLog(@"responseObject==%@",responseObject);
         
          NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"contactUs"] objectForKey:@"SUCCESS"];
          if ([SUCCESS boolValue] ==YES)
          {
              UserName_TXT.text=@"";
              Email_TXT.text=@"";
              Message_TXT.text=@"";
         
              [AppDelegate showErrorMessageWithTitle:@"" message:@"Thank You for Contact Us. Your Message send Successfuly." delegate:nil];
             
          }
          else
          {
              [AppDelegate showErrorMessageWithTitle:@"" message:@"Message send Failed." delegate:nil];
          }
         
         [KVNProgress dismiss] ;
     }
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Menu_Toggle:(id)sender {
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}
#pragma mark - TextField Delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == self.UserName_TXT)
    {
        UserName_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        user_View.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        User_Icon.image=[UIImage imageNamed:@"UserIcon"];
       
    }
    else if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
        email_View.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
        Email_Icon.image=[UIImage imageNamed:@"Emailicon"];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldEndEditing");
    if (textField == UserName_TXT)
    {
        UserName_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        user_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        User_Icon.image=[UIImage imageNamed:@"DisableUser"];
    }
    else if (textField == Email_TXT)
    {
        Email_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
        email_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
        Email_Icon.image=[UIImage imageNamed:@"DisableEmail"];
    }
    Message_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
    Message_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    Message_Icon.image=[UIImage imageNamed:@"MessageIconDisable"];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    Message_TXT.textColor=[UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0];
    Message_View.layer.borderColor = [UIColor colorWithRed:(247/255.0) green:(96/255.0) blue:(41/255.0) alpha:1.0].CGColor;
    Message_Icon.image=[UIImage imageNamed:@"MessageIconEnable"];
}


-(void)textViewDidEndEditing:(UITextView *)textView
{
    Message_TXT.textColor=[UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0];
    Message_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    Message_Icon.image=[UIImage imageNamed:@"MessageIconDisable"];
}
@end