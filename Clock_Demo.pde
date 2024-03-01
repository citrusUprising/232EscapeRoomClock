boolean play = false;
boolean startHit = false;
boolean alarmPlayed = false;
boolean timeUp = false;
boolean[] lasers;
int laserMax = 4;
int laser = 0;
int min;
int sec;
int totalTime = 3600000;
int startTime;

void setup(){
  size (1920,1080);
  background (0);
  startTime = millis();
}

void draw(){
  
  if (play){
    int passedTime = millis()-startTime;
    min = passedTime/60000;
    sec = (passedTime%60000)/1000;
    if(passedTime > totalTime){
      alarmPlayed = true;
      timeUp = true;
      play = false;
    }
  }
  else if (startHit){
    startHit = false;
    play = true;
    startTime = millis();
  }
  else {
    /*if(space bar){
      startHit = true;
      timeUp = false;
    }*/
  }
  
  if (laser >= laserMax){
    laser = laserMax;
  }
  
  if (laser > 1){
    /*for loop targets
    for loop checks*/
  }
  
  if(alarmPlayed){
    alarmPlayed = false;
    //play alarm
  }
}
