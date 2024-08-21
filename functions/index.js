/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

function toTitleCase(str) {
  return str
    .toLowerCase() // Make sure all letters are lowercase first
    .split(' ') // Split the string into words
    .map(word => word.charAt(0).toUpperCase() + word.slice(1)) // Capitalize the first letter of each word
    .join(' '); // Join the words back into a single string
}
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
admin.initializeApp();
exports.sendWeatherNotification = functions.pubsub.schedule("every 3 hours").onRun(async (context) => {
  const snapshot = await admin.firestore().collection("users").get();
  const users = snapshot.docs.map(doc => {
    const {location, token} = doc.data();
    return {location, token};
  });

  for (const user of users) {
    const {location, token: fcmToken} = user;
    if (!location || !fcmToken) continue;

    const {latitude: lat, longitude: lon} = location;
    // Weather data
    const apiKey = functions.config().openweathermap.key;
    const weatherUrl = `https://api.openweathermap.org/data/3.0/onecall?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric&exclude=minutely`;
    const response = await axios.get(weatherUrl);
    const weatherDescription = response.data.current.weather[0].description;
    const temperature = response.data.current.temp;
    const temp_max = response.data.daily[0].temp.max;
    const temp_min = response.data.daily[0].temp.min;

    // Reverse geocoding to get City name
    const geocodeUrl = `https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${lon}&key=${functions.config().googlemaps.key}`;
    const geocodeResponse = await axios.get(geocodeUrl);
    const city = geocodeResponse.data.results[0].address_components[2].long_name;

    const payload = {
      notification: {
        title: `${city} - ${temperature.toFixed(1)}°C`,
        body: `${toTitleCase(weatherDescription)} | High: ${temp_max.toFixed(1)}°C - Low: ${temp_min.toFixed(1)}°C`,
      },
      token: fcmToken,
    };

    await admin.messaging().send(payload);
  }
});