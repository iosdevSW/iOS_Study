var apn = require('apn');

// Set up apn with the APNs Auth Key
var apnProvider = new apn.Provider({  
     token: {
        key: 'p8파일명!!', // Path to the key p8 file
        keyId: 'keyID!!', // The Key ID of the p8 file (available at https://developer.apple.com/account/ios/certificate/key)
        teamId: 'teamID!!', // The Team ID of your Apple Developer Account (available at https://developer.apple.com/account/#/membership/)
    },
    production: false // Set to true if sending a notification to a production iOS app
});

// Enter the device token from the Xcode console
// var deviceToken = '토큰'; // 하나만 쓸 때

// Devices Array
var tokenArr =
    [
        'TOKEN!!'
    ];

// Prepare a new notification
var notification = new apn.Notification();

// Specify your iOS app's Bundle ID (accessible within the project editor)
notification.topic = 'App Bundle ID!!';
notification.production = false

// Set expiration to 1 hour from now (in case device is offline)
notification.expiry = Math.floor(Date.now() / 1000) + 3600;

// For silent notification
// notification.contentAvailable = true

// Set app badge indicator
notification.badge = 1;

// Play ping.aiff sound when the notification is received
notification.sound = 'ping.aiff';

// Display the following message (the actual notification text, supports emoji)
notification.title = 'Push test \u270C';

notification.subtitle = 'third'

notification.body = 'iOS Push Notification'

notification.category = 'Categories'

//URL Array (ex image)
notification.urlArgs = [ 'https://res.cloudinary.com/demo/image/upload/sample.jpg' ]

notification.mutableContent = true // true여야 extension에서 푸시 편집 가능

notification.contentAvailable = true // For background remote push

// Send any extra payload data with the notification which will be accessible to your app in didReceiveRemoteNotification
notification.payload = {id: 123, pw: 123};
// Actually send the notification
// apnProvider.send(notification, deviceToken).then(function(result) {  
//     // Check the result for any failed devices
//     console.log(result);
// });

// Actually send the notification with an array of tokens
apnProvider.send(notification, tokenArr).then(function(result) {  
    // Check the result for any failed devices
    console.log(result);
});




