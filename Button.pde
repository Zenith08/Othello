//Derrived from the Processing Tutorial. A button which can be pressed.
class Button{
  PVector position; //Where it goes
  int sizeX, sizeY; //How big it is
  String line; //What it says
  
  boolean mouseOver; //Is the mouse over top of this button?
  
  //Creates a button with the essential values set.
  public Button(String printed, PVector where, int w, int h){
    line = printed;
    position = where.copy();
    sizeX = w;
    sizeY = h;
    mouseOver = false;
  }
  
  //Figures out if the mouse is over this button and returns it.
  public boolean isMouseOver(){
    //2D overlapping logic again!
    if(mouseX > position.x && mouseX < position.x+sizeX && mouseY > position.y && mouseY < position.y+sizeY){
       mouseOver = true;
    }else{
       mouseOver = false;
    }
    return mouseOver;
  }
  
  //Draws the button to the screen.
  public void show(){
    stroke(72);
    if(mouseOver){ //Show a lighter colour if the mouse is over.
      fill(160);
    }else{
      fill(128);
    }
    strokeWeight(2);
    rect(position.x, position.y, sizeX, sizeY);
    stroke(0);
    fill(0);
    textSize(16);
    text(line, position.x+sizeY/16, position.y + sizeY/2);
  }
}

//Like a button, but it can be toggled based on the global showValidMoves button.
class MovesButton extends Button{
  //Required but doesn't need anything else.
  public MovesButton(String printed, PVector where, int w, int h){
    super(printed, where, w, h);
  }
  
  //Changes rendering to allow more options.
  @Override
  public void show(){
    stroke(72);
    //For the record this shouldn't actually work. Only because it's Processing can I do this.
    if(mouseOver && !showValidMoves){ //Deactivated but mouse over.
      fill(160);
    }else if(!mouseOver && !showValidMoves){ //Deactivated and no mouse over.
      fill(128);
    }else if(mouseOver && showValidMoves){ //Activated and mouse over.
      fill(72);
    }else if(!mouseOver && showValidMoves){ //Activated but no mouse over.
      fill(50);
    }
    strokeWeight(2);
    rect(position.x, position.y, sizeX, sizeY);
    stroke(0);
    fill(0);
    textSize(16);
    text(line, position.x+sizeY/16, position.y + sizeY/2);
  }
}

//Like a moveButton but it checks for the ai enabled and can handle both colours.
class AIButton extends Button{
  //Saves the colour this button is representing.
  final int team;
  //Like the previous constructor but needs to know what team it represents. 1 for black, 2 for white.
  public AIButton(String printed, PVector where, int w, int h, int col){
    super(printed, where, w, h);
    team = col;
  }
  
  //Changes rendering to a more advanced system.
  @Override
  public void show(){
    stroke(72);
    boolean enabled = false; //Allows easy switching between black and white AI.
    if(team == 1 && allowBlackAI){ //If we are the black AI button then check black AI enabled
      enabled = true;
    }else if(team == 2 && allowWhiteAI){ //Otherwise just do it for white.
      enabled = true;
    }
    if(mouseOver && !enabled){ //Rendering again.
      fill(160);
    }else if(!mouseOver && !enabled){
      fill(128);
    }else if(mouseOver && enabled){
      fill(72);
    }else if(!mouseOver && enabled){
      fill(50);
    }
    strokeWeight(2);
    rect(position.x, position.y, sizeX, sizeY);
    stroke(0);
    fill(0);
    textSize(16);
    text(line, position.x+sizeY/16, position.y + sizeY/2);
  }
}