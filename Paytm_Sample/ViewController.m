//
//  ViewController.m
//  Paytm_Sample
//
//  Created by HealthOne on 15/03/16.
//  Copyright © 2016 akash. All rights reserved.
//

#import "ViewController.h"
#import "PaymentsSDK.h"

@interface ViewController () <PGTransactionDelegate>{
    PGTransactionViewController *txnController;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //You will get default PGMerchantConfiguration object. By setting the below properties of object you can make a fully configured merchant object.
    PGMerchantConfiguration *merchant = [PGMerchantConfiguration defaultConfiguration];
    merchant.checksumGenerationURL = @"http://paytmbackend.herokuapp.com/generate_checksum";//@"https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp";
    merchant.checksumValidationURL = @"http://paytmbackend.herokuapp.com/verify_checksum";//@"https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp";
    
    // Set the client SSL certificate path. Certificate.p12 is the certificate which you received from Paytm during the registration process. Set the password if the certificate is protected by a password.
    merchant.clientSSLCertPath = NULL; //[[NSBundle mainBundle]pathForResource:@"Certificate" ofType:@"p12"];
    merchant.clientSSLCertPassword = NULL; //@"password";
    
    //configure the PGMerchantConfiguration object specific to your requirements
    merchant.merchantID = @"Health09314010514003";
    merchant.website = @"healthonewap";
    merchant.industryID = @"Retail";
    merchant.channelID = @"WAP"; //provided by PG
}

- (IBAction)btnpaymentClicked:(UIButton *)sender {
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[@"MID"] = @"Health09314010514003";
    orderDict[@"CHANNEL_ID"] = @"WAP";
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail";
    orderDict[@"WEBSITE"] = @"healthonewap";
    //Order configuration in the order object
    orderDict[@"TXN_AMOUNT"] = @"1";
    orderDict[@"ORDER_ID"] = @12324;//@"1232456";
    orderDict[@"REQUEST_TYPE"] = @"DEFAULT";
    orderDict[@"CUST_ID"] = @"1234567890";
    orderDict[@"MOBILE_NO"] = @"9540178557";
    orderDict[@"EMAIL"] = @"akash.rastogi@seedoc.co";
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeStaging;
    txnController.merchant = mc;
    txnController.delegate = self;
    [self presentViewController:txnController animated:YES completion:^{
        
    }];
}

#pragma mark - PGTransactionDelegate
//Called when transaction has completed. response dictionary will be having details about transaction.
- (void)didSucceedTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response{
    [txnController dismissViewControllerAnimated:YES completion:NULL];
}

//Called when transaction fails with any reason. Response dictionary will be having details about the failed transaction.
- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response{
    [txnController dismissViewControllerAnimated:YES completion:NULL];
}

//Called when a transaction is cancelled by the user. Response dictionary will be having details about the cancelled transaction.
- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response{
    [txnController dismissViewControllerAnimated:YES completion:NULL];
}

//Called when Checksum HASH generation completes either by PG Server or Merchant Server.
- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response{
    
}

@end
