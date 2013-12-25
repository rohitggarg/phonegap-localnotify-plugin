var LocalNotify = function() {
};

LocalNotify.prototype.add = function(options) {
  var defaults = {
    fireTimestamp   : new Date().getTime()/1000 + 2,
    alertBody       : "This is a local notification.",
    action          : 'View',
    repeatInterval  : "",
    soundName       : "beep.caf" ,
    badge           : 0,
    notificationId  : "",
    background      : function(notificationId){},
    foreground      : function(notificationId){}                
  };

  if(options){
    for (var key in defaults) {
      if (typeof options[key] !== "undefined"){
        defaults[key] = options[key];
      }
    }
  }

  cordova.exec(
    function(params) {
      window.setTimeout(function(){
        defaults[params.appState](params.notificationId);
      }, 1);
    }, 
    null, 
    "LocalNotify", 
    "notice", 
    [
      defaults.fireDate,
      defaults.alertBody,
      defaults.action,
      defaults.repeatInterval,
      defaults.soundName,
      defaults.notificationId,
      defaults.badge
    ]
  );
};

LocalNotify.prototype.cancel =  function(str, callback) {
  cordova.exec(callback, null, "LocalNotify", "cancel", [str]);
};

LocalNotify.prototype.cancelAll = function(callback) {
  cordova.exec(callback, null, "LocalNotify", "cancelAll", []);
};

if (!window.navigator.localnotify) {
  window.navigator.localnotify = new LocalNotify();
}
