class Hunter
{
  CustomBody mCBody;
  Spring spring;
  Chain chain;
  Randomizer randomizer;
  Box2DProcessing mBoxRef;
  boolean isPlayer;
  float mStep;
  boolean isDead;
  boolean gameOver;
  
  public Hunter(Box2DProcessing _BoxRef, boolean _isPlayer, float _height)
  {
    gameOver = false;
    isDead = false;
    isPlayer = _isPlayer;
    mBoxRef = _BoxRef;
    randomizer = new Randomizer();
    mStep = random(0.001, 0.015);
    randomizer.update(mStep);
    
    ArrayList<Vec2> points = new ArrayList<Vec2>();
    points.add(new Vec2(-20, -10));
    points.add(new Vec2(0, 10));
    points.add(new Vec2(20, -10));
    
    Config hunterConfig = new Config(mBoxRef, Identity.HUNTER);
    Config playerConfig = new Config(mBoxRef, Identity.PLAYER);
    
    int chainSegments = 20;
    
    if (isPlayer) {
      ArrayList<Vec2> playerPoints = new ArrayList<Vec2>();
      playerPoints.add(new Vec2(-15, 0));
      playerPoints.add(new Vec2(-7, 12));
      playerPoints.add(new Vec2(7, 12));
      playerPoints.add(new Vec2(15, 0));
      playerPoints.add(new Vec2(7, -12));
      playerPoints.add(new Vec2(-7, -12));
        
      playerConfig.position = new PVector(randomizer.values.x * width, randomizer.values.y * height);
      playerConfig.points = playerPoints;
      mCBody = new CustomBody(playerConfig);
    } else {
      hunterConfig.position = new PVector(randomizer.values.x * width, _height);
      hunterConfig.points = points;
      mCBody = new CustomBody(hunterConfig);
      chainSegments = int(random(1, 7) + random(1, 7) + random(1, 7) + random(1, 7) + random(1, 7));
    }
    
    spring = new Spring(mBoxRef);
    spring.bind(mCBody.getPosition().x, mCBody.getPosition().y, mCBody);
    
    chain = new Chain(mCBody, chainSegments, mBoxRef);
  }
  
  public Vec2 getPosition()
  {
    return mCBody.getPosition();
  }
  
  public boolean isPlayer()
  {
    return isPlayer;
  }
  
  public void update()
  {
    if (!isDead) {
      if (mCBody.mConfig.health > 0) {
        randomizer.update(mStep);
        if (isPlayer) {
          spring.update(mouseX,mouseY);
          spring.display();
          
        } else {
          spring.update(randomizer.values.x * width, randomizer.values.y * height);
        }
      } else {
        if (isPlayer) {
          gameOver = true;
        }
        spring.destroy();
        chain.destroy();
      }
    }
  }
  
  public void destroy()
  {
    mCBody.destroy();
  }
  
  private int linksRemaining()
  {
    return chain.links.size();
  }
  
  public boolean isDead() {
    return isDead;
  }
  
  public void draw()
  {
    if (linksRemaining() > 0) chain.draw();
    if (!mCBody.isDead()) mCBody.draw();
    
    if (linksRemaining() < 1 && mCBody.isDead()) {
      destroy();
      isDead = true;
    }
  }
}