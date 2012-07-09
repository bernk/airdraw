/* --------------------------------------------------------------------------
 * Author:  Bernard Kowalski / http://www.bernardkowalski.com/
 * Date:  25/03/2012
 * ----------------------------------------------------------------------------
 */
 
import SimpleOpenNI.*;
SimpleOpenNI kinect;

ArrayList<PVector> handPositions; // declare handPositions array globaly accessible

PVector currentHand; // position vectors to hold xyz values
PVector previousHand;

float activeDistance; // distance from "air paper" that is active




void setup() {
  
  size(640, 480); // size of canvas
  frameRate(60);
  
  kinect = new SimpleOpenNI(this);
  kinect.setMirror(true);
  
  kinect.enableDepth(); // enable depth map (array of distance values in mm)
  kinect.enableGesture(); // enable gesture recognition
  kinect.enableHands(); // enable hand gestures
  
  kinect.addGesture("RaiseHand"); // watch for a raised hand gesture
  handPositions = new ArrayList(); // initialize handPositions arraylist
  
  stroke(255, 0, 0);
  strokeWeight(3);
  
  activeDistance = 650; // initialize distance from "air paper" to be 650mm
  
}




void draw() {
  // draw loop where things happen x times per second
  
  println(frameRate);
  
  kinect.update(); // update the sensor data (max 30 times per second)
  
  image(kinect.depthImage(), 0, 0); // draw the kinect's depth image
  
  for(int i = 1; i < handPositions.size(); i++) {
    currentHand = handPositions.get(i);
    previousHand = handPositions.get(i - 1);
    
    if(currentHand.z <= activeDistance) {
      line(previousHand.x, previousHand.y, currentHand.x, currentHand.y);    
    }
  }
  
}




// hand events ------------------------------------------------------------------------

void onCreateHands(int handId, PVector position, float time) {
  kinect.convertRealWorldToProjective(position, position); // convert vectors to 2d xy coordinates
  handPositions.add(position); // add the first point for the drawing 
}

void onUpdateHands(int handId, PVector position, float time) {
  kinect.convertRealWorldToProjective(position, position);
  handPositions.add(position); 
  
  // println("hand x: " + currentHand.x + " y: " + currentHand.y + " z: " + currentHand.z);
}

void onDestroyHands(int handId, float time) {
  handPositions.clear(); // delete the xy points which make up the drawing
  kinect.addGesture("RaiseHand"); // watch for a raised hand again
}




// gesture events ---------------------------------------------------------------------

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition) {
  kinect.startTrackingHands(endPosition);
  kinect.removeGesture("RaiseHand"); // ignore raised hand gestures as there we have a lock on a hand
}

