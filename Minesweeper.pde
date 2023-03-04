import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private static final int NUM_ROWS = 20;
private static final int NUM_COLS = 20;
private static final int NUM_BOMBS = 2;
public boolean gameOver = false;
public int count = 0;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int j = 0; j<NUM_ROWS; j++){
     for(int i = 0; i<NUM_COLS; i++){
       buttons[j][i] = new MSButton(j,i); 
     }
    }
    //initialize array list
    mines = new ArrayList <MSButton>();
    setMines();
}
public void setMines()
{
    while(mines.size() < NUM_BOMBS){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[r][c])){
    mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();   
     
}
public boolean isWon()
{
    if(count==mines.size()){
      return true;
    }
    return false;
}
public void displayLosingMessage()
{
    buttons[10][6].setLabel("G");
    buttons[10][7].setLabel("A");
    buttons[10][8].setLabel("M");
    buttons[10][9].setLabel("E");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("V");
    buttons[10][13].setLabel("E");
    buttons[10][14].setLabel("R");

    gameOver = true;
}
public void displayWinningMessage()
{
    
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("I");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
    gameOver = true;
}
public boolean isValid(int r, int c)
{
    if((0 <= r && r<NUM_ROWS) && (0 <= c && c<NUM_COLS)){
     return true; 
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int j = row-1; j<=row+1; j++){
      for(int i = col-1; i<=col+1; i++){
       if(isValid(j,i) && mines.contains(buttons[j][i])){
        numMines++;
       }
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        count = 0;
        
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
        public void mousePressed () {
        clicked = true;
        if(mouseButton == RIGHT){ //flagging
          if(!isFlagged()){
            flagged = true;
            if(mines.contains(this)){
             count++; 
            }
          }else if(isFlagged()){
            flagged = false;
            clicked = false;
            if(mines.contains(this)){
             count--; 
            }
          }
        }
        if(mouseButton == LEFT && !isFlagged()){ //prevents flagged squares from being clicked
        if(mines.contains(this)){
         displayLosingMessage(); //L bozo
        }else if(countMines(myRow,myCol) > 0){
          setLabel(countMines(myRow,myCol));
        }else if(countMines(myRow, myCol) == 0){
         for(int j = myRow-1; j<=myRow+1; j++){
          for(int i = myCol-1; i<=myCol+1; i++){
            if(isValid(j,i) && !buttons[j][i].clicked){
             buttons[j][i].mousePressed(); 
            }
          }
         }
        }
        if(isWon() == true){
         displayWinningMessage();
        }
       }
    }

    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) )
             fill(255,0,0);
             
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
        if(gameOver == true){
         noLoop(); 
        }
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
