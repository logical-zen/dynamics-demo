//
//  PushViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "PushViewController.h"

@interface PushViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *instantaneousPushBehavior;
@property (strong, nonatomic) UIPushBehavior *continuousPushBehavior;

@property (strong, nonatomic) UISnapBehavior *largeViewSnapBehavior;
@property (strong, nonatomic) UISnapBehavior *smallViewSnapBehavior;

@property (strong, nonatomic) IBOutlet UIButton *largeView;
@property (strong, nonatomic) IBOutlet UIButton *smallView;

@property (strong, nonatomic) IBOutlet UISlider *dxSlider;
@property (strong, nonatomic) IBOutlet UISlider *dySlider;
@property (strong, nonatomic) IBOutlet UILabel *dxLabel;
@property (strong, nonatomic) IBOutlet UILabel *dyLabel;

@property (strong, nonatomic) IBOutlet UISwitch *continuousSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *activeSwitch;

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create tha animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // create the push behaviors and attach them to the animator
    self.continuousPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.smallView, self.largeView]
                                                                   mode:UIPushBehaviorModeContinuous];

    self.instantaneousPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.smallView, self.largeView]
                                                                      mode:UIPushBehaviorModeInstantaneous];

    
    // setup snap behaviors to the dynamic view's original center positions
    self.largeViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.largeView
                                                          snapToPoint:self.largeView.center];
    
    self.smallViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.smallView
                                                          snapToPoint:self.smallView.center];
    [self reset:nil];
}

- (IBAction)updatePushBehavior:(id)sender {
    // update the push direction based on the slider values
    [self pushBehaviorForCurrentMode].pushDirection = CGVectorMake(self.dxSlider.value, self.dySlider.value);
    
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

    // for instantaneous, setting active to YES applies the instant force
    // then resets the push behavior back to inactive immediately following
    // so toggling this for instantaneous is basically like applying a new push each time
    
    [self pushBehaviorForCurrentMode].active = ![self pushBehaviorForCurrentMode].active;
}

- (IBAction)switchMode:(id)sender {
    // switch the mode (continuous/instantaneous) and update the push behavior
    [self.animator removeAllBehaviors];
    [self.animator addBehavior:[self pushBehaviorForCurrentMode]];
    [self updatePushBehavior:nil];
}

- (UIPushBehavior *) pushBehaviorForCurrentMode {
    if (self.continuousSwitch.on) {
        return self.continuousPushBehavior;
    }
    else {
        return self.instantaneousPushBehavior;
    }
}

- (IBAction)reset:(id)sender {
    // remove behaviors from the animator so we can reset all the values
    [self.animator removeAllBehaviors];
    
    // deactivate the push behaviors
    self.instantaneousPushBehavior.active = NO;
    self.continuousPushBehavior.active = NO;
    
    // snap the views back to the center
    [self.animator addBehavior:self.largeViewSnapBehavior];
    [self.animator addBehavior:self.smallViewSnapBehavior];
    
    // reset to the default push direction values
    self.dxSlider.value = 0.0;
    self.dySlider.value = 0.0;
    
    // reset the mode
    self.continuousSwitch.on = YES;
    self.activeSwitch.on = NO;
    
    // add the behaviors back to the animator
    [self.animator addBehavior:[self pushBehaviorForCurrentMode]];
    
    // update the push direction settings
    [self updatePushBehavior:nil];
}

@end
