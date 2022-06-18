import logging
import os

from flask import Flask

logging.getLogger().setLevel(logging.INFO)


app = Flask(__name__)

@app.route("/")
def hello_zero_division_error():
    """Function will attempt an impossible sum.
    When it raises the ZeroDivisionError, workflows (when configured) will retry
    up to 3 times.

    return: <Response [500]>
    """
    logging.info("running hello_zero_division_error…")

    try:
        bad_sum = 1/0
        logging.info("success!")
        return 1
    except ZeroDivisionError as e:
        print(f"\nError = {e}")
        logging.error(f"Encountered error {e}. Retrying ...")
        raise ZeroDivisionError


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8089)))
