import peasy.PeasyCam;

PeasyCam cam;

KACombo[] kaCombos = new KACombo[3];

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

  kaCombos[0] = new KACombo(points, 20);
  kaCombos[1] = new KACombo(points, 80);
  kaCombos[2] = new KACombo(points, 200);
  
  markTime = millis();
}

void draw() {
  background(0);
   
  for(int i=0; i<kaCombos.length; i++) {
    kaCombos[i].run();
  }

  if (millis() > markTime + refreshInterval) { 
    markTime = millis();
    for(int i=0; i<kaCombos.length; i++) {
      //kaCombos[i].init();
    }
  }
  
  surface.setTitle(""+frameRate);
}
