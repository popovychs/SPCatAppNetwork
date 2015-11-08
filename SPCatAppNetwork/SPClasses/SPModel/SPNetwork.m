//
//  SPNetwork.m
//  SPCatAppNetwork
//
//  Created by popovychs on 31.10.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "SPNetwork.h"

@implementation SPNetwork

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.catSorce = [NSURL URLWithString:randomCatURLString];
    }
    return self;
}

- (NSString*) receiveCatUrlAndInCaseOfError: (UIViewController*) alertViewController
{
    NSMutableURLRequest * catRequest = [NSMutableURLRequest new];
    [catRequest setHTTPMethod:@"GET"];
    [catRequest setURL:self.catSorce];
    
    NSError * catError = nil;
    NSHTTPURLResponse * catResponse = nil;
    
    NSData * catData = [NSURLConnection sendSynchronousRequest:catRequest
                                                  returningResponse:&catResponse
                                                              error:&catError];
    if ([catResponse statusCode] !=200) {
        NSString * alertMessage = [NSString stringWithFormat:@"Loading data error %li",[catResponse statusCode]];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                        message:alertMessage
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            nil;
                                                        }];
        [alert addAction:action];
        [alertViewController presentViewController:alert animated:YES completion:^{
            nil;
        }];
        
        return nil;
    }
    
    NSDictionary * catDictionary = [NSJSONSerialization JSONObjectWithData:catData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&catError];
    
    return [NSString stringWithString:catDictionary[@"file"]];
}

- (NSData*) receiveCatImage: (NSString*) urlString
{
    NSData * catData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlString]];
    if (!catData) {
        return nil;
    }
    return catData;
}

- (void) logUpload: (NSString*) urlString
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    configuration.HTTPAdditionalHeaders = @{@"X-Parse-Application-Id" : @"wGuKBRFghDRy3K2JuL9IkCwBssmQ2K0qR2noI5Qx",
                                            @"X-Parse-REST-API-Key" : @"qlAavQKuwnUeCl2L1FcCPUfMMkHJPL75cJjDLsQb",
                                            @"Content-type" : @"JSON"
                                            };
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    
    NSString *postBodyStringJsonRequest = [NSString stringWithFormat:@"{\"userID\":\"Popovychs Stanislav\",\"catURL\":\"%@\"}",urlString];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:logRequestURLString]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[postBodyStringJsonRequest length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postBodyStringJsonRequest dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {  NSLog(@"response = %@",response); }];
    
    [postDataTask resume];
}

@end