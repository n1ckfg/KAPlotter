class KACombo {
  
  Kmeans kmeans;
  ArrayList<Astar> astars;
  boolean astarsGenerated = false;
  
  KACombo(ArrayList<PVector> _points, int _numCentroids) {
    kmeans = new Kmeans(_points, _numCentroids);
    astars = new ArrayList<Astar>();
  }

  void run() {
    kmeans.run();

    if (kmeans.ready && !astarsGenerated) {
      for (int i=0; i<kmeans.clusters.size(); i++) {
        Cluster cluster = kmeans.clusters.get(i);
        astars.add(new Astar(cluster.points, cluster.centroid));
      }
      write("output.json");
      astarsGenerated = true;
    }

    for (int i=0; i<astars.size(); i++) {
      astars.get(i).run();
    }
  }
  
  void init() {
    kmeans.init();
  }
  
  void write(String _fileName) {
    ArrayList<String> FINAL_OUTPUT = new ArrayList<String>();
    FINAL_OUTPUT.add("{");   
    FINAL_OUTPUT.add("}");   
    saveStrings(_fileName, FINAL_OUTPUT.toArray(new String[FINAL_OUTPUT.size()]));
  }

}
