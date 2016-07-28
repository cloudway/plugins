#!/bin/env node

var express = require('express');

var SimpleApp = function() {
    var self = this;

    // Set up server IP address and port using env variables/defaults.
    self.setupVariables = function() {
        self.host = process.env.CLOUDWAY_NODEJS_HOST;
        self.port = process.env.CLOUDWAY_NODEJS_PORT || 8080;

        if (typeof self.host === 'undefined') {
            // contine with 127.0.0.1 - this allows us to run/test the app locally.
            console.log('No CLOUDWAY_NODEJS_HOST specified, using 127.0.0.1');
            self.host = "127.0.0.1";
        }
    };

    // Shutdown server on receipt of the specified signal.
    self.shutdown = function(sig) {
        if (typeof sig == 'string') {
            console.log('%s: Received %s - shutting down application ...',
                        Date(Date.now()), sig);
            process.exit(1);
        }
    }

    // Setup shutdown handlers (for exit and a list of signals).
    self.setupShutdownHandlers = function() {
        // Process on exit and signals.
        process.on('exit', function() { self.shutdown(); });

        ['SIGHUP', 'SIGINT', 'SIGQUIT', 'SIGILL', 'SIGTRAP', 'SIGABRT',
         'SIGBUS', 'SIGFPE', 'SIGUSR1', 'SIGUSR2', 'SIGSEGV', 'SIGTERM'
        ].forEach(function(element, index, array) {
            process.on(element, function() { self.shutdown(element); });
        });
    };

    // Initialize the server (express) and create the routes and register
    // the handlers.
    self.createRoutes = function() {
        var app = express();

        app.get('/', function(req, res) {
            res.setHeader('Content-Type', 'text/html');
            res.send('<html><body><h1>It works!</h1></body></html>');
        });

        return app;
    };

    // Start the server.
    self.start = function() {
        self.setupVariables();
        self.setupShutdownHandlers();

        var app = self.createRoutes();
        app.listen(self.port, self.host, function() {
            console.log('%s: Node server started on %s:%d ...',
                        Date(Date.now()), self.host, self.port);
        });
    };
};

var simple = new SimpleApp();
simple.start();
