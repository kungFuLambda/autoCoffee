import 'dart:io';
import 'dart:async';

Socket socket;


void makeRequest(){
  Socket.connect("192.168.0.53", 6969).then((socket){
    socket.write("make coffee");
  } );
}

