// these values are "static," which means they do not change.
static int rotationStyle_360degrees=0;
static int rotationStyle_leftRight=1;
static int rotationStyle_dontRotate=2;
static int upArrow=0;
static int downArrow=1;
static int leftArrow=2;
static int rightArrow=3;
int emerald=100;
int attackTimeout=0;
// These arrays contain boolean values for each key and arrow key
boolean[] keyIsDown = new boolean[256];
boolean[] arrowIsDown = new boolean[4];

// 5 important variables and objects
static int gridSizeX = 14;
static int gridSizeY = 14;
String gamestate = "placing";
Sprite cursor;
Sprite player;
ArrayList<block> blocks = new ArrayList<block>();
ArrayList<enemy> enemies = new ArrayList<enemy>();
ArrayList<Sprite> arrows = new ArrayList<Sprite>();

// User variables and objects are "declared", or listed, here.
// Our sample includes one Stage object, called stage, and one Sprite object, called cursor.
Stage stage;


// Setup runs once, and sets some default values
void setup() {
  frameRate(30);
  // first, create a Processing window 500 px by 500 px
  size(500, 500);
  // next, initialize a Stage object with the X-Y grid backdrop
  stage = new Stage(this);
  stage.addDefaultBackdrop();
  // now add a "cursor" Sprite object & attach it to our stage. Go to the center of the screen.
  cursor = new Sprite(this, stage);
  cursor.addCostume("images/Wood.png");
  cursor.addCostume("images/Sand.png");
  cursor.addCostume("images/Stone.png");
  cursor.addCostume("images/Glass.png");
  cursor.addCostume("images/fighter.png");
  cursor.addCostume("images/archer.png");
  cursor.direction=0;
  cursor.show();
  cursor.size = 200;
  player = new Sprite(this, stage);
  player.addDefaultCostumes();
  player.direction=0;
  player.size = 10;
  player.goToXY(width/2, height-50);
  player.show();
}

//4 game control functions here -- more below
void draw() {
  if (gamestate=="playing") gameLoop();
  if (gamestate=="placing") placeModeLoop();
  drawAllBlocks();
  stage.draw();
  if (gamestate=="placing")


  { 
    textSize(20); 
    fill(20); 
    text(emerald, width/2, 20);
  }
}

void gameLoop() {
  moveAllBlocks();
  if (enemies.size() < 1) spawnEnemies();
  moveEnemies();
  drawAndMoveArrows();
  attackTimeout--;
  player.draw();
  if (arrowIsDown[upArrow]) { 
    player.direction = 90; 
    player.move(5);
  }
  if (arrowIsDown[rightArrow]) { 
    player.direction = 0; 
    player.move(5);
  }
  if (arrowIsDown[downArrow]) { 
    player.direction = 270; 
    player.move(5);
  }
  if (arrowIsDown[leftArrow]) { 
    player.direction = 180; 
    player.move(5);
  }
}

void placeModeLoop() {
  // finally, draw the stage and then draw the cursor 
  int cursorX = ((int)(mouseX/gridSizeX)+1);
  int cursorY = ((int)(mouseY/gridSizeY)+1);
  //if (cursorX > 19) cursorX = 19;
  //if (cursorY > 19) cursorY = 19;
  cursor.goToXY(cursorX*gridSizeX, cursorY*gridSizeY);
  cursor.draw();
  player.draw();
}

void toggleGameMode() {
  if (gamestate=="playing") gamestate = "placing";
  else gamestate = "playing";
}



// the code below is essential for certain Scratching functions. Do not change keyPressed
// or keyReleased - unless you're absolute sure you know what you're doing!
void keyPressed() { 
  if (key=='w') cursor.nextCostume();
  if (key==' ') toggleGameMode();
  if (key=='z') attack();
  if (stage.askingQuestion) stage.questionKeycheck();
  if (key<256) {
    keyIsDown[key] = true;
  }
  if (key==CODED) {
    switch (keyCode) {
    case UP: 
      arrowIsDown[upArrow]=true; 
      break;
    case DOWN: 
      arrowIsDown[downArrow]=true; 
      break;
    case LEFT: 
      arrowIsDown[leftArrow]=true;  
      break;
    case RIGHT: 
      arrowIsDown[rightArrow]=true; 
      break;
    }
  }
}

