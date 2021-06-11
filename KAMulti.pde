class KAMulti {
  
  int iterations, interval;
  boolean latkGenerated;
  KACombo[] kaCombos;
  Sorter sorter;
  
  KAMulti(ArrayList<PVector>_points, int _iterations, int _interval) {
    sorter = new Sorter();
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
      if (!kaCombos[i].astarsGenerated) ready = false;
    }
    if (ready && !latkGenerated) {
      // * * *
      sorter.init(kaCombos[0].kmeans.centroidFinalPositions, 0);
      // * * *
      writeLatk();
      latkGenerated = true;
    }
    
    sorter.run();
  }
  
  void init() {
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].init();
    }
  }
  
  void writeLatk() {
  }
  
}
