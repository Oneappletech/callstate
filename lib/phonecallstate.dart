import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


typedef void ErrorHandler(String message);

class Phonecallstate {
  static const MethodChannel _channel =
      const MethodChannel('com.plusdt.phonecallstate');

  VoidCallback incomingHandler;
  VoidCallback dialingHandler;
  VoidCallback connectedHandler;
  VoidCallback disconnectedHandler;
  ErrorHandler errorHandler;
  static String incomingnumber;


  Phonecallstate(){
    _channel.setMethodCallHandler(platformCallHandler);
  }

  Future<dynamic> setTestMode(double seconds) => _channel.invokeMethod('phoneTest.PhoneIncoming', seconds);

  void setIncomingHandler(VoidCallback callback) {
    incomingHandler = callback;
  }
  void setDialingHandler(VoidCallback callback) {
    dialingHandler = callback;
  }
  void setConnectedHandler(VoidCallback callback) {
    connectedHandler = callback;
  }
  void setDisconnectedHandler(VoidCallback callback) {
    disconnectedHandler = callback;
  }

  void setErrorHandler(ErrorHandler handler) {
    errorHandler = handler;
  }


  Future platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    var calldata=call.method;
    var callcompletedata=calldata.split("_");
    incomingnumber=callcompletedata[1];
   // print(callcompletedata[0]);
    switch (callcompletedata[0]) {
      case "phone.incoming":
        if (incomingHandler != null) {
          incomingHandler();
          incomingnumber=callcompletedata[1];
        }
        break;
      case "phone.dialing":
        //print("dialing");
        if (dialingHandler != null) {
          dialingHandler();
          incomingnumber=callcompletedata[1];
        }
        break;
      case "phone.connected":
        //print("connected");
        if (connectedHandler != null) {
          connectedHandler();
          incomingnumber=callcompletedata[1];
        }
        break;
      case "phone.disconnected":
        
        if (disconnectedHandler != null) {
          disconnectedHandler();
          incomingnumber=callcompletedata[1];
      }
        break;
      case "phone.onError":
        if (errorHandler != null) {
          errorHandler(call.arguments);
        }
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }
}
