Array2D field; //The playing field representation of the game board.

//Who's turn it is for the game.
final boolean blackTurn = true;
final boolean whiteTurn = false;
boolean turn = whiteTurn;

//Whether or not to show the moves a player can make on this turn.
boolean showValidMoves = false;
//Whether or not to use the AI player for these teams.
boolean allowBlackAI = false;
boolean allowWhiteAI = false;
final int maxAIDelay = 30; //The ammount of time between a turn starting and the AI making a play. Used for ease of understanding.
int aiDelay = maxAIDelay;

//Buttons for playing again and for toggling valid move display.
MovesButton showMoves = new MovesButton("Show Moves", new PVector(50, 50), 100, 50);
//Buttons for enabling AI players for either the black or white team.
AIButton blackAI = new AIButton("Black AI", new PVector(50, 125), 100, 50, 1);
AIButton whiteAI = new AIButton("White AI", new PVector(50, 200), 100, 50, 2);
//Button to let the player play again.
Button playAgain = new Button("Play Again", new PVector(475, 600), 150, 50);

//Setting up all of the default variables guarentees it is exactly how we expect regardless what else has happened.
void setup() {
  size(1280, 720, FX2D);
  rectMode(CORNER);
  ellipseMode(CORNER);
  field = new Array2D(8, 8, 440, 160);
  field.startingPieces();
  textSize(24);
  frameRate(30); //We don't need to try for 60 fps in this game so lets take the extra processing time.
}

//Reset the background and draw the board.
//Also draws scores and stuff.
void draw() {
  background(9, 165, 55); //Draws the default background
  
  //Update the button to show moves before rendering the board so that it is available for the rest of the code.
  showMoves.isMouseOver();
  blackAI.isMouseOver();
  whiteAI.isMouseOver();

  field.display(); //Draws the board
  
  //Draws a title
  textSize(96);
  stroke(0);
  fill(0);
  strokeWeight(4);
  text("Othello", 475, 100);
  
  //Updates internal game logic like scores and checking if a player won.
  field.updateBoardState();
  if(field.moveAvailable == false){ //Checks if the current player can play. If they can't the game is over.
    if(field.getTeamScore(1) > field.getTeamScore(2)){ //Displays who won. It's a pain but changing colour needs these checks.
      stroke(0);
      fill(0);
      strokeWeight(2);
      textSize(26);
      text("Black Wins", 575, 150);
    }else if(field.getTeamScore(2) > field.getTeamScore(1)){
      stroke(255);
      fill(255);
      strokeWeight(2);
      textSize(26);
      text("White Wins", 575, 150);
    }else if(field.getTeamScore(1) == field.getTeamScore(2)){ //This is possible but unlikely.
      stroke(0, 255, 0);
      fill(0, 255, 0);
      strokeWeight(2);
      textSize(26);
      text("It's a Tie", 575, 150);
    }
    playAgain.isMouseOver(); //Now the play again button needs to be handled.
    playAgain.show(); // We can also render it because it is important.
  }else{
    //Draws who's turn it is
    if(turn == whiteTurn){
      stroke(255);
      fill(255);
      strokeWeight(2);
      textSize(26);
      text("White's Turn", 560, 150);
      
      //If its whites turn then let it also run its own ai.
      if(allowWhiteAI){ //Of we are using the ai, then go
        aiDelay--; //Countdown on the delay. Otherwise a turn would last exactly 1 frame and we want some delay.
        if(aiDelay == 0){ //If we are done waiting
          gameAI(getTeam()); //Run the ai for this team
          aiDelay = maxAIDelay; //Then reset the timer.
        }
      }
    }else if(turn == blackTurn){
      stroke(0);
      fill(0);
      strokeWeight(2);
      textSize(26);
      text("Black's Turn", 560, 150);
      
      //If its blacks turn and there are moves available then we can check if AI is enabled and run it.
      if(allowBlackAI){
        aiDelay--;
        if(aiDelay == 0){
          gameAI(getTeam());
          aiDelay = maxAIDelay;
        }
      }
    }
  }
  
  //Done after a logic update so scores are accurate
  int blackScore = field.getTeamScore(1);
  int whiteScore = field.getTeamScore(2);
  //Draws the scores assuming nothing about previous rendering state.
  textSize(24);
  strokeWeight(2);
  stroke(0);
  fill(0);
  text("Black " + blackScore, 300, 500);
  stroke(255);
  fill(255);
  text("White " + whiteScore, 900, 500);
  
  //Draw buttons after that because I needed to do them at some point.
  showMoves.show();
  blackAI.show();
  whiteAI.show();
}

//When the mouse is clicked see if a tile can be played.
void mousePressed() {
  Tile pressed = field.getClickedTile(); //Get's the tile the mouse was over when the key was pressed
  if(pressed != null){ //Makes sure the player wasn't over air when they clicked.
    if((allowBlackAI && getTeam() == 1) || (allowWhiteAI && getTeam() == 2)){ //If it is an AI's turn
      //Let the AI make the move.
    }else{ //Otherwise let the player make moves.
      if(pressed.turn(getTeam())){ //If they weren't, then let the tile process the turn. It will return true if it is a valid play.
        turn = !turn; //If the play was allowed then it is the next players turn.
      }
    }
  }else if(showMoves.isMouseOver()){ //If the player didn't click a tile, check the other buttons.
    showValidMoves = !showValidMoves; //Toggles move display.
  }else if(playAgain.isMouseOver()){ //Reset the game
    reset();
  }else if(blackAI.isMouseOver()){ //Toggle black AI
    allowBlackAI = !allowBlackAI;
  }else if(whiteAI.isMouseOver()){ //Toggle white AI
    allowWhiteAI = !allowWhiteAI;
  }
}

//Storing the turn as a boolean saves ram but we need 3 states for the piece so we have to convert between the int and byte representations.
byte getTeam(){
  if(turn == blackTurn){
    return 1; //The black team is team 1
  }else if(turn == whiteTurn){
    return 2; //The white team is team 2
  }else{
    return 0; //0 Is just an error handling value. It should never be possible.
  }
}

//Reinitalizes base variables and starts the game again.
void reset(){
  playAgain.mouseOver = false; //If we don't do this it will cause an issue.
  field = new Array2D(8, 8, 440, 160); //Resets the board to being completly empty.
  field.startingPieces(); //Places the initial pieces to start the game.
}

//Runs perimative AI logic
void gameAI(byte team){
  int topScore = 0; //The highest score we've found so far
  int topX = 0; //Where that high score is
  int topY = 0;
  int currentScore;
  
  for(int x = 0; x < 8; x++){
    for(int y = 0; y < 8; y++){
      currentScore = field.getAt(x, y).eval(team); //Get the score for the current tile
      if(currentScore > topScore){ //if its more than our previous last score
        topScore = currentScore; //Then save it
        topX = x;
        topY = y;
      }
    }
  }
  //Finally make the move.
  if(field.getAt(topX, topY).turn(team)){ //If this returns false then the game should be over because a tile with no valid move has score of 0.
    turn = !turn;
  }
}