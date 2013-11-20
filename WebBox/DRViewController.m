//
//  DRViewController.m
//  WebBox
//
//  Created by Danny Ricciotti on 11/20/13.
//  Copyright (c) 2013 Danny Ricciotti. All rights reserved.
//

#import "DRViewController.h"
#import "DRWebBoxView.h"

@interface DRViewController ()
@property (nonatomic, strong) DRWebBoxView *webbox;
@end

@implementation DRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webbox = [[DRWebBoxView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.view.bounds, UIEdgeInsetsMake(0, 0, 0, 0))];
    [self.view addSubview:self.webbox];
    
    
    NSURLRequest *req = [DRWebBoxView requestFromURL:[NSURL URLWithString:@"http://www.google.com"]];
    [self.webbox loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
