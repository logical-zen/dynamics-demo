//
//  GravityViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()

// the dynamic animator and its gravity behavior
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;

// snap behaviors used in the reset
@property (strong, nonatomic) UISnapBehavior *largeViewSnapBehavior;
@property (strong, nonatomic) UISnapBehavior *smallViewSnapBehavior;

// the dynamic views which have gravity applied
@property (strong, nonatomic) IBOutlet UIButton *largeView;
@property (strong, nonatomic) IBOutlet UIButton *smallView;

// sliders to adjust the direction of the gravitational force
@property (strong, nonatomic) IBOutlet UISlider *dxSlider;
@property (strong, nonatomic) IBOutlet UISlider *dySlider;
@property (strong, nonatomic) IBOutlet UILabel *dxLabel;
@property (strong, nonatomic) IBOutlet UILabel *dyLabel;

// switch to turn gravity on/off
@property (strong, nonatomic) IBOutlet UISwitch *gravitySwitch;

@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // create the animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    // create the gravity behavior and give it two views to use
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.largeView, self.smallView]];

    // setup snap behaviors to the dynamic view's original center positions
    self.largeViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.largeView
                                                          snapToPoint:self.largeView.center];
    
    self.smallViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.smallView
                                                          snapToPoint:self.smallView.center];

    // start with all default values
    [self reset:nil];
}

- (IBAction)toggleGravity:(id)sender {
    // add gravity if it's being turned on, otherwise remove it
    if (self.gravitySwitch.on) {
        [self.animator addBehavior:self.gravityBehavior];
    }
    else {
        [self.animator removeBehavior:self.gravityBehavior];
    }
    
    [self updateGravityBehavior:nil];
}

- (IBAction)updateGravityBehavior:(id)sender {
    // if we're turning on gravity, remove the snap behaviors
    if (self.gravitySwitch.on) {
        [self.animator removeBehavior:self.smallViewSnapBehavior];
        [self.animator removeBehavior:self.largeViewSnapBehavior];
    }
    
    // update the gravity direction based on the slider values
    self.gravityBehavior.gravityDirection = CGVectorMake(self.dxSlider.value, self.dySlider.value);

    // update the slider value labels
    self.dxLabel.text = [NSString stringWithFormat:@"%.1f", self.dxSlider.value];
    self.dyLabel.text = [NSString stringWithFormat:@"%.1f", self.dySlider.value];
}

- (IBAction)reset:(id)sender {
    // snap the views back to the center
    [self.animator addBehavior:self.largeViewSnapBehavior];
    [self.animator addBehavior:self.smallViewSnapBehavior];

    // turn gravity off
    self.gravitySwitch.on = NO;
    [self.animator removeBehavior:self.gravityBehavior];

    // reset to the default gravity direction values
    self.dxSlider.value = 0.0;
    self.dySlider.value = 0.0;
    
    [self updateGravityBehavior:nil];
}


@end
