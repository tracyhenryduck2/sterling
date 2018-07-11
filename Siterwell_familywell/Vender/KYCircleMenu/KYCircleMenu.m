//
//  KYCircleMenu.m
//  KYCircleMenu
//
//  Created by Kaijie Yu on 2/1/12.
//  Copyright (c) 2012 Kjuly. All rights reserved.
//

#import "KYCircleMenu.h"
#import "AutoScrollLabel.h"
#import "SystemSceneModel.h"

@interface KYCircleMenu () {
 @private
  NSInteger buttonCount_;
  CGRect    buttonOriginFrame_;
  
  NSString * buttonImageNameFormat_;
  NSString * centerButtonImageName_;
  NSString * centerButtonBackgroundImageName_;
  
  BOOL shouldRecoverToNormalStatusWhenViewWillAppear_;
}

@property (nonatomic, copy) NSString * buttonImageNameFormat,
                                     * centerButtonImageName,
                                     * centerButtonBackgroundImageName;

- (void)_releaseSubviews;
- (void)_setupNotificationObserver;

// Toggle menu beween open & closed
- (void)_toggle:(id)sender;
// Close menu to hide all buttons around
- (void)_close:(NSNotification *)notification;
// Update buttons' layout with the value of triangle hypotenuse that given
- (void)_updateButtonsLayoutWithTriangleHypotenuse:(CGFloat)triangleHypotenuse;
// Update button's origin value
- (void)_setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin;

@end


// Basic configuration for the Circle Menu
static CGFloat menuSize_,         // size of menu
               buttonSize_,       // size of buttons around
               centerButtonSize_; // size of center button
static CGFloat defaultTriangleHypotenuse_,
               minBounceOfTriangleHypotenuse_,
               maxBounceOfTriangleHypotenuse_,
               maxTriangleHypotenuse_;

static CGPoint centerBtnPoint;


@implementation KYCircleMenu

@synthesize menu           = menu_,
            centerButton   = centerButton_;
@synthesize isOpening      = isOpening_,
            isInProcessing = isInProcessing_,
            isClosed       = isClosed_;
@synthesize buttonImageNameFormat = buttonImageNameFormat_,
            centerButtonImageName = centerButtonImageName_,
  centerButtonBackgroundImageName = centerButtonBackgroundImageName_;

-(void)dealloc {
  self.buttonImageNameFormat =
    self.centerButtonImageName =
    self.centerButtonBackgroundImageName = nil;
  // Release subvies & remove notification observer
  [self _releaseSubviews];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kKYNCircleMenuClose object:nil];
}

- (void)_releaseSubviews {
  self.centerButton = nil;
  self.menu         = nil;
}

// Designated initializer
- (id)      initWithButtonCount:(NSInteger)buttonCount
                       menuSize:(CGFloat)menuSize
                     buttonSize:(CGFloat)buttonSize
          buttonImageNameFormat:(NSString *)buttonImageNameFormat
               centerButtonSize:(CGFloat)centerButtonSize
          centerButtonImageName:(NSString *)centerButtonImageName
centerButtonBackgroundImageName:(NSString *)centerButtonBackgroundImageName centerPoint:(CGPoint)centerPoint
                   sysSceneArry:(NSArray*)sysSceneArry{
  if (self = [self init]) {
    buttonCount_                     = buttonCount;
    menuSize_                        = menuSize;
    buttonSize_                      = buttonSize;
    buttonImageNameFormat_           = buttonImageNameFormat;
    centerButtonSize_                = centerButtonSize;
    centerButtonImageName_           = centerButtonImageName;
    centerButtonBackgroundImageName_ = centerButtonBackgroundImageName;
      
    centerBtnPoint = centerPoint;
      _sysSceneArry = sysSceneArry;
    
    // Defualt value for triangle hypotenuse
    defaultTriangleHypotenuse_     = (menuSize - buttonSize) / 2.f;
    minBounceOfTriangleHypotenuse_ = defaultTriangleHypotenuse_ - 12.f;
    maxBounceOfTriangleHypotenuse_ = defaultTriangleHypotenuse_ + 12.f;
    maxTriangleHypotenuse_         = kKYCircleMenuViewHeight / 2.f;
    
    // Buttons' origin frame
    CGFloat originX = (menuSize_ - centerButtonSize_) / 2;
    buttonOriginFrame_ =
      (CGRect){{originX, originX}, {centerButtonSize_, centerButtonSize_}};
  }
  return self;
}

