import peasy.PeasyCam;

PeasyCam cam;

KAComboSet kaComboSet;

PointCloud pc;

int refreshInterval = 50000;
int markTime = 0;
float scaler = -1000;

int globalSmoothReps = 400;
int globalSplitReps = 4;
  
void setup() {
  size(900, 450, P3D);

  cam = new PeasyCam(this, 400);
  
  pc = new PointCloud("epoch_199_fake_B.binvox");

  kaComboSet = new KAComboSet(pc.points, 3, 40);
  
  markTime = millis();
}

void draw() {
  background(0);
   
  kaComboSet.run();

  if (millis() > markTime + refreshInterval) { 
    markTime = millis();
    //kaComboSet.init();
  }
  
  surface.setTitle(""+frameRate);
}
