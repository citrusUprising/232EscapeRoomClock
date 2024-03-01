import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;


// Server variables
int port = 9876;
ServerThread server;
int numberCommands = 6; // arduinos+start+reset

// Countdown variables
final long maxTime = 3600000;
long countDown = maxTime;
long lastLoopTime = 0;

void setup(){
  // Configure basic sketch properties
  //fullScreen();
  size(640, 480);
  
  // Create our server thread
  server = new ServerThread(port, numberCommands);
  
  // Start our server thread
  server.start();
  
  // For calcualting delta time
  lastLoopTime = millis();
}

void draw(){
  background(255);
  
  // Calculate delta time
  long delta = millis() - lastLoopTime;
  lastLoopTime = millis();
  
  if (server.states[0] == 1){
  
  // Update countdown
  countDown -= delta;
  
  // Draw countdown
  textSize(128);
  fill(0);
  textAlign(CENTER);
  text(nf(countDown / 60000.0, 0, 2), width/2, height/2);
  }
}
