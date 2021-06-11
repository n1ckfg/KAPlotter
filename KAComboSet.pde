class KAComboSet {
  
  int iterations, interval;
  boolean latkGenerated;
  KACombo[] kaCombos;
  
  KAComboSet(ArrayList<PVector>_points, int _iterations, int _interval) {
    latkGenerated = false;
    iterations = _iterations;
    interval = _interval;
    kaCombos = new KACombo[iterations];
    
    for (int i=0; i<kaCombos.length; i++) {
      if (i == 0) {
        kaCombos[i] = new KACombo(_points, interval * (i+1), true, true); // one sorter layer
      } else {
        kaCombos[i] = new KACombo(_points, interval * (i+1), true, false); // no sorter layers
      }
    }
  }

  void run() {
    boolean ready = true;
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].run();
      if (!kaCombos[i].secondaryGenerated) ready = false;
    }
    if (ready && !latkGenerated) {
      writeLatk();
      latkGenerated = true;
    }
  }
  
  void init() {
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].init();
    }
  }
  
  void writeLatk() {
    // TODO
  }
  
}
