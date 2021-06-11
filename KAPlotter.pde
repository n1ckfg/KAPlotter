import peasy.PeasyCam;

PeasyCam cam;

KAComboSet kaComboSet;

PShape shp;
ArrayList<PVector> points;

int refreshInterval = 50000;
int markTime = 0;
float scaler = -1000;

void setup() {
  size(900, 450, P3D);

  cam = new PeasyCam(this, 400);
  
  shp = loadShape("test.obj");
  points = new ArrayList<PVector>();
  for (int i=0; i<shp.getChildCount(); i++) {
    PShape child = shp.getChild(i);
    for (int j=0; j<child.getVertexCount(); j++) {
      PVector p = child.getVertex(j).mult(scaler);
      points.add(p);
    }
  }

  kaComboSet = new KAComboSet(points, 3, 40);
  
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
