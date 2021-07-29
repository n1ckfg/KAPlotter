import peasy.PeasyCam;
import latkProcessing.*;

PeasyCam cam;

KAComboSet kaComboSet;
Latk latk;

PointCloud pc;

float globalScaler = 1000;

int globalComboIterations = 10;
int globalComboInterval = 40;
int globalSmoothReps = 1000;
int globalSplitReps = 4;
float globalRdpEpsilon = 0.1; //0.8;
int globalMinStrokeSize = 10;

String[] urls;
int urlCounter = 0;
int frameLimit = 24;

PApplet parent;

void setup() {
  size(900, 450, P3D);

  cam = new PeasyCam(this, 400);
  
  urls = filesLoader("input");
  
  parent = this;
  latk = new Latk(parent);
  
  init();
}

void draw() {
  background(0);
  
  if (pc.valid) kaComboSet.run();
  
  if (!pc.valid || kaComboSet.latkGenerated) {   
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
  println("Rendering " + urlCounter + " / " + urls.length + " ...");
  pc = new PointCloud(urls[urlCounter]);
  
  kaComboSet = new KAComboSet(pc.points, globalComboIterations, globalComboInterval); 
}
