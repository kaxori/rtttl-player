// Copyright (C) 2024 kaxori.
// Use of this source code is governed by an MIT-style license
// that can be found in the LICENSE file.

/**
RTTTL player.

Converts music string in "Ring Tone Text Transfer Language" code into pitch and duration.
*/

/*
Inspired by the idea of ​​reusing the piezo detectors contained in discarded smoke detectors, 
the desire to play melodies arose. 

Wiki RTTTL:
=> https://de.wikipedia.org/wiki/Ring_Tones_Text_Transfer_Language

RTTTL Format Specifications:
=> http://merwin.bespin.org/t4a/specs/nokia_rtttl.txt

To play RTTTL online:
=> https://adamonsoon.github.io/rtttl-play/

Collection of 
=> https://1j01.github.io/rtttl.js/

Toit regexp package:
=> https://pkg.toit.io/package/github.com%2Ferikcorry%2Ftoit-dartino-regexp@v0.2.0

Online RegExp tester:
=> https://regex101.com/
*/

import .pitch
import dartino_regexp.regexp as re


/**
Datatype to hold a tone consisting of pitch and duration.
*/
class Tone_:
  pitch /int?       // frequency in Hz
  duration /int?    // duration in ms
  constructor .pitch .duration:


/**
The rtttl-player converts the RTTTL melody string into a Tone list. Regular expressions (=> dartino_regexp pkg) is used to analyse the music string. 
*/
class rtttl-player:

  static TITLE-SECTION ::= 0
  static DEFAULTS-SECTION ::= 1
  static NOTES-SECTION ::= 2
  section_ /List/*<string>*/ := []

  default_ := {:}                     // extracted default values
  tones_ /List/*<Tone_>*/             // extracted tones
  player_ /Lambda                     // external play function


  constructor .player_: 
    tones_ = []


  /**
  Converts the RTTTL melody string into a Tone list and play each tone.
  @param melody The melody string specified in RTTTL.
  */
  play melody/string:
    tones_.clear
    parse-sections_ melody
    parse-defaults_ 
    parse-tones_ section_[NOTES-SECTION]
    play-tones_


  /**
  Splits the melody string into the 3 sections title, defaults, notes.
  */
  parse-sections_ melody:
    section_ = (melody.split ":")
    if section_.size != 3:
      throw "RTTTL error: 3 sections expected"

  /**
  Extracts from default section the values of note length, octave and beats per minute.
  */
  parse-defaults_:
    section := (section_[DEFAULTS-SECTION].split ",")
    if section.size != 3:
      throw "RTTTL error: 3 default specifications expected"

    section.size.repeat:
      match := (re.RegExp "([dob])=([0-9]+)?").first-matching section[it]
      if match != null:
        label := match[1]
        value := match[2]

        if label == "d":
          default_["fraction"] = int.parse value

        else if label == "o":
          default_["octave"] = int.parse value

        else if label == "b":
          bpm := int.parse value
          default_["whole-note-ms"] = 4*60*1000/bpm

      else: 
        throw "$match[0] contains unknown data"


  /**
  Converts the specified music tones into pitch/duration values.
  */
  parse-tones_ tones/string:
    tone := tones.split ","
    if tone.size <= 1:
      throw "error RTTTL: tones expected"

    tone.size.repeat:
      match := (re.RegExp "(1|2|4|8|16|32|64)?([a-hp]#?)([.])?(4|5|6|7)?").first-matching tone[it]
      if match == null:
        throw "error: note $tones[it] unknown"

      duration := default_["whole-note-ms"]

      if match[1] != null:
        duration /= int.parse match[1]
      else:
        duration /= default_["fraction"]

      if match[3] != null:
        duration += duration/2

      octave := default_["octave"]
      if match[4] != null:
        octave = int.parse match[4]

      note := match[2]
      pitch := 0
      if note != "p": 
        if note == "h": note = "b"
        note = "$note$octave"
        pitch = PITCH[note]

      tones_.add (Tone_ pitch duration)



  /**
  Play all tones in list using an external lambda function.
  */
  play-tones_:
    tones_.do:
      //print "pitch: $(%5d it.pitch), duration: $it.pitch ms"
      player_.call it.pitch it.duration

//EOF.