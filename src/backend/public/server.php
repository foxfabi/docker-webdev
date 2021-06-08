<?php

use Swoole\HTTP\Server;

$LISTEN = getenv('LISTEN', true) ?: getenv('LISTEN');
if (empty($LISTEN)) { $LISTEN = 7409; }

$server = new Server("0.0.0.0", $LISTEN);

$server->on("start", function (Swoole\Http\Server $server) {
    sprintf("Swoole http server is started at http://0.0.0.0:%d\n", $server->port);
});

$server->on("request", function (Swoole\Http\Request $request, Swoole\Http\Response $response) {
    $response->header("Content-Type", "text/plain");
    $response->end("Hello World\n");
});

$server->start();