// Secondary initializer
- (id)init {
  self = [super init];
  if (self) {
    isInProcessing_ = NO;
    isOpening_      = NO;
    isClosed_       = YES;
    shouldRecoverToNormalStatusWhenViewWillAppear_ = NO;
#ifndef KY_CIRCLEMENU_WITH_NAVIGATIONBAR
    [self.navigationController setNavigationBarHidden:YES];
#endif
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
  CGFloat viewHeight =
    (self.navigationController.isNavigationBarHidden
      ? kKYCircleMenuViewHeight : kKYCircleMenuViewHeight - kKYCircleMenuNavigationBarHeight);
  CGRect frame = CGRectMake(0.f, 0.f, kKYCircleMenuViewWidth, viewHeight);
  UIView * view = [[UIView alloc] initWithFrame:frame];
  self.view = view;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Constants
  CGFloat viewHeight = CGRectGetHeight(self.view.frame);
  CGFloat viewWidth  = CGRectGetWidth(self.view.frame);
  
  // Center Menu View
  CGRect centerMenuFrame =
    CGRectMake((viewWidth - menuSize_) / 2, (viewHeight - menuSize_) / 2, menuSize_, menuSize_);
  menu_ = [[UIView alloc] initWithFrame:centerMenuFrame];
  [menu_ setAlpha:0.f];
    menu_.center = centerBtnPoint;
  [self.view addSubview:menu_];
  
  // Add buttons to |ballMenu_|, set it's origin frame to center
  NSString * imageName = nil;
  for (int i = 1; i <= buttonCount_; ++i) {
      
      
      UIView * button = [[UIView alloc] initWithFrame:buttonOriginFrame_];
      [button setOpaque:NO];
      button.layer.cornerRadius = buttonSize_/2.0f;
      button.layer.masksToBounds = YES;
      [button setTag:i];
      imageName = [NSString stringWithFormat:self.buttonImageNameFormat, button.tag];
      button.backgroundColor = RGB(53, 167, 255);
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//      [button setImage:[UIImage imageNamed:imageName]
//              forState:UIControlStateNormal];
      [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(runButtonActions:)]];
//      [button addTarget:self action:@selector(runButtonActions:) forControlEvents:UIControlEventTouchUpInside];
      imageView.frame = CGRectMake(buttonSize_/2.0f - 15, 10, 30, 26);
      
      [button addSubview:imageView];
      
      AutoScrollLabel *label = [[AutoScrollLabel alloc] initWithFrame:CGRectMake(10, imageView.frame.origin.y + 30, buttonSize_ - 20, 20)];
      
      SystemSceneModel *sysModel = [_sysSceneArry objectAtIndex:i-1];
      if (i == 1) {
          label.text = NSLocalizedString(@"在家", nil);
          [imageView setImage:[UIImage imageNamed:@"home00_icon"]];
      }else if (i== 2){
          label.text = NSLocalizedString(@"离家", nil);
          [imageView setImage:[UIImage imageNamed:@"away00_icon"]];
      }else if (i == 3){
          label.text = NSLocalizedString(@"睡眠", nil);
          [imageView setImage:[UIImage imageNamed:@"sleep00_icon"]];
      }else{
          label.text = sysModel.systemname;
          [imageView setImage:[UIImage imageNamed:@"home00_icon"]];
      }
      
      label.font = [UIFont systemFontOfSize:13.0f];
      [button addSubview:label];
      [self.menu addSubview:button];
      
  }
  
  // Main Button
  CGRect mainButtonFrame =
    CGRectMake((CGRectGetWidth(self.view.frame) - centerButtonSize_) / 2.f,
               (CGRectGetHeight(self.view.frame) - centerButtonSize_) / 2.f,
               centerButtonSize_, centerButtonSize_);
  centerButton_ = [[UIButton alloc] initWithFrame:mainButtonFrame];

  [centerButton_ setImage:[UIImage imageNamed:@"closepage_icon"]
                 forState:UIControlStateNormal];
  [centerButton_ addTarget:self
                    action:@selector(_toggle:)
          forControlEvents:UIControlEventTouchUpInside];
   centerButton_.center = centerBtnPoint;
    
  [self.view addSubview:centerButton_];
  
  // Setup notification observer
  [self _setupNotificationObserver];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [self _releaseSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
#ifndef KY_CIRCLEMENU_WITH_NAVIGATIONBAR
  [self.navigationController setNavigationBarHidden:YES animated:YES];
#endif
  
  // If it is from child view by press the buttons,
  //   recover menu to normal state
  if (shouldRecoverToNormalStatusWhenViewWillAppear_)
    [self performSelector:@selector(recoverToNormalStatus)
               withObject:nil
               afterDelay:.3f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Publich Button Action

// Run action depend on button, it'll be implemented by subclass
- (void)runButtonActions:(id)sender {
#ifndef KY_CIRCLEMENU_WITH_NAVIGATIONBAR
  [self.navigationController setNavigationBarHidden:NO animated:YES];
#endif
  // Close center menu
//  [self _closeCenterMenuView:nil];
  shouldRecoverToNormalStatusWhenViewWillAppear_ = YES;
    
    if (isClosed_)
        return;

    isInProcessing_ = YES;
    // Hide buttons with animation
    [UIView animateWithDuration:.3f
                          delay:0.f
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         for (UIButton * button in [self.menu subviews])
                             [button setFrame:buttonOriginFrame_];
                         [self.menu setAlpha:0.f];
                     }
                     completion:^(BOOL finished) {
                         isClosed_       = YES;
                         isOpening_      = NO;
                         isInProcessing_ = NO;
                         
                     }];
    
}

// Push View Controller
- (void)pushViewController:(id)viewController {
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     // Slide away buttons in center view & hide them
                     [self _updateButtonsLayoutWithTriangleHypotenuse:maxTriangleHypotenuse_];
                     [self.menu setAlpha:0.f];
                     
                     /*/ Show Navigation Bar
                     [self.navigationController setNavigationBarHidden:NO];
                     CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
                     if (navigationBarFrame.origin.y < 0) {
                       navigationBarFrame.origin.y = 0;
                       [self.navigationController.navigationBar setFrame:navigationBarFrame];
                     }*/
                   }
                   completion:^(BOOL finished) {
                     [self.navigationController pushViewController:viewController animated:YES];
                   }];
}

