//////////////////////////////////////////////////////////////
///////    CS3483 Multimodal interface design        /////////
///////                                              /////////
///////             Group Project                    /////////
///////      Gesture-Controlled Presentation         /////////
///////                                              /////////
///////     LI Shiying                      /////////
///////     WANG Yanfei                     /////////
///////     YANG Siyue                      /////////
//////////////////////////////////////////////////////////////
import java.awt.*;
import gab.opencv.*;
import processing.video.*;

OpenCV opencv;
Capture cam;

//camera
int camWidth = 320;
int camHeight = 240;


PGraphics glow;

PFont ARB, IMP, Arial, bold; //start screen title
PImage bkg, bkg2, raise, braise;//img cover
PImage pagefoot, pagefoot2, pagefoot3; //footpage img
PImage lefthand, righthand, uphand, downhand; //hand img
PImage setting, file; //icons
PImage glowselect;
PImage p1, p2, p3, p4, p5, p6; //slides
PImage timer, navigator, language, handmode;


boolean successreg = false; //the rasing hand image turns to green
boolean glue = false;  //to control the glue rect to display
boolean select = false;  //to show the select interface




int currentPage = 0; //page
float transp = 0;
int x = 0;

void setup() {
  size(1000, 600);
  background(0);
  textAlign(CENTER, CENTER);
  frameRate(70);
  
  cam = new Capture(this, camWidth, camHeight);
  cam.start();
  opencv = new OpenCV(this, camWidth, camHeight);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  ARB = loadFont("ARBERKLEY-48.vlw");
  IMP = loadFont("MonotypeCorsiva-48.vlw");
  Arial = loadFont("ArialMT-48.vlw");
  bold = loadFont("Arial-BoldMT-48.vlw");
  
  bkg = loadImage("background.jpg");
  bkg2 = loadImage("bkg2.jpg");
  raise = loadImage("raisinghand.png");
  braise = loadImage("blackraising.png");
  pagefoot = loadImage("pagefoot.png");
  pagefoot2 = loadImage("pagefoot2.png");
  pagefoot3 = loadImage("pagefoot3.png");
  
  setting = loadImage("gearwheel.png");
  file = loadImage("fileselect.png");
  glowselect = loadImage("glowselect.png");
  
  lefthand = loadImage("lefthand.png");
  righthand = loadImage("righthand.png");
  uphand = loadImage("stophand.png");
  
  p1 = loadImage("ppt1.jpg");
  p2 = loadImage("ppt2.jpg");
  p3 = loadImage("ppt3.jpg");
  p4 = loadImage("ppt4.png");
  p5 = loadImage("ppt5.jpg");
  p6 = loadImage("ppt6.jpg");
  
  timer = loadImage("timer.png");
  navigator = loadImage("navigator.png");
  language = loadImage("language.png");
  handmode = loadImage("handmode.png");

  glow = createGraphics(width, height, JAVA2D);
  glow.beginDraw();
  glow.smooth();
  glow.noStroke();
  glow.fill(255);
  glow.rect(width/2-260, 125, 520, 320);
  glow.filter(BLUR,6);
  glow.image(p4, width/2-250, 135, 500, 300);
  glow.endDraw();
  
  
 
}

void draw(){
  frameRate(70);
  //println(frameRate);
  println(currentPage);
  //the first page 
  if (currentPage == 0) {
    //Re-design start page
    transp ++;
    textFont(ARB, 60);
    fill(255-transp*2);
    text("Gesture-Controlled Presentation", width/2, height/2);
    textFont(IMP, 30);
    text("Free your hand and free your mind", width/2, height/2 + 80);
 
    //select hand mode
    if (transp*2 > 255) {
      tint(200);
      image(bkg, 0, 0, width, height);
      Cover();
    }
    
  } 
  else if (currentPage == 1) {
    frameRate(70);
    tint(255);
    fill(0);
    rect(0, 0, width, height);
    image(bkg2, 0, 0, width, height+100);
    //select practice or presentation mode
    ModeSelection();
  }
  else if (currentPage == 2) {
    frameRate(70);
    tint(255);
    fill(0);
    rect(0, 0, width, height);
    image(bkg2, 0, 0, width, height+100);
    //settings
    Settings();
  }
  else if (currentPage == 3) {
    frameRate(70);
    tint(255);
    fill(0);
    rect(0, 0, width, height);
    image(bkg2, 0, 0, width, height+100);
    Practice();
  }
}

