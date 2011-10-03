Factory.define :airport do |a|
  a.name      "Pulkovo"
  a.code      "LED"
  a.latitude  12
  a.longitude 34
end

Factory.define :flight do |f|
  f.origin { |a| a.association(:airport) } 
  f.destination { |a| a.association(:airport) }
  f.depart_date Date.today
  f.return_date Date.today + 14
  f.value rand(1000)
end