// Open center menu view
- (void)open {
  if (isOpening_)
    return;
  isInProcessing_ = YES;
  // Show buttons with animation
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseInOut
                   animations:^{
                     [self.menu setAlpha:1.f];
                     // Compute buttons' frame and set for them, based on |buttonCount|
                     [self _updateButtonsLayoutWithTriangleHypotenuse:maxBounceOfTriangleHypotenuse_];
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:.1f
                                           delay:0.f
                                         options:UIViewAnimationCurveEaseInOut
                                      animations:^{
                                        [self _updateButtonsLayoutWithTriangleHypotenuse:defaultTriangleHypotenuse_];
                                      }
                                      completion:^(BOOL finished) {
                                        isOpening_ = YES;
                                        isClosed_ = NO;
                                        isInProcessing_ = NO;
                                      }];
                   }];
}

// Recover to normal status
- (void)recoverToNormalStatus {
  [self _updateButtonsLayoutWithTriangleHypotenuse:maxTriangleHypotenuse_];
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     // Show buttons & slide in to center
                     [self.menu setAlpha:1.f];
                     [self _updateButtonsLayoutWithTriangleHypotenuse:minBounceOfTriangleHypotenuse_];
                   }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:.1f
                                           delay:0.f
                                         options:UIViewAnimationOptionCurveEaseInOut
                                      animations:^{
                                        [self _updateButtonsLayoutWithTriangleHypotenuse:defaultTriangleHypotenuse_];
                                      }
                                      completion:nil];
                   }];
}

