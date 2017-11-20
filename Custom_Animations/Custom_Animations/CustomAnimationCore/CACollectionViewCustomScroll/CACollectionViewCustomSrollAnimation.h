//
//  CACollectionViewCustomSrollAnimation.h
//  Custom_Animations
//
//  Created by Stefan Miskovic on 11/19/17.
//  Copyright © 2017 Stefan Miskovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CACollectionViewCustomSrollAnimationDelegate

- (void)endCollectionViewScrollAnimationForIndexPath:(NSIndexPath *)indexPath;

@end

@interface CACollectionViewCustomSrollAnimation : NSObject

@property id<CACollectionViewCustomSrollAnimationDelegate> delegate;

- (void)beginCollectionView:(UICollectionView *)collectionView scrollToIndexPath:(NSIndexPath *)indexPath withPageWidth:(CGFloat)pageWidth duration:(CGFloat)animationDuration;

@end
