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
Movie movie;

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
boolean nextFile = false; //to choose the next file in file selection
boolean lastFile = false;
boolean practice = false;
boolean presen = false;
boolean rolling = false; //tutorial rolling plane
boolean selectfile = false;

int currentPage = 1; //page
float transp = 0;
int x = 0;
int chooseFileCount = 0;
int rollingCount = 0;
int largeCount = 0;

void setup() {
  size(1000, 600);
  background(0);
  textAlign(CENTER, CENTER);
  frameRate(70);
  
  cam = new Capture(this, camWidth, camHeight);
  cam.start();
  opencv = new OpenCV(this, camWidth, camHeight);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  movie = new Movie(this, "moivefile.MP4");
  movie.loop();
  
  ARB = loadFont("ARBERKLEY-48.vlw");
  IMP = loadFont("Calibri-48.vlw");
  Arial = loadFont("ArialMT-48.vlw");
  bold = loadFont("ArialRoundedMTBold-48.vlw");
  
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
  println(mouseX, mouseY);
  //println(nextFile);
  frameRate(70);
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
    Tutorial();
  }
  else if (currentPage == 2){
    tint(255);
    noStroke();
    fill(255);
    rect(0, 0, width, height);
    Menu();  
  }
  else if (currentPage == 3) {
    frameRate(70);
    tint(255);
    noStroke();
    fill(64);
    rect(0, 0, width, height);
    ModeSelection();
  }
  else if (currentPage == 4) {
    frameRate(70);
    tint(255);
    fill(255);
    rect(0, 0, width, height);
    Settings();
  }
  else if (currentPage == 5) {
    frameRate(70);
    tint(255);
    fill(64);
    rect(0, 0, width, height);
    Practice();
  }
  
}

void movieEvent(Movie m) {
     m.read();
}

