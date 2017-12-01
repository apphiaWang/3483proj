import blobscanner.*;
import gab.opencv.*;
import processing.video.*;

OpenCV oc;
Capture cam;
PImage blobs;
Detector bs;
PVector[] edgeCoordinates ;
int bn ;

PImage hand,dst;
ArrayList<Contour> contours;

//ArrayList<Contour> polygons;

void setup(){
  size(800,600);
  frameRate(10);
  hand =  loadImage("all.jpg");
  cam = new Capture(this, 320,240);
  cam.start();
  bs = new Detector(this,255);
  blobs = new PImage(320,240,RGB);
}

void draw(){
  
  if(cam.available()){
    cam.read();
   } 
   
   cam.loadPixels();
   blobs.loadPixels();
   
   
   arrayCopy(cam.pixels,blobs.pixels);
   blobs.updatePixels();
   
 
   
  image(cam,0,320);
  blobs.filter(GRAY);
  blobs.filter(BLUR);
  blobs.filter(THRESHOLD);
  
  /*
  bs.imageFindBlobs(cam);
  bs.loadBlobsFeatures();
  
  for(int x = 0; x < width; x++){
    for(int y = 0; y < height; y++){   
      if(bs.isBlob(x, y)){
        set(x, y, color(255,0,0));
      } 
      else {
         
        set(x, y,color(0));
      }
    } 
  }
  */
  
  //hand.filter(GRAY);
  //hand.filter(BLUR);
  //hand.filter(THRESHOLD);
  
  oc = new OpenCV(this, blobs);
  dst = oc.getOutput();

  contours = oc.findContours();
  
  scale(0.5);
  image(blobs, 0, 0);
  image(dst, blobs.width, 0);

  noFill();
  strokeWeight(3);
  
  for (Contour contour : contours) {
    stroke(0, 255, 0);
    contour.getPolygonApproximation().draw();
    
    stroke(255, 0, 0);
    contour.getConvexHull().draw();
  }
  //image(hand,0,0);
  
  
  //bs.imageFindBlobs(hand);
  //bs.loadBlobsFeatures();

  //draws the blob contour for the blob specified by bn
  //bs.drawBlobContour(bn,color(255, 0, 0),2);
  
  
  fill(0,255,255);
  strokeWeight(1);
  stroke(255,0,0);
  rect(500,500,20,20);
  ellipse(mouseX, mouseY, 3,3);
  println("mouseX"+mouseX+"mouseY"+mouseY);
  
}