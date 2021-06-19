//print on = 1: Prints out infos
int print = 0;
//save = 1: Speichert das Video in Frames
int save = 1;
//fps: Wenn gespeichert wird, jedes x-te Frame wird gesichert (also fps=10 --> nur jedes 10-te Frame wird auch gespeichert
int fps = 1;
int zaehler = 0;
float speed = 1;
int starField = 2;
int showInitial = 0;
int rotating = 0;
int combine = 2;

PImage starfield; 
PShape stars;
float xmag, ymag = 0;
float newXmag, newYmag = 0; 
float lastXmag, lastYmag = 0;

float turnspeed = 1200;
float diag = 990;
float centre = 0;

//Initialisiere alle Variablen
int ZahlX = 20;
int ZahlY = 20;
int ZahlZ = 20;
int Zahl = ZahlX*ZahlY*ZahlZ;  //Anzahl der Teilchen
float[] vx = new float[Zahl];  //Speichert die x-Geschwindigkeiten der Teilchen
float[] vy = new float[Zahl];  //Speichert die y-Geschwindigkeiten der Teilchen
float[] vz = new float[Zahl];  //Speichert die y-Geschwindigkeiten der Teilchen
float[] x = new float[Zahl];  //x-Koordinate der Teilchen
float[] y = new float[Zahl];  //y-Koordinate der Teilchen
float[] z = new float[Zahl];  //y-Koordinate der Teilchen
float[] gew = new float[Zahl]; //Gewichte der verschiedenen Teilchen
float[] rad = new float[Zahl]; //Radien der Teilchen
float InteraktionsRadius = 0; //Ab welchem Abstand Teilchen zusammengefügt werden
float c = 150;










void setup(){
  if(starField == 1){
    starfield = loadImage("starfield2.jpg");
  }
  fullScreen(P3D);
  //size(600,600,P3D);
  background(255);
  //fill(150,0,0);
  //stroke(50,0,0);
  fill(255);
  noStroke();
  strokeWeight(1);
  sphereDetail(10);
  directionalLight(255, 255, 255, -1, 0, -0.5);
  
  
  for(int i=0; i<Zahl; i++){
    gew[i] = 1;
    rad[i] = 6;
  }
  
  //Fülle die Variablenplätze
  for(int i=0; i<Zahl; i++){
    
      String koord = "Röhre";
      String vel = "Röhre";
      
      
      if(koord == "Zufall"){
        //Zufällige Koordinaten
        float dist = 0.6;
        x[i] = random(-dist*diag,dist*diag);
        y[i] = random(-dist*diag,dist*diag);
        z[i] = random(-dist*diag,dist*diag);
      }
      
      
      if(koord == "Röhre"){
        //Kreisförmig mit kreisförmigen Geschwindigkeiten
        float dist = 0.6;
        x[i] = cos(2*PI*(i)/(Zahl))*dist*diag;
        y[i] = random(-dist*diag/2,dist*diag/2);
        z[i] = sin(2*PI*(i)/(Zahl))*dist*diag;
      }
      
      if(koord == "Würfel"){
        float dist = 0.8;
        x[i] = dist*diag*(i%ZahlX)/(ZahlX-1)-0.5*dist*diag;
        y[i] = dist*diag*(((i-i%ZahlY))%(ZahlX*ZahlY))/(ZahlX*ZahlY-ZahlY)-0.5*dist*diag;
        z[i] = dist*diag*(i-i%(ZahlX*ZahlY))/Zahl-0.5*dist*diag;
      }
      
      
      
      if(koord == "Kugel"){
        float dist = 0.4;
        int done = 0;
        while(done == 0){
          x[i] = random(-dist*diag,dist*diag);
          y[i] = random(-dist*diag,dist*diag);
          z[i] = random(-dist*diag,dist*diag);
          if(x[i]*x[i]+y[i]*y[i]+z[i]*z[i] < dist*diag*dist*diag){
            done = 1;
          }
        }
      }
      
      
      
      
      
      
      if(vel == "Null"){
        vx[i] = 0;
        vy[i] = 0;
        vz[i] = 0;
      }
      
      if(vel == "Zufall"){
        //Zufällige Geschwindigkeiten
        int vrand = 1;
        vx[i] = random(-vrand,vrand);
        vy[i] = random(-vrand,vrand);
        vz[i] = random(-vrand,vrand);
      }
      
      if(vel == "Röhre"){
        vx[i] = 1*sin(2*PI*(i)/(Zahl))*random(0.999,1.001);  //1 for fast, 0.6 for slow, 0.2 for slower, not applicable to the oldest clips
        vz[i] = -1*cos(2*PI*(i)/(Zahl))*random(0.999,1.001);
        vy[i] = 0;
      }
      
      //Gleichmäßige kreisförmige Geschwindigkeiten für Würfel
      if(vel == "Würfel"){
        vx[i] = 3*sin(PI*(i-i%(ZahlX*ZahlY)));
        vy[i] = 0;
        vz[i] = 3*cos(PI*(i-i%(ZahlX*ZahlY)));
      }
      
      //Gleichmäßige kreisförmige Geschwindigkeiten für Würfel
      if(vel == "Kugel"){
        float dist = 0.4;
        vx[i] = -6*sin(z[i]/(dist*diag)); //Vorher 3
        vy[i] = 0;
        vz[i] = 6*sin(x[i]/(dist*diag));;
      }
      
      
      
      
      
      
      
      if(showInitial==1){
        translate(x[i],y[i],z[i]);
        sphere(rad[i]);
        translate(-x[i],-y[i],-z[i]);
      }
  }
  
  if(showInitial==1){
    stroke(100,100,150);
    fill(200,200,255);
    translate(width/2,height/2);
    sphereDetail(30);
    sphere(3000);
    sphereDetail(10);
    fill(255);
    noStroke();
  }
  
}






















