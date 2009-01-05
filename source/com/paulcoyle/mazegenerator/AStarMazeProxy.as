/**
* Copyright (c) 2009 Paul Coyle
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
package com.paulcoyle.mazegenerator {
  import com.baseoneonline.flash.astar.IAStarSearchable;
  import com.baseoneonline.flash.geom.IntPoint;
  
  /**
  * An AStarSearchable proxy to a maze.  This implements the IAStarSearchable
  * interface by B. Korsmit (you can get the source at:
  * http://blog.baseoneonline.com/?p=87).
  * 
  * IMPORTANT NOTE: you will need to modify the A* code to prevent checking for
  * paths diagonally.  Otherwise the pathfinding will jump over corner rooms. At
  * this time (Jan 5, 2008) you can comment out each of the if blocks in the
  * private neighbours() method of the AStar class for the diagonal directions:
  * NW, NE, SW, SE.
  *
  * @author Paul Coyle &lt;paul@paulcoyle.com&gt;
  */
  public class AStarMazeProxy implements IAStarSearchable {
    private var _maze:Maze;
    
    public function AStarMazeProxy(maze:Maze) {
      _maze = maze;
    }
    
    /**
    * Returns the maze being proxied.
    */
    public function getMaze():Maze {
      return _maze;
    }
    
    /**
    * Sets the maze to proxy to.
    */
    public function setMaze(value:Maze):void {
      _maze = value;
    }
    
    /**
    * Returns the width where walls are also grid spaces.
    */
    public function getWidth():int {
      return _maze.getWidth() * 2;
    }
    
    /**
    * Returns the height where walls are also grid spaces.
    */
    public function getHeight():int {
      return _maze.getHeight() * 2;
    }
    
    /**
    * Returns whether or not a grid space is passable.  If either of the
    * co-ordinates is odd then it is a wall and is impassable if there is a wall
    * for the corresponding room.  Otherwise we are "inside" a room and thus it
    * is passable.
    */
    public function isWalkable(x:int, y:int):Boolean {
      var room:Room = _maze.getRoomAt(Math.floor(x/2), Math.floor(y/2));
      
      if (((x % 2) != 0) && (room.hWall)) return false;
      else if (((y % 2) != 0) && (room.vWall)) return false;
      else return true;
    }
    
    /**
    * Returns the start point as an IntPoint.
    */
    public function getStartPoint():IntPoint {
      var startRoom:Room = _maze.getStartRoom();
      return new IntPoint(startRoom.x * 2, startRoom.y * 2);
    }
    
    /**
    * Returns the start point as an IntPoint.
    */
    public function getEndPoint():IntPoint {
      var endRoom:Room = _maze.getEndRoom();
      return new IntPoint(endRoom.x * 2, endRoom.y * 2);
    }
  }
}