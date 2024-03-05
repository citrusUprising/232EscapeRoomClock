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
boolean locksComplete = false;
boolean displaySafeCode = false;
PImage lock;
PImage check;

// Countdown variables
final long maxTime = 3600000;
long countDown = maxTime;
long lastLoopTime = 0;

void setup(){
  // Configure basic sketch properties
  //fullScreen();
  size(1920, 1080);
  
  // Create our server thread
  server = new ServerThread(port, numberCommands);
  
  // Start our server thread
  server.start();
  
  // For calcualting delta time
  lastLoopTime = millis();
  
  //Setup Images
  //size(50,50);
  lock = loadImage("noun-lock-6635693.png");
  check = loadImage("noun-checkmark-5910880.png");
}

void draw(){
  background(0);
  
  // Calculate delta time
  long delta = millis() - lastLoopTime;
  lastLoopTime = millis();
  
   // Draw countdown
  textSize(255);
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
  if (!locksComplete){
    for (int i = 0; i < 3; i++){
      if(server.states[i] == true){
        locksVisible = true;
        break;
      }
    }
  }
  else {
    locksVisible = false;
  }

  
  if (locksVisible){
    for (int i =0; i < 3; i++){
      //Draw Locks
      image(lock, 920+50*i, 700);
      if(server.states[i]){
        //draw checkmarks
        image(check, 920+50*i, 700);
      }
    }
  }
  
  //Check Safe Code
  displaySafeCode = true;
  locksComplete = true;
  for (int i = 0; i < 3; i++){
    if (!server.states[i]||videoPlayed){
      displaySafeCode = false;
      locksComplete = false;
      break;
    }
  }
  
  //Display Safe Code
  if (displaySafeCode){
    textAlign(CENTER);
    text("Password", width/2, height*3/4);
  }
  
  //Queue Video Mid
  if(server.states[3]){
    if(!videoPlayed){  
      videoPlayed = true;
      
      //Plays Video
      
      
    }
  }  
}

void keyReleased(){
  // Reset
  if(key=='r'){
    countDown = maxTime;
    notPause = false;
    videoPlayed = false;
    locksVisible = false;
    displaySafeCode = false;
    locksComplete = false;
    for (int i = 0; i < server.states.length; i++){
      server.states[i] = false;
    }
  }  
  // Play and Pause
  else if (key == ' '){
    notPause = !notPause;
  }
  //FOR TESTING PURPOSES ONLY
  /**/else if (key == '0'){
    server.states[0] = true;
  }
  else if (key == '1'){
    server.states[1] = true;
  }
  else if (key == '2'){
    server.states[2] = true;
  }
  else if (key == '3'){
    server.states[3] = true;
  }/**/
}
