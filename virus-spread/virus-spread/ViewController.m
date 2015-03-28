//
//  ViewController.m
//  virus-spread
//
//  Created by Илья Михальцов on 27.3.15.
//  Copyright (c) 2015 morpheby. All rights reserved.
//

@import UIKit;
@import ASOAnimatedButton;

#import <ASOAnimatedButton/ASOBounceButtonView.h>
#import "ViewController.h"
#import "VirusButton.h"
#import "virus_spread-Swift.h"
#import "InfectionManager.h"
#import "VirusInfo.h"


@interface ViewController ()

@property(nonatomic, retain) IBOutlet ASOBounceButtonView *bounceButtons;

@property(nonatomic, retain) IBOutlet UIButton *gotVirusButton;

@property(nonatomic, assign) BOOL buttonsExpanded;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonsExpanded = NO;
    [self.bounceButtons collapseWithAnimationStyle:ASOAnimationStyleExpand];
    self.bounceButtons.bouncingDistance = @0.3;
    self.bounceButtons.speed = @0.2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)segue {

}

- (void)viewDidLayoutSubviews {
    [self.bounceButtons setAnimationStartFromHere:self.gotVirusButton.frame];
}

- (IBAction)gotVirus:(id)sender {
    if (self.buttonsExpanded) {
        [self.bounceButtons collapseWithAnimationStyle:ASOAnimationStyleRiseProgressively];
    } else {
        [self.bounceButtons expandWithAnimationStyle:ASOAnimationStyleRiseProgressively];
    }
    self.buttonsExpanded = !self.buttonsExpanded;
}

- (IBAction)virusSelected:(VirusButton *)sender {
    [self.bounceButtons collapseWithAnimationStyle:ASOAnimationStyleRiseConcurrently];
    self.buttonsExpanded = NO;

    [[NSOperationQueue new] addOperationWithBlock:^{
        [[AppDelegate instance].infectionManager infectWith:[VirusInfo infoWithType:sender.virusId]];
    }];
}

@end
