import urllib.request
req = urllib.request.Request('http://192.168.1.1/userRpm/SysRebootRpm.htm?Reboot=%D6%D8%C6%F4%C2%B7%D3%C9%C6%F7')
req.add_header('User-Agent', 'Mozilla/5.0 (Windows NT 10.0; rv:71.0) Gecko/20100101 Firefox/71.0')
req.add_header('Referer', 'http://192.168.1.1/userRpm/SysRebootRpm.htm')
req.add_header('Cookie', 'Authorization=Basic%20YWRtaW46amlzdWFuamk%3D; ChgPwdSubTag=')
r = urllib.request.urlopen(req)
#ipcontrol http://192.168.1.1/userRpm/QoSCfgRpm.htm?QoSCtrl=1&userWanType=0&down_bandWidth=51200&up_bandWidth=21600&Save=%B1%A3%20%B4%E6
