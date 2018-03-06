class Spring {
  MouseJoint joint;
  Box2DProcessing mBoxRef;
  
  Spring(Box2DProcessing _box) {
    joint = null;
    mBoxRef = _box;
  }
 
  void update(float x, float y) {
    if (joint != null) {
      Vec2 target = mBoxRef.coordPixelsToWorld(x,y);
      joint.setTarget(target);
    }
  }

  void display() {
    if (joint != null) {
      // We can get the two anchor points
      Vec2 v1 = new Vec2(0,0);
      joint.getAnchorA(v1);
      Vec2 v2 = new Vec2(0,0);
      joint.getAnchorB(v2);
      
      v1 = mBoxRef.coordWorldToPixels(v1);
      v2 = mBoxRef.coordWorldToPixels(v2);
      
      stroke(0);
      strokeWeight(1);
      line(v1.x,v1.y,v2.x,v2.y);
    }
  }

  void bind(float x, float y, CustomBody _body) {
    MouseJointDef jointDef = new MouseJointDef();
    jointDef.bodyA = mBoxRef.getGroundBody();
    jointDef.bodyB = _body.mBody;
    
    Vec2 mp = mBoxRef.coordPixelsToWorld(x,y);
    
    jointDef.target.set(mp);
    
    jointDef.maxForce = 1000.0 * _body.mBody.m_mass;
    jointDef.frequencyHz = 5.0;
    jointDef.dampingRatio = 0.9;

    // Wake up body!
    //box.body.wakeUp();

    // Make the joint!
    joint = (MouseJoint) mBoxRef.world.createJoint(jointDef);
  }

  void destroy() {
    // We can get rid of the joint when the mouse is released
    if (joint != null) {
      mBoxRef.world.destroyJoint(joint);
      joint = null;
    }
  }

}