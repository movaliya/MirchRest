//
//  ProfileView.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@end

@implementation ProfileView
@synthesize User_TXT,Email_TXT,Street_TXT,PostCode_TXT,Mobile_TXT,Country_TXT,user_View,Email_View,Street_View,PostCode_View,Mobile_View,Country_View,update_Btn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    // Corner and Color
    
    [user_View.layer setCornerRadius:25.0f];
    user_View.layer.borderWidth = 1.0f;
    [user_View.layer setMasksToBounds:YES];
    user_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Email_View.layer setCornerRadius:25.0f];
    Email_View.layer.borderWidth = 1.0f;
    [Email_View.layer setMasksToBounds:YES];
    Email_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Street_View.layer setCornerRadius:25.0f];
    Street_View.layer.borderWidth = 1.0f;
    [Street_View.layer setMasksToBounds:YES];
    Street_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [PostCode_View.layer setCornerRadius:25.0f];
    PostCode_View.layer.borderWidth = 1.0f;
    [PostCode_View.layer setMasksToBounds:YES];
    PostCode_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Mobile_View.layer setCornerRadius:25.0f];
    Mobile_View.layer.borderWidth = 1.0f;
    [Mobile_View.layer setMasksToBounds:YES];
    Mobile_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [Country_View.layer setCornerRadius:25.0f];
    Country_View.layer.borderWidth = 1.0f;
    [Country_View.layer setMasksToBounds:YES];
    Country_View.layer.borderColor = [UIColor colorWithRed:(193/255.0) green:(193/255.0) blue:(193/255.0) alpha:1.0].CGColor;
    
    [update_Btn.layer setCornerRadius:20.0f];
    [update_Btn.layer setMasksToBounds:YES];
    
    //Disable a Usertext and EmailText
    User_TXT.enabled = NO;
    Email_TXT.enabled = NO;
    
    [self GetUserProfileData];
   
}
-(void)GetUserProfileData
{
    NSMutableDictionary *UserSaveData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    if (UserSaveData)
    {
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        
        [KVNProgress show] ;
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
        
        
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"myProfile" forKey:@"METHOD"];
        
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
            
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                
                 NSMutableDictionary *myProfileDic=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                 
                 User_TXT.text=[myProfileDic valueForKey:@"customerName"];
                 Email_TXT.text=[myProfileDic valueForKey:@"email"];
                 //Street_TXT.text=[myProfileDic valueForKey:@"street"];
                // PostCode_TXT.text=[myProfileDic valueForKey:@"postCode"];
                // Mobile_TXT.text=[myProfileDic valueForKey:@"mobile"];
                // Country_TXT.text=[myProfileDic valueForKey:@"country"];
                 
             }
             else
             {
                 [AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
             }
             
             [KVNProgress dismiss] ;
         }
         
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             NSLog(@"Fail");
             [KVNProgress dismiss] ;
         }];
        
    }
    else
    {
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
    }
    
}
- (IBAction)Menu_Toggle:(id)sender {
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Update_Action:(id)sender {
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
