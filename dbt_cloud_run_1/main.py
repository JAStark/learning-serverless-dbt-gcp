import logging
import os

from flask import Flask

app = Flask(__name__)

logging.getLogger().setLevel(logging.INFO)

@app.route("/")
def hello_world():
    # try:
    #     os.system("chmod -R 777 *.sh")
    #     os.system("./script.sh")
    #     return "SQL Transformations complete"
    # except Exception as e:
    #     print("\nError = {e}")
    #     return "error!"
    logging.info("running hello_world…")
    return "test cloud run main complete. No DBT used."


if __name__ == "__main__":
    # Redirect Flask logs to Gunicorm logs
#     gunicorn_logger = logging.getLogger('gunicorn.error')
#     app.logger.handlers = gunicorn_logger.handlers
#     app.logger.setLevel(gunicorn_logger.level)
#     app.logger.info('Service started…')
# else:
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8089)))
