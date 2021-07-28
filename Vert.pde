class Vert extends PVector {

  color col;
  
  Vert(float _x, float _y, float _z) {
    x = _x;
    y = _y;
    z = _z;
    col = color(255);
  }
  
  Vert(float _x, float _y) {
    x = _x;
    y = _y;
    z = 0;
    col = color(255);
  }
  
  Vert(float _x, float _y, float _z, color _col) {
    x = _x;
    y = _y;
    z = _z;
    col = _col;
  }
  
  Vert(float _x, float _y, float _z, float _r, float _g, float _b) {
    x = _x;
    y = _y;
    z = _z;
    col = color(_r, _g, _b);
  }
  
  Vert(PVector _p) {
    x = _p.x;
    y = _p.y;
    z = _p.z;
    col = color(255);
  }
  
  Vert(color _col) {
    x = 0;
    y = 0;
    z = 0;
    col = _col;
  }
  
  Vert(PVector _p, color _col) {
    x = _p.x;
    y = _p.y;
    z = _p.z;
    col = _col;
  }
  
  @Override
  Vert copy() {
    return new Vert(x, y, z, col);
  }

  @Override
  Vert mult(float f) {
    return new Vert(new PVector(x, y, z).mult(f), col);
  }
  
}
