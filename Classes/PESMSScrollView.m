//
//  ScrollView.m
//  chat
//
//  Created by Pedro Enrique on 8/12/11.
//  Copyright 2011 Appcelerator. All rights reserved.
//

#import "PESMSScrollView.h"
#import "TiUtils.h"

@implementation PESMSScrollView
@synthesize delegate;
@synthesize labelsPosition;
@synthesize sColor;
@synthesize rColor;

-(void)dealloc
{
	RELEASE_TO_NIL(label);
	[super dealloc];
}

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if (self) {
		self.labelsPosition = self.frame;
	}
    return self;
}

-(PESMSLabel *)label:(NSString *)text
{
	[self performSelectorOnMainThread:@selector(reloadContentSize) withObject:nil waitUntilDone:YES];
	
	label = [[PESMSLabel alloc] init];
	[self addSubview:label];
	
	[label addText:text];
	
	CGRect frame = label.frame;
	frame.origin.y += labelsPosition.origin.y;	
	[label setFrame:frame];
	
	CGRect a = self.labelsPosition;
	a.origin.y = frame.origin.y+frame.size.height;
	self.labelsPosition = a;
	
	return label;
}

-(void)reloadContentSize
{
    if(CGRectIsEmpty(self.labelsPosition))
        self.labelsPosition = self.frame;
    
	CGFloat bottomOfContent = self.labelsPosition.origin.y;//+self.labelsPosition.size.height;
	
	CGSize contentSize1 = CGSizeMake(self.frame.size.width , bottomOfContent);
	
	
	[self setContentSize:contentSize1];
	
	CGRect contentSize2 = CGRectMake(0,0,self.frame.size.width, bottomOfContent);
	
	[self scrollRectToVisible: contentSize2 animated: YES];	
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([delegate respondsToSelector:@selector(scrollViewClicked:withEvent:)]) {
		[delegate scrollViewClicked:touches withEvent:event];
	}		
}

-(void)sendColor:(NSString *)col
{
    self.sColor = col;
}
-(void)recieveColor:(NSString *)col
{
    self.rColor = col;
}

-(void)backgroundColor:(UIColor *)col
{
	self.backgroundColor = col;
}

-(void)recieveMessage:(NSString *)text;
{
    if(!self.rColor)
        self.rColor = @"Green";
    
	[[self label:text] position:@"Left":self.rColor];
	RELEASE_TO_NIL(label);
}

-(void)sendMessage:(NSString *)text;
{	
    if(!self.sColor)
        self.sColor = @"White";
	
	[[self label:text] position:@"Right":self.sColor];
	RELEASE_TO_NIL(label);
}

@end
