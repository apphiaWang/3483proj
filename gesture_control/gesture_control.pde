import processing.video.*;
import java.awt.*;
import gab.opencv.*;
import blobscanner.*;

OpenCV opencv;
Capture cam;
PImage temp;
PImage src;

OpenCV opencv_face,opencv_hand;
public static int RIGHT = 0;
public static int lEFT = 1;
int flag = RIGHT;
int posX = 20;
int posY = 20;

int select = 0;

public static int FILE= 0;
public static int SET = 1;
public static int TUT = 2;
  
void setup() {
   size(1000, 800);
   frameRate(1);
  cam = new Capture(this, 320, 240);
  cam.start();
  opencv_face = new OpenCV( this ,320,240); // Initialises the OpenCV object
  opencv_face.loadCascade(OpenCV.CASCADE_FRONTALFACE); // Opens a video capture stream
  opencv_hand=new OpenCV(this, 320, 240);
  opencv_hand.loadCascade("fist.xml",false);
}

void draw() {
  if (cam.available() == true) {
   cam.read();
   
  
  opencv_face.loadImage(cam);    
  opencv_hand.loadImage(cam);
  
  if(flag == RIGHT) println("Right Hand USER");
  else println("left hand user");
  
  Rectangle[] faces = opencv_face.detect();
  Rectangle[] hands = opencv_hand.detect();
  Point cursor = new Point();
  
  if(hands.length==1){
    cursor.x = 3*(340-hands[0].x-hands[0].width/2);
    cursor.y = 3*(20+hands[0].y+hands[0].height/2);
  }
  
  pushMatrix();
  scale(-1,1);
   image(cam, -cam.width-posX, posY);    
   noFill();    
   stroke(0,255,0);
   if (faces.length>0)        
     for( int    i=0; i<faces.length; i++)            
       rect(faces[i].x-cam.width-posX, faces[i].y+posY, faces[i].width, faces[i].height);  
     
   stroke(255,0,0);
   if (hands.length>0)        
     for( int i=0; i<hands.length; i++)            
       rect(hands[i].x-cam.width-posX, hands[i].y+posY, hands[i].width, hands[i].height); 
 
   if(faces.length>0 && hands.length>0)
     if(hands[0].x<faces[0].x) flag = RIGHT;
     else flag = LEFT;
   
   popMatrix();
   scale(1,1);
   fill(255,255,0);
   stroke(0,0,255);
   strokeWeight(2);
   ellipse(cursor.x,cursor.y,2,2);
   println(cursor.x+"  "+cursor.y);
   
   if(cursor.x>850) select = SET;
   else if(cursor.x>600) select = FILE;
   else select = TUT;
   
   println(""+select);
   
   
   
   //Specific gesture detection for ok ok
   PImage fuck = new PImage(320,2409,RGB);
   ArrayList<Contour> contours = opencv_hand.findContours();
  // OKGestureDetector ok = new OKGestureDetector(fuck,contours.get(1));
   
   //if (ok.detect()==false) println("suceed");
   
   
  }
} 