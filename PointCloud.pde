class PointCloud {
  
  ArrayList<PVector> points;
  
  PointCloud(String url) {
    String ext = getExtension(url);
    switch(ext) {
      case "obj":
        loadFromShape(url);
        break;
      case "binvox":
        loadFromBinvox(url, 128);
        break;
      default:
        loadFromShape(url);
        break;
    }
    
  }

  void loadFromShape(String url) {
    points = new ArrayList<PVector>();
    PShape shp = loadShape(url);
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

  public void loadFromBinvox(String url, int dim) {
    points = new ArrayList<PVector>();
    byte bytesData[] = loadBytes(url);
    int readpos = 0;
    
    for (int i = 0; i < bytesData.length; i++) {
      if ((char) bytesData[i] == 'd' && (char) bytesData[i+1] == 'a' && (char) bytesData[i+2] == 't' && (char) bytesData[i+3] == 'a') {
        readpos = i + 5;
        break;
      }
    }
    
    int voxpos = 0;
    int x = 0, y = 0, z = 0;
    //int numVoxels = 0;
    int[][][] voxels = new int[dim][dim][dim];
    
    while (voxpos < dim * dim * dim) {
      int cell = bytesData[readpos] & 0xff;
      int sequence = bytesData[readpos+1] & 0xff;
      
      if (cell == 0 || cell == 1) {
        for (int i = voxpos; i < voxpos + sequence; i++) {
          voxels[x][y][z] = cell;
          //numVoxels += cell;
  
          z += 1;
  
          if (z == dim) {
            z = 0;
            y += 1;
          }
  
          if (y == dim) {
            y = 0;
            x += 1;
          }
  
          if (x == dim) {
            x = 0;
          }
        }
        voxpos = voxpos + sequence;
        readpos = readpos + 2;
      }
    }
    
    for (int xx = 0; xx < dim; xx++) {
      for (int yy = 0; yy < dim; yy++) {
        for (int zz = 0; zz < dim; zz++) {
          if (voxels[xx][yy][zz] == 1) {
            points.add(new PVector(xx, yy, zz));
          }
        }
      }
    }
  }

  String strVertex(float x, float y, float z) {
    return "v " + x + ".0 " + y + ".0 " + z + ".0";
  }
  
  String strFace(float a, float b, float c) {
    return "f " + a + " " + b + " " + c;
  }
  
  public void saveAsObj(String url) {
    String[] vertices = new String[points.size()*24];
    String[] faces = new String[points.size()*12];
    int index = 0;   

    for (int i=0; i<points.size(); i++) {
      PVector p = points.get(i);
      float x = p.x;
      float y = p.y;
      float z = p.z;
      vertices[24*index] = strVertex(y, x, z);
      vertices[24*index+1] = strVertex(y, x, z+1);
      vertices[24*index+2] = strVertex(y+1, x, z);
      vertices[24*index+3] = strVertex(y+1, x, z+1);
      vertices[24*index+4] = strVertex(y+1, x, z);
      vertices[24*index+5] = strVertex(y+1, x, z+1);
      vertices[24*index+6] = strVertex(y+1, x+1, z);
      vertices[24*index+7] = strVertex(y+1, x+1, z+1);
      vertices[24*index+8] = strVertex(y+1, x+1, z);
      vertices[24*index+9] = strVertex(y+1, x+1, z+1);
      vertices[24*index+10] = strVertex(y, x+1, z);
      vertices[24*index+11] = strVertex(y, x+1, z+1);
      vertices[24*index+12] = strVertex(y, x+1, z);
      vertices[24*index+13] = strVertex(y, x+1, z+1);
      vertices[24*index+14] = strVertex(y, x, z);
      vertices[24*index+15] = strVertex(y, x, z+1);
      vertices[24*index+16] = strVertex(y, x, z);
      vertices[24*index+17] = strVertex(y+1, x, z);
      vertices[24*index+18] = strVertex(y+1, x+1, z);
      vertices[24*index+19] = strVertex(y, x+1, z);
      vertices[24*index+20] = strVertex(y, x, z+1);
      vertices[24*index+21] = strVertex(y+1, x, z+1);
      vertices[24*index+22] = strVertex(y+1, x+1, z+1);
      vertices[24*index+23] = strVertex(y, x+1, z+1);
      faces[12*index] = strFace(1+index*24, 3+index*24, 4+index*24);
      faces[12*index+1] = strFace(1+index*24, 4+index*24, 2+index*24);
      faces[12*index+2] = strFace(5+index*24, 7+index*24, 8+index*24);
      faces[12*index+3] = strFace(5+index*24, 8+index*24, 6+index*24);
      faces[12*index+4] = strFace(9+index*24, 11+index*24, 12+index*24);
      faces[12*index+5] = strFace(9+index*24, 12+index*24, 10+index*24);
      faces[12*index+6] = strFace(13+index*24, 15+index*24, 16+index*24);
      faces[12*index+7] = strFace(13+index*24, 16+index*24, 14+index*24);
      faces[12*index+8] = strFace(18+index*24, 17+index*24, 20+index*24);
      faces[12*index+9] = strFace(20+index*24, 19+index*24, 18+index*24);
      faces[12*index+10] = strFace(22+index*24, 24+index*24, 21+index*24);
      faces[12*index+11] = strFace(24+index*24, 22+index*24, 23+index*24);
      index += 1;
    }
    
    String[] lines = concat(vertices, faces);
    saveStrings(url, lines);
  }
  
}
