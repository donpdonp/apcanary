http = require("https")
http.TIMEOUT=10

function capture(url)
  print ("Checking " .. url)
  if string.match(url, "https://wifi.ais.co.th") then
    local urlr = "https://wifi.ais.co.th/" --fix url
    print ("lua loading real " .. urlr)
    local b, c, h, sl = http.request {
        url = urlr,
        headers = { ["User-Agent"]= "Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0",
                    ["Accept"] = "*/*",
                    ["Host"] = "wifi.ais.co.th" }
      }
-- Host: wifi.ais.co.th
-- User-Agent: curl/7.47.0
-- Accept: */*

    if b then
-- https://wifi.ais.co.th/WebResource.axd?d=IMkPF5uiIUCr_cpszKEso1&amp;t=635307591758913288
      print ("LUA BODY " .. " len " .. string.len(b) .. " type " .. type(b))
      local matched = string.match(b, 'https://wifi.ais.co.th/WebResource.axd.*t=%d+')
      print ("LUA match " .. " type " .. type(matched) )
      print ("LUA STATUS " .. c .. " type " .. type(c) .. sl)
      print ("LUA h " .. " type " .. type(h) )
      for k,v in pairs(h) do
       print (k, v)
      end
      print ("LUA END")
    else
      print ("LUA HTTP ERR " .. c)
    end
  end
end

function suck(code, data)
      if (code == 200) then
          print("HTTP request failed")
      else
          print(code, data)
      end
end

print "lua capture AIS module"
-- capture("https://wifi.ais.co.th/")



