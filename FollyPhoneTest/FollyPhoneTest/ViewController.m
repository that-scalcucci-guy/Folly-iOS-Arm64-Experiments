//
//  ViewController.m
//  FollyPhoneTest
//
//  Created by WS Build on 4/19/21.
//

#import "ViewController.h"
#include "FollyExecutor.h"

@interface ViewController () {
    FollyExecutor *executor;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor: [UIColor redColor]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    executor = [[FollyExecutor alloc] init];
    [executor beginTest];
}


@end
