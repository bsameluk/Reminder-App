import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to NotificationChannel")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("Disconnected from NotificationChannel")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Received data from NotificationChannel", data)
    if (data.notification && data.notification.subject && data.notification.body) {
      showNotification(data.notification, "info");
    }
  }
});

function showNotification(notificationData, type = "info") {
  const notification = document.createElement("div");
  notification.className = `notification ${type}`;
  notification.innerHTML = `
    <p>${notificationData.subject}</p>
    <p>${notificationData.body}</p>
  `

  const container = document.getElementById("notification-container");
  container.appendChild(notification);

  setTimeout(() => {
    notification.style.opacity = "0";
    setTimeout(() => notification.remove(), 500);
  }, 8000);
}
