//
//  AttachmentViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "AttachmentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface AttachmentViewController ()

// the dynamic animator and its attachment behaviors
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *viewsAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *panAttachment;

// snap behaviors for reset
@property (strong, nonatomic) UISnapBehavior *blueViewSnapBehavior;
@property (strong, nonatomic) UISnapBehavior *orangeViewSnapBehavior;

// dynamic views used in the attachments
@property (strong, nonatomic) IBOutlet UIView *blueView;
@property (strong, nonatomic) IBOutlet UIView *orangeView;

// steppers to control the attachment settings
@property (strong, nonatomic) IBOutlet UIStepper *lengthStepper;
@property (strong, nonatomic) IBOutlet UIStepper *frequencyStepper;
@property (strong, nonatomic) IBOutlet UIStepper *dampingStepper;

// labels to indicate the current attachment settings
@property (strong, nonatomic) IBOutlet UILabel *lengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (strong, nonatomic) IBOutlet UILabel *dampingLabel;

// a line layer to draw the attachment line between the views
@property (strong, nonatomic) CAShapeLayer *lineLayer;

@end

@implementation AttachmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create tha animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    
    // create an attachment between the two views and add it to the animator
    self.viewsAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.blueView
                                                       attachedToItem:self.orangeView];
    [self.animator addBehavior:self.viewsAttachment];

    
    // create a layer for drawing the line between the view's center points
    self.lineLayer = [[CAShapeLayer alloc] init];
    [self.view.layer addSublayer:self.lineLayer];

    
    // set actions on the attachments so a line will draw between the views with every update
    __weak AttachmentViewController *weakSelf = self;
    self.viewsAttachment.action = ^{
        [weakSelf drawAttachmentLine];
    };
    self.panAttachment.action = ^{
        [weakSelf drawAttachmentLine];
    };
    
    // setup snap behaviors to the dynamic views' original center positions
    self.blueViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.blueView
                                                         snapToPoint:self.blueView.center];

    self.orangeViewSnapBehavior = [[UISnapBehavior alloc] initWithItem:self.orangeView
                                                           snapToPoint:self.orangeView.center];
    
    // start with the default values
    [self reset:nil];
}


- (IBAction)reset:(id)sender {
    // temporarily remove the attachment while we reset
    [self.animator removeBehavior:self.viewsAttachment];
    
    // initialize the stepper values
    self.lengthStepper.value = 150;
    self.frequencyStepper.value = 0.0;
    self.dampingStepper.value = 0.0;
    
    [self updateAttachmentValues:nil];
    
    // snap the views back to their origin
    [self.animator addBehavior:self.blueViewSnapBehavior];
    [self.animator addBehavior:self.orangeViewSnapBehavior];
    
    // add the attachment back after the reset is done
    [self.animator addBehavior:self.viewsAttachment];
}

- (IBAction) handlePanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    UIView* draggedView = gesture.view;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        // the pan has started, remove the snap behaviors so the views can move around
        [self.animator removeBehavior:self.blueViewSnapBehavior];
        [self.animator removeBehavior:self.orangeViewSnapBehavior];
        
        // create an attachment starting at the initial touch point
        self.panAttachment = [[UIAttachmentBehavior alloc] initWithItem:draggedView
                                                       attachedToAnchor:touchPoint];
        [self.animator addBehavior:self.panAttachment];
        
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        // update the anchor point as the pan is moving around
        self.panAttachment.anchorPoint = touchPoint;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        // remove the attachment behavior as soon as the pan ends
        [self.animator removeBehavior:self.panAttachment];
    }
}


- (IBAction)updateAttachmentValues:(id)sender {
    // update the attachment settings based on the stepper values
    self.viewsAttachment.length = self.lengthStepper.value;
    self.viewsAttachment.frequency = self.frequencyStepper.value;
    self.viewsAttachment.damping = self.dampingStepper.value;
    
    // update the labels based on the stepper values
    self.lengthLabel.text = [NSString stringWithFormat:@"%.1f", self.viewsAttachment.length];
    self.frequencyLabel.text = [NSString stringWithFormat:@"%.1f", self.viewsAttachment.frequency];
    self.dampingLabel.text = [NSString stringWithFormat:@"%.1f", self.viewsAttachment.damping];
}

- (void) drawAttachmentLine {
    // create a path joining the center of both views
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:self.blueView.center];
    [bezierPath addLineToPoint:self.orangeView.center];
    [bezierPath closePath];
    
    // assign the correct appearance to the line and display it
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.lineWidth = 5.0;
    self.lineLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    self.lineLayer.path = bezierPath.CGPath;
    [self.lineLayer setNeedsDisplay];
    
}

@end
