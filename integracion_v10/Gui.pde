
/*
class GUI {
 //tendria que armar un dispatch que uniera todos los tipos, un diccionario y el msj  a enviar
 
 ArrayList<Slider> sliders;
 ArrayList<Btn> btns;
 GUI() {
 }
 void displayGui() {
 }
 void add(Btn btn) {
 };
 void add(Slider slider) {
 };
 void addSlider() {
 };
 void addBtn() {
 };
 
 
 //funcionamientos
 void onClickGui() {
 for (Btn b : btns) {
 b.onClicked();
 }
 }
 }
 
 */
//deberia ser una clase como Controlp5 pero no tempo
//es poco modular pero por temas de comodidad mejor mover el codigo asi
void onClickGui() {
  btnIzqAX.onClicked();
  btnIzqAY.onClicked(); 
  btnIzqAZ.onClicked(); 
  btnIzqGX.onClicked();
  btnIzqGY.onClicked(); 
  btnIzqGZ.onClicked(); 
  btnIzqPulsador.onClicked();
  btnIzqFlex.onClicked();

  btnDerAX.onClicked();
  btnDerAY.onClicked(); 
  btnDerAZ.onClicked(); 
  btnDerGX.onClicked();
  btnDerGY.onClicked(); 
  btnDerGZ.onClicked(); 
  btnDerPulsador.onClicked();
  btnDerFlex.onClicked();
  
  piton.onClicked();
}
void toggleBtns() {
  btnIzqAX.toggle();
  btnIzqAY.toggle();
  btnIzqAZ.toggle();
  btnIzqGX.toggle();
  btnIzqGY.toggle();
  btnIzqGZ.toggle();
  btnIzqPulsador.toggle();
  btnIzqFlex.toggle();

  btnDerAX.toggle();
  btnDerAY.toggle(); 
  btnDerAZ.toggle(); 
  btnDerGX.toggle();
  btnDerGY.toggle(); 
  btnDerGZ.toggle(); 
  btnDerPulsador.toggle();
  btnDerFlex.toggle();
}

void setBtns(boolean nuevoEstado) {
  btnIzqAX.setState(nuevoEstado);
  btnIzqAY.setState(nuevoEstado);
  btnIzqAZ.setState(nuevoEstado);
  btnIzqGX.setState(nuevoEstado);
  btnIzqGY.setState(nuevoEstado);
  btnIzqGZ.setState(nuevoEstado);
  btnIzqPulsador.setState(nuevoEstado);
  btnIzqFlex.setState(nuevoEstado);

  btnDerAX.setState(nuevoEstado);
  btnDerAY.setState(nuevoEstado); 
  btnDerAZ.setState(nuevoEstado); 
  btnDerGX.setState(nuevoEstado);
  btnDerGY.setState(nuevoEstado); 
  btnDerGZ.setState(nuevoEstado); 
  btnDerPulsador.setState(nuevoEstado);
  btnDerFlex.setState(nuevoEstado);
}

void displayGui() {
  //GUI

  pushStyle();
  imageMode(CENTER);
  image(imgPj, width/2, height/2, width, height);
  popStyle();



  btnIzqAX.display();
  btnIzqAY.display(); 
  btnIzqAZ.display(); 
  btnIzqGX.display();
  btnIzqGY.display(); 
  btnIzqGZ.display(); 
  btnIzqPulsador.display();
  btnIzqFlex.display();
  //slider.display();


  btnDerAX.display();
  btnDerAY.display(); 
  btnDerAZ.display(); 
  btnDerGX.display();
  btnDerGY.display(); 
  btnDerGZ.display(); 
  btnDerPulsador.display();
  btnDerFlex.display();
  piton.display();
}

//void envioMIDI() {

//  if (btnIzqAX.isOn())
//  {
//    PrintlnIzq("btnIzqAX.isOn");
//    myBus.sendControllerChange(1, 64, ax[0]);
//  }
//  if (btnIzqAY.isOn())
//  {
//    PrintlnIzq("btnIzqAY.isOn");

//    myBus.sendControllerChange(1, 65, ay[0]);
//  }
//  if ( btnIzqAZ.isOn())
//  {
//    PrintlnIzq("btnIzqAZ.isOn");

