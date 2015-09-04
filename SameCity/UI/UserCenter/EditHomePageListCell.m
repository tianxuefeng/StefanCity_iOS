//
//  EditHomePageListCell.m
//  samecity
//
//  Created by zengchao on 15/4/12.
//  Copyright (c) 2015年 com.stefan. All rights reserved.
//

#import "EditHomePageListCell.h"
#import "NSString+Time.h"
#import "UIImageView+WebCache.h"

@interface EditHomePageListCell()

//flag
@property (nonatomic,retain) UIPanGestureRecognizer *panGesture;
@property (nonatomic,assign) CGFloat initialHorizontalCenter;
@property (nonatomic,assign) CGFloat initialTouchPositionX;
@property (nonatomic,retain) UIView *bottomView;
@property (nonatomic,assign) CGFloat originalCenter;
@property (nonatomic,assign) FeedCellDirection lastDirection;

@end

@implementation EditHomePageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, HOME_CELL_HEIGHT)];
        bottom.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bottom];
        
        //        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 30, 30)];
        //        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        //        iconImageView.image = ImageWithName(@"checked_btn_off");
        //        [bottom addSubview:iconImageView];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
        _panGesture.delegate = self;
        [bottom addGestureRecognizer:_panGesture];
        
        _originalCenter = kMainScreenWidth*0.5;
        _currentStatus = kFeedStatusNormal;
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        iconImageView.clipsToBounds = YES;
        //        iconImageView.image = ImageWithName(@"test_image");
        [bottom addSubview:iconImageView];
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 150, 30)];
        titleLb.textColor = COLOR_TITLE;
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.numberOfLines = 2;
        titleLb.font = [UIFont boldSystemFontOfSize:15];
        [bottom addSubview:titleLb];
        
        addressLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 130, 30)];
        addressLb.backgroundColor = [UIColor clearColor];
        addressLb.textColor = COLOR_CONTENT;
        addressLb.font = [UIFont systemFontOfSize:14];
        addressLb.numberOfLines = 2;
        [bottom addSubview:addressLb];
        
        priceLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-80, 5, 80, 35)];
        priceLb.textColor = [UIColor orangeColor];
        priceLb.backgroundColor = [UIColor clearColor];
        priceLb.font = [UIFont systemFontOfSize:14];
        priceLb.textAlignment = NSTextAlignmentRight;
        [bottom addSubview:priceLb];
        
        dateLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-130, 40, 120, 30)];
        dateLb.backgroundColor = [UIColor clearColor];
        dateLb.textColor = COLOR_CONTENT;
        dateLb.font = [UIFont systemFontOfSize:13];
        dateLb.textAlignment = NSTextAlignmentRight;
        [bottom addSubview:dateLb];
        
        //        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 1)];
        //        line.image = ImageWithName(@"div_line");
        //        [self.contentView addSubview:line];
    }
    return self;
}

-(void)layoutBottomView{
    if(!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, HOME_CELL_HEIGHT)];
        _bottomView.backgroundColor = COLOR_BG;
        [self.contentView insertSubview:_bottomView atIndex:0];
        
        //        shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        shareBtn.tag = 200;
        //        shareBtn.exclusiveTouch = YES;
        //        shareBtn.translatesAutoresizingMaskIntoConstraints = NO;
        //        //        shareBtn.frame = CGRectMake(kMainScreenWidth*0.5+10, 0, 50, self.bounds.size.height);
        //        [shareBtn setImage:ImageWithName(@"down_share_icon") forState:UIControlStateNormal];
        //        [_bottomView addSubview:shareBtn];
        //        [shareBtn addTarget:self action:@selector(fuctionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        updateBtn.tag = 201;
//        updateBtn.exclusiveTouch = YES;
//        //        updateBtn.translatesAutoresizingMaskIntoConstraints = NO;
//        updateBtn.frame = CGRectMake(kMainScreenWidth*0.5, 0, 80, self.bounds.size.height);
//        //        [updateBtn setImage:ImageWithName(@"down_collect_icon") forState:UIControlStateNormal];
//        
//        updateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [updateBtn setImage:ImageWithName(@"edit_button") forState:UIControlStateNormal];
//        [updateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [updateBtn setTitle:NSLocalizedString(btn_edit, nil) forState:UIControlStateNormal];
//        updateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//        
//        [_bottomView addSubview:updateBtn];
//        [updateBtn addTarget:self action:@selector(fuctionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.tag = 202;
        deleteBtn.exclusiveTouch = YES;
        //        deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
        deleteBtn.frame = CGRectMake(kMainScreenWidth*0.5+80, 0, 80, self.bounds.size.height);
        //        [deleteBtn setImage:ImageWithName(@"down_delete_icon") forState:UIControlStateNormal];
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleteBtn setImage:ImageWithName(@"delete_btn_icon") forState:UIControlStateNormal];
        [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteBtn setTitle:NSLocalizedString(title_delete, nil) forState:UIControlStateNormal];
        deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [_bottomView addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(fuctionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)fuctionBtnClick:(UIButton *)sender
{
    if (sender.tag == 200) {
        
    }
    else if (sender.tag == 201) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(EditCellUpdate:)]) {
            [self.delegate EditCellUpdate:self];
        }
    }
    else if (sender.tag == 202) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(EditCellDelete:)]) {
            [self.delegate EditCellDelete:self];
        }
    }
}

- (void)dealloc
{
    RELEASE_SAFELY(iconImageView);
    RELEASE_SAFELY(titleLb);
    RELEASE_SAFELY(addressLb);
    RELEASE_SAFELY(priceLb);
    RELEASE_SAFELY(dateLb);
    RELEASE_SAFELY(_item);
    
    [super dealloc];
}

