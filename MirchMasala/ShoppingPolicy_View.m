//
//  ShoppingPolicy_View.m
//  MirchMasala
//
//  Created by Mango SW on 17/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ShoppingPolicy_View.h"
#import "cartView.h"

@interface ShoppingPolicy_View ()

@end

@implementation ShoppingPolicy_View
@synthesize NotificationCartLBL,MyWebView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        [NotificationCartLBL setHidden:NO];
        NotificationCartLBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [NotificationCartLBL setHidden:YES];
    }

    
    NotificationCartLBL.layer.masksToBounds = YES;
    NotificationCartLBL.layer.cornerRadius = 8.0;
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    [self.rootNav CheckLoginArr];
    [self.rootNav.pan_gr setEnabled:YES];
    
    MyWebView.scrollView.showsHorizontalScrollIndicator = NO;
    MyWebView.scrollView.showsVerticalScrollIndicator = NO;
    
    
    NSString * myURLString = @"http://m-masala.co.uk/shoppingpolicy";
    NSURL * url = [[NSURL alloc] initWithString:myURLString];
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:url];
    
    //assuming, the property webView ist the UIWebView you want to change
    [MyWebView loadRequest:request];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
     [KVNProgress show] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [KVNProgress dismiss] ;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
     [KVNProgress dismiss] ;
}
- (IBAction)TopBarCart_action:(id)sender
{
    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)ToggleMenu_action:(id)sender {
    [self.rootNav drawerToggle];
}

#pragma mark - photoShotSavedDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
