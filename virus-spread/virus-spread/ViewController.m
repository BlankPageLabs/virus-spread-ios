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
#import "Error-objc.h"


@interface ViewController ()

@property(nonatomic, retain) IBOutlet ASOBounceButtonView *bounceButtons;

@property(nonatomic, retain) IBOutlet UIButton *gotVirusButton;

@property(nonatomic, assign) BOOL buttonsExpanded;

@property(nonatomic, retain) IBOutlet UIImageView *statusImage;

@property(nonatomic, retain) IBOutlet UIButton *curedButton;

@property(nonatomic, retain) IBOutlet UILabel *cureStatusLabel;

@property(nonatomic, retain) IBOutlet UIButton *settingsButton;

@property(nonatomic, retain) IBOutlet UILabel *possibleInfectionLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.buttonsExpanded = NO;
    [self.bounceButtons collapseWithAnimationStyle:ASOAnimationStyleExpand];
    self.bounceButtons.bouncingDistance = @0.3;
    self.bounceButtons.speed = @0.2;

    [self.gotVirusButton setImage:[UIImage imageNamed:NSLocalizedString(@"btn-ill", @"btn-ill")
                                             inBundle:[NSBundle bundleForClass:[self class]]
                        compatibleWithTraitCollection:nil]
                         forState:UIControlStateNormal];

    [self.curedButton setImage:[UIImage imageNamed:NSLocalizedString(@"btn-cured", @"btn-cured")
                                          inBundle:[NSBundle bundleForClass:[self class]]
                     compatibleWithTraitCollection:nil]
                      forState:UIControlStateNormal];

    [self updateButtons];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unwindToRoot:(UIStoryboardSegue *)segue {
    [self updateButtons];
}

- (IBAction)unwindOneStep:(UIStoryboardSegue *)segue {
    [self updateButtons];
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

    [self performSegueWithIdentifier:@"progress" sender:self];
    [[NSOperationQueue new] addOperationWithBlock:^{
        [[AppDelegate instance].infectionManager infectWith:[VirusInfo infoWithType:sender.virusId]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self updateButtons];
            [self.presentedViewController performSegueWithIdentifier:@"return" sender:self];
        }];
    }];
}

- (void)updateButtons {
    if ([AppDelegate instance].infectionManager.infected) {
        static NSDictionary *virusToImage = nil;
        static dispatch_once_t once;

        dispatch_once(&once, ^{
            virusToImage = @{
                    @"ccold": @"germ2",
                    @"flu": @"bacteria",
                    @"measles": @"germ1",
            };
        });

        self.statusImage.image = [[UIImage imageNamed:virusToImage[[AppDelegate instance].infectionManager.virus.type]
                                             inBundle:[NSBundle bundleForClass:[self class]]
                        compatibleWithTraitCollection:nil] resizableImageWithCapInsets:UIEdgeInsetsZero
                                                                          resizingMode:UIImageResizingModeStretch];
        self.curedButton.hidden = NO;
        self.gotVirusButton.hidden = YES;
        self.possibleInfectionLabel.hidden = YES;
    } else {
        self.gotVirusButton.hidden = NO;
        self.curedButton.hidden = YES;
        self.statusImage.image = [UIImage imageNamed:@"sun"
                                            inBundle:[NSBundle bundleForClass:[self class]]
                       compatibleWithTraitCollection:nil];

        self.possibleInfectionLabel.hidden = ![AppDelegate instance].infectionManager.possibleInfection;
    }
    [self.view setNeedsUpdateConstraints];
}

- (IBAction)cured:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"getCured", @"Выздороветь")
                                                                             message:NSLocalizedString(@"curedConfirm", @"Вы точно здоровы?")
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"curedConfirmYes", @"Да, сопли прошли")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [[AppDelegate instance].infectionManager cure];
                                                          [self updateButtons];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"curedConfirmNo", @"Не, только что чихнул")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                      }]];
    [self presentViewController:alertController
                       animated:YES
                     completion:^{
                     }];

}

@end
