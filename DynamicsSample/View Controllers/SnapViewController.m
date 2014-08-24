//
//  SnapViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()

// the dynamic animator and its snap behavior
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *snapBehavior;

// the dynamic view the snap will be applied to
@property (strong, nonatomic) IBOutlet UIButton *dynamicView;

// slider to control the damping value of the snap
@property (strong, nonatomic) IBOutlet UISlider *dampingSlider;
@property (strong, nonatomic) IBOutlet UILabel *dampingLabel;

@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create tha animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

- (IBAction)snapToSender:(UIButton *)sender {
    // remove any previously added snap behaviors so there are no conflicts
    [self.animator removeAllBehaviors];

    // create the new snap behavior to snap to the center of the tapped view
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.dynamicView
                                                 snapToPoint:sender.center];

    // apply the damping as set
    self.snapBehavior.damping = self.dampingSlider.value;
    
    // add the snap behavior to the animator to apply it
    [self.animator addBehavior:self.snapBehavior];
}

- (IBAction)setDamping:(id)sender {
    // adjust the snap's damping according to the slider
    self.snapBehavior.damping = self.dampingSlider.value;
    
    // update the label
    self.dampingLabel.text = [NSString stringWithFormat:@"damping: %.2f", self.dampingSlider.value];
}


@end