void draw(){
  background(50);
  if(starField == 1){
    stars = createShape(SPHERE, 3000);
    stars.setTexture(starfield);
    pushMatrix();
    translate(0,0,0);
    //rotateY(PI * zaehler / 500);
    shape(stars);
    popMatrix();
  }
  
  if(rotating == 1){
    translate(width/2,0,0);
    rotateX(0.5*sin(speed*zaehler*PI/(4000)));
    rotateY(speed*2*PI*zaehler/3000);
    translate(-width/2,0,0);
  }
  if(rotating == 0){
    
    newXmag = mouseX/float(width) * TWO_PI;
    newYmag = mouseY/float(height) * TWO_PI;
    
    
    float diff = lastXmag-newXmag;
    if (abs(diff) >  0.01 && mousePressed) { 
      xmag -= diff/1.0;
    }
    
    diff = lastYmag-newYmag;
    if (abs(diff) >  0.01 && mousePressed) { 
      ymag -= diff/1.0; 
    }
    
    lastXmag = mouseX/float(width) * TWO_PI;
    lastYmag = mouseY/float(height) * TWO_PI;
    
    rotateX(-ymag);
    rotateY(-xmag);
    //translate(0,0,-(cos(2*xmag)*width/2));
  }
    
  
  
  directionalLight(255, 255, 255, 1, 0, -0.5);
  //directionalLight(100, 100, 100, 0.75, 0, 0.25);
  ambientLight(20,20,20);

  
  //Neue Geschwindigkeiten berechnen
  for(int i=0; i<Zahl; i++){
      if(gew[i] != 0){
        for(int a=i+1; a<Zahl; a++){
          if(gew[a] != 0){
            float Ky = y[a]-y[i];
            float Kx = x[a]-x[i];
            float Kz = z[a]-z[i];
            float H = sqrt(Kx*Kx+Ky*Ky+Kz*Kz);
            //float F = Kraft(x[i],y[i],z[i],  x[a],y[a],z[a],  gew[i], gew[a]);
            float F = Kraft(H,  gew[i], gew[a]);
            vx[i] += F*(Kx/H)/gew[i];
            vy[i] += F*(Ky/H)/gew[i];
            vz[i] += F*(Kz/H)/gew[i];
            vx[a] -= F*(Kx/H)/gew[a];
            vy[a] -= F*(Ky/H)/gew[a];
            vz[a] -= F*(Kz/H)/gew[a];
          }
        }
      }
    }
    if(combine == 2){
      for(int i=0; i<Zahl; i++){
        if(gew[i] != 0){
          for(int j=i; j<Zahl; j++){
            if(gew[j] != 0){
              float r = sqrt((x[i]-x[j])*(x[i]-x[j])+(y[i]-y[j])*(y[i]-y[j])+(z[i]-z[j])*(z[i]-z[j]));
              float abstand = rad[0]*4;
              
              if(r<abstand){
                float vxZW1 = vx[i];
                float vyZW1 = vy[i];
                float vzZW1 = vz[i];
                float vxZW2 = vx[j];
                float vyZW2 = vy[j];
                float vzZW2 = vz[j];
                
                float fac = 0.1;
                float factor = fac*(sqrt(r/abstand)) + 1-fac;
                vx[i] = factor*vxZW1 + (1-factor)*vxZW2;
                vy[i] = factor*vyZW1 + (1-factor)*vyZW2;
                vz[i] = factor*vzZW1 + (1-factor)*vzZW2;
                vx[j] = factor*vxZW2 + (1-factor)*vxZW1;
                vy[j] = factor*vyZW2 + (1-factor)*vyZW1;
                vz[j] = factor*vzZW2 + (1-factor)*vzZW1;
                
              }
            }
          }
        }
      }
    }
      
  
  
  //Setze hier maximale Geschwindigkeit
  for(int i=0; i<Zahl; i++){
      if(gew[i] != 0){
        float v = sqrt(vx[i]*vx[i] + vy[i]*vy[i] + vz[i]*vz[i]);
        while(v>=c){
          vx[i] *= 0.99;
          vy[i] *= 0.99;
          vz[i] *= 0.99;
          v = sqrt(vx[i]*vx[i] + vy[i]*vy[i] + vz[i]*vz[i]);
        }
      }
  }
  
  
  
  //Neue Positionen berechnen
  for(int i=0; i<Zahl; i++){
      if(gew[i] != 0){
        if(vx[i]<c){x[i] += vx[i]*speed;}
        if(vy[i]<c){y[i] += vy[i]*speed;}
        if(vz[i]<c){z[i] += vz[i]*speed;}
      }
      if(zaehler>1 && print==1 && gew[i]>0){
        print(i, ", ", x[i], ", ", y[i], ", ", z[i], "\n"); 
      }
  }
  
  
  
  
  //Nah zusammenliegende Punkte werden zusammengefügt
  if(combine == 1){
    for(int i=0; i<Zahl; i++){
      if(gew[i] != 0){
        for(int a=i; a<Zahl; a++){
          if(gew[a] != 0){
            float abst = sqrt((x[i]-x[a])*(x[i]-x[a]) + (y[i]-y[a])*(y[i]-y[a]) + (z[i]-z[a])*(z[i]-z[a]));
            if(abst<(InteraktionsRadius+rad[i]+rad[a]) && a != i){
              if(i<a){
               vx[i] = gew[a]*vx[a] + gew[i]*vx[i];
               vy[i] = gew[a]*vy[a] + gew[i]*vy[i];
               vz[i] = gew[a]*vz[a] + gew[i]*vz[i];
               
               x[i] = gew[a]*x[a] + gew[i]*x[i];
               y[i] = gew[a]*y[a] + gew[i]*y[i];
               z[i] = gew[a]*z[a] + gew[i]*z[i];
               
               gew[i] += gew[a];
               
               vx[i] /= gew[i];
               vy[i] /= gew[i];
               vz[i] /= gew[i];
               
               x[i] /= gew[i];
               y[i] /= gew[i];
               z[i] /= gew[i];
               
               rad[i] = 5*sqrt(sqrt(gew[i])); //sqrt(sqrt(, überall iff(gew != 0) machen
               
               
               x[a] = width*height*random(1,10);
               y[a] = width*height*random(1,10);
               z[a] = width*height*random(1,10);
               gew[a] = 0;
               vx[a] = 0;
               vy[a] = 0;
               vz[a] = 0;
              }
              if(i>a){
                vx[a] = gew[a]*vx[a] + gew[i]*vx[i];
                vy[a] = gew[a]*vy[a] + gew[i]*vy[i];
                vz[a] = gew[a]*vz[a] + gew[i]*vz[i];
                
                x[a] = gew[a]*x[a] + gew[i]*x[i];
                y[a] = gew[a]*y[a] + gew[i]*y[i];
                z[a] = gew[a]*z[a] + gew[i]*z[i];
                
                gew[a] += gew[i];  
                
                vx[a] /= gew[a];
                vy[a] /= gew[a];
                vz[a] /= gew[a];
                
                x[a] /= gew[a];
                y[a] /= gew[a];
                z[a] /= gew[a];
                
                rad[a] = 5*sqrt(sqrt(gew[a]));
                
                
                x[i] = width*height*random(1,10);
                y[i] = width*height*random(1,10);
                z[i] = width*height*random(1,10);
                gew[i] = 0;
                vx[i] = 0;
                vy[i] = 0;
                vz[i] = 0;
              }
            }
          }
        }
      }
    }
  }

  
  //Zeichne die Punkte auf
  for(int i=0; i<Zahl; i++){
      if(gew[i] != 0){
        if(rad[i]>10){
          sphereDetail(int(rad[i]));
        }
        if(combine == 1){
          if(gew[i]<10){
            fill(200);
          }
          if(gew[i]<50 && gew[i]>=10){
            fill(160,69,19);
          }
          if(gew[i]>=50 && gew[i]<Zahl/5){
            fill(139,40,10);
          }
          if(gew[i]>Zahl/5){
            fill(255,255,0);
          }
        }
        if(combine == 2 || combine == 0){
          fill(170*map(noise(i),0,1,0.6667,1.5));
        }
        translate(x[i],y[i],z[i]);
        sphere(rad[i]);
        translate(-x[i],-y[i],-z[i]);
        if(rad[i]>10){
          sphereDetail(10);
        }
      }
  }
  fill(150);
  
  
    
  if(starField == 0){
    stroke(100,100,150);
    fill(100,100,155);
    translate(width/2,height/2);
    sphereDetail(30);
    sphere(3000);
    sphereDetail(10);
    fill(255);
    noStroke();
  }
  
  //camera(sin(2*PI*float(frameCount)/turnspeed)*diag*(float(mouseY)/float(height)), centre, cos(2*PI*float(frameCount)/turnspeed)*diag*(float(mouseY)/float(height)), centre, centre, centre, 0.0, 1.0, 0.0);
  //camera(sin(2*PI*float(frameCount)/turnspeed)*diag, centre, cos(2*PI*float(frameCount)/turnspeed)*diag, centre, centre, centre, 0.0, 1.0, 0.0);
  camera(0, centre+1600-frameCount*0.2, 0, centre, centre, centre, 0.0, 0.0, -1.0);

  if(save == 1){
    saveFrame("output/8k_ThumbnailAboveSlower_0k2/frame######.png");
  }
  
  
  zaehler += 1;
}







//Berechnet die Kraft zweier Teilchen aufeinander. m=1 für alle Teilchen
/*float Kraft(float x1, float y1, float z1, float x2, float y2, float z2, float gew1, float gew2){
  float r;
  r = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));*/
float Kraft(float r, float gew1, float gew2){
  float G = speed*50/sqrt(Zahl);
  float F;
  if(r > 1.5*rad[0]){
    F = G*(gew1*gew2)/(r*r);
  }
  else{
    F = -6.3*G*(1.5*rad[0]-r)/rad[0];
  }
  if(print == 2){
    print("F = ", F, "\n\n");
  }
  return F;
}



void mouseClicked(){
  lastXmag = mouseX/float(width) * TWO_PI;
  lastYmag = mouseY/float(height) * TWO_PI;
}
