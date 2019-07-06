import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import nub.primitives.*; 
import nub.core.*; 
import nub.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class light extends PApplet {

/**
 * Cajas Orientadas.
 * by Jean Pierre Charalambos.
 * 
 * This example illustrates some basic Node properties, particularly how to
 * orient them.
 *
 * The sphere and the boxes are interactive. Pick and drag them with the
 * right mouse button. Use also the arrow keys to select and move the sphere.
 * See how the boxes will always remain oriented towards the sphere.
 * 
 * Press ' ' the change the picking policy adaptive/fixed.
 * Press 'c' to change the bullseye shape.
 */





Scene scene;
Box[] cajas;
boolean drawAxes = true, bullseye = true, ambientLight = true;
Sphere esfera, esfera2;
PShader lightShader;
Vector p;
public void setup() {
  

  lightShader = loadShader("LightFrag.glsl", "lightVert.glsl");
  shader(lightShader);
  scene = new Scene(this);
  scene.setRadius(200);
  scene.togglePerspective();
  scene.fit();
  lightSpecular(255, 255, 255);
  specular(255,255,255);
  esfera = new Sphere(scene, color(random(0, 255), random(0, 255), random(0, 255)), 10);
  esfera.setPosition(new Vector(0, 100, 0));
  esfera2 = new Sphere(scene, color(random(0, 255), random(0, 255), random(0, 255)), 10);
  esfera2.setPosition(new Vector(0, 0, 0));
  lightSpecular(255, 255, 0);
  specular(255,0,0);
  cajas = new Box[5];
  for (int i = 0; i < cajas.length; i++)
    cajas[i] = new Box(scene, color(random(0, 255), random(0, 255), random(0, 255)), 
      random(10, 40), random(10, 40), random(10, 40));
  scene.fit(1);
  scene.setTrackedNode("keyboard", esfera);
}

public void draw() {
  background(0);
  if(ambientLight)
    ambientLight(75, 75, 75,0,0,0);
  else
    ambientLight(0, 0, 0,0,0,0);
  // calls render() on all scene attached nodes
  // automatically applying all the node transformations
  scene.render();
}

public void mouseMoved() {
  scene.cast();
}

public void mouseDragged() {
  if (mouseButton == LEFT){
    scene.spin();
  } else if (mouseButton == RIGHT){
    scene.translate();
  }else{
    scene.scale(mouseX - pmouseX);
  }
}

public void mouseWheel(MouseEvent event) {
  scene.moveForward(event.getCount() * 20);
}

public int randomColor() {
  return color(random(0, 255), random(0, 255), random(0, 255));
}

public int randomLength(int min, int max) {
  return PApplet.parseInt(random(min, max));
}

public void keyPressed() {
  if (key == ' ')
    for (Box caja : cajas)
      if (caja.pickingThreshold() != 0)
        if (abs(caja.pickingThreshold()) < 1)
          caja.setPickingThreshold(100 * caja.pickingThreshold());
        else
          caja.setPickingThreshold(caja.pickingThreshold() / 100);
  if(key == 'c')
    for (Box caja : cajas)
      caja.setPickingThreshold(-1 * caja.pickingThreshold());
  if (key == 'a')
    drawAxes = !drawAxes;
  if (key == 'p')
    bullseye = !bullseye;
  if (key == 'e')
    scene.togglePerspective();
  if (key == 's')
    scene.fit(1);
  if (key == 'S')
    scene.fit();
  if (key == 'u')
    if (scene.trackedNode("keyboard") == null)
      scene.setTrackedNode("keyboard", esfera);
    else
      scene.resetTrackedNode("keyboard");
  if (key == CODED)
    if (keyCode == UP)
      scene.translate("keyboard", 0, -10);
    else if (keyCode == DOWN)
      scene.translate("keyboard", 0, 10);
    else if (keyCode == LEFT)
      scene.translate("keyboard", -10, 0);
    else if (keyCode == RIGHT)
      scene.translate("keyboard", 10, 0);
  if (key == 't')
    ambientLight = !ambientLight;
}
public class Box extends Node {
  float _w, _h, _d;
  int _color;

  public Box(Scene scene, int tint, float w, float h, float d) {
    super(scene);
    _color = tint;
    _w = w;
    _h = h;
    _d = d;
    setPickingThreshold(PApplet.max(_w, _h, _d)/scene.radius());
    randomize();
  }

  // note that within render() geometry is defined
  // at the node local coordinate system
  @Override
  public void graphics(PGraphics pg) {
      
    directionalLight(position().x(), position().y(), position().z(), 0, 1, 0);
    pg.pushStyle();
    updateOrientation(esfera.position());
    if (drawAxes)
      Scene.drawAxes(pg, PApplet.max(_w, _h, _d) * 1.3f);
    pg.noStroke();
    pg.fill(isTracked() ? color(255, 0, 0) : _color);
    pg.box(_w, _h, _d);
    pg.stroke(255);
    if (bullseye)
      scene.drawBullsEye(this);
    pg.popStyle();
  }

  public void updateOrientation(Vector v) {
    Vector to = Vector.subtract(v, position());
    setOrientation(new Quaternion(new Vector(0, 1, 0), to));
  }
}
class Sphere extends Node {
  float _radius;
  int _color;

  public Sphere(Scene scene, int tint, float radius) {
    super(scene);
    _color = tint;
    _radius = radius;
  }

  @Override
  public void graphics(PGraphics pg) {
    spotLight(155, 200, 170, position().x(), position().y(), position().z(), 0, 1, 0, PI/4, 1);
    pg.pushStyle();
    if (drawAxes)
      Scene.drawAxes(pg, _radius * 1.3f);
    pg.noStroke();
    pg.fill(isTracked() ? color(255, 0, 0) : _color);
    pg.sphere(isTracked() ? _radius * 1.2f : _radius);
    pg.stroke(255);
    if (bullseye)
      scene.drawBullsEye(this);
    pg.popStyle();
  }
}
  public void settings() {  size(800, 800, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "light" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
