abstract class  GestureDetector{
  Detector blob;
  PImage image;
  Contour ct;
  
  public GestureDetector(PImage src, Contour contour){
    
    image = new PImage(src.width,src.height,RGB);
    image.loadPixels();
    
    for(int k = 0; k <src.pixels.length; k++)
        image.pixels[k] = src.pixels[k];
     
     ct = contour;
  }
  
  public abstract boolean detect();
  

  
}