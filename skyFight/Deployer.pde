class Deployer
{
  public Box2DProcessing mBoxRef;
  
  ArrayList<CustomBody> boulders;
  ArrayList<Hunter> hunters;
  
  Hunter player;
  int score;
  
  PVector position;
 
  Deployer(Box2DProcessing _box, PVector _position)
  {
    score = 0;
    mBoxRef = _box;
    position = _position;
    
    boulders = new ArrayList<CustomBody>();  
    
    hunters = new ArrayList<Hunter>();
    player = new Hunter(box, true);
    hunters.add(player);
  }
  
  int particleCount()
  {
    return boulders.size();
  }
  
  void draw()
  {
    // average 70% chance of boulder appearing, per second
    if (random(1, 3000) < 70) {
      addBoulder();
    }
    
    // average 10% chance of hunter appearing, per second
    if (random(1, 3000) < 10) {
      addHunter();
    }
    
    ArrayList<CustomBody> remove = new ArrayList<CustomBody>();
    
    for (CustomBody b:boulders) {
      b.draw();
      
      if (b.isDead()) {
        remove.add(b);
        score++;
      }
    }
    
    // Remove particles that need to be deleted
    for (CustomBody r:remove) {
      boulders.remove(r);
    }
    
    ArrayList<Hunter> removeHunters = new ArrayList<Hunter>();
    for(Hunter h:hunters) {
      h.update();
      h.draw();
      if (h.isDead()) {
        if (!h.isPlayer) {
          score += 100;
        } else {
          print("GAME OVER" + "\n");
          print("Your score was " + score + "!\n");
          exit();
        }
        removeHunters.add(h);
      }
    }
    
    // Remove bodies that need to be deleted
    for (Hunter h:removeHunters) {
      h.destroy();
      hunters.remove(h);
    }
    fill(0,0,0);
    text("SCORE: " + score, 10, 15);
  }
  
  void addHunter()
  {
    if (hunters.size() < 8) {
      hunters.add(new Hunter(mBoxRef, false));
    }
  }
  
  void addBoulder()
  {
    Config config = new Config(mBoxRef, Identity.WEAPON);
      config.position = new PVector(random(50, width - 50), position.y);
      config.radius = random(5.0, 25.0);
      config.colour = color(0, 200, 150);
    CustomBody newBody = new CustomBody(config);
    
    boulders.add(newBody);
  }
}