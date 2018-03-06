class CustomBody 
{
  // Generic Members
  private Body mBody;
  private bodyShape mShape;
  
  private Config mConfig;
  boolean isDead;
     
  public CustomBody(Config _config) {
    isDead = false;
    mConfig = _config;
    if (mConfig.identity == Identity.HUNTER) {
      mConfig.health = 30;
    } else if (mConfig.identity == Identity.PLAYER) {
      mConfig.health = 50;
    }
    
    if (mConfig.box == null) {
      print("ERROR: No box reference provided");
    }
    
    if (mConfig.size != null) {
      mShape = bodyShape.RECTANGLE;
    } else if (mConfig.points != null) {
      mShape = bodyShape.POLYGON;
    } else if (mConfig.radius > 0) {
      mShape = bodyShape.CIRCLE;    
    } else {
      print("ERROR: No shape defined!");
    }
    initialize();
  }
  
  private void initialize() {    
    BodyDef bodyDefinition = new BodyDef();
    bodyDefinition.type    = mConfig.type;    

    // Set body type
    if (mConfig.type == BodyType.STATIC) {
      bodyDefinition.position.set(mConfig.box.coordPixelsToWorld(mConfig.position.x, mConfig.position.y));
    } else {
      bodyDefinition.position = mConfig.box.coordPixelsToWorld(mConfig.position.x, mConfig.position.y);
    }
    mBody = mConfig.box.world.createBody(bodyDefinition);
    mBody.setUserData(this);
    
    // Body properties
    switch(mShape) {
    case CIRCLE:
      CircleShape circleShape = new CircleShape();
      circleShape.m_radius    = mConfig.box.scalarPixelsToWorld(mConfig.radius);
      
      setFixtureDef(circleShape);
      break;
      
    case RECTANGLE:
      // Define the polygon shape by converting dmensions to box2D coordinates
      PolygonShape rectShape = new PolygonShape();
      float box2dW = mConfig.box.scalarPixelsToWorld( mConfig.size.x/2.0f );
      float box2dH = mConfig.box.scalarPixelsToWorld( mConfig.size.y/2.0f );
      rectShape.setAsBox(box2dW, box2dH);
      
      setFixtureDef(rectShape);
      break;
      
    case POLYGON:
      PolygonShape polyShape = new PolygonShape();
      
      int count = mConfig.points.size();
      Vec2[] vertices = new Vec2[count];
      
      for (int i = 0; i < count; i++) {
        vertices[i] = mConfig.box.vectorPixelsToWorld(mConfig.points.get(i));
      }
      
      polyShape.set(vertices, count);
      
      setFixtureDef(polyShape);
      break;
      
    default:
      print("ERROR: CustomBody Initialization error");
    }
  }
  
  private void setFixtureDef(Shape shape)
  {
    // Fixture stuff
    FixtureDef fixtureDefinition   = new FixtureDef();
    fixtureDefinition.shape        = shape;
    fixtureDefinition.density      = mConfig.density;
    fixtureDefinition.friction     = mConfig.friction;
    fixtureDefinition.restitution  = mConfig.restitution;
    
    if (mConfig.identity == Identity.HUNTER || mConfig.identity == Identity.PLAYER) {
      mConfig.colour = color((mConfig.health + 1), 200, 100);
    }
    
    mBody.setUserData(this);
    mBody.createFixture(fixtureDefinition);
  }
  
  // Delete the body
  public void destroy() 
  {
    mConfig.box.destroyBody(mBody);
  }
  
  public void applyForce(float _x, float _y) {
    mBody.applyForce(new Vec2(_x, _y).mulLocal(4000), mBody.getWorldCenter());
  }
  
  public Vec2 getPosition() {
    return mConfig.box.getBodyPixelCoord(mBody);
  }
  
  public Identity getIdentity() {
    return mConfig.identity;
  }
  
  public boolean isDead()
  {
    return isDead;
  }
  
  // Draw the boundary, if it were at an angle we'd have to do something fancier
  public void draw() 
  {
    Vec2 pos = getPosition();
      //if (pos.x > width || pos.x < 0 || pos.y > height * 2 || pos.y < -height) {
      if (mConfig.health == 0) {
        isDead = true;
      }
      
      if (!isDead) { 
      if (mConfig.identity == Identity.HUNTER || mConfig.identity == Identity.PLAYER) {
        if (mConfig.health > 0) {
          mConfig.colour = color((mConfig.health + 1), 250, 255);
        } else {
          mConfig.colour = color(0, 0, 0);
        }
      }
      
      fill(mConfig.colour);
      Vec2 position = getPosition();
      float angle = mBody.getAngle();
      
      pushMatrix();
        translate(position.x, position.y);
        rotate(-angle);
        noStroke();
              
        switch (mShape) {
          case CIRCLE:
          ellipse(0, 0, mConfig.radius * 2, mConfig.radius * 2);
          //line(0, 0, mConfig.radius, 0);
          break;
          
        case RECTANGLE:
          rectMode(CENTER);
          rect(0, 0, mConfig.size.x, mConfig.size.y );
          break;
          
        case POLYGON:
          rectMode(CENTER);
          Fixture fixture = mBody.getFixtureList();
          PolygonShape shape = (PolygonShape) fixture.getShape();
          beginShape();
            for (int i = 0; i < shape.getVertexCount(); i++) {
              Vec2 v = mConfig.box.vectorWorldToPixels(shape.getVertex(i));
              vertex(v.x, v.y);
            }
          endShape(CLOSE);
          break;
        default:
          print("ERROR: CustomBody draw error.");
        }
      popMatrix(); 
    }
  }
  
}