void keyPressed() {
  if (keyCode == ENTER) currentPage++;
  //if (key == '0') currentPage = 0;
  //if (key == '1') currentPage = 1;
  //if (key == '2') currentPage = 2;
  //if (key == '3') currentPage = 3;

  if (currentPage == 0) {
    if(key == 'r') successreg = true; //if the hand is detect, 
  }
  else if (currentPage == 1) {
    if(key == 'g') glue = true; //add white glow rect to the current file
    if(key == 's') select = true; //change to the mode selection mode
  }
  else if (currentPage == 2) {
    
  }
}

void Cover() {
  //footpage 
  tint(255);
  image(pagefoot, 870, 470, 150, 150);
  stroke(255);
  fill(0);
  triangle(904,600,1000,600,1000,505);
  //hand
  tint(230);
  image(righthand, 925,550,80,50);
  fill(200);
  textFont(Arial, 20);
  text("Show your index finger   Turn to the next page", 500, 570);
  //blocks
  noStroke();
  fill(175,173,173,200);
  rect(100,80,350,400,20);
  rect(550,80,350,400,20);
  //border
  stroke(247,247,247,200);
  noFill();
  rect(105,85,340,390,20);
  rect(555,85,340,390,20);
  //text
  textFont(ARB, 40);
  fill(255);
  text("Gesture-Controlled", 275, 160);
  text("Presentation", 275, 200);
  textFont(IMP, 30);
  text("Free your hand!", 275, 380);
  text("Free your mind!", 275, 420);
  textFont(IMP,35);
  text("Please raise your", 725, 150);
  fill(25);
  textFont(IMP,45);
  text("Dominant Hand", 725, 195); 
  fill(255);
  textFont(IMP,35);
  text("to set the hand mode", 725, 240);
  tint(255);     
  if (successreg) {
    image(raise, 650, 268, 140, 175);
    fill(145,255,82); //green
    textFont(Arial, 15);
    text("Right hand detected!", 725, 457);
  }
  else image(braise, 650, 268, 140, 175);
}

void Tutorial() {
  noStroke();
  for(int i = 1; i<600; i +=10 ){
    fill(i/4);
    rect(0,i,width,10);
  }
}

