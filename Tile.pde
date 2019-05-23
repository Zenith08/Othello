//Represents a tile on the board.
class Tile{
  PVector position; //The 2d position for rendering and mouse logic.
  final int sizeX = 50, sizeY = 50; //The size of a tile.
  final int boardX, boardY; //The 2d position on the game board.
  final int strokeWeight = 2;
  final int circleReduction = 6; //How much smaller a piece drawing is than the size.
  
  //Constants for the piece state
  final byte empty = 0; //No piece has been played yet.
  final byte black = 1;
  final byte white = 2;
  byte piece = empty;
  
  //If the mouse is over this tile, used for changing colour and click detection.
  boolean mouseOver = false;
  
  //Creates a tile needing to know its 2d position in space and its 2d position on the board.
  public Tile(PVector loc, int bx, int by){
    position = loc.copy();
    boardX = bx;
    boardY = by;
  }
  
  //Updates and renders a piece.
  void show(){
    //If the mouse is over this tile make a note of it.
    if(mouseX > position.x && mouseX < position.x+sizeX && mouseY > position.y && mouseY < position.y+sizeY){
       mouseOver = true;
    }else{
       mouseOver = false;
    }
    //We always want the outline to be black.
    stroke(0);
    //If the mouse is over, use a lighter colour
    if(mouseOver){
      fill(color(20, 180, 20));
    }else{
      noFill(); //Otherwise, just make it the same as the background
    }
    if(showValidMoves){
      if(turn(getTeam(), true)){
        stroke(0, 255, 0);
      }else{
        stroke(255, 0, 0);
      }
    }
    strokeWeight(strokeWeight); //Makes the boarder bigger
    rect(position.x, position.y, sizeX, sizeY); //Draws the base rectangle.
    
    //If there is a piece, then draw that.
    if(piece == black){
      stroke(0);
      fill(0);
      //The circleReduction math centers the piece on the tile and also makes it smaller than the box.
      ellipse(position.x+circleReduction/2, position.y+circleReduction/2, sizeX-circleReduction, sizeY-circleReduction);
    }else if(piece == white){
      stroke(255);
      fill(255);
      ellipse(position.x+circleReduction/2, position.y+circleReduction/2, sizeX-circleReduction, sizeY-circleReduction);
    }
    
    //Debug
    //text("" + boardX + ", " + boardY, position.x, position.y);
  }
  
  //Prevents confusion by running a turn without making anyone worry about the "simulate" value.
  //This method runs the turn for real and updates the board accordingly.
  public boolean turn(byte player){
    return turn(player, false);
  }
  
