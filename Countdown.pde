import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import processing.video.Movie;
import processing.sound.*;

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
SoundFile correct;

// Countdown variables
final int totalMinute = 45;
final long maxTime = totalMinute*60000;
long countDown = maxTime;
long lastLoopTime = 0;
int min = (int)countDown / 60000;
String sec = formatSec(((int)countDown % 60000)/1000);

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
  //size(1920, 1080);
  
  snyder = new Movie (this, "ES - Zack Snyder Reveal + Scorsese Twist - Made with Clipchamp.mp4");
  scorcese = new Movie (this, "ER - Martin Scorsese Intro Video - Made with Clipchamp.mp4");
  correct = new SoundFile(this, "zapsplat_multimedia_game_sound_game_show_correct_tone_bright_positive_004_80745.mp3");
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
  text(min+":"+sec, width/2, height/2);
  
  if (notPause && countDown > 0){
    // Update countdown
    countDown -= delta;
    min = (int)countDown / 60000;
    sec = formatSec(((int)countDown % 60000)/1000);
    
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
    text("891", width/2, height*3/4);
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
    min = (int)countDown / 60000;
    sec = formatSec(((int)countDown % 60000)/1000);
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
  /**/else if (key == '1'){
    laserTrigger(1);
  }
  else if (key == '2'){
    laserTrigger(2);
  }
  else if (key == '3'){
    laserTrigger(3);
  }
  else if (key == '4'){
    laserTrigger(4);
  }/**/
}

void movieEvent(Movie m) {
  m.read();
}

String formatSec (int i){
  String result = i+"";
  if(i < 10){
    result = "0" + result;
  }
  return result;
}

public void laserTrigger (int ID){
  if (!server.states[ID]&&ID<4){
    /*Game sound, game show correct tone, bright and positive 4
    Sound provided by ZapSplat
    https://www.zapsplat.com/author/zapsplat/*/
    correct.play();
  }
    server.states[ID] = true;
}
