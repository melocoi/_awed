---- a class for softcut operations
--- possibly


local sc = {}

function sc.init()
  --audio.level_adc(0.5)
  audio.level_adc_cut(1)
  --softcut.buffer_clear()
  softcut.enable(1,1)
  softcut.buffer(1,1)
  softcut.level(1,1.0)
  softcut.pan(1,-1)
  softcut.rate(1,rte)
  softcut.rate_slew_time(1,12)
  softcut.level_slew_time(1,2)
  softcut.loop(1,1)
  softcut.loop_start(1,1)
  softcut.loop_end(1,lEnd)
  softcut.position(1,1)
  softcut.play(1,1)
  softcut.phase_quant(1,0.125)
  softcut.event_position(checkPos)
  
  
  softcut.enable(2,1)
  softcut.buffer(2,2)
  softcut.level(2,1.0)
  softcut.pan(2,1)
  softcut.rate(2,rte)
  softcut.rate_slew_time(2,12)
  softcut.level_slew_time(2,2)
  softcut.loop(2,1)
  softcut.loop_start(2,1)
  softcut.loop_end(2,lEnd)
  softcut.position(2,1)
  softcut.play(2,1)
  
  softcut.post_filter_dry(1,0.5)
  softcut.post_filter_lp(1,1)
  softcut.post_filter_fc(1,low)
  softcut.post_filter_rq(1,1)
  
  softcut.post_filter_dry(2,0.5)
  softcut.post_filter_lp(2,1)
  softcut.post_filter_fc(2,low)
  softcut.post_filter_rq(2,1)--]]

  softcut.level_input_cut(1,1,1.0)
  softcut.level_input_cut(2,2,1.0)
  --softcut.level_cut_cut(1,2,pre)
  --softcut.level_cut_cut(2,1,pre)
  softcut.rec_level(1,1)
  softcut.rec_level(2,1)
  softcut.pre_level(1,pre)
  softcut.pre_level(2,pre)
  softcut.rec(1,1)
  softcut.rec(2,1)
   
---mutator1 voices
  softcut.enable(3,1)
  softcut.buffer(3,2)
  softcut.level(3,1.0)
  softcut.pan(3,1)
  softcut.post_filter_dry(3,0.0)
  softcut.post_filter_lp(3,1.0)
  softcut.post_filter_fc(3,low*2)
  softcut.post_filter_rq(3,1)
  softcut.loop(3,1)
  softcut.loop_start(3,1)
  softcut.loop_end(3,lEnd)
  softcut.position(3,1)
  softcut.play(3,1)
  
---mutator2 voices
  softcut.enable(4,1)
  softcut.buffer(4,1)
  softcut.level(4,1.0)
  softcut.pan(4,-1)
  softcut.post_filter_dry(4,0.0)
  softcut.post_filter_lp(4,1.0)
  softcut.post_filter_fc(4,low*2)
  softcut.post_filter_rq(4,1)
  softcut.loop(4,1)
  softcut.loop_start(4,1)
  softcut.loop_end(4,lEnd)
  softcut.position(4,1)
  softcut.play(4,1)
  
  --discombobulators
    -- record input 1
  softcut.level_cut_cut(1,5,1)

    -- record head 1
  softcut.enable(5,0)
  softcut.buffer(5,1)
  softcut.rate(5,1)
  softcut.loop(5,1)
  softcut.loop_start(5,1)
  softcut.loop_end(5,lEnd)
  softcut.position(5,2)
  softcut.play(5,1)
  softcut.rec(5,1)
  softcut.rec_level(5,0.8)
  softcut.pre_level(5,0)
  softcut.level(5,0)
  softcut.fade_time(5,0.1)
  softcut.recpre_slew_time(5,0.02)
      -- record input 2
  softcut.level_cut_cut(2,6,1)

    -- record head 2
  softcut.enable(6,0)
  softcut.buffer(6,2)
  softcut.rate(6,1)
  softcut.loop(6,1)
  softcut.loop_start(6,1)
  softcut.loop_end(6,lEnd)
  softcut.position(6,2)
  softcut.play(6,1)
  softcut.rec(6,1)
  softcut.rec_level(6,0.8)
  softcut.pre_level(6,0)
  softcut.level(6,0)
  softcut.fade_time(6,0.1)
  softcut.recpre_slew_time(6,0.02)
  
  discoM:start()
end

