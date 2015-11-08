//
//  ViewController.m
//  SPCatAppNetwork
//
//  Created by popovychs on 30.10.15.
//  Copyright © 2015 popovychs. All rights reserved.
//

#import "ViewController.h"
#import "SPNetwork.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView * catImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView * actIndicator;
@property (weak, nonatomic) IBOutlet UILabel * urlLabel;
@property (weak, nonatomic) IBOutlet UIButton * catButton;
@property (weak, nonatomic) IBOutlet UIButton * logButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.catButton.layer.cornerRadius = 5;
    self.logButton.layer.cornerRadius = 5;
    self.urlLabel.layer.cornerRadius = 5;
    self.catImageView.layer.cornerRadius = 5;
}

- (IBAction)catButtonImageView:(UIButton *)sender
{
    _actIndicator.alpha = 1;
    [_actIndicator startAnimating];
    _catButton.enabled = NO;
    self.catImageView.image = [UIImage imageNamed:@"loader3.gif"];
    [_catImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    SPNetwork * catClient = [SPNetwork new];
    
    catClient.catSorce = [NSURL URLWithString:randomCatURLString];
    
    NSString * catImageString = [catClient receiveCatUrlAndInCaseOfError:self];
    catClient.catSorce = [NSURL URLWithString:catImageString];
    _urlLabel.text = catImageString;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [catClient receiveCatImage:catImageString];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.catImageView.image = [UIImage imageWithData:data];
            });
        }
        else
        {
            self.catImageView.image = [UIImage imageNamed:@"No_image_available.jpg"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _actIndicator.alpha = 0;
            _catButton.enabled = YES;
            [_actIndicator stopAnimating];
        });
    });
}

- (IBAction)logButtonAction:(UIButton *)sender {
    SPNetwork * webClient = [SPNetwork new];
    if (![_urlLabel.text isEqualToString:@"URL"])
    {
        [webClient logUpload:_urlLabel.text];
    }
}

@end