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

@import Stripe;

@interface CheckOut_PaymentVW ()<STPAddCardViewControllerDelegate,STPPaymentContextDelegate>
{
    STPPaymentContext *paymentContext;
}
@property (nonatomic) STPAPIClient *apiClient;
@property (strong, nonatomic) STPPaymentContext *paymentContext;
@end

@implementation CheckOut_PaymentVW
@synthesize CartNotification_LBL,ProcessOrder_Btn,Discount_LBL,OrderAmount_LBL,Collection_CartBTN;
@synthesize Discount,OrderAmount,deliveryCharge;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self AcceptedOrderTypes];
    OrderType=@"Collection";
    PAYMENTTYPE=@"";
    
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

-(void)PlaceOrderServiceCall
{
    [KVNProgress show] ;
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    //NSLog(@"===%@",KmyappDelegate.MainCartArr);
    
    NSDictionary *UserSaveData=[[NSUserDefaults standardUserDefaults]objectForKey:@"LoginUserDic"];
    
    NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredient"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
       
        
       // ProdArr=[[NSMutableArray alloc]init];
        NSString *ProdidSr=[[NSString alloc]init];
        if ([Array isKindOfClass:[NSArray class]])
        {
            //NSLog(@"Array===%@",Array);
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                else
                {
                    [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
            }
            if (Withindgarr.count>0)
            {
                [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
            }
            if (Withoutindgarr.count>0)
            {
                [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
            }
        }
        
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Productid"] forKey:@"ID"];
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"quatity"] forKey:@"QUANTITY"];
        [ProdArr addObject:inddic];
    }
    
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
    [dictInner setObject:OrderType forKey:@"ORDERTYPE"];
    [dictInner setObject:@"0" forKey:@"USEALTERNATEADDRESS"];
    [dictInner setObject:PAYMENTTYPE forKey:@"PAYMENTTYPE"];
    [dictInner setObject:PAIDAMOUNT forKey:@"PAIDAMOUNT"];
    [dictInner setObject:ProdArr forKey:@"PRODUCTS"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"putitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"webOrder" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSLog(@"dictREQUESTPARAM===%@",dictREQUESTPARAM);
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:kBaseURL parameters:json success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject)
     {
         [KVNProgress dismiss];
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
            NSString *result=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"result"] objectForKey:@"webOrder"];
             NSLog(@"place order result=%@",result);
              [AppDelegate showErrorMessageWithTitle:@"" message:result delegate:nil];
             
             [KmyappDelegate.MainCartArr removeAllObjects];
             KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
             [[NSUserDefaults standardUserDefaults] setObject:KmyappDelegate.MainCartArr forKey:CoustmerID];
             KmyappDelegate.MainCartArr=[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:CoustmerID]];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
}
-(void)AcceptedOrderTypes
{
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"getAcceptedOrderTypes" forKey:@"METHOD"];
    
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
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
              NSString *getAcceptedOrderTypes=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"result"] objectForKey:@"getAcceptedOrderTypes"];
             
              NSLog(@"getAcceptedOrderTypes==%@",getAcceptedOrderTypes);
         }
         
         
     }
          failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"Fail");
         [KVNProgress dismiss] ;
     }];
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
                OrderType=@"Collection";
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
                 OrderType=@"Delivery";
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
                OrderType=@"Collection & Delivery";
                [self.Delivery_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_Radio_Btn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.Collection_CartBTN setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
    NSLog(@"OrderType=%@",OrderType);
}

- (IBAction)CreditCard_action:(id)sender
{
    PAIDAMOUNT=OrderAmount;
    PAYMENTTYPE=@"stripe";
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
}

- (IBAction)PayOnCollection_action:(id)sender
{
    PAIDAMOUNT=@"0";
    PAYMENTTYPE=@"pay_on_collection";
    [self.CreditCard_Radio_Brn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
    [self.PayOnCollection_Radio setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
}

- (IBAction)ProcessOrder_Action:(id)sender
{
    
    if ([PAYMENTTYPE isEqualToString:@""])
    {
         [AppDelegate showErrorMessageWithTitle:@"" message:@"Please select Payment Type." delegate:nil];
    }
    else if ([OrderType isEqualToString:@"Delivery"])
    {
        if (([deliveryCharge isEqualToString:@"-1"] ||[deliveryCharge isEqualToString:@"-2"])) {
             [AppDelegate showErrorMessageWithTitle:@"Address Problem" message:@"We are not able to calculate Distance from our Restaurant to your Provided Address for some reason. Please check your provided address again." delegate:nil];
        }
        else
        {
             [self PlaceOrderServiceCall];
        }
       
    }
    else if ([PAYMENTTYPE isEqualToString:@"stripe"])
    {
         NSLog(@"PAYMENTTYPE=%@",PAYMENTTYPE);
        
        STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
        addCardViewController.delegate = self;
        // STPAddCardViewController must be shown inside a UINavigationController.
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        [self PlaceOrderServiceCall];
    }
    
   // successMessageVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"successMessageVW"];
   // [self.navigationController pushViewController:vcr animated:YES];
}

#pragma mark STPAddCardViewControllerDelegate

- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion {
    //[self submitTokenToBackend:token completion:^(NSError *error) {
      //  if (error) {
         //   completion(error);
       // } else {
          //  [self dismissViewControllerAnimated:YES completion:^{
              //  [self showReceiptPage];
           // }];
      //  }
   // }];
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
