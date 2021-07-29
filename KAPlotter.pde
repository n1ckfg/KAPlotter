import peasy.PeasyCam;
import latkProcessing.*;

PeasyCam cam;

KAComboSet kaComboSet;
Latk latk;

PointCloud pc;

float globalScaler = 1000;

int globalComboIterations = 2;
int globalComboInterval = 40;
int globalSmoothReps = 50;
int globalSplitReps = 1;
float globalRdpEpsilon = 0.5; //0.8;
int globalMinStrokeSize = 10;

String[] urls;
int urlCounter = 0;
int frameLimit = 9999;

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
  
  if (pc.valid) {
    pushMatrix();
    translate(-width/8, height/4, 0);
    scale(1,-1,1);
    kaComboSet.run();
    popMatrix();
  }
  
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
  if (urls.length > frameLimit) {
    println("Rendering " + (urlCounter + 1) + " / " + frameLimit + " ...");
  } else {
    println("Rendering " + (urlCounter + 1) + " / " + urls.length + " ...");
  }
  pc = new PointCloud(urls[urlCounter]);
  
  kaComboSet = new KAComboSet(pc.points, globalComboIterations, globalComboInterval); 
}
