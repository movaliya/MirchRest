//
//  successMessageVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "successMessageVW.h"

@interface successMessageVW ()

@end

@implementation successMessageVW
@synthesize viewManageBtn,continueShoppingBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [viewManageBtn.layer setCornerRadius:20.0f];
    [viewManageBtn.layer setMasksToBounds:YES];
    
    [continueShoppingBtn.layer setCornerRadius:20.0f];
    [continueShoppingBtn.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view.
}
- (IBAction)ViewOrMange_Action:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)continueShopping_Action:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
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
