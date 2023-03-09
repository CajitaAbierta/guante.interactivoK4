
class Slider {

  PImage banner, pin, pinInvert;
  float inter;
  int x, y;
  float w, h;
  float valMax;
  boolean fondo;
  float tolerancia;

  Slider(int x_, int y_, String pathBanner, String pathPin, String pathPinInvert) {
    x=x_;
    y=y_;
    fondo=false;
    tolerancia=0.04;
    banner=loadImage(pathBanner);
    pin=loadImage(pathPin);
    pinInvert=loadImage(pathPinInvert);
    w=banner.width;
    h=banner.height;

    valMax=1.0;
    inter=w/2;
  }

  void isClick() {
    if ((mouseX>x &&mouseX<x+w)&&(mouseY>y&&mouseY<y+h)&&mousePressed) {
      inter=mouseX;
      image(pinInvert, inter, y+h/2);
    } else {
      image(pin, inter, y+h/2);
    }
  }
  float val() {
    return constrain(map(inter, x, x+w, 0-tolerancia, valMax+tolerancia),0.,1.);
  }


  void display() {
    if (fondo)
    {
      pushStyle();
      colorMode(HSB);
      noStroke();
      fill(220, 150, 255);
      rect(x, y, w, h);
      popStyle();
    }

    pushStyle();
    image(banner, x, y, w, h);
    popStyle();

    pushStyle();
    imageMode(CENTER);

    slider.isClick();

    popStyle();

  }

}
