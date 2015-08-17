//
//  RespForWeChatViewController.mm
//  SDKSample
//
//  Created by Tencent on 12-4-9.
//  Copyright (c) 2012年 Tencent. All rights reserved.
//

#import "RespForWeChatViewController.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation RespForWeChatViewController

@synthesize delegate = _delegate;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)sendTextContent
{
    if (_delegate) {
        [_delegate RespTextContent];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)sendImageContent
{
    if (_delegate)
    {
        [_delegate RespImageContent];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, 135)];
    [headView setBackgroundColor:RGBCOLOR(0xe1, 0xe0, 0xde)];
    UIImage *image = [UIImage imageNamed:@"micro_messenger.png"];
    NSInteger tlx = (headView.frame.size.width -  image.size.width) / 2;
    NSInteger tly = 20;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(tlx, tly, image.size.width, image.size.height)];
    [imageView setImage:image];
    [headView addSubview:imageView];
    [imageView release];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, tly + image.size.height, width, 40)];
    [title setText:@"微信OpenAPI Sample Demo"];
    title.font = [UIFont systemFontOfSize:17];
    title.textColor = RGBCOLOR(0x11, 0x11, 0x11);
    title.backgroundColor = [UIColor clearColor];
    [headView addSubview:title];
    [title release];
    
    [self.view addSubview:headView];
    [headView release];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height, width, 1)]; 
    lineView1.backgroundColor = [UIColor blackColor]; 
    lineView1.alpha = 0.1f;
    [self.view addSubview:lineView1];
    [lineView1 release];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height + 1, width, 1)];
    lineView2.backgroundColor = [UIColor whiteColor];
    lineView2.alpha = 0.25f;
    [self.view addSubview:lineView2];
    [lineView2 release];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, headView.frame.size.height + 1, width, height - headView.frame.size.height - 2)];
    [footView setBackgroundColor:RGBCOLOR(0xef, 0xef, 0xef)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"回应Text消息给微信" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14]; 
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(10, 25, 145, 40)];
    [btn addTarget:self action:@selector(sendTextContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn2 setTitle:@"回应Photo消息给微信" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14]; 
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setFrame:CGRectMake(165, 25, 145, 40)];
    [btn2 addTarget:self action:@selector(sendImageContent) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn2];
        
    [self.view addSubview:footView];
    [footView release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
