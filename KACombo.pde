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
    ArrayList<String> s = new ArrayList<String>();
    
    s.add("{");  
    s.add("\t\"info\": {");
    s.add("\t\t\"A\": 1.0,");
    s.add("\t\t\"links\": {");
    s.add("\t\t},");
    s.add("\t\t\"n_radius\": 1.0,");
    s.add("\t\t\"pow\": 2,");
    s.add("\t\t\"k\": 0.1,");
    s.add("\t\t\"nodes\": {");
    s.add("\t\t\t\"labels\": [],");
    s.add("\t\t\t\"radius\": 1.0,");
    s.add("\t\t\t\"amplitude\": 4.3,");
    s.add("\t\t\t\"weighted\": 0,");
    s.add("\t\t},");
    s.add("\t\t\"long_rep\": 0.008691716021844473,");
    s.add("\t},");
    s.add("\t\"scale\": 1.0,");
    s.add("\t\"name\": \"" + _fileName + "\",");
    s.add("\t\"links\": {");
    for (int i=0; i<10; i++) {
      s.add("\t\t\"LINK_NAME\": {");
      s.add("\t\t\t\"end_points\": [],");
      s.add("\t\t\t\"points\": [],");
      s.add("\t\t\t\"radius\": 4.300000190734863,");
      s.add("\t\t\t\"weight\": 1");
      if (i==10-1) {
        s.add("\t\t}");
      } else {
        s.add("\t\t},");
      }
    }
    s.add("\t},");
    s.add("\t\"edgelist\": [],");
    s.add("\t\"nodes\": {");
    s.add("\t\t\"positions\": [],");
    s.add("\t\t\"labels\": []");
    s.add("\t},");
    s.add("}"); 
    
    saveStrings(_fileName, s.toArray(new String[s.size()]));
  }

}
