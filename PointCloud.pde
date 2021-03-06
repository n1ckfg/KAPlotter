import latkProcessing.*;

class PointCloud {
  
  ArrayList<Vert> points;
  
  String ext = "unknown";
  boolean valid = false;
  boolean nativeObjHandling = false;
  
  PointCloud(String url) {
    points = new ArrayList<Vert>();
    
    ext = getExtension(url);
    switch(ext) {
      case "obj":
        loadFromShape(url);
        break;
      case "binvox":
        loadFromBinvox(url);
        break;
      default:
        println(ext + " is not a readable 3D object.");
        break;
    }
    
    valid = points.size() > 0;
    if (valid) {
      println("Created point cloud from " + ext + " with " + points.size() + " points.");  
    } else {
      println("Point cloud creation from " + url + " failed.");
    }
  }

  String getExtension(String url) {
    String[] extensionArray = url.split("\\."); // Period needs to be escaped for Java split method
    return extensionArray[extensionArray.length-1].toLowerCase();
  }
  
  void loadFromShape(String url) {
    points = new ArrayList<Vert>();
    
    if (ext.equals("obj") && nativeObjHandling) {
      PShape shp = loadShape(url);
  
      // first get root vertices
      for (int i=0; i<shp.getVertexCount(); i++) {
        Vert p = new Vert(shp.getVertex(i).mult(globalScaler));
        points.add(p);
      }
      
      // then look for child objects
      for (int i=0; i<shp.getChildCount(); i++) {
        PShape child = shp.getChild(i);
        for (int j=0; j<child.getVertexCount(); j++) {
          Vert p = new Vert(child.getVertex(j).mult(globalScaler));
          points.add(p);
        }
      }  
    } else {
      String[] lines = loadStrings(url);

      switch(ext) {
        default: // obj 
          for (String line : lines) {
            if (line.startsWith("v ")) {
              String[] words = line.split(" ");
              
              float x, y, z, r, g, b;
              boolean validPos = false;
              boolean validCol = false;
                            
              x = float(words[1]);
              y = float(words[2]);
              z = float(words[3]);
              r = 255;
              g = 255;
              b = 255;
              validPos = !Float.isNaN(x) && !Float.isNaN(y) && !Float.isNaN(z);

              if (validPos && words.length > 4) {
                r = float(words[4]);
                g = float(words[5]);
                b = float(words[6]);
                validCol = !Float.isNaN(r) && !Float.isNaN(g) && !Float.isNaN(b);
              }
              
              if (validPos && validCol) {
                points.add(new Vert(x, y, z, r*255, g*255, b*255)); // colors come in normalized
              } else if (validPos && !validCol) {
                points.add(new Vert(x, y, z));
              }
            }
          }
          break;
      }
    }
  }

  void loadFromlatk(String url) {
    // TODO
  }
  
  void loadFromBinvox(String url) {
    points = new ArrayList<Vert>();
    byte bytesData[] = loadBytes(url);
    int readpos = 0;
    int dimpos = 0;
    int dimX = 0;
    int dimY = 0;
    int dimZ = 0;
    
    
    for (int i = 0; i < bytesData.length; i++) {
      if (dimpos == 0 && (char) bytesData[i] == 'd' && (char) bytesData[i+1] == 'i' && (char) bytesData[i+2] == 'm') {
        dimpos = i+4;
        int dimCounter = 0;
        String tempDim = "";
        while (dimCounter < 3) {
          if ((char) bytesData[dimpos] == ' ') {
            dimCounter++;
            switch (dimCounter) {
              case 1:
                dimX = int(tempDim);
                break;
              case 2:
                dimY = int(tempDim);
                break;
              case 3:
                dimZ = int(tempDim);
                break;
            }
          } else {
            tempDim += (char) bytesData[dimpos];
            dimpos++;
          }
        }
        println("Found dimensions " + dimX + " " + dimY + " " + dimZ);
      }
      if ((char) bytesData[i] == 'd' && (char) bytesData[i+1] == 'a' && (char) bytesData[i+2] == 't' && (char) bytesData[i+3] == 'a') {
        readpos = i + 5;
        break;
      }
    }
    
    int voxpos = 0;
    int x = 0, y = 0, z = 0;
    //int numVoxels = 0;
    int[][][] voxels = new int[dimX][dimY][dimZ];
    
    while (voxpos < dimX * dimY * dimZ) {
      int cell = bytesData[readpos] & 0xff;
      int sequence = bytesData[readpos+1] & 0xff;
      
      if (cell == 0 || cell == 1) {
        for (int i = voxpos; i < voxpos + sequence; i++) {
          voxels[x][y][z] = cell;
          //numVoxels += cell;
  
          z += 1;
  
          if (z == dimZ) {
            z = 0;
            y += 1;
          }
  
          if (y == dimY) {
            y = 0;
            x += 1;
          }
  
          if (x == dimX) {
            x = 0;
          }
        }
        voxpos = voxpos + sequence;
        readpos = readpos + 2;
      }
    }
    
    for (int xx = 0; xx < dimX; xx++) {
      for (int yy = 0; yy < dimY; yy++) {
        for (int zz = 0; zz < dimZ; zz++) {
          if (voxels[xx][yy][zz] == 1) {
            points.add(new Vert(xx, -zz, yy));
          }
        }
      }
    }
  }

  // ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~
  
  String strVertex(float x, float y, float z) {
    return "v " + x + ".0 " + y + ".0 " + z + ".0";
  }
  
  String strFace(float a, float b, float c) {
    return "f " + a + " " + b + " " + c;
  }
  
  void saveAsObjCubes(String url) {
    String[] vertices = new String[points.size()*24];
    String[] faces = new String[points.size()*12];
    int index = 0;   

    for (int i=0; i<points.size(); i++) {
      Vert p = points.get(i);
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

  void saveAsObjPlanes(String url) {
    String[] vertices = new String[points.size()*4];
    String[] faces = new String[points.size()*2];
    int index = 0;   

    for (int i=0; i<points.size(); i++) {
      Vert p = points.get(i);
      float x = p.x;
      float y = p.y;
      float z = p.z;
      vertices[4*index] = strVertex(y, x+1, z);
      vertices[4*index+1] = strVertex(y, x+1, z+1);
      vertices[4*index+2] = strVertex(y, x, z);
      vertices[4*index+3] = strVertex(y, x, z+1);
      faces[2*index] = strFace(1+index*4, 3+index*4, 4+index*4);
      faces[2*index+1] = strFace(1+index*4, 4+index*4, 2+index*4);
      index += 1;
    }
    
    String[] lines = concat(vertices, faces);
    saveStrings(url, lines);
  }
  
  void saveAsObjPoints(String url) {
    String[] vertices = new String[points.size()];

    for (int i=0; i<points.size(); i++) {
      Vert p = points.get(i);
      float x = p.x;
      float y = p.y;
      float z = p.z;
      vertices[i] = strVertex(y, x, z);
    }
    
    saveStrings(url, vertices);
  }
  
}
