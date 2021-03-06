﻿package {
  import flash.display.MovieClip;
  import flash.display.SimpleButton;
  import flash.display.Shape;
  import flash.display.Graphics;
  import flash.events.Event;
  import flash.events.MouseEvent;
  
  public class Circle extends MovieClip {
    public var personId:Number;

    private var button:SimpleButton;
    private var active:Boolean;
    private var offsetX:Number;
    private var offsetY:Number;
    private var lastX:Number;
    private var lastY:Number;

    public function Circle(aPersonId:Number) {
      personId = aPersonId;

      button = new SimpleButton();
      button.doubleClickEnabled = true;
      
      button.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
      button.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
      button.addEventListener(MouseEvent.DOUBLE_CLICK, changeState);

      addChild(button);
      updateButton();
    }
    
    public function get truthy():Boolean {
      return active;
    }
    
    public function set truthy(value:Boolean):void {
      active = value;
      updateButton();
    }
    
    private function changeState(event:MouseEvent):void {
      truthy = !truthy;
      dispatchEvent(new Event(Event.CHANGE));
    }
    
    private function updateButton() {
      if (active) {
        button.upState = shapeForActiveState();
      } else {
        button.upState = shapeForInactiveState();
      }
      button.downState = button.upState;
      button.overState = button.upState;
      button.hitTestState = button.upState;
    }
    
    private function shapeForActiveState() {
      return draw(0xFFFFFF, 0xFFFFFF);
    }
    
    private function shapeForInactiveState() {
      return draw(0x000000, 0xFFFFFF);
    }
    
    private function draw(bgColor:uint, strokeColor:uint):Shape {
      var circle:Shape = new Shape();
      
      circle.graphics.lineStyle(5, strokeColor);
      circle.graphics.beginFill(bgColor);
      circle.graphics.drawCircle(0, 10, 10);
      circle.graphics.endFill();
      
      return circle;
    }
    
    private function startDragging(event:MouseEvent):void {
      // Record the difference (offset) between where
      // the cursor was when the mouse button was pressed and the x, y
      // coordinate of the circle when the mouse button was pressed.
      offsetX = event.stageX - x;
      offsetY = event.stageY - y;
      
      lastX = event.stageX;
      lastY = event.stageY;
      
      stage.addEventListener(MouseEvent.MOUSE_MOVE, dragCircle);
    }
    
    private function stopDragging(event:MouseEvent):void {
      var deltaX:Number = Math.abs(lastX - event.stageX);
      var deltaY:Number = Math.abs(lastY - event.stageY);
      
      // trace(deltaX, deltaY);
      
      if ((deltaX && deltaX <= 3) || (deltaY && deltaY <= 3)) {
        button.dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK));
      }
      stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragCircle);
      dispatchEvent(new Event(Event.MOUSE_LEAVE));
    }
    
    private function dragCircle(event:MouseEvent):void {
      
      // Move the circle to the location of the cursor, maintaining 
      // the offset between the cursor's location and the 
      // location of the dragged object.
      x = event.stageX - offsetX;
      y = event.stageY - offsetY;
      
      // Instruct Flash Player to refresh the screen after this event.
      event.updateAfterEvent();
    }
  }
}

