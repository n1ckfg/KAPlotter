int objOutputCounter = 0;

class KAComboSet {
  
  int iterations, interval;
  boolean latkGenerated;
  boolean savePointClouds = false;
  KACombo[] kaCombos;
  
  KAComboSet(ArrayList<Vert>_points, int _iterations, int _interval) {
    latkGenerated = false;
    iterations = _iterations;
    interval = _interval;
    kaCombos = new KACombo[iterations];
    
    for (int i=0; i<kaCombos.length; i++) {
        kaCombos[i] = new KACombo(_points, interval * (i+1));
    }
  }

  void run() {
    boolean ready = true;
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].run();
      if (!kaCombos[i].secondaryGenerated) ready = false;
    }
    if (ready && !latkGenerated) {
      writeToLatk();
      latkGenerated = true;
    }
  }
  
  void init() {
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].init();
    }
  }
  
  void writeToLatk() {
    LatkFrame frame = new LatkFrame(parent);
    for (KACombo kaCombo : kaCombos) {
      for (Sorter sorter : kaCombo.sorters) {
        ArrayList<LatkPoint> lpArray = new ArrayList<LatkPoint>();
        for (Vert p : sorter.points) {
          //p.y *= -1;
          LatkPoint lp = new LatkPoint(parent, p.div(globalScaler/10));
          lpArray.add(lp);
        }
        LatkStroke ls = new LatkStroke(parent, lpArray, color(127,127,127,255));
        frame.strokes.add(ls);
      }
    }
    latk.layers.get(0).frames.add(frame);   
    if (savePointClouds) pc.saveAsObjPoints("output_" + objOutputCounter + ".obj");
    objOutputCounter++;
  }
  
}
