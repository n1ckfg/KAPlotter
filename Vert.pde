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
  
  // https://stackoverflow.com/questions/13806483/increase-or-decrease-color-saturation
  
  void changeSaturation(float sat) {
    PVector hsv = RGBtoHSV(col);
    hsv.y *= sat;
    col = HSVtoRGB(hsv);
  }
  
  PVector RGBtoHSV(color c) {
        float r, g, b, h, s, v;
        r = red(c);
        g = green(c);
        b = blue(c);
        float min = min(r, g, b);
        float max = max(r, g, b);

        v = max;
        float delta = max - min;
        
        if (max != 0) {
            s = delta / max;        // s
        } else {
            // r = g = b = 0        // s = 0, v is undefined
            s = 0;
            h = -1;
            return new PVector(h, s, 0);
        }
        
        if (r == max) {
            h = (g - b) / delta;      // between yellow & magenta
        } else if (g == max) {
            h = 2 + (b - r) / delta;  // between cyan & yellow
        } else {
            h = 4 + (r - g) / delta;  // between magenta & cyan
        }
        h *= 60;                // degrees
        if (h < 0) h += 360; 
        if (Float.isNaN(h)) h = 0;
        
        return new PVector(h, s, v);
    }

    color HSVtoRGB(PVector c) {
        float i, h, s, v, r, g, b;
        h = c.x;
        s = c.y;
        v = c.z;
        
        if (s == 0) {
            // achromatic (grey)
            r = g = b = v;
            return color(r, g, b);
        }
        h /= 60;            // sector 0 to 5
        i = floor(h);
        float f = h - i;          // factorial part of h
        float p = v * (1 - s);
        float q = v * (1 - s * f);
        float t = v * (1 - s * (1 - f));
        
        switch(int(i)) {
            case 0:
                r = v;
                g = t;
                b = p;
                break;
            case 1:
                r = q;
                g = v;
                b = p;
                break;
            case 2:
                r = p;
                g = v;
                b = t;
                break;
            case 3:
                r = p;
                g = q;
                b = v;
                break;
            case 4:
                r = t;
                g = p;
                b = v;
                break;
            default:        // case 5:
                r = v;
                g = p;
                b = q;
                break;
        }
        
        return color(r,g,b);
    }
  
}
