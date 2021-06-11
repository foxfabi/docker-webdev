<?php

use Swoole\HTTP\Server;

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__.'/../../'); // Location of .env
$dotenv->load();
$LISTEN = getenv('LISTEN', true) ?: getenv('LISTEN');
if (empty($LISTEN)) {
    throw new Exception('Fail! Configure the API port.');
 }

$server = new Server("0.0.0.0", $LISTEN);

$server->on("start", function (Swoole\Http\Server $server) {
    sprintf("Swoole http server is started at http://0.0.0.0:%d\n", $server->port);
});

$server->on("request", function (Swoole\Http\Request $request, Swoole\Http\Response $response) {
    $response->header("Content-Type", "text/plain");
    $response->end("Hello World\n");
});

$server->start();
