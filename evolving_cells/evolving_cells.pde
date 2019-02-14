/*
  Evolving Cells
  --------------
  This is a life-like cellular automata with the ability for mutations to occur to the ruleset.
  Many cellular automata rule sets are able to exist at the same time and compete with eachother.
  This causes evolution to occur and the emergance of simple eco-systems. 
  
  written by Adrian Margel, Fall 2016
*/

//camera position
float centerX=0;
float centerY=0;
//camera zoom
float zoom=5;

//acts as the genome and information for a cell
class EvType {
  //if the cell the alive/claimed
  boolean claimed=false;
  //if the cell is able to reproduce
  boolean canSpread=true;

  //the color of the cell
  color col;

  //the cellular automata rules for the cell, a bit ugly but it works
  int one=1;
  int two=1;
  int three=1;
  int four=1;
  int five=1;
  int six=1;
  int seven=1;
  int eight=1;

  //change the rules randomly
  void mutate(int chance) {
    if (random(0, 100)<100/chance) {
      one=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      two=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      three=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      four=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      five=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      six=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      seven=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    if (random(0, 100)<100/chance) {
      eight=(int)random(0, 3);
      col=color(random(0, 255), random(0, 255), random(0, 255));
    }
    claimed=true;
  }

  //have offspring with another cell
  void breed(EvType toThis, int chance) {
    if (random(0, 100)<100/chance) {
      one=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      two=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      three=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      four=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      five=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      six=toThis.one;
    }
    if (random(0, 100)<100/chance) {
      seven=toThis.seven;
    }
    if (random(0, 100)<100/chance) {
      eight=toThis.eight;
    }
    claimed=true;
    col=color(random(0, 255), random(0, 255), random(0, 255));
  }

  //be reborn as a new cell with new rules
  void changeTo(EvType toThis) {
    one=toThis.one;
    two=toThis.two;
    three=toThis.three;
    four=toThis.four;
    five=toThis.five;
    six=toThis.six;
    seven=toThis.seven;
    eight=toThis.eight;
    claimed=toThis.claimed;
    col=toThis.col;
  }

  //run cellular automata based on the rules
  boolean test(int closeBy, int type) {
    if (type==0) {
      //if any of the conditions for living are true then live
      if (closeBy==1&&one>=1) {
        return true;
      } else if (closeBy==2&&two>=1) {
        return true;
      } else if (closeBy==3&&three>=1) {
        return true;
      } else if (closeBy==4&&four>=1) {
        return true;
      } else if (closeBy==5&&five>=1) {
        return true;
      } else if (closeBy==6&&six>=1) {
        return true;
      } else if (closeBy==7&&seven>=1) {
        return true;
      } else if (closeBy==8&&eight>=1) {
        return true;
      } else {
        return false;
      }
    } else {
      //if any of the conditions for death ore met then die
      if (closeBy==1&&one==2) {
        return true;
      } else if (closeBy==2&&two==2) {
        return true;
      } else if (closeBy==3&&three==2) {
        return true;
      } else if (closeBy==4&&four==2) {
        return true;
      } else if (closeBy==5&&five==2) {
        return true;
      } else if (closeBy==6&&six==2) {
        return true;
      } else if (closeBy==7&&seven==2) {
        return true;
      } else if (closeBy==8&&eight==2) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class Tile {
  //how long the tile has been alive
  int age=0;

  //the number of times it has mated, the more times mated the lower the genetic influence of mating
  //this exists to make sure that many mates will not override genetics as much
  int mates=0;

  //the cell data and rules
  EvType species;

  //number of alive neighbors
  int closeBy;

  //position
  int x;
  int y;

  //the value of the tile (0 alive or 1 dead)
  int type;

  Tile(int tempx, int tempy, int temptype, EvType tempEv) {
    x=tempx;
    y=tempy;
    type=temptype;
    species=new EvType();
    species.changeTo(tempEv);
  }

  void display(int xBase, int yBase) {

    if (type==0) {
      noStroke();
      
      /*
      //display a color for the species of cell
      if (species.claimed) {
        fill(species.col, closeBy*30);
        rect((xBase+x)*zoom-centerX*zoom, (yBase+y)*zoom-centerY*zoom, zoom, zoom);
      }
      */

      //display the cell as darker the more neighbors it has
      fill(0, closeBy*20);
      rect((xBase+x)*zoom-centerX*zoom, (yBase+y)*zoom-centerY*zoom, zoom, zoom);
    }
  }
}

//this seperates tiles into groups to reduce the number of comparisons that need to be made between tiles
class Chunk {
  int gridX=0;
  int gridY=0;
  ArrayList<Tile> tiles=new ArrayList<Tile>();
  Chunk(int tempx, int tempy) {
    gridX=tempx;
    gridY=tempy;
  }
  void display() {
    for (int i=0; i<tiles.size(); i++) {
      tiles.get(i).display(gridX*3, gridY*3);
    }
  }
}

//the grid of tiles
ArrayList<Chunk> chunks=new ArrayList<Chunk>();

//the default rules for a dead tile
EvType startSpec=new EvType();
//the rules for conway's game of life
EvType conway=new EvType();

void setup() {
  //setup conway rules
  conway.one=0;
  conway.two=1;
  conway.three=2;
  conway.four=0;
  conway.five=0;
  conway.six=0;
  conway.seven=0;
  conway.eight=0;
  conway.claimed=true;
  conway.col=color(200, 0, 0);

  //set high framerate
  frameRate(100);
  //set window size
  size(900, 600);

  //init tiles
  for (int i=0; i<60; i++) {
    for (int j=0; j<40; j++) {
      chunks.add(new Chunk(i, j));
      for (int k=0; k<3; k++) {
        for (int l=0; l<3; l++) {
          if (i<8&&j<8) {
            //set tiles in the corner to be conway's game of life
            chunks.get(chunks.size()-1).tiles.add(new Tile(l, k, (int)random(0, 2), conway));
          } else {
            //set all other tiles to be the default static rules
            chunks.get(chunks.size()-1).tiles.add(new Tile(l, k, (int)random(0, 2), startSpec));
          }
        }
      }
    }
  }
}
void draw() {
  background(255);
  //run all of the cells
  run();

  //display all the cells
  for (int i=0; i<chunks.size(); i++) {
    if (chunks.get(i).gridX*3*zoom-centerX*zoom<width&&chunks.get(i).gridX*3*zoom+3*zoom-centerX*zoom>0&&
      chunks.get(i).gridY*3*zoom-centerY*zoom<height&&chunks.get(i).gridY*3*zoom+3*zoom-centerY*zoom>0) {
      chunks.get(i).display();
    }
  }
}

//method to run all the logic
void run() {
  //prepare cells for being processed and mutate cells
  for (int i=0; i<chunks.size(); i++) {
    for (int j=0; j<chunks.get(i).tiles.size(); j++) {
      //reset all cells to having 0 neighbors
      chunks.get(i).tiles.get(j).closeBy=0;

      //randomly make mutations to organisms
      if (random(0, 1000)<1) {
        if (chunks.get(i).tiles.get(j).species.claimed)
          chunks.get(i).tiles.get(j).species.mutate(10);
      }

      //set all dead cells to the default type (basicaly kill them)
      if (chunks.get(i).tiles.get(j).type==1) {
        chunks.get(i).tiles.get(j).species.changeTo(startSpec);
        chunks.get(i).tiles.get(j).age=0;

        //age all alive cells
      } else if (chunks.get(i).tiles.get(j).type==0) {
        if (chunks.get(i).tiles.get(j).age<9) {
          chunks.get(i).tiles.get(j).age++;
        } else {
          //if the cells are too old then set them to be unclaimed alive cells
          chunks.get(i).tiles.get(j).species.claimed=false;
          chunks.get(i).tiles.get(j).species.col=startSpec.col;
        }
      }
      //allow all cells to spread
      chunks.get(i).tiles.get(j).species.canSpread=true;
    }
  }

  //
  for (int i=0; i<chunks.size(); i++) {
    for (int j=0; j<chunks.size(); j++) {

      //if the chunks are beside eachother
      if (abs(chunks.get(i).gridX-chunks.get(j).gridX)<=1&&abs(chunks.get(i).gridY-chunks.get(j).gridY)<=1) {

        //for all selected chunk tiles
        for (int k=0; k<chunks.get(i).tiles.size(); k++) {
          for (int l=0; l<chunks.get(j).tiles.size(); l++) {

            //if tiles are beside eachother
            if (abs((chunks.get(j).gridX*3+chunks.get(j).tiles.get(l).x)-
              (chunks.get(i).gridX*3+chunks.get(i).tiles.get(k).x))<=1
              &&abs((chunks.get(j).gridY*3+chunks.get(j).tiles.get(l).y)-
              (chunks.get(i).gridY*3+chunks.get(i).tiles.get(k).y))<=1
              &&((chunks.get(j).gridY*3+chunks.get(j).tiles.get(l).y)!=(chunks.get(i).gridY*3+chunks.get(i).tiles.get(k).y)
              ||(chunks.get(j).gridX*3+chunks.get(j).tiles.get(l).x)!=(chunks.get(i).gridX*3+chunks.get(i).tiles.get(k).x))) {

              //if the cell is dead or unclaimed spread into the tile
              if ((chunks.get(i).tiles.get(k).type==1||!chunks.get(i).tiles.get(k).species.claimed)
                &&chunks.get(j).tiles.get(l).species.claimed&&chunks.get(j).tiles.get(l).species.canSpread) {

                //if canspread is true it means the tile has not been spreaded too yet
                //if this is the case turn the tile to be 100% of the new cell's genetics
                if (chunks.get(i).tiles.get(k).species.canSpread) {
                  chunks.get(i).tiles.get(k).mates=1;
                  chunks.get(i).tiles.get(k).species.changeTo(chunks.get(j).tiles.get(l).species);
                } else {
                  //if the cell has already been spread to then breed the existing genome with the new cell's genetics unless they are the same
                  if (!compare(chunks.get(i).tiles.get(k).species, chunks.get(j).tiles.get(l).species)) {
                    //increase the mates count so that the more cells to contribute their genetics the lower the effect of it.
                    chunks.get(i).tiles.get(k).mates++;
                    chunks.get(i).tiles.get(k).species.breed(chunks.get(j).tiles.get(l).species, chunks.get(i).tiles.get(k).mates);
                  }
                }
                //set the cell to no longer be able to spread to make sure it only spreads once per cycle
                chunks.get(i).tiles.get(k).species.canSpread=false;
              }

              //add up alive neighbors
              if (chunks.get(j).tiles.get(l).type==0) {
                chunks.get(i).tiles.get(k).closeBy++;
              }
            }
          }
        }
      }
    }
  }

  //update cells based on their rules
  for (int i=0; i<chunks.size(); i++) {
    for (int j=0; j<chunks.get(i).tiles.size(); j++) {
      if (chunks.get(i).tiles.get(j).species.test(chunks.get(i).tiles.get(j).closeBy, chunks.get(i).tiles.get(j).type)) {
        chunks.get(i).tiles.get(j).type=0;
      } else {
        chunks.get(i).tiles.get(j).type=1;
      }
    }
  }
}

//test if two rule sets are the same
boolean compare(EvType ev1, EvType ev2) {
  boolean match=true;
  if (ev1.one!=ev2.one) {
    match=false;
  }
  if (ev1.two!=ev2.two) {
    match=false;
  }
  if (ev1.three!=ev2.three) {
    match=false;
  }
  if (ev1.four!=ev2.four) {
    match=false;
  }
  if (ev1.five!=ev2.five) {
    match=false;
  }
  if (ev1.six!=ev2.six) {
    match=false;
  }
  if (ev1.seven!=ev2.seven) {
    match=false;
  }
  if (ev1.eight!=ev2.eight) {
    match=false;
  }
  return match;
}

//simple controls for moving
//these probably are not that useful
void keyPressed() {
  if (key=='w'||key=='W') {
    centerY-=0.5;
  }
  if (key=='s'||key=='S') {
    centerY+=0.5;
  }
  if (key=='a'||key=='A') {
    centerX-=0.5;
  }
  if (key=='d'||key=='D') {
    centerX+=0.5;
  }
  if (key=='q'||key=='Q') {
    centerX+=(width/zoom/2);
    centerY+=(height/zoom/2);
    zoom++;
    centerX-=(width/zoom/2);
    centerY-=(height/zoom/2);
  }
  if (key=='e'||key=='E') {
    if (zoom>1) {
      centerX+=(width/zoom/2);
      centerY+=(height/zoom/2);
      zoom--;
      centerX-=(width/zoom/2);
      centerY-=(height/zoom/2);
    }
  }
}
