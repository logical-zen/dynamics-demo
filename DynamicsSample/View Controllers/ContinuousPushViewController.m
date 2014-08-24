//
//  ContinuousPushViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "ContinuousPushViewController.h"

@interface ContinuousPushViewController ()

// the dynamic animator and its push behavior
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *continuousPushBehavior;

// snap behaviors used in the reset
@property (strong, nonatomic) UISnapBehavior *largeViewSnapBehavior;
@property (strong, nonatomic) UISnapBehavior *smallViewSnapBehavior;

// the dynamic views which have the push applied
@property (strong, nonatomic) IBOutlet UIButton *largeView;
@property (strong, nonatomic) IBOutlet UIButton *smallView;

// sliders to control the push direction
@property (strong, nonatomic) IBOutlet UISlider *dxSlider;
@property (strong, nonatomic) IBOutlet UISlider *dySlider;
@property (strong, nonatomic) IBOutlet UILabel *dxLabel;
@property (strong, nonatomic) IBOutlet UILabel *dyLabel;

// switch to turn the push on/off
@property (strong, nonatomic) IBOutlet UISwitch *activeSwitch;

@end

@implementation ContinuousPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create tha animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // create the push behavior and attach it to the animator
    self.continuousPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.smallView, self.largeView]
                                                                   mode:UIPushBehaviorModeContinuous];
    [self.animator addBehavior:self.continuousPushBehavior];
    
    
    // setup snap behaviors to the dynamic view's original center positions
    self.largeViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.largeView
                                                          snapToPoint:self.largeView.center];
    
    self.smallViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.smallView
                                                          snapToPoint:self.smallView.center];
    
    // start with default values
    [self reset:nil];
}

- (IBAction)updatePushBehavior:(id)sender {
    // update the push direction based on the slider values
    self.continuousPushBehavior.pushDirection = CGVectorMake(self.dxSlider.value, self.dySlider.value);
    
    // update the slider value labels
    self.dxLabel.text = [NSString stringWithFormat:@"%.1f", self.dxSlider.value];
    self.dyLabel.text = [NSString stringWithFormat:@"%.1f", self.dySlider.value];
}

- (IBAction)togglePush:(id)sender {
    // if we're turning on a push, remove the snap behaviors
    if (self.activeSwitch.on) {
        [self.animator removeBehavior:self.smallViewSnapBehavior];
        [self.animator removeBehavior:self.largeViewSnapBehavior];
    }

    // for continous, a constant force is applied as long as active is YES
    // when active is NO, the force is no longer applied

    self.continuousPushBehavior.active = !self.continuousPushBehavior.active;
}

- (IBAction)reset:(id)sender {
    // deactivate the push behavior
    self.continuousPushBehavior.active = NO;
    self.activeSwitch.on = NO;
    
    // snap the views back to the center
    [self.animator addBehavior:self.largeViewSnapBehavior];
    [self.animator addBehavior:self.smallViewSnapBehavior];
    
    // reset to the default push direction values
    self.dxSlider.value = 0.0;
    self.dySlider.value = 0.0;
    
    // update the push direction settings
    [self updatePushBehavior:nil];
}

@end
