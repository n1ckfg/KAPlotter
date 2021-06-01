class KACombo {
  
  Kmeans kmeans;
  ArrayList<Astar> astars;
  
  KACombo(ArrayList<PVector> _points) {
    kmeans = new Kmeans(_points);
    astars = new ArrayList<Astar>();
  }

  void run() {
    kmeans.run();

    for (int i=0; i<astars.size(); i++) {
      astars.get(i).run();
    }

    if (kmeans.ready) {
      for (int i=0; i<kmeans.clusters.size(); i++) {
        Cluster cluster = kmeans.clusters.get(i);
        astars.add(new Astar(cluster.points, cluster.centroid));
      }
      
      kmeans.ready = false;
    }
  }
  
  void init() {
    kmeans.init();
  }

}
