class Brain {
  int ilnNum = 4;
  int hlNum = 2;
  int hlnNum = 4;
  int olnNum = 1;

  int nodeSize = 20;

  ArrayList<ArrayList<Float>> matrixValues;
  ArrayList<ArrayList<ArrayList<Float>>> matrixWeights;
  ArrayList<ArrayList<Float>> matrixBias;
  
  int drawOffset = 600;
  Brain() {

    matrixValues = new ArrayList<ArrayList<Float>>();
    matrixWeights = new ArrayList<ArrayList<ArrayList<Float>>>();
    matrixBias = new ArrayList<ArrayList<Float>>();

    ArrayList<Float> tempInputLayer = new ArrayList<Float>();
    for (int ilnIndex = 0; ilnIndex < ilnNum; ilnIndex++) {
      tempInputLayer.add(0.0);
    }
    matrixValues.add(tempInputLayer);

    for (int hlIndex = 0; hlIndex < hlNum; hlIndex++) {
      ArrayList<Float> tempHiddenLayer = new ArrayList<Float>();
      for (int hlnIndex = 0; hlnIndex < hlnNum; hlnIndex++) {
        tempHiddenLayer.add(0.0);
      }
      matrixValues.add(tempHiddenLayer);
    }

    ArrayList<Float> tempOutputLayer = new ArrayList<Float>();
    for (int ilnIndex = 0; ilnIndex < olnNum; ilnIndex++) {
      tempOutputLayer.add(0.0);
    }
    matrixValues.add(tempOutputLayer);

    for (int wlIndex = 0; wlIndex < hlNum+1; wlIndex++) {
      ArrayList<ArrayList<Float>> tempWeightLayer = new ArrayList<ArrayList<Float>>();
      for (int wlnIndex = 0; wlnIndex < matrixValues.get(wlIndex+1).size(); wlnIndex++) {
        ArrayList<Float> tempWeightNode = new ArrayList<Float>();
        for (int plnIndex = 0; plnIndex < matrixValues.get(wlIndex).size(); plnIndex++) {
          tempWeightNode.add(random(-5, 5));
        }
        tempWeightLayer.add(tempWeightNode);
      }
      matrixWeights.add(tempWeightLayer);
    }

    for (int blIndex = 0; blIndex < hlNum+1; blIndex++) {
      ArrayList<Float> tempBiasNode = new ArrayList<Float>();
      for (int blnIndex = 0; blnIndex < matrixValues.get(blIndex+1).size(); blnIndex++) {
        tempBiasNode.add(random(-5, 5));
      }
      matrixBias.add(tempBiasNode);
    }
  }

  void draw() {
    drawLines();
    drawNodes();
  }

  void drawNodes() {
    String str = "";

    stroke(0);
    textAlign(CENTER, CENTER);
    for (int layerIndex = 0; layerIndex < matrixValues.size(); layerIndex++) {
      for (int lnIndex = 0; lnIndex < matrixValues.get(layerIndex).size(); lnIndex++) {
        if(matrixValues.get(layerIndex).get(lnIndex) > 0.9) {
          fill(color(0,255,0));
        } else {
          fill(255);
        }
        ellipse( (brainWindowSize / (matrixValues.size()+1)) * (layerIndex+1), (brainWindowSize / (matrixValues.get(layerIndex).size()+1)) * (lnIndex+1)+drawOffset, nodeSize, nodeSize);
        fill(0);
        str = nf(matrixValues.get(layerIndex).get(lnIndex), 2, 2);
        text(str, (brainWindowSize / (matrixValues.size()+1)) * (layerIndex+1), (brainWindowSize / (matrixValues.get(layerIndex).size()+1)) * (lnIndex+1)+drawOffset);
      }
    }
  }



  void drawLines() {
    for (int layerIndex = 0; layerIndex < matrixWeights.size(); layerIndex++) {
      for (int lnIndex = 0; lnIndex < matrixWeights.get(layerIndex).size(); lnIndex++) {
        for (int plnIndex = 0; plnIndex < matrixWeights.get(layerIndex).get(lnIndex).size(); plnIndex++) {
          if (matrixWeights.get(layerIndex).get(lnIndex).get(plnIndex) > 0) {
            stroke(color(255, 0, 0));
          } else {
            stroke(color(0, 0, 255));
          }
          line( (brainWindowSize / (matrixValues.size()+1)) * (layerIndex+1), (brainWindowSize / (matrixValues.get(layerIndex).size()+1)) * (plnIndex+1)+drawOffset, (brainWindowSize / (matrixValues.size()+1)) * (layerIndex+1+1), (brainWindowSize / (matrixValues.get(layerIndex+1).size()+1)) * (lnIndex+1)+drawOffset);
          stroke(0);
        }
      }
    }
  }

  void compute() {
    for (int layerIndex = 1; layerIndex < matrixValues.size(); layerIndex++) {
      for (int lnIndex = 0; lnIndex < matrixValues.get(layerIndex).size(); lnIndex++) {
        float sum = 0;
        for (int plnIndex = 0; plnIndex < matrixValues.get(layerIndex-1).size(); plnIndex++) {
          sum += (matrixValues.get(layerIndex-1).get(plnIndex) * (1+matrixWeights.get(layerIndex-1).get(lnIndex).get(plnIndex)) + matrixBias.get(layerIndex-1).get(lnIndex));
        }
        matrixValues.get(layerIndex).set(lnIndex, sigmoid(sum));
      }
    }
  }
}
