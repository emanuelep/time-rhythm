-- Time/Rhythm
-- explore relationship between
-- polyrhythms and duophonic 
-- harmonies  @emanuelep
-- each voice is panned to one side
-- turn E2 and E3 for pitch
-- turn E1 to multiply pitch
-- hold K1 to multiply faster 
-- hold K2 to change pulse width
-- press K3 to turn comp on/off


engine.name = 'TimeRhythm'


function init()
  positionEnc1=1
  positionEnc2=1
  positionEnc3=1
  pitch1=1;
  pitch2=1;
  multiplier=0
  engine.hz1(1)
  engine.hz2(1)
  step1=0.01;
  step2=0.01;
  step3=0.01;
  pwswitch=0;
  enc2pw=0.5;
  enc3pw=0.5;
  compflag=0;
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.font_face(15)
  screen.font_size(13)
  screen.move(0,35)
  screen.text("OSC 1: " .. math.floor(pitch1*100)/100 .. "Hz")
  screen.move(0,50)
  screen.text("OSC 2: " .. math.floor(pitch2*100)/100 .. "Hz")
  if multiplier == 1 then --draw increasing steps tag
    screen.move(50,15)
    screen.text(">>STEPS")
  end
  if compflag == 1 then -- draw compressor on tag
    screen.move(0,63)
    screen.text("COMPRESSOR ON")
  end
  if pwswitch == 1 then
    screen.move(0,10)
    screen.text("PW OSC1:" .. math.floor(enc2pw*100)/100)
    screen.move(0,22)
    screen.text("PW OSC2:" .. math.floor(enc3pw*100)/100)
    screen.aa(0)
    screen.line_width(1)
    -- osc1 draw squarewave
    screen.move(105,10)
    screen.line(105+19*(enc2pw),10)
    screen.line(105+19*(enc2pw),2)
    screen.line(124,2)
    -- osc2 draw squarewave
    screen.move(105,22)
    screen.line(105+19*(enc3pw),22)
    screen.line(105+19*(enc3pw),14)
    screen.line(124,14)
    screen.stroke()
  elseif pwswitch == 0 then
  end
  screen.update()
end

function enc(n,d)
  -- if multiplier flag active then use encoder to increase hz step
  if n == 2 then
    if multiplier == 0 then
      step2=0.01;
    elseif multiplier == 1 then
      step2=0.1;
    end
    -- if pwswitch flag active then use encoder to define pulse width
    if pwswitch == 1 then
      enc2pw = util.clamp(enc2pw + d/100,0.01,0.99)
      engine.width1(enc2pw)
      print("enc2pw = " .. enc2pw)
      redraw()
    elseif pwswitch == 0 then
      positionEnc2 = util.clamp(positionEnc2 + d*step2,0.01,10)
      print("positionEnc2 = " .. positionEnc2)
      pitch1=(positionEnc2*positionEnc1);                   --here pitch1 gets defined
      print("pitch1 = " .. pitch1)
      engine.hz1(pitch1)
      redraw()
    end
  end
  -- same as encoder 2
  if n == 3 then
    if multiplier == 0 then
      step3=0.01;
    elseif multiplier == 1 then
      step3=0.1;
    end
    if pwswitch == 1 then
      enc3pw = util.clamp(enc3pw + d/100,0.01,0.99)
      engine.width2(enc3pw)
      print("enc3pw = " .. enc3pw)
      redraw()
    elseif pwswitch == 0 then
      positionEnc3 = util.clamp(positionEnc3 + d*step3,0.01,10)
      print("positionEnc3 = " .. positionEnc3)
      pitch2=(positionEnc3*positionEnc1)                    --here pitch2 gets defined
      print("pitch2 = " .. pitch2)
      engine.hz2(pitch2)
      redraw()
    end
  end
  
  -- encoder 1
  if n == 1 then
    -- same as encoder 2 and 3
    if multiplier == 0 then
      step1=0.1;
    elseif multiplier == 1 then
      step1=1;
    end
    positionEnc1 = util.clamp(positionEnc1 + d*step1,1,1000)
    print("positionEnc1 = " .. positionEnc1)
    pitch1=positionEnc2*positionEnc1                           --here pitch1 gets defined
    pitch2=positionEnc3*positionEnc1                           --here pitch2 gets defined
    engine.hz1(pitch1)
    engine.hz2(pitch2)
    print("pitch1 = " .. pitch1)
    print("pitch2 = " .. pitch2)
    redraw()
  end
end  

  -- keys activate/deactivate flags or comp(key3)
  function key(n,z)
    if n == 1 then
      if z == 1 then
        multiplier=1
        print("multiplier = " .. multiplier)
      elseif z == 0 then
        multiplier=0
      end
    redraw()
    end
    if n == 2 then
      if z == 1 then
        pwswitch=1
      elseif z == 0 then
        pwswitch=0
      end
    redraw()
    end
    if n == 3 then
      if z == 1 then
        if compflag == 0 then
          audio:comp_on()
          compflag = 1
        elseif compflag == 1 then
          audio:comp_off()
          compflag = 0
        end
      end
    redraw()
    end  
  end