//    myBus.sendControllerChange(1, 66, az[0]);
//  }
//  if (btnIzqGX.isOn())
//  {
//    PrintlnIzq("btnIzqGX.isOn");

//    myBus.sendControllerChange(1, 67, gx[0]);
//  }
//  if (btnIzqGY.isOn())
//  {
//    PrintlnIzq("btnIzqGY.isOn");

//    myBus.sendControllerChange(1, 68, gy[0]);
//  }
//  if (btnIzqGZ.isOn())
//  {
//    PrintlnIzq("btnIzqGZ.isOn");

//    myBus.sendControllerChange(1, 69, gz[0]);
//  }
//  if (btnIzqPulsador.isOn())
//  {
//    PrintlnIzq("btnIzqPulsador.isOn");
//    //myBus.sendNoteOn(3, 60, 255); // Send a Midi noteOn

//    if (tiempoActual>marcaTiempoFlexDer+tiempoEsperaFlexDer)
//    {
//       myBus.sendNoteOn(3, 60,127); // Send a Midi noteOff
//      //myBus.sendNoteOn(3, 60, parseInt(boton[0])*127); // Send a Midi noteOff
//      marcaTiempoFlexDer=tiempoActual;
//    }
//  }
//  if (btnIzqFlex.isOn())
//  {
//    PrintlnIzq("btnIzqFlex.isOn");
//    //if(enviarFlexIzq)
//    //myBus.sendNoteOn(4, 60, 255); // Send a Midi noteOn
//    //delay(200); //esto sería el tiempo en el que el flex está por debajo del umbral
//    if (tiempoActual>marcaTiempoFlexIzq+tiempoEsperaFlexIzq)
//    {
//      myBus.sendNoteOn(4, 60, flex[0]); // Send a Midi noteOff

//      marcaTiempoFlexIzq=tiempoActual;
//    }
//  }
  
  
//  if (btnDerAX.isOn())
//  {
//    PrintlnIzq("btnDerAX.isOn");
//    myBus.sendControllerChange(1, 64, ax[1]);
//  }
//  if (btnDerAY.isOn())
//  {
//    PrintlnIzq("btnDerAY.isOn");

//    myBus.sendControllerChange(1, 65, ay[1]);
//  }
//  if ( btnDerAZ.isOn())
//  {
//    PrintlnIzq("btnDerAZ.isOn");

//    myBus.sendControllerChange(1, 66, az[1]);
//  }
//  if (btnDerGX.isOn())
//  {
//    PrintlnIzq("btnDerGX.isOn");

//    myBus.sendControllerChange(1, 67, gx[1]);
//  }
//  if (btnDerGY.isOn())
//  {
//    PrintlnIzq("btnDerGY.isOn");

//    myBus.sendControllerChange(1, 68, gy[1]);
//  }
//  if (btnDerGZ.isOn())
//  {
//    PrintlnIzq("btnDerGZ.isOn");

//    myBus.sendControllerChange(1, 69, gz[1]);
//  }
//  if (btnDerPulsador.isOn())
//  {
//    PrintlnIzq("btnDerPulsador.isOn");
//    //myBus.sendNoteOn(3, 60, 255); // Send a Midi noteOn

//    if (tiempoActual>marcaTiempoFlexDer+tiempoEsperaFlexDer)
//    {
//      myBus.sendNoteOn(3, 60, 127); // Send a Midi noteOff
//      marcaTiempoFlexDer=tiempoActual;
//    }
//  }
//  if (btnDerFlex.isOn())
//  {
//    PrintlnIzq("btnDerFlex.isOn");
//    //if(enviarFlexDer)
//    //myBus.sendNoteOn(4, 60, 255); // Send a Midi noteOn
//    //delay(200); //esto sería el tiempo en el que el flex está por debajo del umbral
//    if (tiempoActual>marcaTiempoFlexDer+tiempoEsperaFlexDer)
//    {
//      myBus.sendNoteOn(4, 60, flex[1]); // Send a Midi noteOff

//      marcaTiempoFlexDer=tiempoActual;
//    }
//  }
//}
