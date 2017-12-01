import gab.opencv.*;
import processing.video.*;

import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.imgproc.Imgproc;

ArrayList<Contour> contours;
OpenCV opencv;
PImage src,dst, hist, histMask;
Capture cam;

Mat skinHistogram;

void setup(){
  cam = new Capture(this,320,240);
  cam.start();
  src = new PImage(320,240,RGB);
  size(1336, 360);
  
}

 // in BGR
Scalar colorToScalar(color c){
  return new Scalar(blue(c), green(c), red(c));
}


void draw(){
  if(cam.available()){
    cam.read();
    detectGesture();
  }
}

void detectGesture(){
  removeBackground();//not effective, discard
  detectSkin();
  detectHand();
  
}
  
void removeBackground(){
  
}
void detectSkin(){
     src.loadPixels();
  cam.loadPixels();
  arrayCopy(cam.pixels,src.pixels);
  src.updatePixels();
  
  image(cam,0,0);
  
  opencv = new OpenCV(this, src, true);  
  skinHistogram = Mat.zeros(256, 256, CvType.CV_8UC1);
  Core.ellipse(skinHistogram, new Point(113.0, 155.6), new Size(40.0, 25.2), 43.0, 0.0, 360.0, new Scalar(255, 255, 255), Core.FILLED);

   histMask = createImage(256,256, ARGB);
   opencv.toPImage(skinHistogram, histMask);
 
   dst = opencv.getOutput();
   dst.loadPixels();
 
 for(int i = 0; i < dst.pixels.length; i++){
    
    Mat input = new Mat(new Size(1, 1), CvType.CV_8UC3);
    input.setTo(colorToScalar(dst.pixels[i]));
    Mat output = opencv.imitate(input);
    Imgproc.cvtColor(input, output, Imgproc.COLOR_BGR2YCrCb );
    double[] inputComponents = output.get(0,0);
    if(skinHistogram.get((int)inputComponents[1], (int)inputComponents[2])[0] > 0){
      dst.pixels[i] = color(255);
    } else {
      dst.pixels[i] = color(0);
    }
 }
 
 dst.updatePixels();
 
 
 OpenCV oc = new OpenCV(this, dst);
 contours = oc.findContours();
  


  noFill();
  strokeWeight(3);
  
  for (Contour contour : contours) {
    
    if(contour.area()>3600&&contour.area()<22500){
    stroke(0, 255, 0);
    contour.getPolygonApproximation().draw();
    
    stroke(255, 0, 0);
    contour.getConvexHull().draw();
    }
  }
  
  fill(0,255,255);
  strokeWeight(1);
  stroke(255,0,0);

  
  
  image(cam,0,src.height);
  image(dst, src.width, 0); 
  }
  
void detectHand(){
}