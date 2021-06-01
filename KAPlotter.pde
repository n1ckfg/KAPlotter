import peasy.PeasyCam;

PeasyCam cam;

KACombo kaCombo;

PShape shp;
ArrayList<PVector> points;

int refreshInterval = 50000;
int markTime = 0;

void setup() {
  size(900, 450, P3D);

  cam = new PeasyCam(this, 400);
  
  shp = loadShape("battle_pod_tri.obj");
  points = new ArrayList<PVector>();
  for (int i=0; i<shp.getChildCount(); i++) {
    PShape child = shp.getChild(i);
    for (int j=0; j<child.getVertexCount(); j++) {
      points.add(child.getVertex(j));
    }
  }

  kaCombo = new KACombo(points);
  
  markTime = millis();
}

void draw() {
  background(0);
   
  pushMatrix();
  translate(width/2, height/2, -500);
  scale(1000, 1000, 1000);
  rotateX(radians(180));
  rotateY(radians(90));

  kaCombo.run();

  popMatrix();

  if (millis() > markTime + refreshInterval) { 
    markTime = millis();
    kaCombo.init();
  }
  
  surface.setTitle(""+frameRate);
}
