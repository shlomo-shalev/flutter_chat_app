const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.createUser = functions.firestore
      .document("chat/{message}")
      .onCreate((snap, context) => admin.messaging().sendToTopic("chat", {
          notification: {
            title: snap.data().username,
            body: snap.data().text,
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        }));