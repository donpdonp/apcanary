http = require("https")
ltn12 = require("ltn12")

http.TIMEOUT=10

function capture(url)
  print ("Checking " .. url)
  if string.match(url, "https://wifi.ais.co.th") then
    local urlr = "https://wifi.ais.co.th/" --fix url
    print ("lua loading real " .. urlr)
    local t = {}
    local b, c, h, sl = http.request {
        url = urlr,
        sink = ltn12.sink.table(t),
        headers = { ["User-Agent"]= "Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0" }
      }
-- Host: wifi.ais.co.th
-- User-Agent: curl/7.47.0
-- Accept: */*t)

    if b then
      local body = table.concat(t)
-- https://wifi.ais.co.th/WebResource.axd?d=IMkPF5uiIUCr_cpszKEso1&amp;t=635307591758913288
      print ("LUA BODY " .. " len " .. string.len(body) .. " type " .. type(body))
      local matched = string.match(body, '/WebResource.axd.*t=%d+')
      print ("LUA match " .. " type " .. type(matched) )
      if matched then
        print (matched)
        local bodyok, status, headers, status_line = http.request {
            url = urlr .. matched,
            headers = { ["User-Agent"]= "Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101 Firefox/58.0" }
          }
        print ("LUA AUTH STATUS " .. status_line )
        for k,v in pairs(headers) do
         print (k, v)
        end
      end
      print ("LUA STATUS " .. sl )
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



