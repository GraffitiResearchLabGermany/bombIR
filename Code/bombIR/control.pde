
// Radio Button
void CropBox(int a) {
  adjustBox = a;
}

// Camera
 void CAM(boolean theFlag) {
  if(theFlag == true) {
    calibShowCam = true;
  } else if (theFlag == false) {
    calibShowCam = false;
  }
 }
 
// Blob
 void BLB(boolean theFlag) {
  if(theFlag == true) {
    calibShowBlob = true;
  } else if (theFlag == false) {
    calibShowBlob = false;
  }
 }

// Min 
void BlobMin(float range) {
  blobMin = range;
  //println("Minimum Blob Size Set To " + blobMin);
}

// Max
void BlobMax(float range) {
  blobMax = range;
  //println("Maximum Blob Size Set To " + blobMax);
}

// Thresh
void BlobThresh(float thresh) {
  blobThresh = thresh;
  //println("Threshold Blob Size Set To " + blobThresh);
}

// Save Blob Settings
public void SaveSettings() {
  saveCalibrationSettings();
  println("Saving Blob Tracking Config");
}
