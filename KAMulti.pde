class KAMulti {
  
  int iterations, interval;
  boolean latkGenerated;
  KACombo[] kaCombos;
  ArrayList<Sorter> sorters;
  
  KAMulti(ArrayList<PVector>_points, int _iterations, int _interval) {
    sorters = new ArrayList<Sorter>();
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
      for (int i=0; i<kaCombos[0].kmeans.clusters.size(); i++) {
        Cluster cluster = kaCombos[0].kmeans.clusters.get(i);
        if (cluster.points.size() > 1) {
          sorters.add(new Sorter(cluster.points, 0));
        }
      }
      // * * *
      writeLatk();
      latkGenerated = true;
    }
    
    for (int i=0; i<sorters.size(); i++) {
      sorters.get(i).run();
    }
  }
  
  void init() {
    for(int i=0; i<kaCombos.length; i++) {
      kaCombos[i].init();
    }
  }
  
  void writeLatk() {
  }
  
}
