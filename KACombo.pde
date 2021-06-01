class KACombo {
  
  Kmeans kmeans;
  Astar astar;
  
  KACombo(ArrayList<PVector> _points) {
    kmeans = new Kmeans(_points);
    astar = new Astar();
  }

  void run() {
    kmeans.run();
  }
  
  void init() {
    kmeans.init();
  }

}
