FROM python:3.8-slim-buster

# Allow statements and log messages to imediately appear in the knative logs
ENV PYTHONBUFFERED True

# Copy local code to the container image
ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . ./

RUN pip install -r requirements.txt

# Run the webservice on container startup. Here we use the gunicorn
# webserver, with one worker process adn 8 threads
# For environments with multiple CPU cores, increase the numnber of workers
# to be equal to the cores available.
CMD exec gunicorn --bind :$PORT --workers 2 --threads 8 --timeout 0 app:app
