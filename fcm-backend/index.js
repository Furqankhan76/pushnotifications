const express = require('express');
const bodyParser = require('body-parser');
const firebaseAdmin = require('firebase-admin');

// Initialize Firebase Admin SDK with the service account
const serviceAccount = require('./service.json');

firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount),
});

const app = express();
const port = 3000;

// Middleware to parse incoming JSON requests
app.use(bodyParser.json());


// Endpoint to send push notification
app.post('/send-notification', (req, res) => {
  // Destructure title, message, and token from the request body
  const { title, message, token } = req.body;

  // Validate if title, message, and token are provided
  if (!title || !message || !token) {
    return res.status(400).send({ error: 'Title, message, and token are required' });
  }

  // Construct the notification payload
  const messagePayload = {
    notification: {
      title: title,     // Title of the notification
      body: message,    // Body of the notification
    },
    
    token: token,        // The FCM token of the target device
  };

  // Send the notification using Firebase Admin SDK
  firebaseAdmin
    .messaging()
    .send(messagePayload)  // Send the notification to the specific device
    .then((response) => {
      console.log('Successfully sent message:', response);
      res.send({ message: 'Notification sent successfully', response });
    })
    .catch((error) => {
      console.log('Error sending message:', error);
      res.status(500).send({ error: 'Failed to send message', details: error });
    });
});


 

app.get('/get' , (req, res) => {
  try {
    res.send('get');
  } catch (error) {
    console.log(error);
    
  }
})

app.listen(port, () => {
  console.log(`Backend is running on http://localhost:${port}`);
});
