//
//  GravityViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "GravityViewController.h"

@interface GravityViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;

@property (strong, nonatomic) IBOutlet UIButton *dynamicView;
@property (strong, nonatomic) IBOutlet UISlider *dxSlider;
@property (strong, nonatomic) IBOutlet UISlider *dySlider;

@property (strong, nonatomic) IBOutlet UILabel *dxLabel;
@property (strong, nonatomic) IBOutlet UILabel *dyLabel;

@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // create tha animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    // create the gravity behavior and attach it to the animator
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicView]];
}

- (IBAction)updateGravityBehavior:(id)sender {
    // update the gravity direction based on the slider values
    self.gravityBehavior.gravityDirection = CGVectorMake(self.dxSlider.value, self.dySlider.value);

    // update the slider value labels
    self.dxLabel.text = [NSString stringWithFormat:@"%.1f", self.dxSlider.value];
    self.dyLabel.text = [NSString stringWithFormat:@"%.1f", self.dySlider.value];
}

- (IBAction)reset:(id)sender {
    // reset the view to the center
    self.dynamicView.frame = CGRectMake(110, 234, 100, 100);

    // remove gravity
    [self.animator removeBehavior:self.gravityBehavior];

    // reset to the default gravity direction values
    self.dxSlider.value = 0.0;
    self.dySlider.value = 0.0;
    
    [self updateGravityBehavior:nil];
}

- (IBAction)toggleGravity:(id)sender {
    // remove gravity if it's there, otherwise add it
    if (self.gravityBehavior.dynamicAnimator) {
        [self.animator removeBehavior:self.gravityBehavior];
    }
    else {
        [self.animator addBehavior:self.gravityBehavior];
    }
}

@end
