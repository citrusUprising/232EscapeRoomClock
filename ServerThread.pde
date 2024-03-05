class ServerThread extends Thread {
  int port;
  //Countdown clock;
  ServerSocket server;
  Socket socket;
  boolean[] states;
  
  public ServerThread(int port, int numCommands){
    this.port = port;
    this.states = new boolean [numCommands];
    
    try {
      server = new ServerSocket(port);
    } catch(Exception e){
      println("Error creating server socket: ", e.toString());
    }
  }
  
  public void run(){
    while(true){
      println("Waiting for the client request");
      
      // Create the socket and waiting for client connection
      try {
        socket = server.accept();
      } catch(Exception e){
        println("Error connecting to client: ", e.toString());
      }
      
      // Once a connection is made, read from the socket to ObjectInputStream object
      try {
        //ois = new ObjectInputStream(socket.getInputStream());
        byte[] buf = new byte[4096];
        while(true) {
          int n = socket.getInputStream().read(buf);
          println("Read n bytes: ", n);
          if( n < 0 ){
            println("End of message");
            break;
          }else{
            println("Read message: ", int(buf[0]));
            int message = int(buf[0]);
           // if (clock.notPause){
              states [message] = true;
            //}
            println ("Successful check, Light #", message);
          }
        }
      } catch(Exception e){
        println("Error reading message from client: ", e.toString());
      }
      
      // Close the client connection and prepare to wait for a new one
      try {
        socket.close();
      } catch(Exception e){
        println("Error closing client connection: ", e.toString());
      }
    }    
  }
}
