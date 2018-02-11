//
//  LLLogView.m
//  lhy_test
//
//  Created by WangZhaomeng on 2018/1/29.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLLogView.h"
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define IS_iPhone      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX        (IS_iPhone && SCREEN_HEIGHT==812)
#define OFFSET_Y       (iPhoneX ? 88:64)
#define TABBAR_HEIGHT  (iPhoneX ? 83:49)

@implementation UITextView (LLLogView)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

@end

@interface LHYMessageView : UIView<UITextViewDelegate> {
    BOOL _color;
    UITextView *_textView;
    UITextRange *_textRange;
    NSAttributedString *_spaceAttStr;
}
@property (nonatomic, assign) BOOL scrollEnabled;

@end

@implementation LHYMessageView

+ (instancetype)messageView {
    static LHYMessageView *logView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logView = [[LHYMessageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return logView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.scrollEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        
        CGRect rect = self.bounds;
        rect.origin.x += 5;
        rect.origin.y += 64;
        rect.size.width -= 10;
        rect.size.height -= 84;
        _textView = [[UITextView alloc] initWithFrame:rect];
        _textView.editable = NO;
        _textView.bounces = NO;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 2;
        _textView.delegate = self;
        [self addSubview:_textView];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(12, 20, 44, 44);
        closeBtn.tag = 0;
        closeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        closeBtn.backgroundColor = [UIColor grayColor];
        closeBtn.layer.masksToBounds = YES;
        closeBtn.layer.cornerRadius = 22;
        [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        clearBtn.frame = CGRectMake(self.bounds.size.width-56, 20, 44, 44);
        clearBtn.tag = 1;
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        clearBtn.backgroundColor = [UIColor grayColor];
        clearBtn.layer.masksToBounds = YES;
        clearBtn.layer.cornerRadius = 22;
        [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [clearBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:clearBtn];
        
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.frame = CGRectMake(CGRectGetMaxX(closeBtn.frame),
                                  _textView.frame.origin.y-44,
                                  CGRectGetMinX(clearBtn.frame)-CGRectGetMaxX(closeBtn.frame),
                                  44);
        topBtn.tag = 2;
        [topBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:topBtn];
        
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake(0, self.bounds.size.height-20, self.bounds.size.width, 20);
        bottomBtn.tag = 3;
        [bottomBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bottomBtn];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        self.scrollEnabled = YES;
        [self removeFromSuperview];
    }
    else if (btn.tag == 1) {
        self.scrollEnabled = YES;
        _textView.text = @"";
        [UIPasteboard generalPasteboard].string = @"";
    }
    else if (btn.tag == 2) {
        self.scrollEnabled = NO;
        [self scrollsToTopAnimated:YES];
    }
    else {
        self.scrollEnabled = YES;
        [self scrollsToBottomAnimated:YES];
    }
    _textRange = nil;
    _textView.selectedTextRange = nil;
}

- (void)scrollsToTopAnimated:(BOOL)animated {
    [_textView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollsToBottomAnimated:(BOOL)animated {
    if (self.scrollEnabled) {
        CGFloat offset = _textView.contentSize.height - _textView.bounds.size.height;
        if (offset > 0) {
            [_textView setContentOffset:CGPointMake(0, offset) animated:animated];
        }
    }
    _textView.selectedTextRange = _textRange;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.scrollEnabled = NO;
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if (textView.selectedTextRange.isEmpty == NO) {
        _textRange = textView.selectedTextRange;
        [UIPasteboard generalPasteboard].string = [textView textInRange:_textRange];
    }
}

- (void)outputString:(NSString *)string {
    
    UIColor *color = (_color ? [UIColor blueColor] : [UIColor blackColor]);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    [attStr addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:[UIFont systemFontOfSize:8]}
                    range:NSMakeRange(0, attStr.length)];
    
    NSMutableAttributedString *muAttStr = [_textView.attributedText mutableCopy];
    if (muAttStr.length) {
        if (_spaceAttStr == nil) {
            _spaceAttStr = [[NSAttributedString alloc] initWithString:@"\n\n"];
        }
        [muAttStr appendAttributedString:_spaceAttStr];
        [muAttStr appendAttributedString:[attStr copy]];
    }
    else {
        muAttStr = attStr;
    }
    _textView.attributedText = [muAttStr copy];
    if (self.superview) {
        [self scrollsToBottomAnimated:YES];
    }
    _color = !_color;
}

@end

@interface LLLogView ()

@property (nonatomic, assign) BOOL isStart;

@end

@implementation LLLogView {
    UITextView *_textView;
}

+ (void)startLog {
    dispatch_async(dispatch_get_main_queue(), ^{
        LLLogView *logView = [LLLogView logView];
        logView.isStart = YES;
        if (logView.superview == nil) {
            [[UIApplication sharedApplication].delegate.window addSubview:logView];
        }
    });
}

+ (NSString *)outputString:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        LLLogView *logView = [LLLogView logView];
        if (logView.isStart) {
            if (string) {
                LHYMessageView *messageView = [LHYMessageView messageView];
                [messageView outputString:string];
            }
        }
    });
    return (string ? string : @"");
}

+ (instancetype)logView {
    static LLLogView *logView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logView = [[LLLogView alloc] initWithFrame:CGRectMake(0, OFFSET_Y, 40, 40)];
        logView.layer.masksToBounds = YES;
        logView.layer.cornerRadius = 20;
        logView.isStart = NO;
    });
    return logView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.text = @"日志";
        label.textColor = [UIColor blueColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [self addGestureRecognizer:tapRec];
    
    UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognizer:)];
    [self addGestureRecognizer:panRec];
}

- (void)tapRecognizer:(UILongPressGestureRecognizer *)recognizer {
    LHYMessageView *messageView = [LHYMessageView messageView];
    if (messageView.superview == nil) {
        [[UIApplication sharedApplication].delegate.window addSubview:messageView];
    }
    [messageView setNeedsDisplay];
    [messageView scrollsToBottomAnimated:YES];
}

- (void)panRecognizer:(UIPanGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:tapView];
    
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = tapView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat x = rect.origin.x+point_0.x;
        CGFloat y = rect.origin.y+point_0.y;
        
        if (x < 0 || x > SCREEN_WIDTH-tapView.frame.size.width) {
            x = tapView.frame.origin.x;
        }
        if (y < OFFSET_Y || y > SCREEN_HEIGHT-TABBAR_HEIGHT-tapView.frame.size.height) {
            y = tapView.frame.origin.y;
        }
        
        tapView.frame = CGRectMake(x, y, tapView.frame.size.width, tapView.frame.size.height);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        CGRect rect = self.frame;
        if (self.center.x <= SCREEN_WIDTH/2) {
            rect.origin.x = 0.0;
        }
        else {
            rect.origin.x = SCREEN_WIDTH-rect.size.width;
        }
        [UIView animateWithDuration:.2 animations:^{
            self.frame = rect;
        }];
    }
}

@end

