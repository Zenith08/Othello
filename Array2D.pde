public class Array2D{ //Not generic, actually represents the playing board.
  Tile[][] board; //The playable area of tiles.
  //Constant information on the size of the board
  final int width;
  final int height;
  //How much x and y movement should be applied even before the procedural board is generated
  final int baseX, baseY;
  
  boolean moveAvailable = true;
  
  int blackScore = 0, whiteScore = 0;
  
  //Basic constructor needing to know width, height, offsetX, and offsetY
  public Array2D(int w, int h, int bx, int by){
    width = w;
    height = h;
    baseX = bx;
    baseY = by;
    board = new Tile[width][height]; //Setup the 2d array
    
    //Populate the array with empty tiles.
    for(int x = 0; x < width; x++){
       for(int y = 0; y < height; y++){
         board[x][y] = new Tile(new PVector(baseX+x*50, baseY+y*50), x, y);
       }
    }
  }
  
  //Sets the initial pieces for the game.
  //These are always the same so it doesn't matter.
  public void startingPieces(){
    board[3][3].piece = 1;
    board[4][3].piece = 2;
    board[3][4].piece = 2;
    board[4][4].piece = 1;
  }
  
  //Let's each tile draw itself to the screen.
  public void display(){
    for(int x = 0; x < width; x++){
       for(int y = 0; y < height; y++){
         board[x][y].show();
       }
    }
  }
  
  //Called when the mouse is clicked and used to figure out which tile the mouse was over when they clicked it.
  public Tile getClickedTile(){
    for(int x = 0; x < width; x++){
       for(int y = 0; y < height; y++){
         if(board[x][y].mouseOver){
           return board[x][y];
         }
       }
    }
    return null;
  }
  
  //If the tile at the requested coordinate can exist it is returned. Otherwise a dummy tile is returned.
  public Tile getAt(int x, int y){
    if(x >= 0 && x < width && y >= 0 && y < width){ //Checks if the x and y requested are in the array.
      return board[x][y]; //Then returns it.
    }else{
      return new Tile(new PVector(0, 0), 0, 0); //Otherwise returns a blank tile.
    }
  }
  
  //Gets the score of the specified team. 1 for black, 2 for white.
  public int getTeamScore(int team){
    if(team == 1){
      return blackScore;
    }else{
      return whiteScore;
    }
  }
  
  //Lets us update scores and other logic in one shot
  public void updateBoardState(){
    boolean anyMoves = false; //A check if the game is over due to no available moves.
    blackScore = 0; //Sets the scores to 0 so they can be recalculated.
    whiteScore = 0;
    for(int x = 0; x < width; x++){
       for(int y = 0; y < height; y++){
         if(board[x][y].piece == 1){ //For each tile, if their piece is the same as the team we are checking then add a point.
           blackScore++;
         }else if(board[x][y].piece == 2){
           whiteScore++;
         }
         
         if(board[x][y].turn(getTeam(), true)){ //Also simulate a move and see if it works. If so then there are moves the current player can make.
           anyMoves = true;
         }
       }
    }
    moveAvailable = anyMoves; //Store if any moves can be made for the master program.
  }
}