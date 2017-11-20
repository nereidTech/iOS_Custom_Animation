//
//  CACollectionViewCustomSrollAnimation.m
//  Custom_Animations
//
//  Created by Stefan Miskovic on 11/19/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

#import "CACollectionViewCustomSrollAnimation.h"

@interface CACollectionViewCustomSrollAnimation()

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) CFTimeInterval lastTimerTick;
@property (assign, nonatomic) CGFloat animationPointsPerSecond;
@property (assign, nonatomic) CGPoint finalContentOffset;
@property (strong, nonatomic) NSIndexPath* indexPath;

@end

@implementation CACollectionViewCustomSrollAnimation

- (void)beginCollectionView:(UICollectionView *)collectionView scrollToIndexPath:(NSIndexPath *)indexPath withPageWidth:(CGFloat)pageWidth duration:(CGFloat)animationDuration
{
    self.collectionView = collectionView;
    self.indexPath = indexPath;
    // define nuber of points to animate, and duration of animation
    // e.g cell width = 375. 1s Animation, 5 cells -> 1875 p/s
    int totlanNumberOfPointsToAnimate = (pageWidth * ([self.indexPath item] + 1));
    int effectiveNumberOfPoints = ceil(totlanNumberOfPointsToAnimate / animationDuration);
    
    self.lastTimerTick = 0;
    
    self.animationPointsPerSecond =  effectiveNumberOfPoints;
    self.finalContentOffset = CGPointMake(pageWidth * [self.indexPath item], 0);
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    [self.displayLink setPreferredFramesPerSecond:60]; // setFrameInterval
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.collectionView.userInteractionEnabled = NO;
}

- (void)endCollectionViewScrollAnimation
{
    [self.displayLink invalidate];
    self.displayLink = nil;
    
    // setup ECStrechableHeaderView. Must call this method manually because "-scrollViewDidEnd-" delegate methods
    // are not called when performing animation programmatically
    self.collectionView.userInteractionEnabled = YES;
    [self.delegate endCollectionViewScrollAnimationForIndexPath:self.indexPath];
}

- (void)displayLinkTick:(CADisplayLink *)sender
{
    if (self.lastTimerTick == 0) {
        self.lastTimerTick = self.displayLink.timestamp;
    }
    CFTimeInterval currentTimestamp = self.displayLink.timestamp;
    CGPoint newContentOffset = self.collectionView.contentOffset;
    newContentOffset.x += self.animationPointsPerSecond * (currentTimestamp - self.lastTimerTick);
    self.collectionView.contentOffset = newContentOffset;
    
    self.lastTimerTick = currentTimestamp;
    
    if (newContentOffset.x >= self.finalContentOffset.x)
        [self endCollectionViewScrollAnimation];
}

@end