// the code below is essential for certain Scratching functions. Do not change keyPressed
// or keyReleased - unless you're absolute sure you know what you're doing!
void keyReleased() {
  if (key<256) {
    keyIsDown[key] = false;
  }
  if (key==CODED) {
    switch (keyCode) {
    case UP: 
      arrowIsDown[upArrow]=false; 
      break;
    case DOWN: 
      arrowIsDown[downArrow]=false; 
      break;
    case LEFT: 
      arrowIsDown[leftArrow]=false;  
      break;
    case RIGHT: 
      arrowIsDown[rightArrow]=false; 
      break;
    }
  }
}

void mousePressed() {
  if (gamestate=="placing") {
    float cursorX = (int)(mouseX/gridSizeX)+1;
    float cursorY = (int)(mouseY/gridSizeY)+1;
    if (cursorX < 50 && cursorY < 50) addBlock(cursorX, cursorY);
  }
}

void spawnEnemies() {
  int i = 0;
  do {
    addEnemy();
    i++;
  } 
  while (enemies.size () < 3);
} 

void addEnemy() {
  int newest = enemies.size();
  enemies.add(new enemy(0, this, stage));
  enemies.get(newest).addDefaultCostumes();
  enemies.get(newest).goToXY(random(0, width), 0);
  enemies.get(newest).direction = 270;
  enemies.get(newest).rotationStyle = rotationStyle_leftRight;
  enemies.get(newest).size = 45;
}

void moveEnemies() {
  boolean removeEnemy = false;
  for (int i=0; i<enemies.size (); i++) {
    boolean mayMove = true;
    removeEnemy = false;
    for (int j=0; j<blocks.size (); j++) {
      if (enemies.get(i).touchingSprite(blocks.get(j))) {
        mayMove = false;
        blocks.get(j).ghostEffect += 10;
        enemies.get(i).attackTimeout--;
        if (enemies.get(i).attackTimeout<0) {
          enemies.get(i).attackTimeout=15;
          blocks.get(j).health -= 1;
        }
        if (blocks.get(j).health < 0) {
          blocks.remove(j); 
          j--;
        }
        break;
      }
    }
    if (mayMove) {
      enemies.get(i).move(2);
      if (frameCount % 3==0) enemies.get(i).nextCostume();
    }
    if (enemies.get(i).distanceToSprite(player)<200 || enemies.get(i).hasSeenPlayer==true) {
      enemies.get(i).hasSeenPlayer=true;
      enemies.get(i).pointToSprite(player);
    }
    if (enemies.get(i).colorTimeout>0) {
      enemies.get(i).colorTimeout--;
      if (enemies.get(i).colorTimeout==0) enemies.get(i).colorEffect=0;
    }
    if (enemies.get(i).isOffStageBottom()==true || enemies.get(i).health < 0) {
      removeEnemy = true;
    }
    if (removeEnemy) {
      enemies.remove(i);
      i--;
    } else enemies.get(i).draw();
  }
}

void addBlock(float x, float y) {
  if (emerald >= block.cost(cursor.costumeNumber)) {
    int newest = blocks.size();
    // this has changed: new "block" type has an extra parameter, the block type
    blocks.add(new block(cursor.costumeNumber, this, stage));
    blocks.get(newest).goToXY(x*gridSizeX, y*gridSizeY);
    blocks.get(newest).size = 150;
    blocks.get(newest).anchorX = blocks.get(newest).pos.x;
    blocks.get(newest).anchorY = blocks.get(newest).pos.y;
    emerald-= block.cost(cursor.costumeNumber);
  }
}

