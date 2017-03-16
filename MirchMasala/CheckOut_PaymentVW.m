//
//  CheckOut_PaymentVW.m
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "CheckOut_PaymentVW.h"
#import "successMessageVW.h"
#import "cartView.h"
#import "cartView.h"


@interface CheckOut_PaymentVW ()

@end

@implementation CheckOut_PaymentVW
@synthesize CartNotification_LBL,ProcessOrder_Btn,Discount_LBL,OrderAmount_LBL,Collection_CartBTN;
@synthesize Discount,OrderAmount;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    if (CoustmerID!=nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
    }
    if (KmyappDelegate.MainCartArr.count>0 && CoustmerID!=nil)
    {
        [CartNotification_LBL setHidden:NO];
        CartNotification_LBL.text=[NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    }
    else
    {
        [CartNotification_LBL setHidden:YES];
    }
    CartNotification_LBL.layer.masksToBounds = YES;
    CartNotification_LBL.layer.cornerRadius = 8.0;
    
    [ProcessOrder_Btn.layer setCornerRadius:20.0f];
    [ProcessOrder_Btn.layer setMasksToBounds:YES];
    
    float disct=[Discount floatValue];
    Discount_LBL.text=[NSString stringWithFormat:@"£%.02f",disct];;
    OrderAmount_LBL.text=[NSString stringWithFormat:@"£%@",OrderAmount];
    
}
- (IBAction)Radio_Coll_Delvry_Action:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            if([self.Collection_Radio_Btn isSelected]==YES)
            {
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
            }
            else{
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
            if([self.Delivery_Radio_Btn isSelected]==YES)
            {
                 [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                
            }
            else{
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            if([self.Collection_CartBTN isSelected]==YES)
            {
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                
            }
            else{
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
}

- (IBAction)CreditCard_action:(id)sender
{
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
    
}

- (IBAction)PayOnCollection_action:(id)sender
{
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
}

- (IBAction)ProcessOrder_Action:(id)sender
{
    successMessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"successMessageVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)TopBarCartBtn_action:(id)sender
{
    cartView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"cartView"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)BackBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
