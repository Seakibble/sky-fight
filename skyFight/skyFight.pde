/////////////////////////////
/////////////////////////////
////                     ////
////    SKY FIGHT        ////
////    by Max Leeming   ////
////    March 2018       ////
////                     ////
/////////////////////////////
/////////////////////////////

// Sorry about the mess :(

// Box2D stuff
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;

// Networking stuff
import oscP5.*;
import netP5.*;


// Variables
Box2DProcessing box;
ArrayList<CustomBody> staticBodies;

ArrayList<BackgroundParticle> bgParticles;
PVector gravity;

Game game;

int time;
Randomizer randomizer;

OscP5 mOSC;

void setup() 
{
  size(1280,720);
  colorMode(HSB);
  
  time = 0;
  gravity = new PVector(0, -9.8);
  
  bgParticles = new ArrayList<BackgroundParticle>();
  
  mOSC = new OscP5(this, "239.0.0.1", 7777);
  mOSC.plug(this, "setGravity", "/gravity");
  
  randomizer = new Randomizer();
  randomizer.update(0.05);
  
  initialize();
}

void initialize() {
  box = new Box2DProcessing(this);
  box.createWorld();
  gravity = new PVector(0, -9.8);
  box.setGravity(gravity.x, gravity.y * 4);
  box.listenForCollisions();
  
  game = new Game(box, new PVector(width/2, -200));
  
  staticBodies = new ArrayList<CustomBody>();
    
  float boundaryWidth = 500.0;  
  
  Config staticConfig = new Config(box, Identity.DEFAULT);
    staticConfig.type = BodyType.STATIC; 
  
    staticConfig.position = new PVector(-boundaryWidth, height / 2.0);
    staticConfig.size = new PVector(boundaryWidth * 2, height * 5);
  staticBodies.add(new CustomBody(staticConfig));
  
    staticConfig.position = new PVector(width + boundaryWidth, height / 2.0);
    staticConfig.size = new PVector(boundaryWidth * 2, height * 5);
  staticBodies.add(new CustomBody(staticConfig));
}

void draw() 
{
  if (bgParticles.size() < 40 && time % 30 == 0) {
    bgParticles.add(new BackgroundParticle(new PVector(gravity.x, -gravity.y)));
  }
  
  box.step();
  randomizer.update(0.002);
  
  background(randomizer.values.x * 100 + 50, randomizer.values.y * 100, randomizer.values.z * 105 + 150);  
  for (BackgroundParticle p:bgParticles) { p.draw(); }
  fill(randomizer.values.x * 100 + 50, randomizer.values.y * 100, randomizer.values.z * 105 + 150, 225);
  rect(width/2,height/2, width, height);
  
  game.draw();
}

void setGravity(float gravityX, float gravityY)
{
  for (BackgroundParticle p:bgParticles) {
    p.setGravity(new PVector(gravityX, gravityY));
  }
  
  gravity = new PVector(gravityX, -gravityY);
  box.setGravity(gravity.x, gravity.y);
  if (gravity.y > 0) {
    game.setPosition(new PVector(width/2, height+200));
  } else {
    game.setPosition(new PVector(width/2, -200));
  }
}

void mouseClicked() {
  if (game.gameOver) {
    initialize();
  }
  
  game.start();
}

void beginContact(Contact _cp)
{
  Fixture f1 = _cp.getFixtureA();
  Fixture f2 = _cp.getFixtureB();
  
  Body body1 = f1.getBody();
  Body body2 = f2.getBody();
  
  CustomBody obj1 = (CustomBody)body1.getUserData();
  CustomBody obj2 = (CustomBody)body2.getUserData();
  
  CustomBody attacker = null;
  CustomBody target = null;
  
  if (obj1.getIdentity() == Identity.WEAPON && (obj2.getIdentity() == Identity.HUNTER || obj2.getIdentity() == Identity.PLAYER)) {
    attacker = obj1;
    target = obj2;
  }
  
  if (obj2.getIdentity() == Identity.WEAPON && (obj1.getIdentity() == Identity.HUNTER || obj1.getIdentity() == Identity.PLAYER)) {
    target = obj1;
    attacker = obj2;
  }
  
  if (attacker != null && target != null && target.mConfig.health > 0) {
    target.mConfig.health--;
    target.damaged = true;
  }
  
  
}

void endContact(Contact cp)
{
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();
  
  CustomBody o1 = (CustomBody)b1.getUserData();
  CustomBody o2 = (CustomBody)b2.getUserData();
  
  CustomBody attacker = null;
  CustomBody target = null;
  
  if (o1.getIdentity() == Identity.WEAPON && (o2.getIdentity() == Identity.HUNTER || o2.getIdentity() == Identity.PLAYER)) {
    attacker = o1;
    target = o2;
  }
  
  if (o2.getIdentity() == Identity.WEAPON && (o1.getIdentity() == Identity.HUNTER || o1.getIdentity() == Identity.PLAYER)) {
    target = o1;
    attacker = o2;
  }
  
  if (attacker != null && target != null && target.mConfig.health > 0) {
    target.damaged = false;
  }
}