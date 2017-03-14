//
//  AboutUS.m
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "AboutUS.h"

@interface AboutUS ()

@end

@implementation AboutUS
@synthesize WebViewAbout;
@synthesize CartNotification_LBL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0)
    {
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 10.0;
    
    
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    
    NSString* htmlString= @"<html><body><h4><center>Welcome to Mirch Masala Indian Takeaway</center></h4><br><span>Situated in Pensnett, the Mirch Masala Indian Takeaway offers mouth-watering Indian cuisine.</span></br><br>The Mirch Masala Indian Takeaway is renowned throughout the Pensnett and Dudley area for its divine style and presentation of traditional Indian cuisine, this is achieved by paying special attention to every fine detail and only using the very finest ingredients.</br><br>If you looking for the most exquisite Indian food in the Pensnett and Dudley area, then take a look and order from our easy to use on screen menu, you will see that we offer something for every member of your family. Our on-line menu is fully customisable, so why give it a try! If your favourite meal is not on our menu just call 01384 78007 to ask us, and our chef will happily try and prepare it especially for you.</br><br>Our high quality Website is provided by tiffintom.com, please be sure to visit our website on a regular basis to see our latest menu updates.\n We deliver on all online orders to following postcods DY1 DY2 DY3 DY5 DY4 DY6 DY8 B69 plus more also Pensenett Dudley and Brierley hill</br></body></html>";
    [WebViewAbout setBackgroundColor:[UIColor clearColor]];
    [WebViewAbout setOpaque:NO];
    [WebViewAbout loadHTMLString:htmlString baseURL:nil];
   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
