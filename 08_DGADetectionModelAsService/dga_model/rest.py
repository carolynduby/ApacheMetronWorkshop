import json
import model
from flask import Flask
from flask import request,jsonify
import socket

app = Flask(__name__)

@app.route("/apply", methods=['GET'])
def predict():
  # We expect one argument, the hostname without TLD.
  h = request.args.get('host')
  r = {}
  r['is_malicious'] = model.evaluate_domain(h)
  # We will return a JSON map with one field, 'is_malicious' which will be
  # 'legit' or 'dga', the two possible outputs of our model.
  return jsonify(r)

if __name__ == "__main__":
  # Create my model object that I want to expose.
  model = model.DGA()
  # In order to register with model as a service, we need to bind to a port
  # and inform the discovery service of the endpoint. Therefore,
  # we will bind to a port and close the socket to reserve it.
  sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  sock.bind(('localhost', 0))
  port = sock.getsockname()[1]
  sock.close()
  with open("endpoint.dat", "w") as text_file:
    # To inform the discovery service, we need to write a file with a simple
    # JSON Map indicating the full URL that we've bound to.
    text_file.write("{\"url\" : \"http://0.0.0.0:%d\"}" % port)
  # Make sure flask uses the port we reserved
  app.run(threaded=True, host="0.0.0.0", port=port)