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
boolean notPause = false;
boolean videoPlayed = false;
boolean locksVisible = false;
boolean displaySafeCode = false;

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
  background(0);
  
  // Calculate delta time
  long delta = millis() - lastLoopTime;
  lastLoopTime = millis();
  
   // Draw countdown
  textSize(128);
  fill(255);
  textAlign(CENTER);
  text(nf(countDown / 60000.0, 0, 2), width/2, height/2);
  
  if (notPause && countDown > 0){
    // Update countdown
    countDown -= delta;
  }else if (notPause){
    countDown = 0;
  }
  
  //Check to Draw Locks
  for (int i = 0; i < 3; i++){
    if(server.states[i] == true){
      locksVisible = true;
      break;
    }
  }
  
  //Draw Locks
  if (locksVisible){
    for (int i =0; i < 3; i++){
      
    }
  }
  
  //Draw Checkmarks
  if (locksVisible){
    for (int i =0; i < 3; i++){
      
    }
  }
  
  //Check Safe Code
  displaySafeCode = true;
  for (int i = 0; i < 3; i++){
    if (!server.states[i]){
      
      break;
    }
  }
  
  //Display Safe Code
  if (displaySafeCode){
  
  }
  
  //Queue Video Mid
  if(server.states[3]){
    if(!videoPlayed){  
      videoPlayed = true;
      displaySafeCode = false;
      
      //Plays Video
      
    }
  }  
}

void keyReleased(){
  // Reset
  if(key=='r'){
    lastLoopTime = millis();
    notPause = false;
    videoPlayed = false;
    locksVisible = false;
    displaySafeCode = false;
    for (int i = 0; i < server.states.length; i++){
      server.states[i] = false;
    }
  }  
  // Play and Pause
  else if (key == ' '){
    notPause = !notPause;
  }
}
