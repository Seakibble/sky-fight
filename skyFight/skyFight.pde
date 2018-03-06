// Box2D stuff
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import org.jbox2d.dynamics.joints.*;

Box2DProcessing box;
ArrayList<CustomBody> staticBodies;

Deployer deployer;

Randomizer randomizer;

// Networking stuff
import oscP5.*;
import netP5.*;

OscP5 mOSC;

void setup() 
{
  size(1280,720);
  colorMode(HSB);
  
  mOSC = new OscP5(this, "239.0.0.1", 7777);
  mOSC.plug(this, "setGravity", "/gravity");
  
  randomizer = new Randomizer();
  randomizer.update(0.05);
  
  box = new Box2DProcessing(this);
  box.createWorld();
  box.setGravity(0, -9.8 * 4);
  box.listenForCollisions();
  
  deployer = new Deployer(box, new PVector(width/2, -200));
  
  staticBodies = new ArrayList<CustomBody>();
  
  
  float boundaryWidth = 500.0;  
  
  Config staticConfig = new Config(box, Identity.DEFAULT);
    staticConfig.type = BodyType.STATIC; 
  
    staticConfig.position = new PVector(-boundaryWidth, height / 2.0);
    staticConfig.size = new PVector(boundaryWidth * 2, height * 3);
  staticBodies.add(new CustomBody(staticConfig));
  
    staticConfig.position = new PVector(width + boundaryWidth, height / 2.0);
    staticConfig.size = new PVector(boundaryWidth * 2, height * 3);
  staticBodies.add(new CustomBody(staticConfig));
}

void draw() 
{
  randomizer.update(0.002);
  background(randomizer.values.x * 100 + 50, randomizer.values.y * 100, randomizer.values.z * 105 + 150);
  
  box.step();
  
  deployer.draw();
  
  for(CustomBody b:staticBodies) {
    b.draw();
  }
}

void setGravity(float gravityX, float gravityY)
{
  box.setGravity(gravityX, -gravityY);
  if (gravityY < 0) {
    deployer.setPosition(new PVector(width/2, height+200));
  } else {
    deployer.setPosition(new PVector(width/2, -200));
  }
}

void beginContact(Contact cp)
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
    target.mConfig.health--;
  }
  
  
}

void endContact(Contact cp)
{
  //
}