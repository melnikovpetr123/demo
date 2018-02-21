<html>
  <head>
</head>
<body>
<div><?php
  //whether ip is from share internet
  if (!empty($_SERVER['HTTP_CLIENT_IP']))  {    $ip_address = $_SERVER['HTTP_CLIENT_IP'];  }
  //whether ip is from proxy
  elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR']))  {    $ip_address = $_SERVER['HTTP_X_FORWARDED_FOR'];  }
  //whether ip is from remote address
  else  {    $ip_address = $_SERVER['REMOTE_ADDR'];  }
  echo $ip_address ;
  ?>
  </div><div>
<p id="demo"></p>
<script language='javascript'>
    var browserName;
    // Opera 8.0+    
  if ((window.opr && opr.addons) || window.opera || (navigator.userAgent.indexOf(' OPR/') >= 0))        
    browserName = 'Opera';
    // Firefox 1.0+    
  if (typeof InstallTrigger !== 'undefined')        
    browserName = 'Firefox';
    // At least Safari 3+: '[object HTMLElementConstructor]'    
  if (Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0)        
    browserName = 'Safari';
    // Internet Explorer 6-11    
  if ((/*@cc_on!@*/false) || (document.documentMode))        
    browserName = 'IE';
    // Edge 20+    
  if (!(document.documentMode) && window.StyleMedia)        
  browserName = 'Edge';
    // Chrome 1+    
  if (window.chrome && window.chrome.webstore)        
    browserName = 'Chrome';
  //  document.body.innerHTML = browserName + ' browser detected' + '<br>';   
  document.getElementById("demo").innerHTML = browserName + ' browser detected' ;</script>

</div></body></html>
