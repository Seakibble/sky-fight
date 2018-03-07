class BackgroundParticle
{
  PVector mPosition;
  PVector mSize;
  PVector mGravity;
  float mRadius;
  float mRotation;
  float mAngularVelocity;
  boolean isCircle;
  
  PVector mColour;
  
  BackgroundParticle(PVector _gravity) {
    setGravity(_gravity);
    init();
  }
  
  void init() {
    if (random(-1, 1) > 0) {
      isCircle = true;
    } else {
      isCircle = false;
    }   
    
    mColour = new PVector(random(0, 255), random(0, 55), random(0, 255));
    mSize = new PVector(random(30, 200), random(30, 200));
    mRotation = random(0, 360);
    mAngularVelocity = random(-0.01, 0.01);
    
    if (mGravity.y > 0) {
      mPosition = new PVector(random(-width/2, width * 2), random(-height, -height/2));
    } else {
      mPosition = new PVector(random(-width/2, width * 2), random(height * 2, height * 1.5));
    }
  }
  
  void setGravity(PVector _gravity) {
    mGravity = _gravity.mult(0.1);
  }
  
  void draw() {
    mPosition.add(mGravity);
    mRotation += mAngularVelocity;
    
    
    if (mPosition.x > width * 1.5 || mPosition.x < -width/2 || mPosition.y > height * 1.5 || mPosition.y < -height/2) {
      init();
    }
    
    noStroke();
    fill(mColour.x, mColour.y, mColour.z);
    
    pushMatrix();
      translate(mPosition.x, mPosition.y);
      rotate(mRotation);
      if (isCircle) {
        ellipse(0, 0, mSize.x, mSize.y);
      } else {
        rect(0, 0, mSize.x, mSize.y);
      }
    popMatrix();
  }
  
}