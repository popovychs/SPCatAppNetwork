//
//  SPNetwork.h
//  SPCatAppNetwork
//
//  Created by popovychs on 31.10.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const randomCatURLString = @"http://random.cat/meow";
static NSString * const logRequestURLString = @"https://api.parse.com/1/classes/Logs";

@interface SPNetwork : NSObject

@property (weak, nonatomic) NSURL * catSorce;
@property (weak, nonatomic) NSURL * catUrlImageToShowOnImageView;

- (NSString*) receiveCatUrlAndInCaseOfError: (UIViewController*) alertViewController;
- (NSData*) receiveCatImage: (NSString*) urlString;
- (void) logUpload: (NSString*) urlString;

@end