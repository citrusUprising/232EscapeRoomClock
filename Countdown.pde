import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import processing.video.Movie;

// Server variables
int port = 9876;
ServerThread server;
int numberCommands = 6; // arduinos+start+reset
boolean notPause = false;
boolean videoPlayed = false;
boolean locksVisible = false;
boolean locksComplete = false;
boolean displaySafeCode = false;
boolean playIntro = false;
boolean endIntro = false;
PImage lock;
PImage check;
Movie snyder;
Movie scorcese;

// Countdown variables
final long maxTime = 3600000;
long countDown = maxTime;
long lastLoopTime = 0;

void setup(){

  // Create our server thread
  server = new ServerThread(port, numberCommands);
  
  // Start our server thread
  server.start();
  
  // For calcualting delta time
  lastLoopTime = millis();
  
  //Setup Images
  lock = loadImage("noun-lock-6635693.png");
  check = loadImage("noun-checkmark-5910880.png");
  
  // Configure basic sketch properties
  fullScreen();
  size(1920, 1080);
  
  snyder = new Movie (this, "ES - Zack Snyder Reveal + Scorsese Twist - Made with Clipchamp.mp4");
  scorcese = new Movie (this, "ER - Martin Scorsese Intro Video - Made with Clipchamp.mp4");
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
  
  if (playIntro&&!endIntro){
    scorcese.play();
    image(scorcese,0,0);
    if(scorcese.time() >= scorcese.duration()-0.1){
      scorcese.stop();
      endIntro = true;
      notPause =!notPause;
    }
  }
  
  //Check to Draw Locks
  if (!locksComplete){
    for (int i = 1; i < 4; i++){
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
    for (int i =1; i < 4; i++){
      //draw circle
      circle(370+300*i, 775, 275);
      //Draw Locks
      image(lock, 370+300*i-150, 650, 300, 300);
      if(server.states[i]){
        //draw checkmarks
        image(check, 370+300*i-160, 650, 320, 320);
      }
    }
  }
  
  //Check Safe Code
  displaySafeCode = true;
  locksComplete = true;
  for (int i = 1; i < 4; i++){
    if (!server.states[i]){
      displaySafeCode = false;
      locksComplete = false;
      break;
    }
  }
  if (videoPlayed){
    displaySafeCode = false;
  }
  
  //Display Safe Code
  if (displaySafeCode){
    textAlign(CENTER);
    text("743", width/2, height*3/4);
  }
  
  //Queue Video Mid
  if(server.states[4]&&!videoPlayed){
     //Plays Video
     snyder.play();
    image(snyder, 0, 0);
    if(snyder.time() >= snyder.duration()-0.1){
      snyder.stop();
      videoPlayed = true;
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
    playIntro = false;
    endIntro = false;
    for (int i = 0; i < server.states.length; i++){
      server.states[i] = false;
    }
  }  
  // Play and Pause
  else if (key == ' '){
    notPause = !notPause;
  }
  //Start room
  else if (key == 'w'){
    playIntro = true;
  }
  //FOR TESTING PURPOSES ONLY
  /**/else if (key == '0'){
    server.states[1] = true;
  }
  else if (key == '1'){
    server.states[2] = true;
  }
  else if (key == '2'){
    server.states[3] = true;
  }
  else if (key == '3'){
    server.states[4] = true;
  }/**/
}

void movieEvent(Movie m) {
  m.read();
}
