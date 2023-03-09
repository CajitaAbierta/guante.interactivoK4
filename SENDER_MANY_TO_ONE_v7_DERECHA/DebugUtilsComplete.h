
#ifdef DEBUG
  #define DEBUG_PRINT(...)   Serial.print(millis());  Serial.print(": ");  Serial.print(__PRETTY_FUNCTION__);  Serial.print(' ');  Serial.print(__LINE__);  Serial.print(' ');  Serial.print(__VA_ARGS__);
  #define DEBUG_PRINTLN(...)  Serial.print(millis()); Serial.print(": ");  Serial.print(__PRETTY_FUNCTION__); Serial.print(' '); Serial.print(__LINE__); Serial.print(' '); Serial.println(__VA_ARGS__);
#else
  #define DEBUG_PRINT(...)
  #define DEBUG_PRINTLN(...)  
#endif

//https://forum.arduino.cc/t/serial-debug-macro/64259
