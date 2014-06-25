//
//  mainViewController.m
//  codepath-fbPaper
//
//  Created by Mario C. Delgado Jr. on 6/21/14.
//  Copyright (c) 2014 Mario C. Delgado Jr. All rights reserved.
//

#import "mainViewController.h"
#import <QuartzCore/QuartzCore.h>
float firstX;
float firstY;

@interface mainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *menuView;
@property (weak, nonatomic) IBOutlet UIImageView *headlineView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *newsView;
@property (weak, nonatomic) IBOutlet UIImageView *gradientView;
@property (weak, nonatomic) IBOutlet UIImageView *aImageView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer1;
@property(assign, nonatomic) CGPoint offset;

- (IBAction)onDrag:(UIPanGestureRecognizer *)sender;
- (IBAction)scrollDrag:(UIPanGestureRecognizer *)sender;

@end



@implementation mainViewController
float oldX;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _scrollView.contentSize = _newsView.frame.size;
    _menuView.transform =  CGAffineTransformMakeScale(0.95, 0.95);
    [self.panGestureRecognizer1 requireGestureRecognizerToFail:self.scrollView.panGestureRecognizer];
    [self startTimer];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//I think this disables the scroll gesture
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer{
    if (recognizer == self.panGestureRecognizer1 ) {
        return YES;
    }
        return NO;
}

//Pretty sure this is correct, but the pan gesture is disabled when the scroll view is scaled.
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if(otherGestureRecognizer == self.scrollView.panGestureRecognizer) {
        return YES;
    } else {
        return NO;
    }
}


- (void) startTimer {
    [NSTimer scheduledTimerWithTimeInterval:2
                                     target:self
                                   selector:@selector(tick:)
                                   userInfo:nil
                                    repeats:YES];
}


- (void) tick:(NSTimer *) timer {
    CGPoint feedCenter = _newsView.center;

    //Tried to programmatically create a new image with each time the timer runs...did not work.
    //UIImageView *aImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newcard.png"]];
    //aImageView.center = CGPointMake(-146,380);
    
    //this *should* add the imageView to the scrollView
    //[self.scrollView addSubView:aImageView];
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.newsView.center = CGPointMake((feedCenter.x +145), 127);
        _aImageView.center = CGPointMake(73, 127);
        self.scrollView.contentSize = CGSizeMake(self.newsView.frame.size.width + 144, self.newsView.frame.size.height);}
                     completion:NULL];
    
    //just running the timer once. 
    [timer invalidate];
    
}


- (IBAction)onDrag:(UIPanGestureRecognizer *)sender {
    
    CGPoint touchPosition = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:_headlineView.superview];
    CGPoint point = [_panGestureRecognizer locationInView:self.view];
    // CGPoint velocity = [_panGestureRecognizer velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.offset = CGPointMake(touchPosition.x - self.headlineView.center.x, touchPosition.y - self.headlineView.center.y);
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(point));
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.headlineView.center = CGPointMake(touchPosition.x - self.offset.x, touchPosition.y - self.offset.y);
        if (self.headlineView.frame.origin.y < 0) {CGPointMake(0, (touchPosition.y - self.offset.y)/5); }
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(point));
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(point));
    }
    
    self.headlineView.center = CGPointMake(160, touchPosition.y - self.offset.y);
    self.scrollView.center = CGPointMake(160, touchPosition.y - self.offset.y + 157);
    
    if (translation.y >0){
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1.0
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.scrollView.center = CGPointMake(160, 1068);
        self.headlineView.center = CGPointMake(160, 800);}
     
                     completion:^(BOOL finished) {
    [UIView animateWithDuration:.3
                          delay:0
                        options:0
                     animations:^{
           _gradientView.alpha = 0;
           _menuView.transform = CGAffineTransformMakeScale(1,1);}
                     completion:nil];
                     }];
    }

    else if (translation.y < 0){
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1.0
              initialSpringVelocity:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
            self.scrollView.center = CGPointMake(160, 438);
            self.headlineView.center = CGPointMake(160, 283);}
         
                         completion:^(BOOL finished) {
        [UIView animateWithDuration:.3
                              delay:0
                            options:0
                         animations:^{
                                 _gradientView.alpha = .9;
                                 _menuView.transform =  CGAffineTransformMakeScale(0.95, 0.95);}
                        completion:nil];
                         }];
    }
    
    else if (self.headlineView.frame.origin.y < 0){
        self.headlineView.center = CGPointMake(160, (touchPosition.y - self.offset.y)/100);
    }
}


- (IBAction)scrollDrag:(UIPanGestureRecognizer *)sender{
    CGPoint translation = [sender translationInView:self.view];
    //setting scrollview anchor point to bottom of screen so it scales from there.
    self.scrollView.layer.anchorPoint = CGPointMake(0, 1);
    self.scrollView.center = CGPointMake(0, 568);
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at: %@", NSStringFromCGPoint(translation));
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        //this is where dragging on the scrollview should scale it.
        self.scrollView.transform = CGAffineTransformMakeScale((1 - translation.y), (1 - translation.y));
        NSLog(@"Gesture changed: %@", NSStringFromCGPoint(translation));
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended: %@", NSStringFromCGPoint(translation));
    }

    if (translation.y < 10){
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        self.scrollView.transform = CGAffineTransformMakeScale(2.235, 2.235);
        }
                     completion:nil];
        }
    
    else if (translation.y > 0){
    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
            self.scrollView.transform = CGAffineTransformMakeScale(1,1);}
                     completion:nil];
        }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
