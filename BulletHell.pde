Spinner s; //<>//
Bullet b;

float r;
float theta;
float theta_vel;
float theta_acc;

ArrayList<Bullet> bulletlist = new ArrayList<Bullet>();
int index;

boolean death;
float a;
boolean cleared;
int st2, st1;
int stage;

String formattedString;
int bullets;

boolean collision;

void setup()
{
  size(1500, 1500, P2D);
  //fullScreen(P2D);

  //***********************
  collision = true;
  //***********************

  frameRate = 60;

  background(0);

  s = new Spinner();

  r = height;
  theta = 0;
  theta_vel = 0;
  theta_acc = 0.00001;

  a = 120;
  cleared = false;

  stage = 1;
}
void draw()
{ 
  if (!death)
  {
    background(0);
    s.update();
    translate(0, 0);
  } else if (death)
  {
    background(255, 0, 0);
    rectMode(CENTER);
    fill(0);
    stroke(0);
    rect(width/2, height/2, 500, 200);
    fill(255);
    stroke(255);
    textSize(36);
    text(formattedString, width/2-200, height/2-10);
  }

  if (st1 <= height+200)
  {
    fill(255, 0, 0);
    stroke(255, 0, 0);
    textSize(50);
    text("STAGE 1", width/2, st1*10);
    st1++;
  }

  ArrayList toRemove = new ArrayList();
  for (Bullet b : bulletlist)
  {
    if (b != null && !death)
    {
      b.update();

      float frames = frameCount;

      if (b.isMouse() && collision)
      {
        death = true;

        float time = frames / frameRate;
        formattedString = String.format("Time: %.02f seconds\nBullets: %2$d", time, bullets);
      }

      if (b.isExpired())
      {
        toRemove.add(b);
      }
    }
  }
  bulletlist.removeAll(toRemove);
}

class Spinner
{
  java.util.Random rng;
  Spinner()
  {
    rng = new java.util.Random();
  }
  void update()
  {
    float x = r * cos(theta);
    float y = r * sin(theta);
    theta_vel += theta_acc;
    theta += theta_vel;

    noStroke();
    fill(200);
    ellipse(x+width/2, y+height/2, 32, 32);

    translate(0, 0);
    if (stage == 1)
    {
      if (frameCount % floor(a) == 0)
      {
        bulletlist.add(new Bullet(x+width/2, y+height/2, 
          rng.nextBoolean() ? Bullet.MODE_MOUSE : Bullet.MODE_WOBBEL));
        bullets++;
        if (a > 2)
        {
          a = a - 2;
        }
        if (a == 2 && st2 <= height+200)
        {
          if (!cleared)
          {
            bulletlist.clear();
            cleared = true;
          }
          stage = 2;
        }
      }
    }     

    if (stage == 2)
    {
      if (st2 <= height+200)
      {
        fill(255, 0, 0);
        stroke(255, 0, 0);
        textSize(50);
        text("STAGE 2", width/2, st2*10);
        st2++;
      }
      if (frameCount % 6 == 0)
      {
        bulletlist.add(new Bullet(x+width/2, y+height/2, Bullet.MODE_CENTER));
        bullets++;
      }
      if (frameCount % 12 == 0)
      {
        bulletlist.add(new Bullet(x+width/2, y+height/2, Bullet.MODE_CENTER));
        bullets++;
      }
    }
  }
}

class Bullet
{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector mouse;
  PVector center;
  PVector dir;
  float topspeed;
  int mode;

  static final int MODE_WOBBEL = 1;
  static final int MODE_CENTER = 2;
  static final int MODE_MOUSE = 3;

  Bullet(float posx, float posy, int mode_)
  {
    mouse = new PVector(mouseX, mouseY);
    location = new PVector(posx, posy);
    velocity = new PVector(0, 0);
    center = new PVector(width/2, height/2);
    topspeed = 4;

    this.mode = mode_;
    if (mode == MODE_CENTER)
    {
      dir = PVector.sub(center, location);
    } else if (mode == MODE_MOUSE)
    {
      dir = PVector.sub(mouse, location);
    }
  }
  void update()
  {
    if (mode == MODE_WOBBEL)
    {
      dir = PVector.sub(mouse, location);
    } 
    dir.normalize();
    dir.mult(0.5);
    acceleration = dir;

    velocity.add(acceleration);
    velocity.limit(topspeed);
    location.add(velocity);

    if (mode == MODE_WOBBEL)
    {
      fill(255);
      noStroke();
      ellipse(location.x, location.y, 15, 15);
    } else if (mode == MODE_CENTER)
    {
      fill(255, 0, 0);
      noStroke();
      ellipse(location.x, location.y, 15, 15);
    } else if (mode == MODE_MOUSE)
    {
      fill(0, 255, 0);
      noStroke();
      ellipse(location.x, location.y, 15, 15);
    }
  }

  boolean isMouse()
  {
    if (mouseX > location.x-7.5 && mouseX < location.x+7.5 &&
      mouseY > location.y-7.5 && mouseY < location.y+7.5)
    {
      return true;
    } else
    {
      return false;
    }
  }

  boolean isExpired()
  {
    if (mode == 2 && location.x > width/2 -7.5 && location.x < width/2 +7.5 &&
      location.y > height/2 -7.5 && location.y < height/2 +7.5)
    {
      return true;
    } else
    {
      return false;
    }
  }
}