#pragma mark - Private Methods

// Setup notification observer
- (void)_setupNotificationObserver {
  // Add Observer for close self
  // If |centerMainButton_| post cancel notification, do it
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(_close:)
                                               name:kKYNCircleMenuClose
                                             object:nil];
}

// Toggle Circle Menu
- (void)_toggle:(id)sender {
  (isClosed_ ? [self open] : [self _close:nil]);
}

// Close menu to hide all buttons around
- (void)_close:(NSNotification *)notification {
  if (isClosed_)
    return;
  
  isInProcessing_ = YES;
  // Hide buttons with animation
  [UIView animateWithDuration:.3f
                        delay:0.f
                      options:UIViewAnimationCurveEaseIn
                   animations:^{
                     for (UIButton * button in [self.menu subviews])
                       [button setFrame:buttonOriginFrame_];
                     [self.menu setAlpha:0.f];
                   }
                   completion:^(BOOL finished) {
                     isClosed_       = YES;
                     isOpening_      = NO;
                     isInProcessing_ = NO;
                    
                       self.closedCircleMenu();
                     
                   }];
}

// Update buttons' layout with the value of triangle hypotenuse that given
- (void)_updateButtonsLayoutWithTriangleHypotenuse:(CGFloat)triangleHypotenuse {
  //
  //  Triangle Values for Buttons' Position
  // 
  //      /|      a: triangleA = c * cos(x)
  //   c / | b    b: triangleB = c * sin(x)
  //    /)x|      c: triangleHypotenuse
  //   -----      x: degree
  //     a
  //
  CGFloat centerBallMenuHalfSize = menuSize_         / 2.f;
  CGFloat buttonRadius           = centerButtonSize_ / 2.f;
  if (! triangleHypotenuse) triangleHypotenuse = defaultTriangleHypotenuse_; // Distance to Ball Center
  
  //
  //      o       o   o      o   o     o   o     o o o     o o o
  //     \|/       \|/        \|/       \|/       \|/       \|/
  //  1 --|--   2 --|--    3 --|--   4 --|--   5 --|--   6 --|--
  //     /|\       /|\        /|\       /|\       /|\       /|\
  //                           o       o   o     o   o     o o o
  //
  switch (buttonCount_) {
    case 1:
      [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
      break;
      
    case 2: {
      CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
      CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
      [self _setButtonWithTag:1 origin:CGPointMake(negativeValue, negativeValue)];
      [self _setButtonWithTag:2 origin:CGPointMake(positiveValue, negativeValue)];
      break;
    }
      
    case 3: {
      // = 360.0f / self.buttonCount * M_PI / 180.0f;
      // E.g: if |buttonCount_ = 6|, then |degree = 60.0f * M_PI / 180.0f|;
      // CGFloat degree = 2 * M_PI / self.buttonCount;
      //
      CGFloat degree    = M_PI / 3.0f; // = 60 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self _setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize + triangleHypotenuse - buttonRadius)];
      break;
    }
      
    case 4: {
      CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      CGFloat negativeValue = centerBallMenuHalfSize - triangleB - buttonRadius;
      CGFloat positiveValue = centerBallMenuHalfSize + triangleB - buttonRadius;
      [self _setButtonWithTag:1 origin:CGPointMake(negativeValue, negativeValue)];
      [self _setButtonWithTag:2 origin:CGPointMake(positiveValue, negativeValue)];
      [self _setButtonWithTag:3 origin:CGPointMake(negativeValue, positiveValue)];
      [self _setButtonWithTag:4 origin:CGPointMake(positiveValue, positiveValue)];
      break;
    }
      
    case 5: {
      CGFloat degree    = M_PI / 2.5f; // = 72 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
      [self _setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      
      degree    = M_PI / 5.0f;  // = 36 * M_PI / 180
      triangleA = triangleHypotenuse * cosf(degree);
      triangleB = triangleHypotenuse * sinf(degree);
      [self _setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      [self _setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      break;
    }
      
    case 6: {
      CGFloat degree    = M_PI / 3.0f; // = 60 * M_PI / 180
      CGFloat triangleA = triangleHypotenuse * cosf(degree);
      CGFloat triangleB = triangleHypotenuse * sinf(degree);
      [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self _setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
      [self _setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize - triangleA - buttonRadius)];
      [self _setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      [self _setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                  centerBallMenuHalfSize + triangleHypotenuse - buttonRadius)];
      [self _setButtonWithTag:6 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                  centerBallMenuHalfSize + triangleA - buttonRadius)];
      break;
    }
      case 7: {
          CGFloat degree    = 360.0/7*M_PI/180; // = 360 / 7 * M_PI / 180
          CGFloat triangleA = triangleHypotenuse * cosf(degree);
          CGFloat triangleB = triangleHypotenuse * sinf(degree);
          
          
          [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                       centerBallMenuHalfSize - triangleA - buttonRadius)];
          [self _setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                       centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
          
          [self _setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                       centerBallMenuHalfSize - triangleA - buttonRadius)];
          
          
          [self _setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius - 10,
                                                       centerBallMenuHalfSize + triangleA - buttonRadius -45)];
          CGFloat degree56    = M_PI / 7.0f;
          
          CGFloat triangleA56 = triangleHypotenuse * cosf(degree56);
          CGFloat triangleB56 = triangleHypotenuse * sinf(degree56);
          
          [self _setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize - triangleB56 - buttonRadius,
                                                       centerBallMenuHalfSize + triangleA56 - buttonRadius)];
          [self _setButtonWithTag:6 origin:CGPointMake(centerBallMenuHalfSize + triangleB56 - buttonRadius,
                                                       centerBallMenuHalfSize + triangleA56 - buttonRadius)];
          [self _setButtonWithTag:7 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius + 10,
                                                       centerBallMenuHalfSize + triangleA - buttonRadius -45)];
          break;
      }
      case 8: {
          CGFloat degree    = M_PI / 4.0f; // = 45 * M_PI / 180
          CGFloat triangleA = triangleHypotenuse * cosf(degree);
          CGFloat triangleB = triangleHypotenuse * sinf(degree);
          [self _setButtonWithTag:1 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                       centerBallMenuHalfSize - triangleA - buttonRadius)];
          [self _setButtonWithTag:2 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                       centerBallMenuHalfSize - triangleHypotenuse - buttonRadius)];
          [self _setButtonWithTag:3 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                       centerBallMenuHalfSize - triangleA - buttonRadius)];
          
          [self _setButtonWithTag:4 origin:CGPointMake(centerBallMenuHalfSize - triangleHypotenuse - buttonRadius,
                                                       centerBallMenuHalfSize - buttonRadius)];
          
          [self _setButtonWithTag:5 origin:CGPointMake(centerBallMenuHalfSize - triangleB - buttonRadius,
                                                       centerBallMenuHalfSize + triangleA - buttonRadius)];
          
          [self _setButtonWithTag:6 origin:CGPointMake(centerBallMenuHalfSize - buttonRadius,
                                                       centerBallMenuHalfSize + triangleHypotenuse - buttonRadius)];
          
          [self _setButtonWithTag:7 origin:CGPointMake(centerBallMenuHalfSize + triangleB - buttonRadius,
                                                       centerBallMenuHalfSize + triangleA - buttonRadius)];
          
          [self _setButtonWithTag:8 origin:CGPointMake(centerBallMenuHalfSize + triangleHypotenuse - buttonRadius,
                                                       centerBallMenuHalfSize - buttonRadius)];
          break;
      }

      
    default:
      break;
  }
}

// Set Frame for button with special tag
- (void)_setButtonWithTag:(NSInteger)buttonTag origin:(CGPoint)origin {
  UIView * button = (UIView *)[self.menu viewWithTag:buttonTag];
  [button setFrame:CGRectMake(origin.x, origin.y, centerButtonSize_, centerButtonSize_)];
  button = nil;
}

@end
