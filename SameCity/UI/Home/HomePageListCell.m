//
//  HomePageListCell.m
//  SameCity
//
//  Created by zengchao on 14-5-3.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "HomePageListCell.h"
#import "NSString+Time.h"
#import "UIImageView+WebCache.h"

@implementation HomePageListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
        iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        iconImageView.clipsToBounds = YES;
//        iconImageView.image = ImageWithName(@"test_image");
        [self.contentView addSubview:iconImageView];
        
        titleLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, 150, 30)];
        titleLb.textColor = COLOR_TITLE;
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.numberOfLines = 2;
        titleLb.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:titleLb];
        
        addressLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, 130, 30)];
        addressLb.backgroundColor = [UIColor clearColor];
        addressLb.textColor = COLOR_CONTENT;
        addressLb.font = [UIFont systemFontOfSize:14];
        addressLb.numberOfLines = 2;
        [self.contentView addSubview:addressLb];
        
        priceLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-10-80, 5, 80, 35)];
        priceLb.textColor = [UIColor orangeColor];
        priceLb.backgroundColor = [UIColor clearColor];
        priceLb.font = [UIFont systemFontOfSize:14];
        priceLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:priceLb];
        
        dateLb = [[UILabel alloc] initWithFrame:CGRectMake(kMainScreenWidth-130, 40, 120, 30)];
        dateLb.backgroundColor = [UIColor clearColor];
        dateLb.textColor = COLOR_CONTENT;
        dateLb.font = [UIFont systemFontOfSize:13];
        dateLb.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:dateLb];
        
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, kMainScreenWidth, 1)];
//        line.image = ImageWithName(@"div_line");
//        [self.contentView addSubview:line];
    }
    return self;
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
//        priceLb.text = item.Price;
        
//        item.Price = @"3249990876582";
        
        if (!isNull(item.Price)) {
            if (item.Price.doubleValue > 99999999) {
                
                priceLb.text = [NSString stringWithFormat:@"%0.2e",item.Price.doubleValue];
            }
            else {
                priceLb.text = item.Price;
            }
        }
        else {
            priceLb.text = nil;
        }
        
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

-(NSString *) toExponent:(double)d rms:(unsigned)n
{
    if(n==0)
    {
        return nil;
    }
    CFLocaleRef currentLocale = CFLocaleCopyCurrent();
    CFNumberFormatterRef customCurrencyFormatter = CFNumberFormatterCreate
    (NULL, currentLocale, kCFNumberFormatterCurrencyStyle);
    NSString *s_n = @"#";
    if(n > 1)
    {
        for(int j = 0; j < n; j++)
        {
            NSString *temp = s_n;
            if(j == 0)
            {
                s_n = [temp stringByAppendingString:@"."];
            }
            else
            {
                s_n = [temp stringByAppendingString:@"0"];
            }
            
        }
        
    }
    CFNumberFormatterSetFormat(customCurrencyFormatter, (CFStringRef)s_n);
    
    double i=1;
    int exponent = 0;
    while (1) {
        i = i*10;
        exponent++;
        if(d < i)
        {
            break;
        }
    }
    double n1 = d * 10 / i;
    
    CFNumberRef number1 = CFNumberCreate(NULL, kCFNumberDoubleType, &n1);
    CFStringRef string1 = CFNumberFormatterCreateStringWithNumber
    (NULL, customCurrencyFormatter, number1);
    
    NSString * result = [NSString stringWithFormat:@"%s E%d",CFStringGetCStringPtr(string1, CFStringGetSystemEncoding()),exponent];
    
    CFRelease(currentLocale);
    CFRelease(customCurrencyFormatter);
    CFRelease(number1);
    CFRelease(string1);
    
    return result;
    
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
