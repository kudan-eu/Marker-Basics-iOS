#Kudan Tutorials - Marker Basics
----

This tutorial will take you through the basics of getting started with KudanAR, leading on from our previous tutorial which described how to integrate our framework into an iOS project. If you have not already set up a project with an ARCameraViewController, I suggest you check it out before going any further.

This tutorial utilises bundled assets so ensure that you have imported the correct assets into your project. 

For this sample we have used:

* Marker	: spaceMarker.jpg
* Image 	: Augmentation: eyebrow.png
* Video	: Augmentation: waves.mp4
* Alpha video augmentation: kaboom.mp4
* Model 	: bloodhoud.armodel / bloodhound.jet 
* Model Texture : bloodhound.png

All of which can be downloaded [here](https://wiki.kudan.eu/Tutorials/assets.zip).

##Setting Up and Image Trackable

To create an Image Trackable, you are first going to need an image to track. We do not put any restrictions as to what image format you use as long as it is supported natively. For information about what creates a good marker please read our blog post:

[What makes a good marker? ](https://wiki.kudan.eu/What_Makes_a_Good_Marker%3F)

Notes: Common problems associated with a poor marker are your augmentation appears to twitch or shake.

~~~objectivec
@property (nonatomic) ARImageTrackable *imageTrackable;
...
// Initialise image trackable
self.imageTrackable = [[ARImageTrackable alloc] initWithImage:[UIImage imageNamed:@"spaceMarker.jpg"] name:@"space"];
    
// Get instance of image tracker manager
ARImageTrackerManager *trackerManager = [ARImageTrackerManager getInstance];
[trackerManager initialise];
    
// Add image trackable to image tracker manager
[trackerManager addTrackable:self.imageTrackable];
~~~

##Adding content to an Image Trackable
To add content to an Image Trackable you need to transform the content you have in the corresponding ARNode and add that to the trackable's world (the 3D space surrounding the marker). Kudan has 4 different ARNode subclasses:
 
* ARImageNode
* ARVideoNode
* ARAlphaVideoNode
* ARModelNode

Note: When adding any AR content to your application you should consider adding it on the background thread. This will help prevent the camera feed from stalling.

###Image Nodes 

Images are displayed using the ARImageNode class. These are initialised with an image. This image can use any format that is supported by the device's operating system.
 
~~~objectivec
// Initialise image node
ARImageNode *imageNode = [[ARImageNode alloc] initWithBundledFile:@"eyebrow.png"];
    
// Add image node to image trackable
[self.imageTrackable.world addChild:imageNode];

~~~

###Video Nodes

Videos are displayed using ARVideoNode class. Video nodes are initialised using a video file on iOS and a video texture initialised from a video file for Android. The video file can be any format supported by the native device.

~~~objectivec
// Initialise video node
ARVideoNode *videoNode = [[ARVideoNode alloc] initWithBundledFile:@"waves.mp4"];
    
// Add video node to image trackable
[self.imageTrackable.world addChild:videoNode];

~~~

###Alpha Video Nodes

Alpha videos are videos with a transparency channel and can be created through our Toolkit using a set of transparent PNGs. Alpha videos are displayed using the ARAlphaVideo class. They are initialised the same as a video node. 


~~~objectivec
// Initialise alpha video node
ARAlphaVideoNode *alphaVideoNode = [[ARAlphaVideoNode alloc] initWithBundledFile:@"kaboom.mp4"];
    
// Add alpha video node to image trackable
[self.imageTrackable.world addChild:alphaVideoNode];
~~~
 
###Model Nodes

Models are displayed using the ARModelNode class. They are created in a two steps. First the model is imported using the ARModelImporter class. A texture material is then applied to the model's individual mesh nodes. This can be either a colour material, texture material or a light material.

Note: For iOS if you have correctly mapped your texture to your model you only need to set the lighting values of each mesh node as your texture should be applied during the importing of the model. 

For more information on using 3D models with Kudan please check out our Wiki entry:

[3D Models](https://wiki.kudan.eu/3D_Models)

Note: If you do not add lighting to your ARLightMaterial your material will show up as black.


~~~objectivec
// Import model
ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
ARModelNode *modelNode = [importer getNode];
    
// Apply ambient light to model mesh nodes
for(ARMeshNode *meshNode in modelNode.meshNodes){
    ARLightMaterial *material = (ARLightMaterial *)meshNode.material;
    material.ambient.value = [ARVector3 vectorWithValuesX:0.8 y:0.8 z:0.8];;  
}
    
// Add model node to image trackable
[self.imageTrackable.world addChild:modelNode];
~~~    
    
###Scaling

If the image/video/model you wish to add to the marker isn't the same size as the marker, you may wish to scale your ARNode. Providing your video/image is the same aspect ratio as your trackable you can divide one width/height from the other to get the correct scale. This value can then be used to scale your nodes.

Note: This tutorial scales using a uniform value, although you are able to scale your x,y and z axis separately.

~~~objectivec
// Image scale
float scale = (float)self.imageTrackable.width / imageNode.texture.width;
[imageNode scaleByUniform:scale];

// Video
float scale = (float)self.imageTrackable.width / videoNode.videoTexture.width ;
[videoNode scaleByUniform:scale];

// Alpha video scale
float scale = (float)self.imageTrackable.width / alphaVideoNode.videoTexture.width;
[alphaVideoNode scaleByUniform:scale];
~~~


###Content visibility

Each node has a boolean value which can be set to determine whether or not the node is displayed. This is useful when you have multiple nodes attached to a marker and you do not wish to display them all at once. This can be set using:

~~~objectivec
// Hide image node
[imageNode setVisible:NO];
~~~
