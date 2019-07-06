#!/usr/bin/env python
#
# HTTPecho
# echo requests from HTTP methods GET and POST.
#
from BaseHTTPServer import HTTPServer, BaseHTTPRequestHandler
from optparse import OptionParser

#
# to-do
# 1) provide ability to specify IP listen address (defaults to localhost currently)
# 2) support SSL connection
# 3) provide separate methods for PATCH,PUT,DELETE


class RequestHandler(BaseHTTPRequestHandler):
    #
    def do_GET(self):

        request_path = self.path

        print("\n::::::: Request Start :::::::\n")
        
        print(request_path)
        
        print(self.headers)
        
        print("::::::: Request End :::::::\n")

        self.send_response(200)
        
        #self.send_header("Set-Cookie", "name=value")
        
        self.send_header("Content-type","text/html")
        
        self.end_headers()

    def do_POST(self):

        request_path = self.path

        print("\n::::::: Request Start :::::::>\n")
        print(request_path)

        request_headers = self.headers
        content_length = request_headers.getheaders('content-length')
        length = int(content_length[0]) if content_length else 0

        print(request_headers)
        print(self.rfile.read(length))
        print("::::::: Request End :::::::\n")

        self.send_response(200)

    do_PUT = do_POST
    do_DELETE = do_GET
    do_PATCH = do_POST
    do_PUT = do_POST

if __name__ == "__main__":

    
    parser = OptionParser("HTTPEcho\nSet up an HTTP server that echos GET and POST messages received on a given port.\nUsage: % httpecho [options]")    
    parser.add_option("-p","--port",dest="port",help="Listen on specified port",type="int", default=8080)
    #parser.add_option("-i","--host",dest="host",help="Listen on specified IP/host", default="")
    (options, args) = parser.parse_args()
    
    print('HTTPEcho : listening on %s:%s' % ('localhost',options.port))
    try :
        server = HTTPServer(('', options.port), RequestHandler)
        server.serve_forever()
    except KeyboardInterrupt:
        print 'Interrupt received; terminating.'
        server.socket.close()
