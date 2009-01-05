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
  import flash.events.Event;
  import flash.events.EventDispatcher;
  
  /**
  * Defines and generates a maze made up of Room objects.
  *
  * @author Paul Coyle &lt;paul@paulcoyle.com&gt;
  */
  public class Maze extends EventDispatcher {
    // Counts the number of stack overflows encountered when generating the maze.
    public var overflows:uint;
    
    private var _width:uint;
    private var _height:uint;
    
    //private var _rooms:Vector.<Vector.<Room>>;
    private var _rooms:Array;
    private var _start:Room;
    private var _end:Room;
    
    private var _lastStep:Room;
    private var _lastDir:uint;
    
    private static const NEIGHBOURS:Array = [{x:0,y:-1}, {x:-1,y:0}, {x:1,y:0},
      {x:0,y:1}];
    
    // PUBLIC
    /**
    * Initializes the maze.
    */
    public function init(width:uint, height:uint):void {
      // If the rooms array exists we've already generated the maze.
      if (_rooms) throw new Error('Maze is already initialized.');
      
      _width = width;
      _height = height;
      
      initRooms();
      initPath();
    }
    
    /**
    * Returns the number of rooms wide the maze is.
    */
    public function getWidth():uint {
      return _width;
    }
    
    /**
    * Returns the number of rooms high the maze is.
    */
    public function getHeight():uint {
      return _height;
    }
    
    /**
    * Gets the room that represents the start of the maze.
    */
    public function getStartRoom():Room {
      return _start;
    }
    
    /**
    * Gets the room that represents the end of the maze.
    */
    public function getEndRoom():Room {
      return _end;
    }
    
    /**
    * Returns the room for the given coordinates.
    * TODO: Throw out-of-range errors.
    */
    public function getRoomAt(x:uint, y:uint):Room {
      return _rooms[x][y];
    }
    
    /**
    * Returns a copy of the rooms grid.
    */
    //public function get rooms():Vector.<Vector.<Room>> {
    public function get rooms():Array {
      return _rooms.slice();
    }
    
    /**
    * Returns a graphical string representation used when showing an ASCII
    * version of a maze.
    */
    public function toMazeString():String {
      var out:String = '';
      var x:uint, y:uint;
      for (y = 0; y < _height; y++) {
        out += '|'
        for (x = 0; x < _width; x++) {
          out += _rooms[x][y].toMazeString();
        }
        out += "\n";
      }
      
      return out;
    }
    
    // PRIVATE
    /**
    * Initializes the Vectors of new Rooms.
    */
    private function initRooms():void {
      //_rooms = new Vector.<Vector.<Room>>(width);
      _rooms = new Array();
      
      var x:uint, y:uint;
      //var col:Vector.<Room>;
      var col:Array;
      var room:Room;
      for (x = 0; x < _width; x++) {
        //_rooms[x] = col = new Vector.<Room>(height);
        _rooms[x] = col = new Array();
        for (y = 0; y < _height; y++) {
          room = new Room();
          room.x = x;
          room.y = y;
          col[y] = room;
        }
      }
    }
    
    /**
    * Begins by semi-randomly selecting the start and end rooms along distant
    * edges then starts the path generating.
    */
    private function initPath():void {
      _start = _rooms[0][Math.floor(_height * Math.random())];
      _start.visited = true;
      _start.start = true;
      
      _end = _rooms[_width - 1][Math.floor(_height * Math.random())];
      _end.end = true;
      
      overflows = 0;
      _lastStep = _start;
      
      resumePath();
    }
    
    /**
    * Resumes the path from the _lastStep.
    */
    private function resumePath():void {
      try { stepPath(_lastStep) }
      catch (e:Error) {
        overflows++;
        resumePath();
      }
    }
    
    /**
    * Does one step through creating the path.  Chooses a random unvisited
    * neighbour of the last room, clears the wall between them and adds the
    * newly chosen room to the last room as its "previous" propery (basically
    * a linked list).  If a room has no neighbours (returns null) then we go
    * back to the previous room and continue.  Finally if we hit a room with no
    * previous room defined and there's no neightbours we can consider the maze
    * complete.
    */
    private function stepPath(current:Room):void {
      _lastStep = current;
      var next:Room = randomUnvisitedNeighbour(current.x, current.y);
      
      if (next == null) {
        if (current.previous == null) {
          dispatchEvent(new Event(Event.COMPLETE));
          return;
        }
        else {
          var previous:Room = current.previous;
          current.previous = null;
          stepPath(previous)
        }
      }
      else {
        removeWallBetween(current, next);
        next.visited = true;
        next.previous = current;
        stepPath(next);
      }
    }
    
    /**
    * Returns a random unvisited neighbour.
    */
    private function randomUnvisitedNeighbour(x:uint, y:uint):Room {
      var unvisited:Array = new Array();
      var roomCheck:Room;
      var xOffset:int, yOffset:int;
      var xCheck:int, yCheck:int;
      var nid:uint;
      var offset:Object;
      
      for (nid = 0; nid < 4; nid++) {
        offset = NEIGHBOURS[nid];
        xCheck = x + offset.x;
        yCheck = y + offset.y;
        
        if ((xCheck < 0) || (xCheck == _width) ||
            (yCheck < 0) || (yCheck == _height)) continue;

        roomCheck = _rooms[xCheck][yCheck];
        if (!roomCheck.visited) unvisited.push(roomCheck);
      }
      
      var nextDir:uint;
      if (unvisited.length > 0)
        return unvisited[Math.floor(unvisited.length * Math.random())];
      else
        return null;
    }
    
    /**
    * Removes the wall between the two given rooms.
    */
    private function removeWallBetween(a:Room, b:Room):void {
      var lesser:Room;
      if (a.x != b.x) {// Horizontal
        lesser = (a.x < b.x) ? a : b;
        lesser.hWall = false;
      }
      else if (a.y != b.y) {// Vertical
        lesser = (a.y < b.y) ? a : b;
        lesser.vWall = false;
      }
    }
  }
}