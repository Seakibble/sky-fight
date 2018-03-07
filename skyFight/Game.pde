class Game
{
  public Box2DProcessing mBoxRef;
  
  ArrayList<CustomBody> boulders;
  ArrayList<Hunter> hunters;
  
  Hunter player;
  int score;
  float time;
  
  PVector position;
  boolean active;
  boolean gameOver;
 
  Game(Box2DProcessing _box, PVector _position)
  {
    active = false;
    time = 0;
    gameOver = false;
    score = 0;
    mBoxRef = _box;
    position = _position;
    
    boulders = new ArrayList<CustomBody>();  
    
    hunters = new ArrayList<Hunter>();
    player = new Hunter(box, true, 0);
    hunters.add(player);
  }
  
  int particleCount()
  {
    return boulders.size();
  }
  
  public void setPosition(PVector _pos)
  {
    position = _pos;    
  }
  
  // If this many seconds have elapsed, this is the average 
  // percent chance per second that something should happen.
  private boolean oddsAfterTime(float _odds, float _seconds)
  {
    return time > _seconds && random(0, 60) < _odds;
  }
  
  void draw()
  {
    if (active) {
      if (!gameOver){
        time += 1.0/60.0;
      } else {
        fill(0);
        text("GAME OVER. Click to restart.", 10, 45);
      }
      
      // Starting immediately: average 80% chance of boulder appearing every second
      if (oddsAfterTime(4, 0)) {
        addBoulder();
      }
      
      // Starting after 10 seconds: average 10% chance of hunter appearing every second
      if (oddsAfterTime(0.3, 10)) {
        addHunter();
      }
      
      ArrayList<CustomBody> remove = new ArrayList<CustomBody>();
      
      for (CustomBody b:boulders) {
        b.draw();
        
        if (b.isDead()) {
          remove.add(b);
          if (!gameOver) {
            score++;
          }
        }
      }
      
      // Remove particles that need to be deleted
      for (CustomBody r:remove) {
        boulders.remove(r);
      }
      
      fill(0);
      text("SCORE: " + score, 10, 15);
      text("TIME: " + round(time) + " seconds", 10, 30);
    } else {
      fill(0);
      text("Use the mouse to avoid red boulders.", 10, 15);
      text("Click to start!", 10, 30);      
    }
    
    
    ArrayList<Hunter> removeHunters = new ArrayList<Hunter>();
    for(Hunter h:hunters) {
      h.update();
      h.draw();
      
      if (h.gameOver && !gameOver) {
          gameOver = true;
          print("GAME OVER" + "\n");
          print("Your score was " + score + "!\n");
        }
        
      if (h.isDead()) {
        if (!gameOver && !h.isPlayer) {
          score += 100;
        }
        removeHunters.add(h);
      }
    }
    
    // Remove bodies that need to be deleted
    for (Hunter h:removeHunters) {
      h.destroy();
      hunters.remove(h);
    }
  }
  
  public void start() {
    active = true;
  }
  
  void addHunter()
  {
    if (hunters.size() < 8) {
      hunters.add(new Hunter(mBoxRef, false, position.y));
    }
  }
  
  void addBoulder()
  {
    Config config = new Config(mBoxRef, Identity.WEAPON);
      config.position = new PVector(random(50, width - 50), position.y);
      if (random(0, 6) > 1) {
        config.radius = random(5.0, 25.0);
      } else {
        config.size = new PVector(random(5.0, 150.0), random(5.0, 150.0));
        config.density = 10;
        config.restitution = 0.05;
      }
      config.colour = color(0, 200, 150);
    CustomBody newBody = new CustomBody(config);
    
    boulders.add(newBody);
  }
}