void moveAllBlocks() {
  for (int i = 0; i < blocks.size (); i++) {
    if (blocks.get(i).type == 4) {
      // be a fighter
      float followDistance = 200;
      enemy target = new enemy(0, this, stage); target.goToXY(-1000,-1000);
      blocks.get(i).actionTimeout--;
      target.pos.x = blocks.get(i).anchorX;
      target.pos.y = blocks.get(i).anchorY;
      for (int j = 0; j < enemies.size (); j++) {
        if (enemies.get(j).distanceToSprite(blocks.get(i)) < followDistance) {
          followDistance = enemies.get(j).distanceToSprite(blocks.get(i));
          target = enemies.get(j);
        }
        if (blocks.get(i).distanceToXY(blocks.get(i).anchorX, blocks.get(i).anchorY) < 100) {
          blocks.get(i).pointToSprite(target);
          blocks.get(i).move(2);
          if (blocks.get(i).touchingSprite(target) && blocks.get(i).actionTimeout < 0) {
            target.health --;
            blocks.get(i).actionTimeout = 10;
          }
          if (blocks.get(i).distanceToXY(blocks.get(i).anchorX, blocks.get(i).anchorY) > 100) blocks.get(i).move(-2);
        }
      }
      float storedGhostEffect = blocks.get(i).ghostEffect;
      blocks.get(i).ghostEffect = 50;
      blocks.get(i).stamp(blocks.get(i).anchorX, blocks.get(i).anchorY);
      blocks.get(i).ghostEffect = storedGhostEffect;
    } else if (blocks.get(i).type == 5) {
      // be an archer
      float followDistance = 150;
      enemy target = new enemy(0, this, stage); target.goToXY(-1000,-1000);
      blocks.get(i).actionTimeout--;
      for (int j = 0; j < enemies.size (); j++) {
        if (enemies.get(j).distanceToSprite(blocks.get(i)) < followDistance && blocks.get(i).actionTimeout < 0) {
          followDistance = enemies.get(j).distanceToSprite(blocks.get(i));
          target = enemies.get(j);
          blocks.get(i).actionTimeout = 10;
        }
        if (followDistance < 150) {
          blocks.get(i).pointToSprite(target);
          if (blocks.get(i).distanceToSprite(target) < 150) fireArrowAt(blocks.get(i),target);
        }
      }
    }
  }
}

void fireArrowAt(block shooter, enemy target) {
  int newest = arrows.size();
  arrows.add(new Sprite(this, stage));
  arrows.get(newest).addDefaultCostumes();
  arrows.get(newest).goToXY(shooter.pos.x, shooter.pos.y);
  arrows.get(newest).pointToSprite(target);
  arrows.get(newest).size = 10;
}

void drawAndMoveArrows() {
  for (int i = 0; i < arrows.size (); i++) {
    boolean remove = false;
    arrows.get(i).move(5);
    if (arrows.get(i).isOffStage()) remove = true;
    for (int j = 0; j < enemies.size (); j++) {
      if (arrows.get(i).touchingSprite(enemies.get(j))) {
        remove = true;
        enemies.get(j).health --;
      }
    }
    arrows.get(i).draw();
  }
}

void drawAllBlocks() {
  for (int i = 0; i < blocks.size (); i++) {
    blocks.get(i).draw();
  }
}

void attack() {
  println("attack timeout: "+attackTimeout);
  if (attackTimeout < 0) {
    attackTimeout = 10;
    //player.costumeNumber = AttackCostume;
    for (int i = 0; i<enemies.size (); i++) {
      if (player.distanceToSprite(enemies.get(i)) < 50) {
        enemies.get(i).health -= 3;
        enemies.get(i).move(-20);
        enemies.get(i).colorEffect=10;
        enemies.get(i).colorTimeout=15;
      }
    }
  }
}
