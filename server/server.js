const WebSocket = require('ws');

// Create a server on port 8080
const wss = new WebSocket.Server({ port: 8080 });

let counter = 0;

wss.on('connection', (ws) => {
    console.log("Godot client connected!");
    
    // Send the current counter immediately upon connection
    ws.send(JSON.stringify({ "type": "update", "value": counter }));

    ws.on('message', (message) => {
        // If Godot sends a message to increment
        const data = JSON.parse(message);
        if (data.action === "increment") {
            counter++;
            broadcastCounter();
        }
    });
});

// Function to send the new number to EVERY connected Godot instance
function broadcastCounter() {
    const payload = JSON.stringify({ "type": "update", "value": counter });
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(payload);
        }
    });
}

console.log("Server is running on ws://localhost:8080");