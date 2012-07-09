/* --------------------------------------------------------------------------
 * Author:  Bernard Kowalski / http://www.bernardkowalski.com/
 * Date:  25/03/2012
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

SimpleOpenNI kinect;

int closestValue;
int farthestValue;
int farthestX;
int farthestY;
int closestX;
int closestY;

// previous frame's x,y
int previousX;
int previousY;

void setup() {
  size(640, 480);
  frameRate(30);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
}

void draw() {
  // clear the frame
  background(255, 204, 0);
  // initialize closestValue with end of spectrum value
  closestValue = 8000; // 8000mm or 8m will be the farthest point readable
  farthestValue = 0;
  
  // update the data from the kinect
  kinect.update();
  
  // get the hi-res depth array from the kinect
  int[] depthValues = kinect.depthMap();
  
  // for each row of the depth image
  for(int y = 0; y < 480; y++) {
    // check each pixel in the row
    for(int x = 0; x < 640; x++) {
      // retrieve value from depth array
      // note: get row number by mulitpling y (or row) by the amount of pixels in a row
      // add x to find the exact pixel we're looking for
      int i = y * 640 + x;
      int currentDepthValue = depthValues[i]; 
      // if the index pixel is the closest one so far
      if(currentDepthValue > 0 && currentDepthValue < closestValue) {
        // save its value
        closestValue = currentDepthValue;
        // and position (x and y)
        closestX = x;
        closestY = y;
      }
      // if the index pixel is the farthest one so far
      if(currentDepthValue < 8000 && currentDepthValue > farthestValue) {
        farthestValue = currentDepthValue;
        farthestX = x;
        farthestY = y;  
      }
    }
  }
  
  // draw depth image
//  image(kinect.depthImage(), 0, 0);

  // let's draw some lines
//  stroke(255, 0, 0);
//  line(previousX, previousY, closestX, closestY);
//  previousX = closestX;
//  previousY = closestY;
  
  // draw a cirle positioned at x,y of closest pixel
  fill(255, 48, 52);
  smooth();
  noStroke();
  ellipse(closestX, closestY,20, 20);

}
