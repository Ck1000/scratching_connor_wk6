import processing.core.PApplet;
import processing.core.PImage;
import processing.core.PFont;
import java.util.ArrayList;
import processing.core.PGraphics;
import java.util.Arrays; 

public class enemy extends Sprite {
  int health = 0;
  int colorTimeout = 0;
  int attackTimeout = 0;
  boolean hasSeenPlayer = false;

  // added enemy type argument to Constructor block, below
  enemy (int enemyType, PApplet parent, Stage stage) {
    super(parent, stage); // super invokes the Sprite's own constructor (set up code)
    switch (enemyType) {
      case 0: addDefaultCostumes();
      health = 5;
      break;
    case 1: 
      addCostume("images/zombie.png");
      health = 3;
      break;
    case 2: 
      addCostume("images/skeleton.png");
      health = 2;
      break;
    case 3: 
      addCostume("images/creeper.png");
      health = 5; 
      break;
    case 4: 
      addCostume("images/pig.png");
      health = 2;
      break;
    }
  }
}
