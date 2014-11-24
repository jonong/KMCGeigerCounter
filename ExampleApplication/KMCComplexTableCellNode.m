//
//  KMCTableCellNode.m
//  KMCGeigerCounter
//
//  Created by Jonathan Ong on 20/11/14.
//  Copyright (c) 2014 Kevin Conner. All rights reserved.
//

#import "KMCComplexTableCellNode.h"
#import <AsyncDisplayKit/ASDisplayNode+Subclasses.h>
#import "KMCTableItem.h"


static const CGFloat kImageSize = 80.0f;
static const CGFloat kOuterPadding = 16.0f;
static const CGFloat kInnerPadding = 10.0f;

@interface KMCComplexTableCellNode() {
  ASDisplayNode *toolbar;
  ASImageNode *unreadDotImageView;
  ASImageNode *senderPhotoImageView;
  ASImageNode *backgroundImageView;
  ASTextNode *senderEmailLabel;
  ASTextNode *subjectLabel;
  ASTextNode *bodyLabel;
}

@end

@implementation KMCComplexTableCellNode

- (instancetype)initWithItem:(KMCTableItem *)item {
  if (!(self = [super init]))
    return nil;
  
  self.backgroundColor = [UIColor blackColor];
  
  backgroundImageView = [[ASImageNode alloc] init];
  backgroundImageView.image = item.senderPhoto;
  backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  backgroundImageView.alpha = 0.5;
  [self addSubnode:backgroundImageView];
  
  toolbar = [[ASDisplayNode alloc] init];
  toolbar.backgroundColor = [UIColor whiteColor];
  toolbar.clipsToBounds = YES;
  [self addSubnode:toolbar];
  
  senderEmailLabel = [[ASTextNode alloc] init];
  senderEmailLabel.attributedString = [[NSAttributedString alloc] initWithString:item.senderEmail
                                                                      attributes:[self emailStyle]];
  [self addSubnode:senderEmailLabel];
  
  subjectLabel = [[ASTextNode alloc] init];
  subjectLabel.attributedString = [[NSAttributedString alloc] initWithString:item.subject
                                                                  attributes:[self subjectStyle]];
  subjectLabel.truncationMode = NSLineBreakByTruncatingTail;
  [self addSubnode:subjectLabel];
  
  bodyLabel = [[ASTextNode alloc] init];
  bodyLabel.attributedString = [[NSAttributedString alloc] initWithString:item.body
                                                               attributes:[self bodyStyle]];
  bodyLabel.truncationMode = NSLineBreakByTruncatingTail;
  [self addSubnode:bodyLabel];
  
  senderPhotoImageView = [[ASImageNode alloc] init];
  senderPhotoImageView.image = item.senderPhoto;
  senderPhotoImageView.contentMode = UIViewContentModeScaleToFill;
  senderPhotoImageView.clipsToBounds = YES;
  [self addSubnode:senderPhotoImageView];
  
  unreadDotImageView = [[ASImageNode alloc] init];
  unreadDotImageView.image = [UIImage imageNamed:@"dot"];
  unreadDotImageView.contentMode = UIViewContentModeScaleToFill;
  [self addSubnode:unreadDotImageView];
  
  unreadDotImageView.hidden = !item.unread;
  
  return self;
}

- (NSDictionary *)emailStyle {
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
  
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.paragraphSpacing = 0.5 * font.lineHeight;
  style.hyphenationFactor = 1.0;
  
  return @{ NSFontAttributeName: font,
            NSParagraphStyleAttributeName: style };
}

- (NSDictionary *)subjectStyle {
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f];
  
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.paragraphSpacing = 0.5 * font.lineHeight;
  style.hyphenationFactor = 1.0;
  
  return @{ NSFontAttributeName: font,
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSBackgroundColorAttributeName: [UIColor clearColor]};
}

- (NSDictionary *)bodyStyle {
  UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
  
  NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  style.paragraphSpacing = 0.5 * font.lineHeight;
  style.hyphenationFactor = 1.0;
  
  return @{ NSFontAttributeName: font,
            NSParagraphStyleAttributeName: style,
            NSForegroundColorAttributeName: [UIColor whiteColor],
            NSBackgroundColorAttributeName: [UIColor clearColor]};
}

