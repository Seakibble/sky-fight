class Randomizer {
  public PVector values;  
  private PVector phase;   
  
  public Randomizer() {
    phase = new PVector(random(0.0, 1000.0), random(0.0, 1000.0), random(0.0, 1000.0));
  }
  
  public void update(float step) {
    values = new PVector(noise(phase.x), noise(phase.y), noise(phase.z));
    phase.x += step;
    phase.y += step;
    phase.z += step;
  }
  
};