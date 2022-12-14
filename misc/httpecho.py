#!/usr/bin/env python
#
# HTTPecho
# echo requests from HTTP methods GET and POST.
#
#from http.server import HTTPServer, BaseHTTPRequestHandler
import http.server as SimpleHTTPServer
import socketserver as SocketServer
from optparse import OptionParser
import logging
#
# to-do
# 1) support SSL connection
# 2) provide separate methods for PATCH,PUT,DELETE


class RequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    #
    def write_response(self):
        self.send_response(200)
        self.send_header('Content-type','text/xml')
        self.end_headers()
        
    def do_GET(self):
        logging.info("GET request\n\tPath:%s\n\tHeaders:%s", str(self.path), str(self.headers))
        self.write_response()
        self.wfile.write("GET request for {}".format(self.path).encode('utf-8'))

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length).decode('utf-8')
        logging.info("POST request\nPath:%s\nHeaders:%s\nBody:%s", str(self.path), str(self.headers), body)
        self.write_response()
        if options.response:
            with open(options.response, 'rb') as file: 
                body = file.read()
            logging.info("POST Response:%s",body.decode('utf-8'))
            self.wfile.write(body)
        else:
            self.wfile.write("POST request for {}".format(self.path).encode('utf-8'))

    # mappings for handlers to prevent breaking on unsupported methods.
    do_PUT = do_POST
    do_DELETE = do_GET
    do_PATCH = do_POST
    do_PUT = do_POST

if __name__ == "__main__":
    parser = OptionParser("HTTPEcho\nSet up an HTTP server that echos GET and POST messages received on a given port.\nUsage: % httpecho [options]")    
    parser.add_option("-p","--port",dest="port",help="Listen on specified port",type="int", default=8080)
    parser.add_option("-i","--host",dest="host",help="Listen on specified IP/host", default="localhost")
    parser.add_option("-r","--response",dest="response",help="Respond to POST with the contents of this file", default="")
    (options, args) = parser.parse_args()
    
    try :
        logging.basicConfig(level=logging.INFO)
        logging.info('Starting server on %s:%s', options.host,options.port)
        server = SimpleHTTPServer.HTTPServer((options.host, options.port), RequestHandler)
        #server = SocketServer.TCPServer((options.host, options.port), RequestHandler)
        server.serve_forever()
    
    except KeyboardInterrupt:
        logging.info('Stopping server...\n')
        server.socket.close()