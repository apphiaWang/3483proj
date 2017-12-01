import processing.video.*;
import java.awt.*;
import gab.opencv.*;


OpenCV opencv_face,opencv_hand;
Capture cam;
public static int RIGHT = 0;
public static int lEFT = 1;
int flag = RIGHT;
int posX = 20;
int posY = 20;
  
  
void setup() {
   size(640, 480);
  cam = new Capture(this, 320, 240);
  cam.start();
  opencv_face = new OpenCV( this ,320,240); // Initialises the OpenCV object
  opencv_face.loadCascade(OpenCV.CASCADE_FRONTALFACE); // Opens a video capture stream
  //opencv_face.loadCascade("fist.xml",false);
  opencv_hand=new OpenCV(this, 320, 240);
  opencv_hand.loadCascade("fist.xml",false);
}

void draw() {
  if (cam.available() == true) {
   cam.read();
   
  pushMatrix();
  scale(-1,1);
  opencv_face.loadImage(cam);    
  opencv_hand.loadImage(cam);
  
  if(flag == RIGHT) println("Right Hand USER");
  else println("left hand user");
  
  Rectangle[] faces = opencv_face.detect();
  Rectangle[] hands = opencv_hand.detect();
 
   image(cam, -cam.width-posX, posY);    
   noFill();    
   stroke(0,255,0);
   if (faces.length>0) {       
     for( int    i=0; i<faces.length; i++) {           
       rect(faces[i].x-cam.width-posX, faces[i].y+posY, faces[i].width, faces[i].height);  
       
     }     
   }
    
   stroke(255,0,0);
   if (hands.length>0) {       
     for( int i=0; i<hands.length; i++) {           
       rect(hands[i].x-cam.width-posX, hands[i].y+posY, hands[i].width, hands[i].height); 
     }     
   }
   
   if(faces.length>0 && hands.length>0){
     if(hands[0].x<faces[0].x) flag = RIGHT;
     else flag = LEFT;
   }
   
   popMatrix();
    //<>//
  }
} 