void keyPressed() {
  //if (keyCode == ENTER) currentPage++;
  if (keyCode == DOWN) currentPage++;
  if (keyCode == UP) currentPage--;

  if (currentPage == 0) {
    if (key == 'r') successreg = true; //if the hand is detect, 
  }
  else if (currentPage == 1) {
    if (keyCode == RIGHT) rolling = true; rollingCount = 0;
  }
  else if (currentPage == 2) {
    largeCount = 0;
    select = false;
    if (key == 's') {
      selectfile = true; 
    }
  }
  else if (currentPage == 3) {
    if(key == 'g') glue = true; //add white glow rect to the current file
    if(key == 's') {
      select = true; //change to the mode selection mode
    }
    if(!select){
      if(key == 't') currentPage = 4;
      if(keyCode == RIGHT) nextFile = true;
      if(keyCode == LEFT) {
        lastFile = true;
        nextFile = false;
        chooseFileCount = 0;
      }
    }
    else if(select){
      if (keyCode == RIGHT) practice = true; presen = false;
      if (keyCode == LEFT) presen = true; practice = true;
      if (keyCode == ENTER) currentPage = 5;
    }
  }
  else if (currentPage == 5) {
    if (key == 't') currentPage = 4;
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
  fill(65);
  rect(0,0,width,height);
  //big white ellipse
  fill(255);
  ellipse(30, height/2, height+80, height+80);
  
  //footpage 
  tint(255);
  image(pagefoot, 870, 470, 150, 150);
  stroke(255);
  fill(0);
  triangle(904,600,1000,600,1000,505);
  //hand
  tint(230);
  image(righthand, 925,550,80,50);
  
  image(movie, 260+150+30, 100, 500, 300);
  
  
  
  if (rolling) rollingCount= rollingCount +2;
  fill(65);
  ellipse(max(260-rollingCount,210), max(height/2-3*rollingCount, height/2-150), max(150-rollingCount,100),  max(150-rollingCount,100));
  ellipse(max(210-1.7*rollingCount,110), max(height/2-150-1.5*rollingCount, 65), 100, 100);
  ellipse(max(110-2*rollingCount, -100), max(65-2*rollingCount, -100), 100, 100);
  ellipse(min(210+rollingCount,260), max(height/2+150-3*rollingCount, height/2), min(100+rollingCount,150),  min(100+rollingCount,150));
  ellipse(min(110+1.7*rollingCount,210), max(height/2+235-1.7*rollingCount, height/2+150), 100, 100);
  ellipse(min(-100+3*rollingCount, 110), max(700-3*rollingCount, height/2+235), 100, 100);
  //text
  fill(255);
  textFont(IMP, constrain(23-rollingCount,17, 23));
  text("Presentation", max(260-rollingCount,210), max(height/2-10-3*rollingCount, height/2-10-150));
  text("Demo", max(260-rollingCount,210), max(height/2+10-3*rollingCount, height/2-150+10));
  textFont(IMP, 17);
  text("Feature", max(210-1.7*rollingCount,110), max(height/2-10-150-1.5*rollingCount, 65-10));
  text("Demo", max(210-1.7*rollingCount,110), max(height/2-150+10-1.5*rollingCount, 65+10));
  textFont(IMP, constrain(17+rollingCount, 17, 23));
  text("Customize", min(210+rollingCount,260), max(height/2+150-10-3*rollingCount, height/2-10));
  text("setting",  min(210+rollingCount,260), max(height/2+150+10-3*rollingCount, height/2+10));
  textFont(IMP, 17);
  text("Quick", max(110-2*rollingCount, -100), max(65-10-2*rollingCount, -100));
  text("Start", max(110-2*rollingCount, -100), max(65+10-2*rollingCount, -100));
  textFont(IMP, 17);
  text("File", min(110+1.7*rollingCount,210), max(height/2+235-10-1.7*rollingCount, height/2+150-10));
  text("Management", min(110+1.7*rollingCount,210), max(height/2+235+10-1.7*rollingCount, height/2+150+10));
  text("Quick", min(-100+3*rollingCount, 110), max(700-3*rollingCount-10, height/2+235-10));
  text("Start", min(-100+3*rollingCount, 110), max(700-3*rollingCount+10, height/2+235+10));  
}

void Menu(){
  stroke(175);
  strokeWeight(1);
  noFill();
  pushMatrix();
  polygon(190, 480, 40, 6, true);  
  polygon(190, 550, 40, 6, true);
  polygon(250, 514, 40, 6, true);
  polygon(250, 514, 40, 6, true);
  polygon(310, 548, 40, 6, true);
  polygon(310, 548-70, 40, 6, true);
  polygon(110, 770, 40, 6, true);
  polygon(170, 804, 40, 6, true);
  polygon(170, 734, 40, 6, true);
  popMatrix();
 
  fill(64);
  textFont(IMP, 30);
  text("Gesture-Controlled", 235, 240);
  textFont(IMP, 45);
  text("Presentation", 235, 285);
  textFont(bold, 80 );
  text("GCP3", 235, 370);
  textFont(IMP, 30);
  text("Free your hand!", 235, 450);
  text("Free your mind!", 235, 490);
  
  fill(64);
  pushMatrix();
  //translate(width*0.8, height*0.5);
  polygon(230, 650, 120, 6, true);  // Heptagon
  polygon(400, 530, 80, 6, true); 
  polygon(420, 780, 100, 6, true);
  popMatrix();
  
  //text
  fill(255);
  textFont(IMP, 40);
  text("Select", 650, 210);
  text("File", 650, 260);
  text("Setting", 780, 420);
  textFont(IMP, 30);
  text("Tutorial", 530, 400);
  
  if (selectfile) {
    largeCount++;
    noStroke();
    fill(64);
    pushMatrix();
    polygon(230, 650, 120+10*largeCount, 6, true);  // Heptagon
    popMatrix();
    fill(255);
    textFont(IMP, 40+5*largeCount);
    if (largeCount < 50) {
      text("Select", 650, 210);
    } else {
      currentPage = 3;
      selectfile = false;
    }
  }
}


void ModeSelection() {
  //files
  noStroke();
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
  
  //interaction of choosing the left and right file
  if (nextFile || lastFile){
  
    if (nextFile) {
      chooseFileCount = chooseFileCount + 2;
      image(p5, constrain(width-80-142-6*chooseFileCount, 80, width-80-142), 275, 142, 86);
      image(p3, constrain(width/2+250-130+2*chooseFileCount, width/2+250-130,width-80-142), constrain(250+chooseFileCount,250,275), constrain(230-2*chooseFileCount, 142, 230), constrain(130-chooseFileCount,86, 130));  
      image(p4, constrain(width/2-250+3*chooseFileCount,width/2-250,width/2+250-130), constrain(135+chooseFileCount,135,250),constrain(500-2*chooseFileCount, 230, 500), constrain(300-1.5*chooseFileCount, 130,300));  
      //image(glow, min(5*x, 250), 0, max(1000-10*x,500), max(600-6*x, 300));  
      image(p1, constrain(80+2*chooseFileCount, 80, 150), constrain(275-chooseFileCount,250,275), constrain(142+2*chooseFileCount, 142, 230), constrain(86+chooseFileCount,86,130)); 
      image(p2, constrain(150+2*chooseFileCount, 150, width/2-250), constrain(250-chooseFileCount,135,250), constrain(230+2.5*chooseFileCount,230,500), constrain(130+2*chooseFileCount,130,300));     
    } 
    if (lastFile) {
      chooseFileCount = chooseFileCount + 2;
      //image(p3, constrain(width-80-142-5*chooseFileCount, 80, width-80-142), 275, 142, 86);
      //image(p4, constrain(width/2+250-130+2*chooseFileCount, width/2+250-130,width-80-142), constrain(250+chooseFileCount,250,275), constrain(230-2*chooseFileCount, 142, 230), constrain(130-chooseFileCount,86, 130));  
      //image(p2, constrain(width/2-250+3*chooseFileCount,width/2-250,width/2+250-130), constrain(135+chooseFileCount,135,250),constrain(500-2*chooseFileCount, 230, 500), constrain(300-1.5*chooseFileCount, 130,300));  
      ////image(glow, min(5*x, 250), 0, max(1000-10*x,500), max(600-6*x, 300));  
      //image(p5, constrain(80+2*chooseFileCount, 80, 150), constrain(275-chooseFileCount,250,275), constrain(142+2*chooseFileCount, 142, 230), constrain(86+chooseFileCount,86,130)); 
      //image(p1, constrain(150+2*chooseFileCount, 150, width/2-250), constrain(250-chooseFileCount,135,250), constrain(230+2.5*chooseFileCount,230,500), constrain(130+2*chooseFileCount,130,300)); 
      image(p5, constrain(80+5*chooseFileCount, 80, width-80-142), 275, 142, 86); 
      image(p1, constrain(150-chooseFileCount, 80, 150), constrain(250+chooseFileCount,250, 275), constrain(230-2.5*chooseFileCount,142,230), constrain(130-2*chooseFileCount,86,130));   
      image(p3, constrain(width-80-142-chooseFileCount, width/2+250-130, width-80-142), constrain(275-chooseFileCount,250,275), constrain(142+2.5*chooseFileCount,142,230), constrain(86+2*chooseFileCount,86,130));
      image(p2, constrain(width/2-250-3*chooseFileCount, 150, width/2-250), constrain(135+chooseFileCount,135,250),constrain(500-2*chooseFileCount, 230, 500), constrain(300-1.5*chooseFileCount,130,300));  
      image(p4, constrain(width/2+250-130-2*chooseFileCount,width/2-250,width/2+250-130), constrain(250-chooseFileCount,135,250), constrain(230+2*chooseFileCount, 230, 500), constrain(130+2*chooseFileCount,130,300));  
      if(glue) image(glow, 0, 0);  
   }
  
  }
  else {
    chooseFileCount = 0;
    image(p5, width-80-142, 275, 142, 86);
    image(p3, width/2+250-130,250,230,130);
    image(p1, 80, 275, 142, 86);
    image(p2, 150, 250, 230, 130); 
    if(glue) image(glow, 0, 0);   else image(p4, width/2-250,135,500,300);
  }
  
  if (select) {
    x++;
    image(glowselect, 0, 0);
    image(glow, min(5*x, 250), 0, max(1000-10*x,500), max(600-6*x, 300));
    //plane
    choosePlane(x, 0);
    if (practice) choosePlane(255, 2);
    if (presen) choosePlane(255,1);
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
  //tint(255);
  //image(pagefoot3, -15, 470, 150, 150);
  //stroke(255);
  //fill(0);
  //triangle(-1,500,100,600,-1,600);
  //image(file, 16, 551, 40, 40);
  
  //footpage 
  tint(255);
  image(pagefoot2, 870, -30, 150, 150);
  stroke(255);
  fill(0);
  triangle(904,-1,1000,-1,1000,96);
  tint(225);
  image(setting, 951, 10, 40, 40);
  
  //polygon
  fill(64);
  noStroke();
  polygon(350, 300, 300, 6, false);
  polygon(650, 80, 65, 6, false); 
  polygon(730, 220, 65, 6, false); 
  polygon(650, 520, 65, 6, false); 
  polygon(730, 380, 65, 6, false); 
  //icons
  noStroke(); 
  tint(255);
  image(timer, 613, 35, 80, 70);
  image(language, 700, 175, 80, 70);
  image(navigator, 690, 335, 90, 80);
  image(handmode, 615, 475, 80, 70);
  //text
  fill(255);
  textFont(IMP, 23);
  text("Timer", 650, 115);
  textFont(IMP, 18);
  text("Language", 730, 256);
  text("Navigator", 733, 415);
  text("Hand mode", 650, 555);
}

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
  
  textFont(IMP, 18);
  text("Mode: Practice", 900, 555); 

  if (cam.available() == true) cam.read();
  opencv.loadImage(cam);
  image(cam, 25, 350);
}

void Presentation() {
}

void choosePlane(int x, int pcolor) {
  strokeWeight(5);
  stroke(225,225,225, min(3*x, 255));
  if (pcolor == 0)  {
    fill(175,173,173, min(-50+5*x, 200)); 
    //left 
    ellipse(width/2-300,380,300,300);
    ellipse(width/2-300,380,150,150);
    line(87,283,142,329);
    line(313,283,256,329);
    line(87,477,142,430);
    line(313,477,256,430);
    //right
    ellipse(width/2+300,380,300,300);
    ellipse(width/2+300,380,150,150);
    line(687,283,744,329);
    line(913,283,855,329);
    line(687,477,744,430);
    line(913,477,855,433);
  }
  else if (pcolor == 1) {
    fill(63,60,76);
    //left 
    ellipse(width/2-300,380,300,300);
    ellipse(width/2-300,380,150,150);
    line(87,283,142,329);
    line(313,283,256,329);
    line(87,477,142,430);
    line(313,477,256,430);
    fill(175,173,173, min(-50+5*x, 200)); 
    //right
    ellipse(width/2+300,380,300,300);
    ellipse(width/2+300,380,150,150);
    line(687,283,744,329);
    line(913,283,855,329);
    line(687,477,744,430);
    line(913,477,855,433);
  } 
  else if (pcolor == 2) {
    fill(175,173,173, min(-50+5*x, 200)); 
    //left 
    ellipse(width/2-300,380,300,300);
    ellipse(width/2-300,380,150,150);
    line(87,283,142,329);
    line(313,283,256,329);
    line(87,477,142,430);
    line(313,477,256,430);
    fill(175,173,173, min(-50+5*x, 200)); 
    fill(63,60,76);
    //right
    ellipse(width/2+300,380,300,300);
    ellipse(width/2+300,380,150,150);
    line(687,283,744,329);
    line(913,283,855,329);
    line(687,477,744,430);
    line(913,477,855,433);
  }
  //text
  fill(255,255,255, min(3*x, 255));
  textFont(IMP, 26);
  text("Presentation", width/2-300, 380);
  text("Practice", width/2+300, 380);
  textFont(IMP, 20);
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

void polygon(float x, float y, float radius, int npoints, boolean vertical) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    if(vertical) vertex(sy, sx);
    else vertex(sx, sy);
  }
  endShape(CLOSE);
}