void ModeSelection() {
  //files
  noStroke();
  image(p1, 120, 420, 142, 86); 
  image(p2, 180, 380, 142, 86); 
  image(p5, 740, 420, 142, 86); 
  image(p3, 700, 380, 142, 86);
  if(glue) image(glow, 0, 0);
  else image(p4, width/2-250, 135, 500, 300);
  //footpage 
  tint(255);
  image(pagefoot2, 870, -30, 150, 150);
  stroke(255);
  fill(0);
  triangle(904,-1,1000,-1,1000,96);
  tint(225);
  image(setting, 951, 10, 40, 40);
  
  //hand
  fill(0);
  
  tint(230);
  image(righthand, width/2 + 100,550,80,50);
  image(lefthand, width/2 - 180,550,80,50);
  tint(245);
  image(uphand, width/2 - 20, 480, 40, 40);
  if (select) {
    x++;
    image(glowselect, 0, 0);
    image(glow, min(5*x, 250), 0, max(1000-10*x,500), max(600-6*x, 300));
    //plane
    strokeWeight(5);
    stroke(225,225,225, min(2*x, 255));
    fill(175,173,173, min(-50+5*x, 200));
    ellipse(width/2-300,380,300,300);
    ellipse(width/2+300,380,300,300);
    ellipse(width/2-300,380,150,150);
    ellipse(width/2+300,380,150,150);
    //text
    line(87,283,142,329);
    line(313,283,256,329);
    line(687,283,744,329);
    line(913,283,855,329);
    line(87,477,142,430);
    line(313,477,256,430);
    line(687,477,744,430);
    line(913,477,855,433);
    fill(255,255,255, min(2*x, 255));
    textFont(ARB, 26);
    text("Presentation", width/2-300, 380);
    text("Practice", width/2+300, 380);
    textFont(ARB, 20);
    text("Navigator", width/2-300, 270);
    text("Navigator", width/2+300, 270);
    text("Language", width/2-300, 484);
    text("Language", width/2+300, 484);
    text("Hand", 86, 358);
    text("Mode", 86, 387);
    text("Hand", 686, 358);
    text("Mode", 686, 387);
    text("Timer", 313, 374);
    text("Timer", 911, 374); 
  }
  
  //fill(175,173,173,200);
  //rect(width/2-125,80,250,400,20);
  //beginShape();
  //vertex(width/2 + 30, 100);
  //vertex(width/2 + 400, 120);
  //vertex(width/2 + 400, 400);
  //vertex(width/2 + 30, 420);
  //endShape();
}

void Settings () {
  //footpage 
  //line(width/2, 0, width/2, 600);
  tint(255);
  image(pagefoot3, -15, 470, 150, 150);
  stroke(255);
  fill(0);
  triangle(-1,500,100,600,-1,600);
  image(file, 16, 551, 40, 40);
  
  //icons
  image(timer, width/2 - 280, 140, 100, 90);
  image(language, width/2 + 200, 140, 100, 90);
  image(navigator, width/2 - 280, 375, 110, 90);
  image(handmode, width/2 + 210, 385, 80, 70);
  
  //text
  fill(255);
  textFont(bold, 26);
  text("Timer", 265, 247);
  text("Language", 750, 247);
  text("Navigator", 265, 480);
  text("Hand mode", 750, 480);
}

void Timer() {}

void Navigator() {}

void Language() {}

void Handmode() {}

void Practice() {
  strokeWeight(1);
  //footpage 
  tint(255);
  image(pagefoot2, 870, -30, 150, 150);
  stroke(255);
  fill(0);
  triangle(904,-1,1000,-1,1000,96);
  tint(225);
  image(setting, 951, 10, 40, 40);
  
  fill(125,125,125,200);
  rect(10, 40, 170, 300, 12);
  rect(190, 40, 170, 300, 12);
  //rect(10, 345, 350, 250, 12);
  image(p4, 20, 54, 150, 90);
  image(p4, 20, 150, 150, 90);
  image(p4, 20, 245, 150, 90);
  
  image(p4, 380, 170, 600, 350);
  
  rect(385, 122, 190, 40, 12); 
  rect(590, 122, 190, 40, 12); 
  rect(790, 122, 190, 40, 12);
  
  //rect(790, 549, 190, 40, 12);
  
  //text
  fill(255);
  textFont(Arial, 18);
  text("Progress: 6/30", 487, 145);
  text("10:20", 685, 145);
  text("Next Speaker: David", 887, 145);
  
  textFont(bold, 18);
  text("Mode: Practice", 900, 555); 

  if (cam.available() == true) cam.read();
  opencv.loadImage(cam);
  image(cam, 25, 350);
}

void Presentation() {






}

//void polygon(float x, float y, float radius, int npoints) {
//  float angle = TWO_PI / npoints;
//  beginShape();
//  for (float a = 0; a < TWO_PI; a += angle) {
//    float sx = x + cos(a) * radius;
//    float sy = y + sin(a) * radius;
//    vertex(sx, sy);
//  }
//  endShape(CLOSE);
//}