class PointCloud {
  
  ArrayList<PVector> points;
  
  PointCloud(String url) {
    String ext = getExtension(url);
    switch(ext) {
      case "obj":
        loadFromShape(url);
        break;
      default:
        loadFromShape(url);
        break;
    }
    
  }

  void loadFromShape(String url) {
    PShape shp = loadShape(url);
    points = new ArrayList<PVector>();
    for (int i=0; i<shp.getChildCount(); i++) {
      PShape child = shp.getChild(i);
      for (int j=0; j<child.getVertexCount(); j++) {
        PVector p = child.getVertex(j).mult(scaler);
        points.add(p);
      }
    }  
  }

  String getExtension(String url) {
    String[] extensionArray = url.split("\\."); // Period needs to be escaped for Java split method
    return extensionArray[extensionArray.length-1].toLowerCase();
  }
  
}
