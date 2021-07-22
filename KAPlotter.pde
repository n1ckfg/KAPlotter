import peasy.PeasyCam;
import latkProcessing.*;

PeasyCam cam;

KAComboSet kaComboSet;
Latk latk;

PointCloud pc;

float globalScaler = 1000;

int globalComboIterations = 1;
int globalComboInterval = 50;
int globalSmoothReps = 400;
int globalSplitReps = 4;
float globalRdpEpsilon = 0.8;

String[] urls;
int urlCounter = 0;
int frameLimit = 999;

PApplet parent;

void setup() {
  size(900, 450, P3D);

  cam = new PeasyCam(this, 400);
  
  urls = filesLoader("newtest");
  
  parent = this;
  latk = new Latk(parent);
  
  init();
}

void draw() {
  background(0);
   
  kaComboSet.run();
  
  if (kaComboSet.latkGenerated) {
    urlCounter++;
    if (urlCounter < urls.length && urlCounter < frameLimit) {
      init();
    } else {
      latk.write("output.latk");
      exit();
    }
  }
  
  
  surface.setTitle(""+frameRate);
}

void init() {
  pc = new PointCloud(urls[urlCounter]);
  //pc.saveAsObjPlanes("test2.obj");
  
  kaComboSet = new KAComboSet(pc.points, globalComboIterations, globalComboInterval); 
}
