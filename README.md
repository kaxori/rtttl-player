# RTTTL-PLAYER
The player converts a music string in "Ring Tone Text Transfer Language" code into pitch and duration.

Inspired by the idea of ​​reusing the piezo detectors contained in discarded smoke detectors, 
the desire to play melodies arose. 

The rtttl-player converts the RTTTL melody string into a Tone list. Regular expressions (=> dartino_regexp pkg) is used to analyse the music string. 

A user defined tone player (lamdba function) is intented to control your own device.

# Installation

```bash
jag pkg install github.com/kaxori/rtttl-player
```

# Usage

```toit
import rtttl-player show *
import gpio show Pin
import gpio.pwm show Pwm

GPIO_BUZZER ::= 16
BUZZER ::= Pin GPIO_BUZZER

play-host pitch duration:
  print "pitch: $(%5d pitch), duration: $duration ms"

play-buzzer freq length:
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
  rtttl := rtttl-player (:: | pitch duration | play-buzzer pitch duration )
  rtttl.play SMOKE
```

# References

Wiki RTTTL: https://de.wikipedia.org/wiki/Ring_Tones_Text_Transfer_Language

RTTTL Format Specifications: http://merwin.bespin.org/t4a/specs/nokia_rtttl.txt

To play RTTTL online: https://adamonsoon.github.io/rtttl-play/

Collection of melodies: https://1j01.github.io/rtttl.js/

Toit regexp package: https://pkg.toit.io/package/github.com%2Ferikcorry%2Ftoit-dartino-regexp@v0.2.0

Online RegExp tester: https://regex101.com/