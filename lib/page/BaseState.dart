
import 'package:flutter/material.dart';
import 'package:imclient/core/IMClient.dart';

 abstract class BaseState<T> extends State with ClientCallback{
   @override
   void initState(){
     super.initState();
     IMClient.getInstance().addListener(this);
   }

   @override
   void dispose(){
     IMClient.getInstance().removeListener(this);
     super.dispose();
   }
}//end class
