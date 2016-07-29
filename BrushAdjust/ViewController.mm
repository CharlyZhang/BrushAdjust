//
//  ViewController.m
//  BrushAdjust
//
//  Created by CharlyZhang on 16/7/28.
//  Copyright © 2016年 CharlyZhang. All rights reserved.
//

#import "ViewController.h"
#import "HYBrushCore.h"
#import "CanvasView.h"

#define BOTTOM_OFFSET   144

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,CanvasViewDelegate>
{
    UIPopoverController *picturePopoverController;
    HYBrushCore *coreInstance;
}

// Labels
@property (weak, nonatomic) IBOutlet UILabel *intentity;
@property (weak, nonatomic) IBOutlet UILabel *angle;
@property (weak, nonatomic) IBOutlet UILabel *spacing;
@property (weak, nonatomic) IBOutlet UILabel *jitter;
@property (weak, nonatomic) IBOutlet UILabel *scatter;
@property (weak, nonatomic) IBOutlet UILabel *bDensity;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *bSize;
@property (weak, nonatomic) IBOutlet UILabel *Dangle;
@property (weak, nonatomic) IBOutlet UILabel *Dweight;
@property (weak, nonatomic) IBOutlet UILabel *Dintentity;

// sliders
@property (weak, nonatomic) IBOutlet UISlider *brushSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *bDensitySlider;
@property (weak, nonatomic) IBOutlet UISlider *bSizeSlider;
@property (weak, nonatomic) IBOutlet UISlider *DangleSlider;
@property (weak, nonatomic) IBOutlet UISlider *DweightSlider;
@property (weak, nonatomic) IBOutlet UISlider *DintentitySlider;
@property (weak, nonatomic) IBOutlet UISlider *jitterSlider;
@property (weak, nonatomic) IBOutlet UISlider *scatterSlider;
@property (weak, nonatomic) IBOutlet UISlider *intentitySlider;
@property (weak, nonatomic) IBOutlet UISlider *angleSlider;
@property (weak, nonatomic) IBOutlet UISlider *spacingSlider;

// values
@property (assign, nonatomic) float brushSizeValue;
@property (assign, nonatomic) float spacingValue;
@property (assign, nonatomic) float angleValue;
@property (assign, nonatomic) float intentityValue;
@property (assign, nonatomic) float jitterValue;
@property (assign, nonatomic) float scatterValue;
@property (assign, nonatomic) float dynamicAngleValue;
@property (assign, nonatomic) float dynamicWeightValue;
@property (assign, nonatomic) float dynamicIntentityValue;
@property (assign, nonatomic) float bristleDensityValue;
@property (assign, nonatomic) float bristleSizeValue;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    NSLog(@"sandbox path is:%@",NSHomeDirectory());
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    int w = size.width > size.height ? size.width : size.height;
    int h = size.width < size.height ? size.width : size.height;
    coreInstance = [HYBrushCore sharedInstance];
    CanvasView *canvasView = [coreInstance initializeWithWidth:w
                                                        Height:h-BOTTOM_OFFSET
                                                   ScreenScale:[UIScreen mainScreen].scale
                                                 GLSLDirectory:[[[NSBundle mainBundle]bundlePath] stringByAppendingString:@"/BrushesCoreResources.bundle/glsl/"]];
    
    [self.view insertSubview:canvasView atIndex:0];
    canvasView.delegate = self;
    
    [self initBrush];
    
    // top bar layout
    UIBarButtonItem *photoPickerItem = [[UIBarButtonItem alloc]initWithTitle:@"选择笔触图片" style:UIBarButtonItemStylePlain target:self action:@selector(tapPhotoPicker:)];
    
    self.navigationItem.rightBarButtonItem = photoPickerItem;
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gesture & topbar action

- (void) showMessageView:(ShowingMessageType)msgType{};
- (void) dismissMessageView{};

- (void) displayToolView:(BOOL) flag
{
    self.navigationController.navigationBar.hidden = flag;
}

- (void)tapPhotoPicker:(UIBarButtonItem*)sender {
    UIImagePickerController  *picker = [[UIImagePickerController alloc]init];
    UIImagePickerControllerSourceType sourcheType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.sourceType = sourcheType;
    picker.delegate = self;
    picturePopoverController = [[UIPopoverController alloc]initWithContentViewController:picker];
    [picturePopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picturePopoverController dismissPopoverAnimated:YES];
    
    UIImage *imagePicked = info[@"UIImagePickerControllerOriginalImage"];
    
    [coreInstance setCurrentBrushStamp:imagePicked];
    
}

#pragma mark - Properties

- (void) setBrushSizeValue:(float)size
{
    _brushSizeValue = size;
    [coreInstance setActiveBrushSize:size];
    self.weight.text = [NSString stringWithFormat:@"大小:%0.2f",size];
    self.brushSizeSlider.value = size;
}

- (void) setSpacingValue:(float)spacing
{
    _spacingValue = spacing;
    [coreInstance setSpacing4ActiveBrush:spacing];
    self.spacing.text = [NSString stringWithFormat:@"spacing:%0.2f",spacing];
    self.spacingSlider.value = spacing;
}

- (void) setAngleValue:(float)angle
{
    _angleValue = angle;
    [coreInstance setAngle4ActiveBrush:angle];
    self.angle.text = [NSString stringWithFormat:@"angle:%0.2f",angle];
    self.angleSlider.value = angle;
}

