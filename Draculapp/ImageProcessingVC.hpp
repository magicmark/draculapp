//
//  ImageProcessingVC.h
//  Draculapp
//
//  Created by Avery Lamp on 9/4/15.
//  Copyright (c) 2015 magicmark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoSource.h"
#import "ImageProcessor.hpp"

@interface ImageProcessingVC : UIViewController <VideoSourceDelegate>{
    double lowHD, lowSD, lowVD, highHD, highSD,highVD;
    double lowH, lowS, lowV, highH, highS,highV;
    CGPoint touchPoint;
    
}

@property VideoSource* videoSource;


@end
