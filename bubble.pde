static final float START_RADIUS = 5;

class Bubble extends PVector {
  private float radius;
  private int frameWidth;
  private int frameHeight;

  private int grow;

  private int updates;

  ArrayList<Bubble> neighbors;

  private Bubble() {
  }

  private Bubble(float x, float y) {
  }

  private Bubble(float x, float y, float z) {
  }

  public Bubble(int frameWidth, int frameHeight) {
    this.radius = START_RADIUS;
    this.frameWidth = frameWidth;
    this.frameHeight = frameHeight;
    this.x = random(radius, frameWidth - (1 + radius));
    this.y = random(radius, frameHeight - (1 + radius));
    this.grow = 1;
    this.updates = 0;
    this.neighbors = new ArrayList<Bubble>();
  }

  public void clearNeighbors() {
    neighbors.clear();
  }
  public void addNeighbor(Bubble other) {
    if (!neighbors.contains(other)) {
      neighbors.add(other);
    }
  }

  public boolean touchesANeighbor() {
    for(Bubble neighbor : neighbors) {
      if (touches(neighbor)) {
        return true;
      }
    }
    return false;
  }

  public boolean touches(Bubble other) {
    return dist(other) <= radius + other.radius + 1;
  }

  public boolean overlapses(Bubble other) {
    return dist(other) < radius + other.radius + 1;
  }

  public boolean touchesWalls() {
    return (0 >= x - radius) || (0 >= y - radius) || (frameWidth < x + radius + 1) || (frameHeight < y + radius + 1);
  }

  public int neighborsCount() {
    return neighbors.size();
  }

  public void update() {
    if (touchesWalls() || touchesANeighbor()) {
      if (1 == grow) {
        grow = 0;
      } else {
        grow = -1;
      }
    } else {
       if (-1 == grow) {
         grow = 0;
       } else {
         grow = 1;
       }
     }
    grow();
    updates++;
  }

  private void grow() {
    radius += grow/3.0;
  }

  public boolean dead() {
    return (0 >= radius);
  }

  public void render() {
    fill(updates % 360, 1, 1, radius);
    ellipse(x, y, 2 * radius, 2 * radius);
  }

  public float radius() {
    return radius;
  }

  public int updates() {
    return updates;
  }
}