-- Discombobulation
discobC = 0
bDisco = true
discoM = metro.init()
discoM.time = 0.5
discoM.event = function()
  dbTime = params:get("time")
  discoM.time = math.random()*dbTime
  
  if bDisco then
    local dscbC = math.random(8)
    
    if discobC >= dscbC then
      softcut.enable(5,1)
      softcut.enable(6,1)
     -- local newPos = (math.random()) 
      local newPos1 = math.random()+math.random(lStrt,lEnd)
      local newPos2 = math.random()+math.random(lStrt,lEnd)
      softcut.position(5,newPos1)
      softcut.position(6,newPos2)
      --softcut.loop_start(5,newPos1)
      --softcut.loop_start(6,newPos2)
      softcut.rec_level(5,0.8)
      softcut.pre_level(5,0)
      softcut.rec_level(6,0.8)
      softcut.pre_level(6,0)
      dAmp = params:get("amplitude")
      softcut.level_cut_cut(1,5,dAmp)
      softcut.level_cut_cut(2,6,dAmp)
      --print(newPos1)
    else
      softcut.enable(5,0)
      softcut.enable(6,0)
    end
    
    
  else
    softcut.enable(5,0)
    softcut.enable(6,0)
  end
  
end

function sc.mutator(v,t,r,l,p)

  --softcut.recpre_slew_time(v,t)
  --updateSlew(v,t)
  
  softcut.level(v,l)
  softcut.pan(v,p)
  softcut.rate(v,r)
  
  
end

function sc.updateSlew(v,t)
  softcut.level_slew_time(v,t)
  softcut.pan_slew_time(v,t*2)
end

function sc.mutator2(v,t,r,l,p)

   --softcut.recpre_slew_time(v,t)
  --updateSlew(v,t)
  
  softcut.level(v,l)
  softcut.pan(v,p)
  softcut.rate(v,r)
  
end

function sc.sft_loop_length(v,s,e)
  softcut.loop_start(v,s)
  softcut.loop_end(v,e)
end

function checkPos(i,pos)
  
  if i == 1 then
    lStrt = math.floor(pos)
    params:set("lStrt",lStrt)
    sc.sft_loop_length(1,lStrt,lEnd)
    sc.sft_loop_length(2,lStrt,lEnd)
    print(lStrt)
    
  elseif i == 2 then
    lEnd= math.floor(pos)-lStrt
    params:set("lEnd",lEnd)
    sc.sft_loop_length(1,lStrt,lEnd)
    sc.sft_loop_length(2,lStrt,lEnd)
    print(lEnd, pos)
  end
  
end

function sc.resetLoop()
  lStrt = 1
  params:set("lStrt",lStrt)
  lEnd = tapeLength
  params:set("lEnd",lEnd)
  sc.sft_loop_length(1,lStrt,lEnd)
  sc.sft_loop_length(2,lStrt,lEnd)
end
function sc.rteOffset(o)
  local racine = MusicUtil.freq_to_note_num(root[o])-MusicUtil.freq_to_note_num(root[1])
  rteOff = MusicUtil.interval_to_ratio(racine) - 1
  
  softcut.rate(1,calcRteWobble())
  softcut.rate(2,calcRteWobble())
end

function sc.sft_enc_rte(d)
-- set RATE and draw it
  rte = util.clamp(rte+d/100,0.1,1)
  rteQuant = (quantize_interval((MusicUtil.ratio_to_interval(rte/2)*-2)+28)-4)
  --print(rte)
  --print(rteQuant)
  newRate = MusicUtil.interval_to_ratio(-rteQuant)*16
  --print(newRate)
  softcut.rate(1,newRate+rteOff)
  softcut.rate(2,newRate+rteOff)
 
  screen.clear()
  screen.level(math.floor(rec*15))
  calcRect(rte)
  screen.fill()
  redraw()
end

function sc.sft_enc_pre(d)

-- set PRE level and draw it
  pre = util.clamp(pre+d/100,0,1)
  softcut.pre_level(1,pre)
  softcut.pre_level(2,pre)
  --softcut.level_cut_cut(1,2,pre)
  --softcut.level_cut_cut(2,1,pre)
  redraw()
  
end

function sc.sft_enc_rec(d)
  
-- set REC level and draw it
  rec = util.clamp(rec+d/100,0,1)
  softcut.rec_level(1,rec)
  softcut.rec_level(2,rec)
  screen.clear()
  screen.level(math.floor(rec*15))
  calcRect(rte)
  screen.fill()    
  redraw()
  
end

function sc.sft_enc_filt(d)
  
--set FILTER CENTER FREQUENCY and draw it
  newLow = util.clamp(newLow+(d*10),root[1],filtMax)
  low = quantize_note(newLow)
--softcut.pre_filter_fc(1,low)
--softcut.pre_filter_fc(2,low)
  softcut.post_filter_fc(1,(low*4))
  softcut.post_filter_fc(2,(low*4))
  lowOff = low/filtMax
  drawRec = true
  redraw()
  
end
  

return sc