- (void)didLoad {
  [super didLoad];
  
  self.view.preservesSuperviewLayoutMargins = NO;
  self.view.layoutMargins = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
  
  toolbar.layer.cornerRadius = 4.0f;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
  [backgroundImageView measure:CGSizeMake(constrainedSize.width, 99.0f)];
  
  [senderPhotoImageView measure:CGSizeMake(66.0f, 66.0f)];
  
  [unreadDotImageView measure:CGSizeMake(8.0f, 8.0f)];
  
  return CGSizeMake(constrainedSize.width, 100.0f);
}

- (void)layout {
  CGFloat toolbarOffset = 4.0f;
  CGFloat toolbarHeight = 30.0f;
  toolbar.frame = CGRectMake(-toolbarOffset, toolbarOffset, self.calculatedSize.width, toolbarHeight);
  
  backgroundImageView.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, self.calculatedSize.height - 1);
  if (!backgroundImageView.imageModificationBlock) {
    backgroundImageView.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(backgroundImageView.frame.size, 12.0f, 2.0f, [UIColor colorWithWhite:1.0 alpha:0.4]);
  }
  
  CGFloat imageSize = 66.0f;
  CGFloat yOffset = (self.calculatedSize.height - imageSize) / 2;
  CGFloat xOffset = self.calculatedSize.width - imageSize - yOffset;
  senderPhotoImageView.frame = CGRectMake(xOffset, yOffset, imageSize, imageSize);
  if (!senderPhotoImageView.imageModificationBlock) {
    senderPhotoImageView.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(senderPhotoImageView.frame.size, 8.0f, 2.0f, [UIColor whiteColor]);
  }
  
  CGFloat dotSize = 8.0f;
  yOffset = ((toolbarHeight - dotSize) / 2) + toolbarOffset;
  unreadDotImageView.frame = CGRectMake(yOffset, yOffset, dotSize, dotSize);
  
  CGFloat labelHeight = 18.0f;
  CGFloat padding = 8.0f;
  xOffset = unreadDotImageView.frame.origin.x + unreadDotImageView.frame.size.width + padding;
  yOffset = ((toolbarHeight - labelHeight) / 2) + toolbarOffset;
  CGFloat labelWidth = self.calculatedSize.width - xOffset - padding;
  senderEmailLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
  
  yOffset = toolbarOffset + toolbarHeight + 6.0f;
  labelWidth = senderPhotoImageView.frame.origin.x - padding - xOffset;
  labelHeight = 17.0f;
  subjectLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
  
  yOffset = yOffset + labelHeight + padding;
  labelHeight = self.calculatedSize.height - yOffset - 4.0f;
  bodyLabel.frame = CGRectMake(xOffset, yOffset, labelWidth, labelHeight);
  
}

extern asimagenode_modification_block_t ASImageNodeRoundBorderModificationBlock(CGSize viewSize, CGFloat cornerRadius, CGFloat borderWidth, UIColor *borderColor)
{
  return ^(UIImage *originalImage) {
    CGFloat scale = originalImage.size.width / viewSize.width;
//    NSLog(@"\n");
//    NSLog(@"view size: %@", NSStringFromCGSize(viewSize));
//    NSLog(@"image size: %@", NSStringFromCGSize(originalImage.size));
//    NSLog(@"scale: %f", scale);
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, originalImage.scale);
    
    CGFloat newCornerRadius = cornerRadius * scale;
    CGFloat newBorderWidth = borderWidth * scale;
    
//    NSLog(@"new corner radius: %f", newCornerRadius);
//    NSLog(@"new border width: %f", newBorderWidth);
    
    UIBezierPath *roundOutline = [UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, originalImage.size} cornerRadius:newCornerRadius];
    
    
    // Make the image round
    [roundOutline addClip];
    
    // Draw the original image
    [originalImage drawAtPoint:CGPointZero];
    
    // Draw a border on top.
    if (newBorderWidth > 0.0) {
      [borderColor setStroke];
      CGPathRef path = CGPathCreateWithRoundedRect((CGRect){CGPointZero, originalImage.size}, newCornerRadius, newCornerRadius, nil);
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), newBorderWidth);
      CGContextAddPath(UIGraphicsGetCurrentContext(), path);
      CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathStroke);
      CGPathRelease(path);
    }
    
    UIImage *modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return modifiedImage;
  };
}

@end
