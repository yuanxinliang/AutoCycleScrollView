//
//  YXLAutoCycleScrollView.m
//  AutoCycleScrollView
//
//  Created by 袁鑫亮 on 2017/9/17.
//  Copyright © 2017年 yxl. All rights reserved.
//

#import "YXLAutoCycleScrollView.h"

@interface YXLAutoCycleScrollView() <UIScrollViewDelegate> {
    UIScrollView *carouselScrollView;
    UIImageView *leftImageView;
    UIImageView *middleImageView;
    UIImageView *rightImageView;
    NSInteger imagesCount;
    NSInteger currentImageCount;
    UIPageControl *pageControl;
    NSTimer *timer;
}

@end

/** 滚动视图里面放置图片视图的数量 */
static NSInteger displayImageCount = 3;

@implementation YXLAutoCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor brownColor];
    }
    return self;
}

- (void)setImageNameArray:(NSArray<NSString *> *)imageNameArray {
    _imageNameArray = imageNameArray;
    imagesCount = imageNameArray.count;
    [self createCarouselScrollView];
    [self createPageControl];
    [self createTimer];
}

- (void)createCarouselScrollView {
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    carouselScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    carouselScrollView.pagingEnabled = YES; // 整页滚动效果
    carouselScrollView.bounces = YES; // 当滚动到内容边缘时，有反弹回来效果。这里如果快速滑动边缘时，会看到背景色。设置为NO,就可以解决。
    carouselScrollView.showsVerticalScrollIndicator = NO; // 关闭垂直滚动条
    carouselScrollView.showsHorizontalScrollIndicator = NO; // 关闭水平滚动条
    carouselScrollView.delegate = self;
    carouselScrollView.contentSize = CGSizeMake(width * displayImageCount, height);
    carouselScrollView.contentOffset = CGPointMake(width, 0);
    [self addSubview:carouselScrollView];
    
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    leftImageView.image = [UIImage imageNamed:_imageNameArray[imagesCount - 1]];
    middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
    middleImageView.image = [UIImage imageNamed:_imageNameArray[0]];
    rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
    rightImageView.image = [UIImage imageNamed:_imageNameArray[1]];
    [carouselScrollView addSubview:leftImageView];
    [carouselScrollView addSubview:middleImageView];
    [carouselScrollView addSubview:rightImageView];
}

- (void)createPageControl {
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, 100, 30)];
    pageControl.numberOfPages = imagesCount;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
    [self addSubview:pageControl];
}

- (void)createTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)timerAction {
    [carouselScrollView scrollRectToVisible:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height) animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    /** 第一种方式 */
    if (scrollView.contentOffset.x == 2 * (self.bounds.size.width)) { // 左滑，图片滑到最后一个的时候
        if (currentImageCount == imagesCount - 1) {
            currentImageCount = 0;
        } else {
            currentImageCount++;
        }
        [self resetImages];
    } else if (scrollView.contentOffset.x == 0) { // 右滑，图片滑到第一个的时候
        if (currentImageCount == 0) {
            currentImageCount = imagesCount - 1;
        } else {
            currentImageCount--;
        }
        [self resetImages];
    }
    
    /** 第二种方式 */
//    if (scrollView.contentOffset.x == 2 * (self.bounds.size.width)) { // 左滑，图片滑到最后一个的时候
//        currentImageCount++;
//        [self resetImages];
//    } else if (scrollView.contentOffset.x == 0) { // 右滑，图片滑到第一个的时候
//        currentImageCount += imagesCount;
//        currentImageCount--;
//        [self resetImages];
//    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 2 * (self.bounds.size.width)) {
        
        /** 第一种方式 */
        if (currentImageCount == imagesCount - 1) {
            currentImageCount = 0;
        } else {
            currentImageCount++;
        }
        [self resetImages];
        
        /** 第二种方式 */
//        currentImageCount++;
//        [self resetImages];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 当滚动视图开始拖动时，关闭定时器。
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 当滚动视图结束拖动时，开启定时器。2秒之后重新开始定时器
    [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2.0f]];
}

- (void)resetImages {
    
    NSInteger leftImageIndex, middleImageIndex, rightImageIndex;
    
    /**
     计算左中右三个图的下角标，这里用了两种不一样的算法，其中上下文的算法必须一致。
     */
    
    /** 第一种方式 */
    if (currentImageCount == 0) {
        leftImageIndex = (imagesCount - 1) % imagesCount;
    } else {
        leftImageIndex = (currentImageCount - 1) % imagesCount;
    }
    
    middleImageIndex = currentImageCount % imagesCount;
    
    if (currentImageCount == imagesCount - 1) {
        rightImageIndex = 0;
    } else {
        rightImageIndex = (currentImageCount + 1) % imagesCount;
    }
    
    /** 第二种方式 */
//    leftImageIndex = (currentImageCount - 1) % imagesCount;
//    middleImageIndex = currentImageCount % imagesCount;
//    rightImageIndex = (currentImageCount + 1) % imagesCount;
    
    leftImageView.image = [UIImage imageNamed:_imageNameArray[leftImageIndex]];
    middleImageView.image = [UIImage imageNamed:_imageNameArray[middleImageIndex]];
    rightImageView.image = [UIImage imageNamed:_imageNameArray[rightImageIndex]];
    
    carouselScrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    pageControl.currentPage = middleImageIndex;
    
    NSLog(@"%ld, %ld, %ld, %ld", leftImageIndex, middleImageIndex, rightImageIndex, currentImageCount);
}

- (void)dealloc {
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
}

@end
