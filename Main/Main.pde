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


//MainScreen ms;

PFont ARB, IMP, Arial; //start screen title
PImage bkg, bkg2, raise, braise, pagefoot; //img
PImage lefthand, righthand, uphand, downhand; //hand img
PImage p1, p2, p3, p4, p5, p6; //slides

boolean successreg = false;
int currentPage = 0; //page
float transp = 0;
float x = 0;

void setup() {
  size(1000, 600);
  background(0);
  textAlign(CENTER, CENTER);
  ARB = loadFont("ARBERKLEY-48.vlw");
  IMP = loadFont("MonotypeCorsiva-48.vlw");
  Arial = loadFont("ArialMT-48.vlw");
  
  bkg = loadImage("background.jpg");
  bkg2 = loadImage("bkg2.jpg");
  raise = loadImage("raisinghand.png");
  braise = loadImage("blackraising.png");
  pagefoot = loadImage("pagefoot.png");
  
  lefthand = loadImage("lefthand.png");
  righthand = loadImage("righthand.png");
  
  p1 = loadImage("ppt1.jpg");
  p2 = loadImage("ppt2.jpg");
  p3 = loadImage("ppt3.jpg");
  p4 = loadImage("ppt4.jpg");
  p5 = loadImage("ppt5.jpg");
  p6 = loadImage("ppt6.jpg");
  
  
  
}

void draw(){
  println(mouseX, mouseY);
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
    
  } else if (currentPage == 1) {
    tint(255);
    fill(0);
    rect(0, 0, width, height);
    image(bkg2, 0, 0, width, height+100);
    Selection();
  }
}

void keyPressed() {
  if (keyCode == ENTER){
     if (currentPage == 0) currentPage = 1;
  }
  if (key == 'r') successreg = true;
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

void Selection() {
  noStroke();
  image(p2, width/2-400, 350, 142, 86); 
  image(p1, width/2-250, 135, 500, 300);
  
  //fill(175,173,173,200);
  //rect(width/2-125,80,250,400,20);
  //beginShape();
  //vertex(width/2 + 30, 100);
  //vertex(width/2 + 400, 120);
  //vertex(width/2 + 400, 400);
  //vertex(width/2 + 30, 420);
  //endShape();



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