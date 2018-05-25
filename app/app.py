""" hello.py """

from flask import Flask, jsonify

app = Flask(__name__)

def create_app():
    global app
    # init other things...
    return app

@app.route('/')
def hello():
    return jsonify({
        'hello': 'world'
    })

if __name__ == '__main__':
    app = create_app()
    app.run(host='0.0.0.0')
