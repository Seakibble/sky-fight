class Chain
{
  ArrayList<CustomBody> links;
  ArrayList<DistanceJoint> joints;
  Box2DProcessing mBoxRef;
  boolean dead;
  
  Chain(CustomBody _master, int numSections, Box2DProcessing _box)
  {
    dead = false;
    mBoxRef = _box;
    links = new ArrayList<CustomBody>();
    links.add(_master);
    joints = new ArrayList<DistanceJoint>();
    
    PVector startPos = new PVector(_master.getPosition().x, _master.getPosition().y); 
    
    float sectionRadius = 4.0;
    
    Config endSectionConfig = new Config(mBoxRef, Identity.WEAPON);
      endSectionConfig.radius = sectionRadius * 3;
      
    Config midSectionConfig = new Config(mBoxRef, Identity.CHAIN);
      midSectionConfig.radius = sectionRadius;
 
    for (int i = 1; i < numSections + 1; i++) {
      CustomBody section = null;
      
      if (i == numSections) {
        PVector sectionPos = new PVector(startPos.x, startPos.y + (sectionRadius * 2 * i-1) + (sectionRadius * 6));
        endSectionConfig.position = sectionPos;
        section = new CustomBody(endSectionConfig);  
      } else {
        PVector sectionPos = new PVector(startPos.x, startPos.y + sectionRadius * 2 * i);
        midSectionConfig.position = sectionPos;
        section = new CustomBody(midSectionConfig);
      }
      
      links.add(section);
      
      if (i > 0) {
        DistanceJointDef djd = new DistanceJointDef();
        CustomBody previous = links.get(i-1);
        
        djd.bodyA = section.mBody;
        djd.bodyB = previous.mBody;
        
        djd.length = box.scalarPixelsToWorld(sectionRadius*2);
        
        djd.frequencyHz = 0;
        djd.dampingRatio = 0;
        
        joints.add((DistanceJoint)box.world.createJoint(djd));
      }
    }
  }
  
  public void destroy() {
    for (DistanceJoint j:joints) {
      mBoxRef.world.destroyJoint(j);
    }
    joints.clear();
    dead = true;
  }
  
  public boolean isDead() {
    return dead;
  }
  
  void draw()
  {
    if (dead) {
      ArrayList<CustomBody> remove = new ArrayList<CustomBody>();
      for (CustomBody l:links) {
        if (l.isDead()) {
          remove.add(l);
        }
      }
      
      // Remove bodies that need to be deleted
      for ( CustomBody r:remove ) {
        r.destroy();
        links.remove(r);
      }
    }
    
    for (CustomBody l:links) {
      l.draw();
    }
  }
}