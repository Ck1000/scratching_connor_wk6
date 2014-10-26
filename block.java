import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PFont;
import java.util.ArrayList;
import processing.core.PGraphics;
import java.util.Arrays; 

public class block extends Sprite {
  int health = 0;
  int cost = 0;
  // added "type" and "anchor" positions for attack blocks. constructor will set "type" automatically. set anchorX and anchorY in your sketch's void addBlock();
  int type = 0;
  float anchorX = 0;
  float anchorY = 0;
  int actionTimeout = 0;

  block (int blockType, PApplet parent, Stage stage) {
    super(parent, stage); // super invokes the Sprite's own constructor (set up code)
    type = blockType;
    cost = cost(type);
    
    switch (blockType) {
    case 0: 
      addCostume("images/Wood.png");
      health = 3;
      break;
    case 1: 
      addCostume("images/Sand.png");
      health = 2;
      break;
    case 2: 
      addCostume("images/Stone.png");
      health = 5; 
      break;
    case 3: 
      addCostume("images/Glass.png");
      health = 2;
      break;
      // fighter is type 4
    case 4: 
      addCostume("images/fighter.png");
      health = 2;
      break;
      // archer is type 5
    case 5: 
      addCostume("images/archer.png");
      health = 2;
      break;
    }
  }

  public static int cost(int type) {
    switch (type) {
    case 0: 
      return 3;
    case 1: 
      return 2;
    case 2: 
      return 5;
    case 3: 
      return 2;
    }
    return -99;
  }
}
