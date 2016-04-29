#import "ARViewController.h"

@interface ARViewController ()

@property (nonatomic) ARImageTrackable *imageTrackable;

@end

@implementation ARViewController

- (void)setupContent
{
    [self setupImageTrackable];
    [self addImageNode];
    [self addVideoNode];
    [self addAlphaVideoNode];
    [self addModelNode];
}

- (void)setupImageTrackable
{
    // Initialise image trackable
    self.imageTrackable = [[ARImageTrackable alloc] initWithImage:[UIImage imageNamed:@"spaceMarker.jpg"] name:@"space"];
    
    // Get instance of image tracker manager
    ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
    [trackerManager initialise];
    
    // Add image trackable to image tracker mangaer
    [trackerManager addTrackable:self.imageTrackable];
}

- (void)addImageNode
{
    // Initialise image node
    ARImageNode *imageNode = [[ARImageNode alloc] initWithBundledFile:@"eyebrow.png"];
    
    // Add image node to image trackable
    [self.imageTrackable.world addChild:imageNode];
    
    // Image scale
    float scale = (float)self.imageTrackable.width / imageNode.texture.width;
    [imageNode scaleByUniform:scale];
    
    // Hide image node
    [imageNode setVisible:NO];
    
}

- (void)addVideoNode
{
    // Initialise video node
    ARVideoNode *videoNode = [[ARVideoNode alloc] initWithBundledFile:@"waves.mp4"];
    
    // Add video node to image trackable
    [self.imageTrackable.world addChild:videoNode];
    
    // Video scale
    float scale = (float)self.imageTrackable.width / videoNode.videoTexture.width ;
    [videoNode scaleByUniform:scale];
    
    [videoNode setVisible:NO];
}

- (void)addAlphaVideoNode
{
    // Initialise alpha video node
    ARAlphaVideoNode *alphaVideoNode = [[ARAlphaVideoNode alloc] initWithBundledFile:@"kaboom.mp4"];
    
    // Add alpha video node to image trackable
    [self.imageTrackable.world addChild:alphaVideoNode];
    
    // Alpha video scale
    float scale = (float)self.imageTrackable.width / alphaVideoNode.videoTexture.width;
    [alphaVideoNode scaleByUniform:scale];
    
    [alphaVideoNode setVisible:NO];
}

- (void)addModelNode
{
    // Import model
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
    ARModelNode *modelNode = [importer getNode];
    
    // Apply ambient light to model mesh nodes
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        ARLightMaterial *material = (ARLightMaterial *)meshNode.material;
        material.ambient.value = [ARVector3 vectorWithValuesX:0.8 y:0.8 z:0.8];;
        
    }
    
    [modelNode rotateByDegrees:90 axisX:1 y:0 z:0];
    [modelNode scaleByUniform:0.25f];
    
    // Add model node to image trackable
    [self.imageTrackable.world addChild:modelNode];
}


- (IBAction)addModelButtonPressed:(id)sender
{
    [self hideAll];
    [[self.imageTrackable.world.children objectAtIndex:3] setVisible:YES];
}

- (IBAction)addAlphaVideoButtonPressed:(id)sender
{
    [self hideAll];
    [[self.imageTrackable.world.children objectAtIndex:2] setVisible:YES];
}

- (IBAction)addVideoButtonPressed:(id)sender
{
    [self hideAll];
    [[self.imageTrackable.world.children objectAtIndex:1] setVisible:YES];
}

- (IBAction)addImageButtonPressed:(id)sender
{
    [self hideAll];
    [[self.imageTrackable.world.children objectAtIndex:0] setVisible:YES];
}

- (void)hideAll
{
    for (ARNode *node in self.imageTrackable.world.children) {
        [node setVisible:NO];
    }
}

@end
