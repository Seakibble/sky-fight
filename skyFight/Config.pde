
public enum bodyShape {
  CIRCLE,
  RECTANGLE,
  POLYGON
};

public enum Identity {
  HUNTER,
  PLAYER,
  WEAPON,
  CHAIN,
  DEFAULT
};

class Config {
  public PVector position;
  public PVector size;
  public float radius;
  public ArrayList<Vec2> points;
  
  public BodyType type;
  public Box2DProcessing box;
  
  public float density;
  public float friction;
  public float restitution;
  
  public Identity identity; 
  public int health;
  
  public color colour;
  
  public Config(Box2DProcessing _boxRef, Identity _identity) {
    position = new PVector(width, height);
    identity = _identity;
    box = _boxRef;
    
    size = null;
    points = null;
    radius = 50;
    
    type = BodyType.DYNAMIC;
    health = 0;
    
    switch (identity) {
    case WEAPON:
      density = 3.0;
      friction = 0.01;
      restitution = 0.99;
      colour = color(0, 255, 200);
      break; 
      
    case PLAYER:
      density = 3.0;
      friction = 0.9;
      restitution = 0.00002;
      colour = color(55, 255, 255);
      break;
      
    case HUNTER:
      density = 1.5;
      friction = 0.9;
      restitution = 0.95;
      colour = color(110, 255, 255);
      break;
      
    case CHAIN:
      density = 3.0;
      friction = 0.99;
      restitution = 0.01;
      colour = color(150, 200, 255);
      break;
    
    default:
      density = 1.0;
      friction = 0.5;
      restitution = 0.3;
      colour = color(150, 0, 100);
    }
  }
}