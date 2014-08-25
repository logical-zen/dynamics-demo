//
//  CollisionViewController.m
//  DynamicsSample
//
//  Created by Andria Jensen on 8/14/14.
//  Copyright (c) 2014 Logical Zen, LLC. All rights reserved.
//

#import "CollisionViewController.h"

@interface CollisionViewController ()

// the dynamic animator and its behaviors
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

// boundary views to denote the top and bottom collision boundaries
@property (strong, nonatomic) IBOutlet UIView *topBoundaryView;
@property (strong, nonatomic) IBOutlet UIView *bottomBoundaryView;

@end

@implementation CollisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create the animator and have it use the entire view for animations
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // create a collision behavior and set it to use the reference view as its boundary box
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    // add boundary lines, using the top/bottom edges of the dark gray subviews
    [self addCollisionBoundaryForTopEdgeOfView:self.topBoundaryView
                                withIdentifier:@"topViewTopBoundary"];
    
    [self addCollisionBoundaryForTopEdgeOfView:self.bottomBoundaryView
                                withIdentifier:@"bottomViewTopBoundary"];

    
    /*
    [self addCollisionBoundaryForBottomEdgeOfView:self.topBoundaryView
                                   withIdentifier:@"topViewBottomBoundary"];

    [self addCollisionBoundaryForBottomEdgeOfView:self.bottomBoundaryView
                                   withIdentifier:@"bottomViewBottomBoundary"];
    */
    
    // add the collision behavior to the animator
    [self.animator addBehavior:self.collisionBehavior];

    
    // create an item behavior to apply to each view we create
    // set the elasticy to its max of 1.0 to make the collisions extra crazy
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
    self.itemBehavior.elasticity = 1.0;
    [self.animator addBehavior:self.itemBehavior];

    
    // create an instantaneous push behavior
    // we'll apply this to each view as it's created to keep things moving around
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[]
                                                         mode:UIPushBehaviorModeInstantaneous];
    
    self.pushBehavior.pushDirection = CGVectorMake(0.5, 0.5);
    [self.animator addBehavior:self.pushBehavior];

}

- (void) addCollisionBoundaryForTopEdgeOfView:(UIView *)view
                               withIdentifier:(NSString *)identifier {
    
    CGPoint origin = view.frame.origin;
    CGPoint topRightPoint = CGPointMake(origin.x + view.frame.size.width, origin.y);
    
    // use the top left and top right points of the view to create a boundary
    // which would appear to be the view's top edge
    [self.collisionBehavior addBoundaryWithIdentifier:identifier
                                            fromPoint:origin
                                              toPoint:topRightPoint];
    
}

- (void) addCollisionBoundaryForBottomEdgeOfView:(UIView *)view
                                  withIdentifier:(NSString *)identifier {
    
    CGPoint origin = view.frame.origin;
    CGPoint bottomLeftPoint = CGPointMake(origin.x, origin.y + view.frame.size.height);
    CGPoint bottomRightPoint = CGPointMake(origin.x + view.frame.size.width, bottomLeftPoint.y);
    
    // use the bottom left and bottom right points of the view to create a boundary
    // which would appear to be the view's bottom edge
    [self.collisionBehavior addBoundaryWithIdentifier:identifier
                                            fromPoint:bottomLeftPoint
                                              toPoint:bottomRightPoint];
    
}

- (IBAction)addAView:(id)sender {
    // create a 30x30 red view and add it to our main view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.center = self.view.center;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    // make the items elastic and give them some speed in a different direction to change things up
    [self.itemBehavior addItem:view];
    [self.itemBehavior addLinearVelocity:CGPointMake(-0.5, -0.5) forItem:view];
    
    // give all the views a little push to keep things moving
    [self.pushBehavior addItem:view];
    self.pushBehavior.active = YES;
    
    // add the new view to the collision behavior
    [self.collisionBehavior addItem:view];
}

- (IBAction)reset:(id)sender {
    // remove all the collision views
    [self.collisionBehavior.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
}

@end