  //Attempts a turn where the designated player clicked on this tile.
  //If the move is allowed, this will return true.
  //Otherwise it will return false.
  //Simulate is used to make sure a valid move is possible. Usually, just don't include it and it is false by default.
  public boolean turn(byte player, boolean simulate){
    boolean validMove = false;
    if(piece == empty){ //If there is something here already then you can't play.
      int needed = 0; //We need this to be beside us to matter.
      if(player == black){
        needed = white;
      }else if(player == white){
        needed = black;
      }
      //Check if we can capture tiles and then make the play.
      int shift = 1; //Same shift variable saves garbage collection hassels. Set to 1 so we check a piece adjacent to us.
      //Check downwards ------------------------------------------------
      while(field.getAt(boardX, boardY+shift).piece == needed){ //While the piece we are checking is the opponents colour
        shift++; //Keep going
      }
      //Afterwards
      if(field.getAt(boardX, boardY+shift).piece == player && shift > 1){ //If the last piece is our colour (and not empty)
        for(int i = 1; i <= shift; i++){ //Then change each piece between those pieces to our colour.
          if(!simulate){
            field.getAt(boardX, boardY+i).piece = player;
          }
        }
        validMove = true; //Then say that the move did capture and flag it as allowed.
        //This piece will be set at the end of this function after checking simulation.
      }
      //End Check down -------------------------------------------------
      //Keep running the same logic but change how shift is addressed.
      //Check up -------------------------------------------------------
      shift = 1;
      while(field.getAt(boardX, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX, boardY-shift).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX, boardY-i).piece = player;
          }
        }
        validMove = true;
      }
      //End check down -------------------------------------------------
      //Start Check Right ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX+i, boardY).piece = player;
          }
        }
        validMove = true;
      }
      //End Check Right -----------------------------------------------
      //Start Check Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX-i, boardY).piece = player;
          }
        }
        validMove = true;
      }
      //End check right ----------------------------------------------
      //Start Diagonal Down Right ------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY+shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY+shift).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX+i, boardY+i).piece = player;
          }
        }
        validMove = true;
      }
      //End diagonal down right ----------------------------------------------
      //Start Diagonal up Right ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY+shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY+shift).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX-i, boardY+i).piece = player;
          }
        }
        validMove = true;
      }
      //End diagonal up right ----------------------------------------------
      //Start Diagonal up Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY-shift).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX-i, boardY-i).piece = player;
          }
        }
        validMove = true;
      }
      //End diagonal up left ----------------------------------------------
      //Start Diagonal down Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY-shift).piece == player && shift > 1){
        for(int i = 1; i <= shift; i++){
          if(!simulate){
            field.getAt(boardX+i, boardY-i).piece = player;
          }
        }
        validMove = true;
      }
      //End diagonal down left ----------------------------------------------
    }
    
    if(validMove && !simulate){
      this.piece = player;
    }
    return validMove;
  }
  
  //Evaluates how many points this tile is worth for the specified team. Used for perimative AI.
  //All it does is count how many tiles will be captured and return this sum.
  public int eval(byte player){
    int value = 0; //How many points this is worth.
    if(piece == empty){ //If there is something here already then you can't play.
      int needed = 0; //We need this to be beside us to matter.
      if(player == black){
        needed = white;
      }else if(player == white){
        needed = black;
      }
      //Check if we can capture tiles and then make the play.
      int shift = 1; //Same shift variable saves garbage collection hassels. Set to 1 so we check a piece adjacent to us.
      //Check downwards ------------------------------------------------
      while(field.getAt(boardX, boardY+shift).piece == needed){ //While the piece we are checking is the opponents colour
        shift++; //Keep going
      }
      //Afterwards
      if(field.getAt(boardX, boardY+shift).piece == player && shift > 1){ //If the last piece is our colour (and not empty)
        value += shift-1; //Increase by how much we stand to gain.
      }
      //End Check down -------------------------------------------------
      //Keep running the same logic but change how shift is addressed.
      //Check up -------------------------------------------------------
      shift = 1;
      while(field.getAt(boardX, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX, boardY-shift).piece == player && shift > 1){
        value += shift-1;
      }
      //End check down -------------------------------------------------
      //Start Check Right ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY).piece == player && shift > 1){
        value+=shift-1;
      }
      //End Check Right -----------------------------------------------
      //Start Check Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY).piece == player && shift > 1){
        value+=shift-1;
      }
      //End check right ----------------------------------------------
      //Start Diagonal Down Right ------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY+shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY+shift).piece == player && shift > 1){
        value+=shift-1;
      }
      //End diagonal down right ----------------------------------------------
      //Start Diagonal up Right ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY+shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY+shift).piece == player && shift > 1){
        value+=shift-1;
      }
      //End diagonal up right ----------------------------------------------
      //Start Diagonal up Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX-shift, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX-shift, boardY-shift).piece == player && shift > 1){
        value+=shift-1;
      }
      //End diagonal up left ----------------------------------------------
      //Start Diagonal down Left ----------------------------------------------
      shift = 1;
      while(field.getAt(boardX+shift, boardY-shift).piece == needed){
        shift++;
      }
      if(field.getAt(boardX+shift, boardY-shift).piece == player && shift > 1){
        value+=shift-1;
      }
      //End diagonal down left ----------------------------------------------
    }
    
    return value;
  }
}