- (void)setItem:(HomePageItem *)item
{
    AUTORELEASE_SAFELY(_item);
    
    if (item) {
        _item = [item retain];
        
        titleLb.text = item.Title;
        addressLb.text = item.Description;
        priceLb.text = item.Price;
        dateLb.text = [NSString getTimeString:item.CreateDate];
        
        if ([NSString isNotEmpty:item.Images]) {
            
            NSString *image = [item.Images componentsSeparatedByString:@"|"][0];
            
            image = [image stringByReplacingOccurrencesOfString:@".png" withString:@""];
            
            NSString *urlStr = [[NSString stringWithFormat:@"http://%@/userImages/%@_thumbnail.png",HOST,image] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            __unsafe_unretained UIImageView *weakSelf = iconImageView;
            
            [iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:ImageWithName(@"test_image")  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //
                if (cacheType == SDImageCacheTypeNone) {
                    CATransition *animation = [CATransition animation];
                    animation.duration = 0.32;
                    animation.timingFunction = UIViewAnimationCurveEaseInOut;
                    animation.type = kCATransitionFade;
                    animation.removedOnCompletion = YES;
                    [[weakSelf layer] addAnimation:animation forKey:@"animation"];
                }
            }];
            
        }
        else {
            iconImageView.image = ImageWithName(@"test_image");
        }
    }
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if (state == UITableViewCellStateShowingEditControlMask) {
        
        priceLb.hidden = YES;
        dateLb.hidden = YES;
    }
    else if (state == UITableViewCellStateDefaultMask){
        
        priceLb.hidden = NO;
        dateLb.hidden = NO;
    }
}

//#define kMinimumVelocity  self.contentView.frame.size.width*1.5
#define kMinimumPan       30.0
#define kBOUNCE_DISTANCE  10.0

#pragma mark -- Ges
- (void)panGestureHandle:(UIPanGestureRecognizer *)recognizer
{
    //begin pan...
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _initialTouchPositionX = [recognizer locationInView:self].x;
        _initialHorizontalCenter = bottom.center.x;
        if(_currentStatus==kFeedStatusNormal){
            [self layoutBottomView];
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(EditCellShowMenu:)]) {
            [self.delegate EditCellShowMenu:self];
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged) { //status change
        
        CGFloat panAmount  = _initialTouchPositionX - [recognizer locationInView:self].x;
        CGFloat newCenterPosition     = _initialHorizontalCenter - panAmount;
        CGFloat centerX               = bottom.center.x;
        
        
        if(centerX>_originalCenter && _currentStatus!=kFeedStatusLeftExpanding){
            _currentStatus = kFeedStatusLeftExpanding;
            [self togglePanelWithFlag];
        }
        
        if (panAmount > 0){
            _lastDirection = FeedCellDirectionLeft;
            
            if (newCenterPosition > self.bounds.size.width + _originalCenter){
                newCenterPosition = self.bounds.size.width + _originalCenter;
            }
            else if (newCenterPosition < -_originalCenter){
                newCenterPosition = _originalCenter;
            }
        }
        else{
            _lastDirection = FeedCellDirectionRight;
            
            if (newCenterPosition >  _originalCenter){
                newCenterPosition =  _originalCenter;
            }
            else if (newCenterPosition < -_originalCenter){
                newCenterPosition = _originalCenter;
            }
        }
        
        CGPoint center = bottom.center;
        center.x = newCenterPosition;
        bottom.layer.position = center;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled){
        
        if (fabsf(bottom.center.x - _originalCenter) > kMinimumPan) {
            //
            [self _slideOutContentViewInDirection];
        }
        else {
            [self _slideInContentViewFromDirection];
        }
    }
}

- (void)togglePanelWithFlag{
    switch (_currentStatus) {
        case kFeedStatusNormal:{
            [_bottomView removeFromSuperview];
            RELEASE_SAFELY(_bottomView);
        }
        default:
            break;
    }
    
}

#pragma mark
#pragma mark - ContentView Sliding
- (void)_slideInContentViewFromDirection
{
    CGFloat bounceDistance = 0;
    
    if (bottom.center.x == _originalCenter)
        return;
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         bottom.frame = self.contentView.frame;
                     }
                     completion:^(BOOL f) {
                         _currentStatus=kFeedStatusNormal;
                         [self togglePanelWithFlag];
                     }];
}



- (void)_slideOutContentViewInDirection
{
    CGFloat newCenterX;
    CGFloat bounceDistance;
    
    newCenterX = kMainScreenWidth*0.5-160+80;
    bounceDistance = -kBOUNCE_DISTANCE;
    _currentStatus=kFeedStatusLeftExpanded;
    
    //    CGRect rect = self.contentView.frame;
    //         bottom.frame = CGRectOffset(rect, -20, 0);
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         bottom.center = CGPointMake(newCenterX, bottom.center.y);
                     }
                     completion:^(BOOL f) {
                         //                        NSLog(@"%@",NSStringFromCGRect(self.contentView.frame));
                         
                         [UIView animateWithDuration:0.1 delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              bottom.frame = CGRectOffset(bottom.frame, -bounceDistance, 0);
                                          }
                                          completion:^(BOOL f) {
                                              [UIView animateWithDuration:0.1 delay:0
                                                                  options:UIViewAnimationOptionCurveEaseIn
                                                               animations:^{
                                                                   bottom.frame = CGRectOffset(bottom.frame, bounceDistance, 0);
                                                               }
                                                               completion:NULL];
                                          }];
                     }];
}


#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _panGesture) {
        UIScrollView *superview = (UIScrollView *)self.superview;
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:superview];
        // Make it scrolling horizontally
        return ((fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO &&
                (superview.contentOffset.y == 0.0 && superview.contentOffset.x == 0.0));
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
