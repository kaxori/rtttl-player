// Copyright (C) 2024 kaxori.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import ..src.rtttl-player show *
import gpio show Pin
import gpio.pwm show Pwm

GPIO_BUZZER ::= 16
BUZZER ::= Pin GPIO_BUZZER


play-host pitch duration:
  print "pitch: $(%5d pitch), duration: $duration ms"


play-buzzer freq length:
  //print "pitch: $(%5d freq), duration: $length ms"

  if freq > 0: // play tone
    melody_pwm := Pwm --frequency=freq
    melody_channel := melody_pwm.start BUZZER
    melody_channel.set_duty_factor 0.5
    sleep --ms=length
    melody_pwm.close

  else: // pause
    sleep --ms=length


main:
  SMOKE ::= "smoke:o=5,d=4,b=130:c,d#,f.,c,d#,8f#,f,p,c,d#,f.,d#,c,2p,8p,c,d#,f.,c,d#,8f#,f,p,c,d#,f.,d#,c"
 
  //rtttl := rtttl-player (:: | pitch duration | play-host pitch duration )
  rtttl := rtttl-player (:: | pitch duration | play-buzzer pitch duration )
  rtttl.play SMOKE

//EOF