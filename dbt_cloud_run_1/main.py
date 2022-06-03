import os

from flask import Flask

app = Flask(__name__)


@app.route("/")
def hello_world():
    try:
        os.system("chmod -R 777 *.sh")
        os.system("./script.sh")
        return "SQL Transformations complete"
    except Exception as e:
        print("\nError = {e}")
        return "error!!!"


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
