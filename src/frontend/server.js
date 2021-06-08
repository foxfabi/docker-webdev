// http is an inbuilt module in Node.js
const http = require('http');
const NODE_PORT = process.env.NODE_PORT;
console.log("Server is starting up at port: " + NODE_PORT);

// createServer method takes a callback function as argument
// the callback function takes two arguments req and re
const server = http.createServer(function (req, res) {
    res.statusCode = 200; // 200 = OK
    res.setHeader('Content-Type', 'text/html');
    res.write("<h1>Demo page</h1>");
    res.end();
});

// server is listening to incoming requests on port 3000 on localhost
server.listen(NODE_PORT, function () {
    console.log("Listening on port http://localhost:" + NODE_PORT);
});
