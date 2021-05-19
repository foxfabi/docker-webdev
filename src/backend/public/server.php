<?php

use Swoole\HTTP\Server;

$port = 7409;

$server = new Server("0.0.0.0", $port);

$server->on("start", function (Swoole\Http\Server $server) {
    sprintf("Swoole http server is started at http://0.0.0.0:%d\n", $port);
});

$server->on("request", function (Swoole\Http\Request $request, Swoole\Http\Response $response) {
    $response->header("Content-Type", "text/plain");
    $response->end("Hello World\n");
});

$server->start();
