bpm = 120.0
ms = 60 * 1000 / bpm
l1 = ms / 4.0 / 1000.0

def c(input, scale)
  input.gsub(' ', '').split('').map { |x| Integer(x, 16) / scale }.ring
end

p = {
  "length" => 16,
  
  "root"   => :f2,
  "chord"  => :minor7,
  "scale"  => :minor,
  
  "trig"  => c("1011 1011", 1),
  "amp"   => c("814", 8.0),
  "arp"   => c("0000 0000", 1),
  "note"  => c("1140 014112", 1),
  "rel"   => c("811", 4.0)
}

live_loop :seq1 do
  step = tick % p["length"]
  
  ##| notes = chord p["root"], p["chord"]
  ##| index = p["arp"][step]
  
  notes = scale p["root"], p["scale"], num_octaves: 2
  index = p["note"][step]
  
  note = notes[index]
  
  if p["trig"][step] > 0
    in_thread do
      midi_note_on note, vel_f: p["amp"][step], port: "iac_driver_bus_1", channel: 1
      sleep l1 * p["rel"][step]
      midi_note_off note, port: "iac_driver_bus_1", channel: 1
    end
  end
  
  sleep l1
end
