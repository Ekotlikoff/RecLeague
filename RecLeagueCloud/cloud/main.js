Parse.Cloud.job("eventCleanupAndNotifications", function(request, status) {
  // run every half hour - events in the past are removed, events between
  // a half hour from now and an hour from now are sent push
  // notifications, deleted if not enough attendees.

  // Set up to modify user data
  Parse.Cloud.useMasterKey();
  // Query for all events in the next two hours
  var now = new Date();
  var nowPlusHalf = new Date();
  var nowPlusOne = new Date();
  nowPlusOne.setHours(nowPlusOne.getHours()+1);
  nowPlusHalf.setMinutes(nowPlusHalf.getMinutes()+30);

  var query = new Parse.Query("Event");
  var total = 0;
  var numDestroyed = 0;
  //query.ascending("date");
  query.lessThanOrEqualTo("date", nowPlusOne);
  
  var promise = Parse.Promise.as();
  query.each(function(eventObject) {
      total++;      
      var eventDate = eventObject.get("date");

      // If the date has passed, delete the event
      if (eventDate < now) {
          promise = promise.then(function() {
              return eventObject.destroy().then(function() {
                  numDestroyed++;
                  console.log("DELETED EVENT: " + eventObject.get("name"));
              },
              function(error) {
                  console.log("DESTROY ERROR");
              });
          });
      // If the date is between 1 and 2 hours from now send a push
      // notification
      } else if (eventDate < nowPlusOne && eventDate > nowPlusHalf) {
          // send push notification if there's enough people
          // send push notification and delete if no
      } 
  }).then(function() {
    return promise;
  }).then(function() {
    // Set the job's success status
    status.success("Events cleaned and notifications sent.  " +
                    total + " events screened, " + numDestroyed + " events removed.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});
