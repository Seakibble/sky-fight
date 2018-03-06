
// Networking stuff
import oscP5.*;
import netP5.*;

OscP5 mOSC;

PVector gravity;
float oneGee;
PVector center;
float scale;
float offset;
void setup() 
{
  scale = 8;
  center = new PVector(200, 200);
  oneGee = 9.8 * scale;
  gravity = new PVector(0, oneGee);
  offset = 25.0;
  size(450, 450);
  colorMode(HSB);
  
  mOSC = new OscP5(this, "239.0.0.1", 7777);
  
}

void draw()
{
  background(220);
  fill(40);
  pushMatrix();
    translate(offset, offset);
    pushMatrix();
      line(0, 0, center.x * 2, 0);
      translate(0, center.y);
      line(0, 0, center.x * 2, 0);
      translate(0, center.y);
      line(0, 0, center.x * 2, 0);
    popMatrix();
    
    pushMatrix();
      translate(center.x - 15, center.y - oneGee);
      line(0, 0, 30, 0);
      translate(0, oneGee * 2);
      line(0, 0, 30, 0);
    popMatrix();
    
    pushMatrix();
      translate(center.x - oneGee, center.y - 15);
      line(0, 0, 0, 30);
      translate(oneGee * 2, 0);
      line(0, 0, 0, 30);
    popMatrix();
    
    pushMatrix();
      line(0, 0, 0, center.y * 2);
      translate(center.x, 0);
      line(0, 0, 0, center.y * 2);
      translate(center.x, 0);
      line(0, 0, 0, center.y * 2);
    popMatrix();
    
    pushMatrix();
      translate(gravity.x + center.x, gravity.y + center.y);
      fill(100);
      ellipse(0, 0, 20, 20);
    popMatrix();
  popMatrix();
  
  text("Gravity: " + gravity.x / scale + ", " + -gravity.y / scale, offset, offset - 10);
}

void mouseDragged() {
  boolean sendMessage = false;
  if (mouseX > 0 && mouseX < center.x * 2) {
    gravity.x = mouseX - center.x - offset;
    sendMessage = true;
  }
  if (mouseY > 0 && mouseY < center.y * 2) {
    gravity.y = mouseY - center.y - offset;
    sendMessage = true;
  }
    
  if (sendMessage) {
    OscMessage oscMessage = new OscMessage("/gravity");
    
    oscMessage.add(gravity.x / scale);
    oscMessage.add(gravity.y / scale);
    
    mOSC.send(oscMessage);
  }
}