//
//  LLLogModel.m
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2018/9/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLLogModel.h"

@implementation LLLogModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = -1;
    }
    return self;
}

- (NSInteger)setConfigWithWidth:(NSInteger)width font:(UIFont *)font {
    if (self.height == -1) {
        self.height = MAX(ceil([self ll_heightWithText:self.text width:width font:font]), 44);
    }
    return self.height;
}

- (CGFloat)ll_heightWithText:(NSString *)text width:(CGFloat)width font:(UIFont *)font {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 1;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:attributes context:nil].size;
    return ceilf(size.height);
}

@end