- (void) setIntentityValue:(float)intentity
{
    _intentityValue = intentity;
    [coreInstance setIntentity4ActiveBrush:intentity];
    self.intentity.text = [NSString stringWithFormat:@"intentity:%0.2f",intentity];
    self.intentitySlider.value = intentity;
}

- (void) setJitterValue:(float)jitter
{
    _jitterValue = jitter;
    [coreInstance setJitter4ActiveBrush:jitter];
    self.jitter.text = [NSString stringWithFormat:@"jitter:%0.2f",jitter];
    self.jitterSlider.value = jitter;
}

- (void) setScatterValue:(float)scatter
{
    _scatterValue = scatter;
    [coreInstance setScatter4ActiveBrush:scatter];
    self.scatter.text = [NSString stringWithFormat:@"scatter:%0.2f",scatter];
    self.scatterSlider.value = scatter;
}

- (void) setDynamicAngleValue:(float)dynamicAngle
{
    _dynamicAngleValue = dynamicAngle;
    [coreInstance setDynamicAngle4ActiveBrush:dynamicAngle];
    self.Dangle.text = [NSString stringWithFormat:@"Dangle:%0.2f",dynamicAngle];
    self.DangleSlider.value = dynamicAngle;
}

- (void) setDynamicWeightValue:(float)dynamicWeight
{
    _dynamicWeightValue = dynamicWeight;
    [coreInstance setDynamicWeight4ActiveBrush:dynamicWeight];
    self.Dweight.text = [NSString stringWithFormat:@"Dangle:%0.2f",dynamicWeight];
    self.DweightSlider.value = dynamicWeight;
}

- (void) setDynamicIntentityValue:(float)dynamicIntentity
{
    _dynamicIntentityValue = dynamicIntentity;
    [coreInstance setDynamicIntensity4ActiveBrush:dynamicIntentity];
    self.Dintentity.text = [NSString stringWithFormat:@"Dintentity:%0.2f",dynamicIntentity];
    self.DintentitySlider.value = dynamicIntentity;
}

- (void) setBristleDensityValue:(float)bristleDensity
{
    _bristleDensityValue = bristleDensity;
    [coreInstance setBristleDentity4ActiveBrush:bristleDensity];
    self.bDensity.text = [NSString stringWithFormat:@"bDensity:%0.2f",bristleDensity];
    self.bDensitySlider.value = bristleDensity;
}

- (void) setBristleSizeValue:(float)bristleSize
{
    _bristleSizeValue = bristleSize;
    [coreInstance setBristleSize4ActiveBrush:bristleSize];
    self.bSize.text = [NSString stringWithFormat:@"bSize:%0.2f",bristleSize];
    self.bSizeSlider.value = bristleSize;
}

#pragma mark - Actions

- (IBAction)clearButton:(UIButton *)sender {
    NSInteger activeLayerIdx = [coreInstance getActiveLayerIndex];
    [coreInstance clearLayer:activeLayerIdx];
}

- (IBAction)adjustProperty:(UISlider *)sender {
    switch (sender.tag) {
        case 0: ///< intentity
            self.intentityValue = sender.value;
            break;
        case 1: ///< angle
            self.angleValue = sender.value;
            break;
        case 2: ///< spacing
            self.spacingValue = sender.value;
            break;
        case 3: ///< dynamic itentity
            self.dynamicIntentityValue = sender.value;
            break;
        case 4: ///< jitter
            self.jitterValue = sender.value;
            break;
        case 5: ///< scatter
            self.scatterValue = sender.value;
            break;
        case 6: ///< dynamic weight
            self.dynamicWeightValue = sender.value;
            break;
        case 7: ///< bristle dentity
            self.bristleDensityValue = sender.value;
            break;
        case 8: ///< bristle size
            self.bristleSizeValue = sender.value;
            break;
        case 9: ///< dynamic angle
            self.dynamicAngleValue = sender.value;
            break;
        case 10: ///< weight
            self.brushSizeValue = sender.value;
            break;
        default:
            break;
    }
}


#pragma mark - BrushCore Related Methods

- (void) initBrush {
    [self setActiveBrushAsCrayonStamp];
    
    self.brushSizeValue = 10.0f;
    self.spacingValue = coreInstance.spacing4ActiveBrush;
    self.angleValue = coreInstance.angle4ActiveBrush;
    self.intentityValue = coreInstance.intentity4ActiveBrush;
    self.jitterValue = coreInstance.jitter4ActiveBrush;
    self.scatterValue = coreInstance.scatter4ActiveBrush;
    self.dynamicAngleValue = coreInstance.dynamicAngle4ActiveBrush;
    self.dynamicWeightValue = coreInstance.dynamicWeight4ActiveBrush;
    self.dynamicIntentityValue = coreInstance.dynamicIntensity4ActiveBrush;
    self.bristleSizeValue = coreInstance.bristleSize4ActiveBrush;
    self.bristleDensityValue = coreInstance.bristleDentity4ActiveBrush;
}

- (void)setActiveBrushAsCrayonStamp
{
    UIImage *image = [UIImage imageNamed:@"BrushesCoreResources.bundle/stamp_images/crayon.png"];
    [coreInstance setCurrentBrushStamp:image];
}


@end
