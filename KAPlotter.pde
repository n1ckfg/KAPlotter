import peasy.PeasyCam;

PeasyCam cam;

KACombo kaCombo;

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

  kaCombo = new KACombo(points, 40);
  
  markTime = millis();
}

void draw() {
  background(0);
   
  kaCombo.run();

  if (millis() > markTime + refreshInterval) { 
    markTime = millis();
    //kaCombo.init();
  }
  
  surface.setTitle(""+frameRate);
}
