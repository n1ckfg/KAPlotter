class KACombo {
  
  Kmeans kmeans;
  ArrayList<Astar> astars;
  boolean astarsGenerated = false;
  
  KACombo(ArrayList<PVector> _points) {
    kmeans = new Kmeans(_points);
    astars = new ArrayList<Astar>();
  }

  void run() {
    kmeans.run();

    if (kmeans.ready && !astarsGenerated) {
      for (int i=0; i<kmeans.clusters.size(); i++) {
        Cluster cluster = kmeans.clusters.get(i);
        astars.add(new Astar(cluster.points, cluster.centroid));
      }
      astarsGenerated = true;
    }

    for (int i=0; i<astars.size(); i++) {
      astars.get(i).run();
    }
  }
  
  void init() {
    kmeans.init();
  }

}
