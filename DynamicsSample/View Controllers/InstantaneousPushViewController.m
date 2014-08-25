//
//  InstantaneousPushViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/24/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "InstantaneousPushViewController.h"

@interface InstantaneousPushViewController ()

// the dynamic animator and its push behavior
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *instantaneousPushBehavior;

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

@end

@implementation InstantaneousPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create the animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // create the push behavior and attach it to the animator
    self.instantaneousPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.smallView, self.largeView]
                                                                      mode:UIPushBehaviorModeInstantaneous];
    [self.animator addBehavior:self.instantaneousPushBehavior];
    
    // setup snap behaviors to the dynamic view's original center positions
    self.largeViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.largeView
                                                          snapToPoint:self.largeView.center];
    
    self.smallViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.smallView
                                                          snapToPoint:self.smallView.center];

    // start with default values
    [self reset:nil];
}

- (IBAction)applyPush:(id)sender {
    // in case the snap behaviors are currently applied,
    // remove them so the push will be effective
    [self.animator removeBehavior:self.smallViewSnapBehavior];
    [self.animator removeBehavior:self.largeViewSnapBehavior];
    
    // for instantaneous, a force is applied only once when active is switched ON.
    // then, active is toggled back off immediately after the force is applied
    // setting active to YES applies the force again
    
    self.instantaneousPushBehavior.active = YES;
}

- (IBAction)updatePushBehavior:(id)sender {
    // update the push direction based on the slider values
    self.instantaneousPushBehavior.pushDirection = CGVectorMake(self.dxSlider.value, self.dySlider.value);
    
    // update the slider value labels
    self.dxLabel.text = [NSString stringWithFormat:@"%.1f", self.dxSlider.value];
    self.dyLabel.text = [NSString stringWithFormat:@"%.1f", self.dySlider.value];
}

- (IBAction)reset:(id)sender {
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
