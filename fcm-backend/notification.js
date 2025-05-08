// import { getMessaging } from "firebase-admin/messaging";
const firebaseAdmin = require('firebase-admin');

// Initialize Firebase Admin SDK with the service account
const serviceAccount = require('./push.json');

firebaseAdmin.initializeApp({
    credential: firebaseAdmin.credential.cert(serviceAccount),
});
const getMessaging = firebaseAdmin.messaging();

// This registration token comes from the client FCM SDKs.
const registrationToken = 'cjOiJ6SXR3mkehJuxRxIXv:APA91bHrneDEb26zz7PrQZg_TUNnqY_5MZshqzQUFm10uuJVdfbBDwpQoERnTNNv31olVAtNWx5VbEJuvGBJ8EN5pzzprGlKW-7c8VtxmEkOmEpcjX3N1qU';

const message = {
  data: {
    score: '850',
    time: '2:45'
  },
  token: registrationToken
};

// Send a message to the device corresponding to the provided
// registration token.
getMessaging.send(message)
  .then((response) => {
    // Response is a message ID string.
    console.log('Successfully sent message:', response);
  })
  .catch((error) => {
    console.log('Error sending message:', error);
  });